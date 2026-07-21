package com.example.Scott.responsitory;

import com.example.Scott.entity.DiaChiKhachHang;
import com.example.Scott.utils.HibernateConfig;
import org.hibernate.Session;
import org.hibernate.Transaction;

import java.util.List;

public class DiaChiKhachHangResponsitory {

    public List<DiaChiKhachHang> getAll() {
        try (Session session = HibernateConfig.getFACTORY().openSession()) {
            return session.createQuery("from DiaChiKhachHang order by id desc", DiaChiKhachHang.class).list();
        }
    }

    public DiaChiKhachHang getOne(Integer idDiaChi) {
        if (idDiaChi == null) return null;
        try (Session session = HibernateConfig.getFACTORY().openSession()) {
            return session.find(DiaChiKhachHang.class, idDiaChi);
        }
    }

    public DiaChiKhachHang AddDiaChiKH(DiaChiKhachHang diaChi) {
        if (diaChi == null) return null;
        Transaction tx = null;
        try (Session session = HibernateConfig.getFACTORY().openSession()) {
            tx = session.beginTransaction();
            session.persist(diaChi);
            tx.commit();
            return diaChi;
        } catch (RuntimeException e) {
            if (tx != null && tx.isActive()) tx.rollback();
            throw e;
        }
    }

    public void DeleteDiaChiKH(DiaChiKhachHang diaChi) {
        if (diaChi == null) return;
        execute(session -> session.remove(session.contains(diaChi) ? diaChi : session.merge(diaChi)));
    }

    public void deleteByKhachHang(Integer idKhachHang) {
        if (idKhachHang == null) return;
        execute(session -> session.createQuery("delete from DiaChiKhachHang where idKhachHang = :id")
                .setParameter("id", idKhachHang).executeUpdate());
    }

    public void UpdateDiaChiKH(DiaChiKhachHang diaChi) {
        if (diaChi == null) return;
        execute(session -> session.merge(diaChi));
    }

    public DiaChiKhachHang getByIdKhachHang(Integer idKhachHang) {
        if (idKhachHang == null) return null;
        try (Session session = HibernateConfig.getFACTORY().openSession()) {
            return session.createQuery(
                    "from DiaChiKhachHang where idKhachHang = :id order by isMacDinh desc, id desc",
                    DiaChiKhachHang.class)
                    .setParameter("id", idKhachHang)
                    .setMaxResults(1)
                    .uniqueResult();
        }
    }

    private void execute(SessionWork work) {
        Transaction tx = null;
        try (Session session = HibernateConfig.getFACTORY().openSession()) {
            tx = session.beginTransaction();
            work.run(session);
            tx.commit();
        } catch (RuntimeException e) {
            if (tx != null && tx.isActive()) tx.rollback();
            throw e;
        }
    }

    @FunctionalInterface
    private interface SessionWork { void run(Session session); }
}
