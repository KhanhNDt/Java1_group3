package com.example.Scott.responsitory;

import com.example.Scott.entity.DiaChiApiMapping;
import com.example.Scott.utils.HibernateConfig;
import org.hibernate.Session;
import org.hibernate.Transaction;

public class DiaChiApiMappingRepository {

    public void add(DiaChiApiMapping mapping) { save(mapping, false); }
    public void update(DiaChiApiMapping mapping) { save(mapping, true); }

    private void save(DiaChiApiMapping mapping, boolean merge) {
        if (mapping == null) return;
        Transaction tx = null;
        try (Session session = HibernateConfig.getFACTORY().openSession()) {
            tx = session.beginTransaction();
            if (merge) session.merge(mapping); else session.persist(mapping);
            tx.commit();
        } catch (RuntimeException e) {
            if (tx != null && tx.isActive()) tx.rollback();
            throw e;
        }
    }

    public void delete(DiaChiApiMapping mapping) {
        if (mapping == null) return;
        Transaction tx = null;
        try (Session session = HibernateConfig.getFACTORY().openSession()) {
            tx = session.beginTransaction();
            session.remove(session.contains(mapping) ? mapping : session.merge(mapping));
            tx.commit();
        } catch (RuntimeException e) {
            if (tx != null && tx.isActive()) tx.rollback();
            throw e;
        }
    }

    public DiaChiApiMapping findByDiaChiId(Integer idDiaChiKhachHang) {
        if (idDiaChiKhachHang == null) return null;
        try (Session session = HibernateConfig.getFACTORY().openSession()) {
            return session.createQuery(
                            "from DiaChiApiMapping where idDiaChiKhachHang = :id",
                            DiaChiApiMapping.class)
                    .setParameter("id", idDiaChiKhachHang)
                    .setMaxResults(1)
                    .uniqueResult();
        }
    }
}
