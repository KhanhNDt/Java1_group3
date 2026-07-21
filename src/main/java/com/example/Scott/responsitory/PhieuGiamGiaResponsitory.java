package com.example.Scott.responsitory;

import com.example.Scott.entity.PhieuGiamGia;
import com.example.Scott.utils.HibernateConfig;
import org.hibernate.Session;

import java.util.List;

public class PhieuGiamGiaResponsitory {

    public List<PhieuGiamGia> getAll(){
        try (Session s = HibernateConfig.getFACTORY().openSession()) {
            return s.createQuery(" from PhieuGiamGia ", PhieuGiamGia.class).list();
        }
    }

    public PhieuGiamGia getOne(Integer id5){
        try (Session s = HibernateConfig.getFACTORY().openSession()) {
            return s.find(PhieuGiamGia.class, id5);
        }
    }

    public void addPhieuGiamGia(PhieuGiamGia PGG){
        try (Session s = HibernateConfig.getFACTORY().openSession()) {
            try {
                s.getTransaction().begin();
                s.persist(PGG);
                s.getTransaction().commit();
            } catch (Exception e) {
                e.printStackTrace();
                if (s.getTransaction().isActive()) s.getTransaction().rollback();
                throw new RuntimeException("Loi khi them phieu giam gia: " + e.getMessage(), e);
            }
        }
    }

    public void DeletePhieuGiamGia(PhieuGiamGia PGG){
        try (Session s = HibernateConfig.getFACTORY().openSession()) {
            try {
                s.getTransaction().begin();
                s.delete(PGG);
                s.getTransaction().commit();
            } catch (Exception e) {
                e.printStackTrace();
                if (s.getTransaction().isActive()) s.getTransaction().rollback();
                throw new RuntimeException("Loi khi xoa phieu giam gia: " + e.getMessage(), e);
            }
        }
    }

    public void updatePhieuGiamGia(PhieuGiamGia PGG){
        try (Session s = HibernateConfig.getFACTORY().openSession()) {
            try {
                s.getTransaction().begin();
                s.merge(PGG);
                s.getTransaction().commit();
            } catch (Exception e) {
                e.printStackTrace();
                if (s.getTransaction().isActive()) s.getTransaction().rollback();
                throw new RuntimeException("Loi khi cap nhat phieu giam gia: " + e.getMessage(), e);
            }
        }
    }

    public static void main(String[] args) {
        System.out.println(new PhieuGiamGiaResponsitory().getAll());
    }
}
