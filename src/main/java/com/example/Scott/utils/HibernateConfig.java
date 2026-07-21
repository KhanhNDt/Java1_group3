package com.example.Scott.utils;

import com.example.Scott.entity.DiaChiKhachHang;
import com.example.Scott.entity.KhachHang;
import com.example.Scott.entity.PhieuGiamGia;
import com.example.Scott.entity.*;
import org.hibernate.SessionFactory;
import org.hibernate.boot.registry.StandardServiceRegistryBuilder;
import org.hibernate.cfg.Configuration;
import org.hibernate.cfg.Environment;
import org.hibernate.service.ServiceRegistry;

import java.util.Properties;

public class HibernateConfig {
    private static final SessionFactory FACTORY;

    static {
        Configuration conf = new Configuration();

        Properties properties = new Properties();
        properties.put(Environment.DIALECT, "org.hibernate.dialect.SQLServer2016Dialect");
        properties.put(Environment.DRIVER, "com.microsoft.sqlserver.jdbc.SQLServerDriver");
        properties.put(Environment.URL, envAny(
                new String[]{"SCOTT_DB_URL", "SQLSERVER_DB_URL"},
                "jdbc:sqlserver://localhost:1433;databaseName=DuAnJAVA1_Nhom3;encrypt=true;trustServerCertificate=true;"));
        properties.put(Environment.USER, envAny(new String[]{"SCOTT_DB_USER", "SQLSERVER_DB_USER"}, "sa"));
        properties.put(Environment.PASS, envAny(new String[]{"SCOTT_DB_PASSWORD", "SQLSERVER_DB_PASSWORD"}, "123123"));
        properties.put(Environment.SHOW_SQL, env("SCOTT_SHOW_SQL", "false"));
        properties.put(Environment.FORMAT_SQL, "false");
        properties.put(Environment.CURRENT_SESSION_CONTEXT_CLASS, "thread");

        conf.setProperties(properties);
        conf.addAnnotatedClass(KhachHang.class);
        conf.addAnnotatedClass(DiaChiKhachHang.class);

        conf.addAnnotatedClass(PhieuGiamGia.class);
        conf.addAnnotatedClass(ThuongHieu.class);
        conf.addAnnotatedClass(DanhMuc.class);
        conf.addAnnotatedClass(ChatLieu.class);
        conf.addAnnotatedClass(KieuDang.class);
        conf.addAnnotatedClass(MauSac.class);
        conf.addAnnotatedClass(Size.class);
        conf.addAnnotatedClass(SanPham.class);
        conf.addAnnotatedClass(ChiTietSanPham.class);
        conf.addAnnotatedClass(NhanVien.class);
        conf.addAnnotatedClass(TaiKhoan.class);
        conf.addAnnotatedClass(DiaChiApiMapping.class);
        conf.addAnnotatedClass(HoaDon.class);
        conf.addAnnotatedClass(HoaDonChiTiet.class);
        conf.addAnnotatedClass(LichSuHoaDon.class);
        conf.addAnnotatedClass(ThanhToanHoaDon.class);


        ServiceRegistry registry = new StandardServiceRegistryBuilder()
                .applySettings(conf.getProperties()).build();
        FACTORY = conf.buildSessionFactory(registry);

    }


    private static String env(String key, String fallback) {
        String value = System.getenv(key);
        return value == null || value.trim().isEmpty() ? fallback : value.trim();
    }

    private static String envAny(String[] keys, String fallback) {
        for (String key : keys) {
            String value = System.getenv(key);
            if (value != null && !value.trim().isEmpty()) {
                return value.trim();
            }
        }
        return fallback;
    }

    public static SessionFactory getFACTORY() {
        return FACTORY;
    }

    public static void main(String[] args) {
        System.out.println(getFACTORY());
    }
}
