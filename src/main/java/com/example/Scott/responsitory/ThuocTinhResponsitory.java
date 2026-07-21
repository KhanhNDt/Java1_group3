package com.example.Scott.responsitory;

import com.example.Scott.utils.HibernateConfig;
import org.hibernate.Session;
import org.hibernate.Transaction;

import java.util.Collections;
import java.util.List;

public class ThuocTinhResponsitory {

    public <T> List<T> findAll(Class<T> entityClass, String tenField, String keyword, Integer trangThai) {
        try (Session session = HibernateConfig.getFACTORY().openSession()) {
            StringBuilder hql = new StringBuilder("from ").append(entityClass.getSimpleName()).append(" x where 1=1");
            if (keyword != null && !keyword.trim().isEmpty()) {
                hql.append(" and lower(x.").append(tenField).append(") like :keyword");
            }
            if (trangThai != null) {
                hql.append(" and x.trangThai = :trangThai");
            }
            hql.append(" order by x.id desc");

            org.hibernate.query.Query<T> query = session.createQuery(hql.toString(), entityClass);
            if (keyword != null && !keyword.trim().isEmpty()) {
                query.setParameter("keyword", "%" + keyword.trim().toLowerCase() + "%");
            }
            if (trangThai != null) {
                query.setParameter("trangThai", trangThai);
            }
            return query.list();
        } catch (Exception e) {
            e.printStackTrace();
            return Collections.emptyList();
        }
    }

    public <T> T getOne(Class<T> entityClass, Integer id) {
        try (Session session = HibernateConfig.getFACTORY().openSession()) {
            return session.find(entityClass, id);
        }
    }

    public void save(Object entity) {
        execute(entity, true);
    }

    public void update(Object entity) {
        execute(entity, false);
    }

    private void execute(Object entity, boolean insert) {
        Transaction transaction = null;
        try (Session session = HibernateConfig.getFACTORY().openSession()) {
            transaction = session.beginTransaction();
            if (insert) {
                session.persist(entity);
            } else {
                session.merge(entity);
            }
            transaction.commit();
        } catch (RuntimeException e) {
            if (transaction != null && transaction.isActive()) transaction.rollback();
            throw e;
        }
    }

    public void delete(Object entity) {
        Transaction transaction = null;
        try (Session session = HibernateConfig.getFACTORY().openSession()) {
            transaction = session.beginTransaction();
            session.remove(session.contains(entity) ? entity : session.merge(entity));
            transaction.commit();
        } catch (RuntimeException e) {
            if (transaction != null && transaction.isActive()) transaction.rollback();
            throw e;
        }
    }

    public boolean exists(Class<?> entityClass, String field, String value, Integer excludeId) {
        if (value == null || value.trim().isEmpty()) return false;
        try (Session session = HibernateConfig.getFACTORY().openSession()) {
            String hql = "select count(x.id) from " + entityClass.getSimpleName()
                    + " x where lower(x." + field + ") = :value"
                    + (excludeId == null ? "" : " and x.id <> :excludeId");
            org.hibernate.query.Query<Long> query = session.createQuery(hql, Long.class)
                    .setParameter("value", value.trim().toLowerCase());
            if (excludeId != null) query.setParameter("excludeId", excludeId);
            return query.uniqueResult() > 0;
        }
    }

    public long countReferences(String type, Integer id) {
        String hql;
        if ("danh-muc".equals(type)) hql = "select count(x.id) from SanPham x where x.danhMuc.id = :id";
        else if ("thuong-hieu".equals(type)) hql = "select count(x.id) from SanPham x where x.thuongHieu.id = :id";
        else if ("chat-lieu".equals(type)) hql = "select count(x.id) from SanPham x where x.chatLieu.id = :id";
        else if ("kieu-dang".equals(type)) hql = "select count(x.id) from SanPham x where x.kieuDang.id = :id";
        else if ("mau-sac".equals(type)) hql = "select count(x.id) from ChiTietSanPham x where x.mauSac.id = :id";
        else if ("size".equals(type)) hql = "select count(x.id) from ChiTietSanPham x where x.size.id = :id";
        else return 0;

        try (Session session = HibernateConfig.getFACTORY().openSession()) {
            return session.createQuery(hql, Long.class).setParameter("id", id).uniqueResult();
        }
    }
}
