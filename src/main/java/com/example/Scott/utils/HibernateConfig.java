package com.example.Scott.utils;

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
        properties.put(Environment.URL, getEnv("SQLSERVER_DB_URL", "jdbc:sqlserver://localhost:1433;databaseName=DuAnJAVA1_Nhom3;encrypt=true;trustServerCertificate=true;"));
        properties.put(Environment.USER, getEnv("SQLSERVER_DB_USER", "sa"));
        properties.put(Environment.PASS, getEnv("SQLSERVER_DB_PASSWORD", "123"));
        properties.put(Environment.SHOW_SQL, "true");

        conf.setProperties(properties);
//        conf.addAnnotatedClass(NhanVien.class);
//        conf.addAnnotatedClass(TaiKhoan.class);
        conf.addAnnotatedClass(KhachHang.class);
        conf.addAnnotatedClass(DiaChiKhachHang.class);
        conf.addAnnotatedClass(NhanVien.class);
        conf.addAnnotatedClass(DiaChiApiMapping.class);
//        conf.addAnnotatedClass(ThuongHieu.class);
//        conf.addAnnotatedClass(MauSac.class);
//        conf.addAnnotatedClass(Size.class);
//        conf.addAnnotatedClass(SanPham.class);
//        conf.addAnnotatedClass(ChiTietSanPham.class);
//        conf.addAnnotatedClass(HinhAnh.class);
        conf.addAnnotatedClass(PhieuGiamGia.class);
//        conf.addAnnotatedClass(PhuongThucThanhToan.class);
        conf.addAnnotatedClass(HoaDon.class);
        conf.addAnnotatedClass(HoaDonChiTiet.class);

        ServiceRegistry registry = new StandardServiceRegistryBuilder()
                .applySettings(conf.getProperties()).build();
        FACTORY = conf.buildSessionFactory(registry);

    }

    public static SessionFactory getFACTORY() {
        return FACTORY;
    }

    private static String getEnv(String name, String defaultValue) {
        String value = System.getenv(name);
        return value == null || value.trim().isEmpty() ? defaultValue : value;
    }

    public static void main(String[] args) {
        System.out.println(getFACTORY());
    }
}
