package com.example.Scott.responsitory;

import com.example.Scott.entity.PhieuGiamGia;
import com.example.Scott.utils.HibernateConfig;
import org.hibernate.Session;
import org.hibernate.Transaction;
import org.hibernate.query.Query;

import java.sql.Date;
import java.util.ArrayList;
import java.util.List;

public class PhieuGiamGiaResponsitory {

    // Lấy toàn bộ danh sách (Clear cache để luôn lấy dữ liệu mới nhất từ DB)
    public List<PhieuGiamGia> getAll() {
        List<PhieuGiamGia> list = new ArrayList<>();
        try (Session session = HibernateConfig.getFACTORY().openSession()) {
            session.clear(); // Xóa sạch first-level cache cũ
            list = session.createQuery("FROM PhieuGiamGia ORDER BY id DESC", PhieuGiamGia.class).list();
        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }

    /**
     * Danh sach phieu giam gia con hieu luc (dang bat, con luot dung, chua het han),
     * dung cho man hinh Ban hang tai quay.
     */
    public List<PhieuGiamGia> getValidVouchers() {
        List<PhieuGiamGia> list = new ArrayList<>();

        try (Session session = HibernateConfig.getFACTORY().openSession()) {

            String hql =
                    "FROM PhieuGiamGia p " +
                            "WHERE p.trangThai = 1 " +

                            // Đã đến ngày bắt đầu
                            "AND (p.ngayBatDau IS NULL OR p.ngayBatDau <= CURRENT_DATE) " +

                            // Chưa hết hạn
                            "AND (p.ngayKetThuc IS NULL OR p.ngayKetThuc >= CURRENT_DATE) " +

                            // Còn lượt sử dụng
                            "AND (p.soLuong IS NULL " +
                            "     OR COALESCE(p.soLuongDaDung, 0) < p.soLuong) " +

                            "ORDER BY p.id DESC";

            list = session
                    .createQuery(hql, PhieuGiamGia.class)
                    .getResultList();

            System.out.println("Số voucher hợp lệ: " + list.size());

            for (PhieuGiamGia p : list) {
                System.out.println(
                        "Voucher: " + p.getMaVoucher()
                                + " | Trạng thái: " + p.getTrangThai()
                                + " | Bắt đầu: " + p.getNgayBatDau()
                                + " | Kết thúc: " + p.getNgayKetThuc()
                                + " | Số lượng: " + p.getSoLuong()
                                + " | Đã dùng: " + p.getSoLuongDaDung()
                );
            }

        } catch (Exception e) {
            System.out.println("Lỗi lấy voucher hợp lệ:");
            e.printStackTrace();
        }

        return list;
    }

    // Lấy 1 đối tượng theo ID
    public PhieuGiamGia getOne(Integer id) {
        PhieuGiamGia pgg = null;
        try (Session session = HibernateConfig.getFACTORY().openSession()) {
            session.clear();
            pgg = session.get(PhieuGiamGia.class, id);
        } catch (Exception e) {
            e.printStackTrace();
        }
        return pgg;
    }

    // Thêm mới
    public void addPhieuGiamGia(PhieuGiamGia pgg) {
        Transaction transaction = null;
        try (Session session = HibernateConfig.getFACTORY().openSession()) {
            transaction = session.beginTransaction();
            session.save(pgg);
            session.flush(); // Ép ghi xuống DB lập tức
            transaction.commit();
        } catch (Exception e) {
            if (transaction != null) transaction.rollback();
            e.printStackTrace();
        }
    }

    // CẬP NHẬT (Sửa lại chuẩn 100%: Dùng merge + flush + commit)
    public void updatePhieuGiamGia(PhieuGiamGia pgg) {
        Transaction transaction = null;
        try (Session session = HibernateConfig.getFACTORY().openSession()) {
            transaction = session.beginTransaction();

            // Dùng merge để gắn lại Entity bị detached vào Session hiện tại
            session.merge(pgg);

            session.flush(); // Đẩy toàn bộ thay đổi xuống DB ngay lập tức
            transaction.commit(); // Chốt Transaction
        } catch (Exception e) {
            if (transaction != null) transaction.rollback();
            e.printStackTrace();
        }
    }

    // Xóa
    public void deletePhieuGiamGia(PhieuGiamGia pgg) {
        Transaction transaction = null;
        try (Session session = HibernateConfig.getFACTORY().openSession()) {
            transaction = session.beginTransaction();
            // Cần merge trước khi delete phòng trường hợp entity bị detached
            Object persistentInstance = session.merge(pgg);
            session.delete(persistentInstance);
            session.flush();
            transaction.commit();
        } catch (Exception e) {
            if (transaction != null) transaction.rollback();
            e.printStackTrace();
        }
    }

    // Tìm kiếm full điều kiện
    public List<PhieuGiamGia> searchFull(String keyword, String loaiGiamGia, Integer trangThai, Date from, Date to) {
        List<PhieuGiamGia> list = new ArrayList<>();
        try (Session session = HibernateConfig.getFACTORY().openSession()) {
            session.clear();
            StringBuilder hql = new StringBuilder("FROM PhieuGiamGia p WHERE 1=1 ");

            if (keyword != null && !keyword.trim().isEmpty()) {
                hql.append(" AND (p.maVoucher LIKE :kw OR p.tenVoucher LIKE :kw)");
            }
            if (loaiGiamGia != null && !loaiGiamGia.trim().isEmpty()) {
                hql.append(" AND p.loaiGiamGia = :loai");
            }
            if (trangThai != null) {
                hql.append(" AND p.trangThai = :tt");
            }
            if (from != null) {
                hql.append(" AND p.ngayBatDau >= :from");
            }
            if (to != null) {
                hql.append(" AND p.ngayKetThuc <= :to");
            }
            hql.append(" ORDER BY p.id DESC");

            Query<PhieuGiamGia> query = session.createQuery(hql.toString(), PhieuGiamGia.class);

            if (keyword != null && !keyword.trim().isEmpty()) {
                query.setParameter("kw", "%" + keyword.trim() + "%");
            }
            if (loaiGiamGia != null && !loaiGiamGia.trim().isEmpty()) {
                query.setParameter("loai", loaiGiamGia);
            }
            if (trangThai != null) {
                query.setParameter("tt", trangThai);
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
