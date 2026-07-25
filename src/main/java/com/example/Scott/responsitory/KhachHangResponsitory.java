package com.example.Scott.responsitory;

import com.example.Scott.entity.KhachHang;
import com.example.Scott.utils.HibernateConfig;
import org.hibernate.Session;
import org.hibernate.Transaction;

import java.util.List;

public class KhachHangResponsitory {

    public List<KhachHang> getAll() {
        try (Session session = HibernateConfig.getFACTORY().openSession()) {
            return session.createQuery("from KhachHang order by id desc", KhachHang.class).list();
        }
    }

    public KhachHang getOne(Integer id) {
        if (id == null) return null;
        try (Session session = HibernateConfig.getFACTORY().openSession()) {
            return session.find(KhachHang.class, id);
        }
    }

    public KhachHang findByMa(String ma) {
        if (ma == null || ma.trim().isEmpty()) return null;
        try (Session session = HibernateConfig.getFACTORY().openSession()) {
            return session.createQuery("from KhachHang where lower(ma) = :ma", KhachHang.class)
                    .setParameter("ma", ma.trim().toLowerCase())
                    .uniqueResult();
        }
    }

    public void addKhachHang(KhachHang khachHang) {
        execute(session -> session.persist(khachHang));
    }


    public void UpdateKhachHang(KhachHang khachHang) {
        execute(session -> session.merge(khachHang));
    }

    public List<KhachHang> search(String keyword) {
        return filter(keyword, null, null);
    }

    public List<KhachHang> filter(String keyword, String gioiTinh, Integer trangThai) {
        String kw = keyword == null ? "" : keyword.trim().toLowerCase();
        try (Session session = HibernateConfig.getFACTORY().openSession()) {
            StringBuilder hql = new StringBuilder("from KhachHang kh where 1=1");
            if (!kw.isEmpty()) {
                hql.append(" and (lower(coalesce(kh.ma,'')) like :kw")
                   .append(" or lower(coalesce(kh.hoTen,'')) like :kw")
                   .append(" or lower(coalesce(kh.sdt,'')) like :kw")
                   .append(" or lower(coalesce(kh.email,'')) like :kw")
                   .append(" or lower(coalesce(kh.diaChi,'')) like :kw)");
            }
            if (gioiTinh != null && !gioiTinh.trim().isEmpty()) hql.append(" and kh.gioiTinh = :gioiTinh");
            if (trangThai != null) hql.append(" and kh.trangThai = :trangThai");
            hql.append(" order by kh.id desc");
            org.hibernate.query.Query<KhachHang> query = session.createQuery(hql.toString(), KhachHang.class);
            if (!kw.isEmpty()) query.setParameter("kw", "%" + kw + "%");
            if (gioiTinh != null && !gioiTinh.trim().isEmpty()) query.setParameter("gioiTinh", gioiTinh.trim());
            if (trangThai != null) query.setParameter("trangThai", trangThai);
            return query.list();
        }
    }

    public boolean existsByMa(String ma, Integer excludeId) {
        if (ma == null || ma.trim().isEmpty()) return false;
        try (Session session = HibernateConfig.getFACTORY().openSession()) {
            String hql = "select count(kh.id) from KhachHang kh where lower(kh.ma)=:ma" +
                    (excludeId == null ? "" : " and kh.id <> :id");
            org.hibernate.query.Query<Long> q = session.createQuery(hql, Long.class)
                    .setParameter("ma", ma.trim().toLowerCase());
            if (excludeId != null) q.setParameter("id", excludeId);
            Long count = q.uniqueResult();
            return count != null && count > 0;
        }
    }

    public String generateNextMa() {
        try (Session session = HibernateConfig.getFACTORY().openSession()) {
            List<String> codes = session.createQuery("select kh.ma from KhachHang kh", String.class).list();
            int max = 0;
            for (String code : codes) {
                if (code != null && code.toUpperCase().matches("KH\\d+")) {
                    try { max = Math.max(max, Integer.parseInt(code.substring(2))); } catch (NumberFormatException ignored) {}
                }
            }
            String candidate;
            do { candidate = String.format("KH%04d", ++max); } while (existsByMa(candidate, null));
            return candidate;
        }
    }

    private void execute(SessionWork work) {
        Transaction transaction = null;
        try (Session session = HibernateConfig.getFACTORY().openSession()) {
            transaction = session.beginTransaction();
            work.run(session);
            transaction.commit();
        } catch (RuntimeException e) {
            if (transaction != null && transaction.isActive()) transaction.rollback();
            throw e;
        }
    }

    @FunctionalInterface
    private interface SessionWork {
        void run(Session session);
    }
}
