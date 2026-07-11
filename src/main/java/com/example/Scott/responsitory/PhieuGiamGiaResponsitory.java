package com.example.Scott.responsitory;


import com.example.Scott.entity.PhieuGiamGia;
import com.example.Scott.utils.HibernateConfig;
import org.hibernate.Session;

import java.util.List;

public class PhieuGiamGiaResponsitory {
    private Session s;
    public PhieuGiamGiaResponsitory(){ s = HibernateConfig.getFACTORY().openSession();}
    public List<PhieuGiamGia> getAll(){return s.createQuery(" from PhieuGiamGia ").list();}
    public PhieuGiamGia getOne(Integer id5){return s.find(PhieuGiamGia.class,id5);}
    public void addPhieuGiamGia(PhieuGiamGia PGG){
        try {
            s.getTransaction().begin();
            s.persist(PGG);
            s.getTransaction().commit();
        }catch (Exception e){
            e.printStackTrace();
            s.getTransaction().rollback();
        }
    }
    public void DeletePhieuGiamGia(PhieuGiamGia PGG){
        try {
            s.getTransaction().begin();
            s.delete(PGG);
            s.getTransaction().commit();
        }catch (Exception e){
            e.printStackTrace();
            s.getTransaction().rollback();
        }
    }
    public void updatePhieuGiamGia(PhieuGiamGia PGG){
        try {
            s.getTransaction().begin();
            s.merge(PGG);
            s.getTransaction().commit();
        }catch (Exception e){
            e.printStackTrace();
            s.getTransaction().rollback();
        }
    }


    public static void main(String[] args) {
        System.out.println(new PhieuGiamGiaResponsitory().getAll());
    }
}

