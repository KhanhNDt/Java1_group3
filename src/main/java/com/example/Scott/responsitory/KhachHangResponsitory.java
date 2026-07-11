package com.example.Scott.responsitory;

import com.example.Scott.entity.KhachHang;
import com.example.Scott.utils.HibernateConfig;
import org.hibernate.Session;

import java.util.List;

public class KhachHangResponsitory {
    private Session s;

    public KhachHangResponsitory(){ s= HibernateConfig.getFACTORY().openSession();}
    public List<KhachHang> getAll(){return s.createQuery("from KhachHang ").list();}
    public KhachHang getOne(Integer id2){return s.find(KhachHang.class,id2);}


    public void addKhachHang(KhachHang KH){
        try {
            s.getTransaction().begin();
            s.persist(KH);
            s.getTransaction().commit();
        }catch (Exception e){
            e.printStackTrace();
            s.getTransaction().rollback();
        }
    }

    public void DeleteKhachHang(KhachHang KH){
        try {
            s.getTransaction().begin();
            s.delete(KH);
            s.getTransaction().commit();
        }catch (Exception e){
            e.printStackTrace();
            s.getTransaction().rollback();
        }
    }

    public void UpdateKhachHang(KhachHang KH){
        try {
            s.getTransaction().begin();
            s.merge(KH);
            s.getTransaction().commit();
        }catch (Exception e){
            e.printStackTrace();
            s.getTransaction().rollback();
        }
    }
    public List<KhachHang> search(String keyword) {
        return s.createQuery(
                "FROM KhachHang WHERE ma LIKE :kw",
                KhachHang.class)
                .setParameter("kw", "%" + keyword + "%")
                .list();
    }

    public static void main(String[] args) {
        System.out.println(new KhachHangResponsitory().getAll());
    }

}
