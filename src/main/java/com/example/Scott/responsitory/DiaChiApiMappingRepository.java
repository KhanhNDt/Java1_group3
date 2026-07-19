package com.example.Scott.responsitory;

import com.example.Scott.entity.DiaChiApiMapping;
import com.example.Scott.utils.HibernateConfig;
import org.hibernate.Session;

public class DiaChiApiMappingRepository {

    private Session s;

    public DiaChiApiMappingRepository() {
        s = HibernateConfig.getFACTORY().openSession();
    }

    public void add(DiaChiApiMapping mapping) {

        try {

            s.getTransaction().begin();

            s.persist(mapping);

            s.getTransaction().commit();

        } catch (Exception e) {

            e.printStackTrace();

            if (s.getTransaction().isActive()) {
                s.getTransaction().rollback();
            }

        }

    }

    public void update(DiaChiApiMapping mapping) {

        try {

            s.getTransaction().begin();

            s.merge(mapping);

            s.getTransaction().commit();

        } catch (Exception e) {

            e.printStackTrace();

            if (s.getTransaction().isActive()) {
                s.getTransaction().rollback();
            }

        }

    }

    public void delete(DiaChiApiMapping mapping) {

        try {

            s.getTransaction().begin();

            s.delete(mapping);

            s.getTransaction().commit();

        } catch (Exception e) {

            e.printStackTrace();

            if (s.getTransaction().isActive()) {
                s.getTransaction().rollback();
            }

        }

    }

    public DiaChiApiMapping findByDiaChiId(Integer idDiaChiKhachHang) {

        return s.createQuery(
                "FROM DiaChiApiMapping WHERE idDiaChiKhachHang = :id",
                DiaChiApiMapping.class)
                .setParameter("id", idDiaChiKhachHang)
                .uniqueResult();

    }

}