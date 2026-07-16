package com.example.Scott.responsitory;

import com.example.Scott.entity.DiaChiKhachHang;
import com.example.Scott.entity.KhachHang;
import com.example.Scott.utils.HibernateConfig;
import org.hibernate.Session;

import java.util.List;

public class DiaChiKhachHangResponsitory {

    private Session s;

    public DiaChiKhachHangResponsitory(){ s = HibernateConfig.getFACTORY().openSession();}
    public List<DiaChiKhachHang> getAll(){return s.createQuery(" from DiaChiKhachHang ").list();}
    public DiaChiKhachHang getOne(Integer id3){return s.find(DiaChiKhachHang.class,id3);}


    public DiaChiKhachHang AddDiaChiKH(DiaChiKhachHang DCKH) {
        try {
            s.getTransaction().begin();

            s.persist(DCKH);

            s.getTransaction().commit();

            return DCKH;

        } catch (Exception e) {

            if (s.getTransaction().isActive()) {
                s.getTransaction().rollback();
            }

            e.printStackTrace();

            return null;
        }
    }

    public void DeleteDiaChiKH(DiaChiKhachHang DCKH){
        try{
            s.getTransaction().begin();
            s.delete(DCKH);
            s.getTransaction().commit();
        }catch(Exception e){
            e.printStackTrace();
        }
    }

    public void UpdateDiaChiKH(DiaChiKhachHang DCKH){
        try{
            s.getTransaction().begin();
            s.merge(DCKH);
            s.getTransaction().commit();
        }catch(Exception e){
            e.printStackTrace();
        }
    }
    public static void main(String[] args) {
        System.out.println(new DiaChiKhachHangResponsitory().getAll());
    }
}
