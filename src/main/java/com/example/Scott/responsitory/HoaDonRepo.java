package com.example.Scott.responsitory;

import com.example.Scott.entity.HoaDon;
import com.example.Scott.entity.HoaDonChiTiet;
import com.example.Scott.utils.HibernateConfig;
import org.hibernate.Hibernate;
import org.hibernate.Session;
import org.hibernate.query.NativeQuery;
import org.hibernate.query.Query;

import java.math.BigInteger;
import java.sql.Timestamp;
import java.util.ArrayList;
import java.util.Date;
import java.util.List;

public class HoaDonRepo {
    private Session s;
    private Session getSession() {
        return HibernateConfig.getFACTORY().openSession();
    }

    // Lấy danh sách có phân trang
    public List<HoaDon> getFullInvoiceListPage(String keyword, Integer status, int offset, int limit) {
        List<HoaDon> list = new ArrayList<>();
        StringBuilder sql = new StringBuilder(
                "SELECT hd.*, " +
                        "kh.ho_ten AS ten_khach_hang, kh.sdt AS sdt_khach_hang, kh.dia_chi AS dia_chi_khach_hang, " +
                        "nv.ho_ten AS ten_nhan_vien, nv.ma_nhan_vien AS ma_nhan_vien " +
                        "FROM hoa_don hd " +
                        "LEFT JOIN khach_hang kh ON hd.id_khach_hang = kh.id " +
                        "LEFT JOIN nhan_vien nv ON hd.id_nhan_vien = nv.id " +
                        "WHERE 1=1 "
        );

        if (keyword != null && !keyword.trim().isEmpty()) {
            sql.append("AND (hd.ma_hoa_don LIKE :keyword OR kh.ho_ten LIKE :keyword OR kh.sdt LIKE :keyword) ");
        }
        if (status != null) {
            sql.append("AND hd.trang_thai = :status ");
        }

        sql.append("ORDER BY hd.ngay_tao DESC OFFSET :offset ROWS FETCH NEXT :limit ROWS ONLY");

        try (Session session = getSession()) {
            NativeQuery<Object[]> query = session.createNativeQuery(sql.toString());
            if (keyword != null && !keyword.trim().isEmpty()) {
                query.setParameter("keyword", "%" + keyword.trim() + "%");
            }
            if (status != null) {
                query.setParameter("status", status);
            }
            query.setParameter("offset", offset);
            query.setParameter("limit", limit);

            List<Object[]> rows = query.getResultList();
            for (Object[] row : rows) {
                list.add(mapRowToHoaDon(row));
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }

    private HoaDon mapRowToHoaDon(Object[] row) {
        HoaDon hd = new HoaDon();
        int idx = 0;
        hd.setId(((Number) row[idx++]).intValue());
        hd.setIdKhachHang(((Number) row[idx++]).intValue());
        hd.setIdNhanVien(((Number) row[idx++]).intValue());
        Object idPhieu = row[idx++];
        hd.setIdPhieuGiamGia(idPhieu != null ? ((Number) idPhieu).intValue() : null);
        hd.setMaHoaDon((String) row[idx++]);

        // Xử lý ngày an toàn
        Object ngayTaoObj = row[idx++];
        if (ngayTaoObj instanceof Timestamp) {
            hd.setNgayTao(new Date(((Timestamp) ngayTaoObj).getTime()));
        } else if (ngayTaoObj instanceof java.sql.Date) {
            hd.setNgayTao(new Date(((java.sql.Date) ngayTaoObj).getTime()));
        } else if (ngayTaoObj instanceof Date) {
            hd.setNgayTao((Date) ngayTaoObj);
        } else {
            hd.setNgayTao(null);
        }

        Object ngayThanhToanObj = row[idx++];
        if (ngayThanhToanObj instanceof Timestamp) {
            hd.setNgayThanhToan(new Date(((Timestamp) ngayThanhToanObj).getTime()));
        } else if (ngayThanhToanObj instanceof java.sql.Date) {
            hd.setNgayThanhToan(new Date(((java.sql.Date) ngayThanhToanObj).getTime()));
        } else if (ngayThanhToanObj instanceof Date) {
            hd.setNgayThanhToan((Date) ngayThanhToanObj);
        } else {
            hd.setNgayThanhToan(null);
        }

        hd.setTongTienThanhToan(((Number) row[idx++]).doubleValue());
        hd.setTrangThai(((Number) row[idx++]).intValue());
        hd.setGhiChu((String) row[idx++]);
        hd.setTenKhachHang((String) row[idx++]);
        hd.setSdtKhachHang((String) row[idx++]);
        hd.setDiaChiKhachHang((String) row[idx++]);
        hd.setTenNhanVien((String) row[idx++]);
        hd.setMaNhanVien((String) row[idx]);
        return hd;
    }

    // Đếm tổng bản ghi
    public int countFullInvoiceList(String keyword, Integer status) {
        StringBuilder sql = new StringBuilder(
                "SELECT COUNT(*) FROM hoa_don hd " +
                        "LEFT JOIN khach_hang kh ON hd.id_khach_hang = kh.id " +
                        "WHERE 1=1 "
        );
        List<Object> params = new ArrayList<>();

        if (keyword != null && !keyword.trim().isEmpty()) {
            sql.append("AND (hd.ma_hoa_don LIKE ? OR kh.ho_ten LIKE ? OR kh.sdt LIKE ?) ");
            String kw = "%" + keyword.trim() + "%";
            params.add(kw);
            params.add(kw);
            params.add(kw);
        }
        if (status != null) {
            sql.append("AND hd.trang_thai = ? ");
            params.add(status);
        }

        try (Session session = getSession()) {
            NativeQuery<BigInteger> query = session.createNativeQuery(sql.toString());
            for (int i = 0; i < params.size(); i++) {
                query.setParameter(i + 1, params.get(i));
            }
            return query.getSingleResult().intValue();
        } catch (Exception e) {
            e.printStackTrace();
            return 0;
        }
    }

    // Lấy hóa đơn theo id
    public HoaDon getById(Integer id) {
        String sql = "SELECT hd.id, hd.ma_hoa_don, hd.ngay_tao, hd.ngay_thanh_toan, hd.tong_tien_thanh_toan, " +
                "hd.trang_thai, hd.ghi_chu, hd.id_khach_hang, hd.id_nhan_vien, hd.id_phieu_giam_gia, " +
                "kh.ho_ten AS ten_khach_hang, nv.ho_ten AS ten_nhan_vien, pgg.ma_voucher " +
                "FROM hoa_don hd " +
                "LEFT JOIN khach_hang kh ON hd.id_khach_hang = kh.id " +
                "LEFT JOIN nhan_vien nv ON hd.id_nhan_vien = nv.id " +
                "LEFT JOIN phieu_giam_gia pgg ON hd.id_phieu_giam_gia = pgg.id " +
                "WHERE hd.id = :id";

        try (Session session = getSession()) {
            NativeQuery<Object[]> query = session.createNativeQuery(sql);
            query.setParameter("id", id);
            Object[] row = query.getSingleResult();
            if (row != null) {
                HoaDon hd = new HoaDon();
                hd.setId((Integer) row[0]);
                hd.setMaHoaDon((String) row[1]);
                hd.setNgayTao((Date) row[2]);
                hd.setNgayThanhToan((Date) row[3]);
                hd.setTongTienThanhToan((Double) row[4]);
                hd.setTrangThai((Integer) row[5]);
                hd.setGhiChu((String) row[6]);
                hd.setIdKhachHang((Integer) row[7]);
                hd.setIdNhanVien((Integer) row[8]);
                hd.setIdPhieuGiamGia((Integer) row[9]);
                hd.setTenKhachHang((String) row[10]);
                hd.setTenNhanVien((String) row[11]);
                hd.setMaVoucher((String) row[12]);
                return hd;
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return null;
    }

    // Lấy chi tiết sản phẩm của hóa đơn
    public List<HoaDonChiTiet> getChiTietByHoaDonId(Integer hoaDonId) {
        String sql = "SELECT cthd.id, cthd.id_hoa_don, cthd.id_san_pham_chi_tiet, cthd.so_luong, " +
                "cthd.don_gia, cthd.gia_ban_ra, cthd.tong_tien, cthd.trang_thai, sp.ten_san_pham " +
                "FROM chi_tiet_hoa_don cthd " +
                "JOIN chi_tiet_san_pham ctsp ON cthd.id_san_pham_chi_tiet = ctsp.id " +
                "JOIN san_pham sp ON ctsp.id_san_pham = sp.id " +
                "WHERE cthd.id_hoa_don = :idHoaDon";

        try (Session session = getSession()) {
            NativeQuery<Object[]> query = session.createNativeQuery(sql);
            query.setParameter("idHoaDon", hoaDonId);
            List<Object[]> rows = query.getResultList();
            List<HoaDonChiTiet> list = new ArrayList<>();
            for (Object[] row : rows) {
                HoaDonChiTiet hdct = new HoaDonChiTiet();
                hdct.setId((Integer) row[0]);
                hdct.setIdHoaDon((Integer) row[1]);
                hdct.setIdSanPhamChiTiet((Integer) row[2]);
                hdct.setSoLuong((Integer) row[3]);
                hdct.setDonGia((Double) row[4]);
                hdct.setGiaBanRa((Double) row[5]);
                hdct.setTongTien((Double) row[6]);
                hdct.setTrangThai((Integer) row[7]);
                hdct.setTenSanPham((String) row[8]);
                list.add(hdct);
            }
            return list;
        } catch (Exception e) {
            e.printStackTrace();
            return new ArrayList<>();
        }
    }

    // Cập nhật trạng thái
    public boolean updateTrangThai(Integer id, Integer status) {
        String hql = "UPDATE HoaDon SET trangThai = :status WHERE id = :id";
        try (Session session = getSession()) {
            session.getTransaction().begin();
            int result = session.createQuery(hql)
                    .setParameter("status", status)
                    .setParameter("id", id)
                    .executeUpdate();
            session.getTransaction().commit();
            return result > 0;
        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }

    // Xóa mềm
    public boolean softDeleteInvoice(Integer id) {
        return updateTrangThai(id, 3);
    }

    // Cập nhật ghi chú
    public boolean updateGhiChu(Integer id, String ghiChu) {
        String hql = "UPDATE HoaDon SET ghiChu = :ghiChu WHERE id = :id";
        try (Session session = getSession()) {
            session.getTransaction().begin();
            int result = session.createQuery(hql)
                    .setParameter("ghiChu", ghiChu)
                    .setParameter("id", id)
                    .executeUpdate();
            session.getTransaction().commit();
            return result > 0;
        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }

    // Xuất Excel
    public List<HoaDon> getAllInvoicesForExport(String keyword, Integer status) {
        StringBuilder sql = new StringBuilder(
                "SELECT hd.id, hd.ma_hoa_don, hd.ngay_tao, hd.ngay_thanh_toan, hd.tong_tien_thanh_toan, " +
                        "hd.trang_thai, hd.ghi_chu, hd.id_khach_hang, hd.id_nhan_vien, hd.id_phieu_giam_gia, " +
                        "kh.ho_ten AS ten_khach_hang, nv.ho_ten AS ten_nhan_vien, pgg.ma_voucher " +
                        "FROM hoa_don hd " +
                        "LEFT JOIN khach_hang kh ON hd.id_khach_hang = kh.id " +
                        "LEFT JOIN nhan_vien nv ON hd.id_nhan_vien = nv.id " +
                        "LEFT JOIN phieu_giam_gia pgg ON hd.id_phieu_giam_gia = pgg.id " +
                        "WHERE 1=1 "
        );
        if (keyword != null && !keyword.trim().isEmpty()) {
            sql.append("AND (hd.ma_hoa_don LIKE :keyword OR kh.ho_ten LIKE :keyword OR kh.sdt LIKE :keyword) ");
        }
        if (status != null) {
            sql.append("AND hd.trang_thai = :status ");
        }
        sql.append("ORDER BY hd.ngay_tao DESC");

        try (Session session = getSession()) {
            NativeQuery<Object[]> query = session.createNativeQuery(sql.toString());
            if (keyword != null && !keyword.trim().isEmpty()) {
                query.setParameter("keyword", "%" + keyword.trim() + "%");
            }
            if (status != null) {
                query.setParameter("status", status);
            }
            List<Object[]> rows = query.getResultList();
            List<HoaDon> list = new ArrayList<>();
            for (Object[] row : rows) {
                HoaDon hd = new HoaDon();
                hd.setId((Integer) row[0]);
                hd.setMaHoaDon((String) row[1]);
                hd.setNgayTao((Date) row[2]);
                hd.setNgayThanhToan((Date) row[3]);
                hd.setTongTienThanhToan((Double) row[4]);
                hd.setTrangThai((Integer) row[5]);
                hd.setGhiChu((String) row[6]);
                hd.setIdKhachHang((Integer) row[7]);
                hd.setIdNhanVien((Integer) row[8]);
                hd.setIdPhieuGiamGia((Integer) row[9]);
                hd.setTenKhachHang((String) row[10]);
                hd.setTenNhanVien((String) row[11]);
                hd.setMaVoucher((String) row[12]);
                list.add(hd);
            }
            return list;
        } catch (Exception e) {
            e.printStackTrace();
            return new ArrayList<>();
        }
    }

    // Thống kê
    public int getTotalOrdersToday() {
        String sql = "SELECT COUNT(*) FROM hoa_don WHERE CAST(ngay_tao AS DATE) = CAST(GETDATE() AS DATE)";
        try (Session session = getSession()) {
            NativeQuery<Long> query = session.createNativeQuery(sql);
            return query.getSingleResult().intValue();
        } catch (Exception e) {
            e.printStackTrace();
            return 0;
        }
    }

    public Double getTotalRevenueToday() {
        String sql = "SELECT ISNULL(SUM(tong_tien_thanh_toan), 0) FROM hoa_don WHERE CAST(ngay_tao AS DATE) = CAST(GETDATE() AS DATE) AND trang_thai = 1";
        try (Session session = getSession()) {
            NativeQuery<Double> query = session.createNativeQuery(sql);
            return query.getSingleResult();
        } catch (Exception e) {
            e.printStackTrace();
            return 0.0;
        }
    }

    public int getPendingOrders() {
        String sql = "SELECT COUNT(*) FROM hoa_don WHERE trang_thai = 0";
        try (Session session = getSession()) {
            NativeQuery<Long> query = session.createNativeQuery(sql);
            return query.getSingleResult().intValue();
        } catch (Exception e) {
            e.printStackTrace();
            return 0;
        }
    }

    public int getCancelledOrders() {
        String sql = "SELECT COUNT(*) FROM hoa_don WHERE trang_thai = 2";
        try (Session session = getSession()) {
            NativeQuery<Long> query = session.createNativeQuery(sql);
            return query.getSingleResult().intValue();
        } catch (Exception e) {
            e.printStackTrace();
            return 0;
        }
    }
}