package com.example.Scott.responsitory;

import com.example.Scott.entity.DiaChiKhachHang;
import com.example.Scott.utils.HibernateConfig;
import org.hibernate.Session;

import java.util.List;

public class DiaChiKhachHangResponsitory {

    private Session s;

    public DiaChiKhachHangResponsitory(){ s = HibernateConfig.getFACTORY().openSession();}
    public List<DiaChiKhachHang> getAll(){return s.createQuery(" from DiaChiKhachHang ").list();}


    public static void main(String[] args) {
        System.out.println(new DiaChiKhachHangResponsitory().getAll());
    }
}
