package com.example.Scott.responsitory;

import com.example.Scott.entity.DiaChiApiMapping;
import com.example.Scott.utils.HibernateConfig;
import org.hibernate.Session;
import org.hibernate.Transaction;

public class DiaChiApiMappingRepository {

    public boolean add(DiaChiApiMapping mapping) {
        Transaction transaction = null;

        try (Session session = HibernateConfig.getFACTORY().openSession()) {

            transaction = session.beginTransaction();

            session.persist(mapping);

            transaction.commit();

            return true;

        } catch (Exception e) {

            if (transaction != null) {
                transaction.rollback();
            }

            e.printStackTrace();

            return false;
        }
    }

    public boolean update(DiaChiApiMapping mapping) {

        Transaction transaction = null;

        try (Session session = HibernateConfig.getFACTORY().openSession()) {

            transaction = session.beginTransaction();

            session.merge(mapping);

            transaction.commit();

            return true;

        } catch (Exception e) {

            if (transaction != null) {
                transaction.rollback();
            }

            e.printStackTrace();

            return false;
        }
    }

    public boolean delete(DiaChiApiMapping mapping) {

        Transaction transaction = null;

        try (Session session = HibernateConfig.getFACTORY().openSession()) {

            transaction = session.beginTransaction();

            session.remove(session.contains(mapping)
                    ? mapping
                    : session.merge(mapping));

            transaction.commit();

            return true;

        } catch (Exception e) {

            if (transaction != null) {
                transaction.rollback();
            }

            e.printStackTrace();

            return false;
        }
    }

    public DiaChiApiMapping findByDiaChiId(Integer idDiaChiKhachHang) {

        try (Session session = HibernateConfig.getFACTORY().openSession()) {

            return session.createQuery(
                    "FROM DiaChiApiMapping WHERE idDiaChiKhachHang = :id",
                    DiaChiApiMapping.class)
                    .setParameter("id", idDiaChiKhachHang)
                    .uniqueResult();

        } catch (Exception e) {

            e.printStackTrace();

            return null;
        }
    }

}