package com.example.Scott.responsitory;

import com.example.Scott.entity.HoaDon;
import com.example.Scott.entity.HoaDonChiTiet;
import com.example.Scott.utils.HibernateConfig;
import org.hibernate.Session;
import org.hibernate.Transaction;
import org.hibernate.query.NativeQuery;
import java.math.BigInteger;
import java.sql.Timestamp;
import java.util.ArrayList;
import java.util.Date;
import java.util.List;

public class HoaDonRepo {

    private Session getSession() {
        return HibernateConfig.getFACTORY().openSession();
    }

    // Helper an toàn để ép kiểu Number sang Integer
    private Integer toInteger(Object obj) {
        return obj != null ? ((Number) obj).intValue() : null;
    }

    // Helper an toàn để ép kiểu Number sang Double
    private Double toDouble(Object obj) {
        return obj != null ? ((Number) obj).doubleValue() : 0.0;
    }

    // Helper xử lý Date an toàn từ Database
    private Date toDate(Object obj) {
        if (obj instanceof Timestamp) return new Date(((Timestamp) obj).getTime());
        if (obj instanceof java.sql.Date) return new Date(((java.sql.Date) obj).getTime());
        if (obj instanceof Date) return (Date) obj;
        return null;
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
        hd.setId(toInteger(row[idx++]));
        hd.setIdKhachHang(toInteger(row[idx++]));
        hd.setIdNhanVien(toInteger(row[idx++]));
        hd.setIdPhieuGiamGia(toInteger(row[idx++]));
        hd.setMaHoaDon((String) row[idx++]);
        hd.setNgayTao(toDate(row[idx++]));
        hd.setNgayThanhToan(toDate(row[idx++]));
        hd.setTongTienThanhToan(toDouble(row[idx++]));
        hd.setTrangThai(toInteger(row[idx++]));
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

        if (keyword != null && !keyword.trim().isEmpty()) {
            sql.append("AND (hd.ma_hoa_don LIKE :keyword OR kh.ho_ten LIKE :keyword OR kh.sdt LIKE :keyword) ");
        }
        if (status != null) {
            sql.append("AND hd.trang_thai = :status ");
        }

        try (Session session = getSession()) {
            NativeQuery<?> query = session.createNativeQuery(sql.toString());
            if (keyword != null && !keyword.trim().isEmpty()) {
                query.setParameter("keyword", "%" + keyword.trim() + "%");
            }
            if (status != null) {
                query.setParameter("status", status);
            }
            return toInteger(query.getSingleResult());
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
            Object[] row = query.uniqueResult(); // Dùng uniqueResult an toàn hơn getSingleResult nếu không có dữ liệu
            if (row != null) {
                HoaDon hd = new HoaDon();
                hd.setId(toInteger(row[0]));
                hd.setMaHoaDon((String) row[1]);
                hd.setNgayTao(toDate(row[2]));
                hd.setNgayThanhToan(toDate(row[3]));
                hd.setTongTienThanhToan(toDouble(row[4]));
                hd.setTrangThai(toInteger(row[5]));
                hd.setGhiChu((String) row[6]);
                hd.setIdKhachHang(toInteger(row[7]));
                hd.setIdNhanVien(toInteger(row[8]));
                hd.setIdPhieuGiamGia(toInteger(row[9]));
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

        List<HoaDonChiTiet> list = new ArrayList<>();
        try (Session session = getSession()) {
            NativeQuery<Object[]> query = session.createNativeQuery(sql);
            query.setParameter("idHoaDon", hoaDonId);
            List<Object[]> rows = query.getResultList();
            for (Object[] row : rows) {
                HoaDonChiTiet hdct = new HoaDonChiTiet();
                hdct.setId(toInteger(row[0]));
                hdct.setIdHoaDon(toInteger(row[1]));
                hdct.setIdSanPhamChiTiet(toInteger(row[2]));
                hdct.setSoLuong(toInteger(row[3]));
                hdct.setDonGia(toDouble(row[4]));
                hdct.setGiaBanRa(toDouble(row[5]));
                hdct.setTongTien(toDouble(row[6]));
                hdct.setTrangThai(toInteger(row[7]));
                hdct.setTenSanPham((String) row[8]);
                list.add(hdct);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }

    // Cập nhật trạng thái an toàn Transaction
    public boolean updateTrangThai(Integer id, Integer status) {
        String hql = "UPDATE HoaDon SET trangThai = :status WHERE id = :id";
        Transaction tx = null;
        try (Session session = getSession()) {
            tx = session.beginTransaction();
            int result = session.createQuery(hql)
                    .setParameter("status", status)
                    .setParameter("id", id)
                    .executeUpdate();
            tx.commit();
            return result > 0;
        } catch (Exception e) {
            if (tx != null) tx.rollback();
            e.printStackTrace();
            return false;
        }
    }

    // Xóa mềm
    public boolean softDeleteInvoice(Integer id) {
        return updateTrangThai(id, 3);
    }

    // Cập nhật ghi chú an toàn Transaction
    public boolean updateGhiChu(Integer id, String ghiChu) {
        String hql = "UPDATE HoaDon SET ghiChu = :ghiChu WHERE id = :id";
        Transaction tx = null;
        try (Session session = getSession()) {
            tx = session.beginTransaction();
            int result = session.createQuery(hql)
                    .setParameter("ghiChu", ghiChu)
                    .setParameter("id", id)
                    .executeUpdate();
            tx.commit();
            return result > 0;
        } catch (Exception e) {
            if (tx != null) tx.rollback();
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

        List<HoaDon> list = new ArrayList<>();
        try (Session session = getSession()) {
            NativeQuery<Object[]> query = session.createNativeQuery(sql.toString());
            if (keyword != null && !keyword.trim().isEmpty()) {
                query.setParameter("keyword", "%" + keyword.trim() + "%");
            }
            if (status != null) {
                query.setParameter("status", status);
            }
            List<Object[]> rows = query.getResultList();
            for (Object[] row : rows) {
                HoaDon hd = new HoaDon();
                hd.setId(toInteger(row[0]));
                hd.setMaHoaDon((String) row[1]);
                hd.setNgayTao(toDate(row[2]));
                hd.setNgayThanhToan(toDate(row[3]));
                hd.setTongTienThanhToan(toDouble(row[4]));
                hd.setTrangThai(toInteger(row[5]));
                hd.setGhiChu((String) row[6]);
                hd.setIdKhachHang(toInteger(row[7]));
                hd.setIdNhanVien(toInteger(row[8]));
                hd.setIdPhieuGiamGia(toInteger(row[9]));
                hd.setTenKhachHang((String) row[10]);
                hd.setTenNhanVien((String) row[11]);
                hd.setMaVoucher((String) row[12]);
                list.add(hd);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }

    // Thống kê an toàn kiểu dữ liệu
    public int getTotalOrdersToday() {
        String sql = "SELECT COUNT(*) FROM hoa_don WHERE CAST(ngay_tao AS DATE) = CAST(GETDATE() AS DATE)";
        try (Session session = getSession()) {
            NativeQuery<?> query = session.createNativeQuery(sql);
            return toInteger(query.getSingleResult());
        } catch (Exception e) {
            e.printStackTrace();
            return 0;
        }
    }

    public Double getTotalRevenueToday() {
        String sql = "SELECT ISNULL(SUM(tong_tien_thanh_toan), 0) FROM hoa_don WHERE CAST(ngay_tao AS DATE) = CAST(GETDATE() AS DATE) AND trang_thai = 1";
        try (Session session = getSession()) {
            NativeQuery<?> query = session.createNativeQuery(sql);
            return toDouble(query.getSingleResult());
        } catch (Exception e) {
            e.printStackTrace();
            return 0.0;
        }
    }

    public int getPendingOrders() {
        String sql = "SELECT COUNT(*) FROM hoa_don WHERE trang_thai = 0";
        try (Session session = getSession()) {
            NativeQuery<?> query = session.createNativeQuery(sql);
            return toInteger(query.getSingleResult());
        } catch (Exception e) {
            e.printStackTrace();
            return 0;
        }
    }

    public int getCancelledOrders() {
        String sql = "SELECT COUNT(*) FROM hoa_don WHERE trang_thai = 2";
        try (Session session = getSession()) {
            NativeQuery<?> query = session.createNativeQuery(sql);
            return toInteger(query.getSingleResult());
        } catch (Exception e) {
            e.printStackTrace();
            return 0;
        }
    }
}