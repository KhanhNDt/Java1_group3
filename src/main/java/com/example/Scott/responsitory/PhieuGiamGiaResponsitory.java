package com.example.Scott.responsitory;

import com.example.Scott.entity.PhieuGiamGia;
import com.example.Scott.utils.HibernateConfig;
import org.hibernate.Session;
import org.hibernate.query.Query;

import java.sql.Date;
import java.util.ArrayList;
import java.util.List;

public class PhieuGiamGiaResponsitory {

    // ================= LẤY TẤT CẢ =================
    public List<PhieuGiamGia> getAll() {
        try (Session session = HibernateConfig.getFACTORY().openSession()) {
            return session.createQuery("FROM PhieuGiamGia ORDER BY id DESC", PhieuGiamGia.class).list();
        } catch (Exception e) {
            e.printStackTrace();
            return new ArrayList<>();
        }
    }

    // ================= LẤY THEO ID =================
    public PhieuGiamGia getOne(Integer id) {
        try (Session session = HibernateConfig.getFACTORY().openSession()) {
            return session.get(PhieuGiamGia.class, id);
        } catch (Exception e) {
            e.printStackTrace();
            return null;
        }
    }

    // ================= THÊM MỚI =================
    public void addPhieuGiamGia(PhieuGiamGia pgg) {
        try (Session session = HibernateConfig.getFACTORY().openSession()) {
            session.beginTransaction();
            session.persist(pgg);
            session.getTransaction().commit();
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    // ================= CẬP NHẬT =================
    public void updatePhieuGiamGia(PhieuGiamGia pgg) {
        try (Session session = HibernateConfig.getFACTORY().openSession()) {
            session.beginTransaction();
            session.merge(pgg);
            session.getTransaction().commit();
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    // ================= XÓA =================
    public void deletePhieuGiamGia(PhieuGiamGia pgg) {
        try (Session session = HibernateConfig.getFACTORY().openSession()) {
            session.beginTransaction();
            session.remove(pgg);
            session.getTransaction().commit();
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    // ================= TÌM KIẾM ĐA ĐIỀU KIỆN (BAO GỒM TỪ NGÀY / ĐẾN NGÀY) =================
    public List<PhieuGiamGia> searchFull(String keyword, String loaiGiamGia, Integer trangThai, Date from, Date to) {
        List<PhieuGiamGia> list = new ArrayList<>();
        StringBuilder hql = new StringBuilder("FROM PhieuGiamGia p WHERE 1=1 ");

        if (keyword != null && !keyword.trim().isEmpty()) {
            hql.append(" AND (p.maVoucher LIKE :kw OR p.tenVoucher LIKE :kw) ");
        }
        if (loaiGiamGia != null && !loaiGiamGia.trim().isEmpty()) {
            hql.append(" AND p.loaiGiamGia = :loai ");
        }
        if (trangThai != null) {
            hql.append(" AND p.trangThai = :trangThai ");
        }
        if (from != null) {
            hql.append(" AND p.ngayBatDau >= :from ");
        }
        if (to != null) {
            hql.append(" AND p.ngayKetThuc <= :to ");
        }

        hql.append(" ORDER BY p.id DESC");

        try (Session session = HibernateConfig.getFACTORY().openSession()) {
            Query<PhieuGiamGia> query = session.createQuery(hql.toString(), PhieuGiamGia.class);

            if (keyword != null && !keyword.trim().isEmpty()) {
                query.setParameter("kw", "%" + keyword.trim() + "%");
            }
            if (loaiGiamGia != null && !loaiGiamGia.trim().isEmpty()) {
                query.setParameter("loai", loaiGiamGia.trim());
            }
            if (trangThai != null) {
                query.setParameter("trangThai", trangThai);
            }
            if (from != null) {
                query.setParameter("from", from);
            }
            if (to != null) {
                query.setParameter("to", to);
            }

            list = query.list();
        } catch (Exception e) {
            e.printStackTrace();
        }

        return list;
    }
}