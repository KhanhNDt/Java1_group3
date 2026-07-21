package com.example.Scott.responsitory;

import com.example.Scott.entity.PhieuGiamGia;
import com.example.Scott.utils.HibernateConfig;
import org.hibernate.Session;
import org.hibernate.query.Query;

import java.util.List;

public class PhieuGiamGiaResponsitory {

    // Hiển thị tất cả
    public List<PhieuGiamGia> getAll() {
        try (Session s = HibernateConfig.getFACTORY().openSession()) {
            return s.createQuery(
                    "FROM PhieuGiamGia ORDER BY id DESC",
                    PhieuGiamGia.class
            ).getResultList();
        }
    }

    // Lấy theo ID
    public PhieuGiamGia getOne(Integer id) {
        try (Session s = HibernateConfig.getFACTORY().openSession()) {
            return s.find(PhieuGiamGia.class, id);
        }
    }

    // Thêm
    public void addPhieuGiamGia(PhieuGiamGia pgg) {
        try (Session s = HibernateConfig.getFACTORY().openSession()) {
            s.beginTransaction();
            s.persist(pgg);
            s.getTransaction().commit();
        } catch (Exception e) {
            e.printStackTrace();
            throw new RuntimeException("Lỗi thêm phiếu giảm giá");
        }
    }

    // Sửa
    public void updatePhieuGiamGia(PhieuGiamGia pgg) {
        try (Session s = HibernateConfig.getFACTORY().openSession()) {
            s.beginTransaction();
            s.merge(pgg);
            s.getTransaction().commit();
        } catch (Exception e) {
            e.printStackTrace();
            throw new RuntimeException("Lỗi cập nhật phiếu giảm giá");
        }
    }

    // Xóa
    public void deletePhieuGiamGia(PhieuGiamGia pgg) {
        try (Session s = HibernateConfig.getFACTORY().openSession()) {
            s.beginTransaction();
            s.remove(s.contains(pgg) ? pgg : s.merge(pgg));
            s.getTransaction().commit();
        } catch (Exception e) {
            e.printStackTrace();
            throw new RuntimeException("Lỗi xóa phiếu giảm giá");
        }
    }

    // Tìm kiếm theo mã hoặc tên
    public List<PhieuGiamGia> search(String keyword) {

        try (Session s = HibernateConfig.getFACTORY().openSession()) {

            String hql = "FROM PhieuGiamGia " +
                    "WHERE maVoucher LIKE :kw " +
                    "OR tenVoucher LIKE :kw";

            Query<PhieuGiamGia> query =
                    s.createQuery(hql, PhieuGiamGia.class);

            query.setParameter("kw", "%" + keyword + "%");

            return query.getResultList();
        }
    }

    public static void main(String[] args) {
        System.out.println(new PhieuGiamGiaResponsitory().getAll());
    }
}