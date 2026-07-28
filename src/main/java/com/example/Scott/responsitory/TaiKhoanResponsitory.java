package com.example.Scott.responsitory;

import com.example.Scott.entity.TaiKhoan;
import com.example.Scott.utils.HibernateConfig;
import org.hibernate.Session;

public class TaiKhoanResponsitory {

    public TaiKhoan login(String username, String password) {

        try (Session session = HibernateConfig.getFACTORY().openSession()) {

            String hql = "FROM TaiKhoan WHERE tenDangNhap = :username "
                    + "AND matKhau = :password "
                    + "AND trangThai = 1";

            return session.createQuery(hql, TaiKhoan.class)
                    .setParameter("username", username)
                    .setParameter("password", password)
                    .uniqueResult();
        }
    }

}