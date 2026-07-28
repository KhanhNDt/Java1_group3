package com.example.Scott.responsitory;

import com.example.Scott.dto.DoanhThuDiemDTO;
import com.example.Scott.entity.HoaDon;
import com.example.Scott.entity.HoaDonChiTiet;
import com.example.Scott.entity.LichSuHoaDon;
import com.example.Scott.entity.ThanhToanHoaDon;
import com.example.Scott.utils.HibernateConfig;
import org.hibernate.Session;
import org.hibernate.Transaction;
import org.hibernate.query.NativeQuery;
import java.math.BigInteger;
import java.sql.Timestamp;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.Date;
import java.util.LinkedHashMap;
import java.util.List;
import java.util.Map;

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
    public List<HoaDon> getFullInvoiceListPage(String keyword, Integer status, String fromDate, String toDate, int offset, int limit) {
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
        if (fromDate != null && !fromDate.trim().isEmpty()) sql.append("AND CAST(hd.ngay_tao AS DATE) >= CAST(:fromDate AS DATE) ");
        if (toDate != null && !toDate.trim().isEmpty()) sql.append("AND CAST(hd.ngay_tao AS DATE) <= CAST(:toDate AS DATE) ");

        sql.append("ORDER BY hd.ngay_tao DESC OFFSET :offset ROWS FETCH NEXT :limit ROWS ONLY");

        try (Session session = getSession()) {
            NativeQuery<Object[]> query = session.createNativeQuery(sql.toString());
            if (keyword != null && !keyword.trim().isEmpty()) {
                query.setParameter("keyword", "%" + keyword.trim() + "%");
            }
            if (status != null) {
                query.setParameter("status", status);
            }
            if (fromDate != null && !fromDate.trim().isEmpty()) query.setParameter("fromDate", fromDate);
            if (toDate != null && !toDate.trim().isEmpty()) query.setParameter("toDate", toDate);
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
    public int countFullInvoiceList(String keyword, Integer status, String fromDate, String toDate) {
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
        if (fromDate != null && !fromDate.trim().isEmpty()) sql.append("AND CAST(hd.ngay_tao AS DATE) >= CAST(:fromDate AS DATE) ");
        if (toDate != null && !toDate.trim().isEmpty()) sql.append("AND CAST(hd.ngay_tao AS DATE) <= CAST(:toDate AS DATE) ");

        try (Session session = getSession()) {
            NativeQuery<?> query = session.createNativeQuery(sql.toString());
            if (keyword != null && !keyword.trim().isEmpty()) {
                query.setParameter("keyword", "%" + keyword.trim() + "%");
            }
            if (status != null) {
                query.setParameter("status", status);
            }
            if (fromDate != null && !fromDate.trim().isEmpty()) query.setParameter("fromDate", fromDate);
            if (toDate != null && !toDate.trim().isEmpty()) query.setParameter("toDate", toDate);
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
                "kh.ho_ten AS ten_khach_hang, kh.sdt, kh.dia_chi, " +
                "dc.ten_nguoi_nhan, dc.sdt_nguoi_nhan, " +
                "CONCAT(dc.dia_chi_cu_the, ', ', dc.phuong_xa, ', ', dc.quan_huyen, ', ', dc.tinh_thanh) AS dia_chi_giao_hang, " +
                "nv.ho_ten AS ten_nhan_vien, nv.ma_nhan_vien, " +
                "pgg.ma_voucher, pgg.ten_voucher, pgg.loai_giam_gia, pgg.gia_tri_giam, " +
                "pgg.giam_toi_da, pgg.don_toi_thieu " +
                "FROM hoa_don hd " +
                "LEFT JOIN khach_hang kh ON hd.id_khach_hang = kh.id " +
                "LEFT JOIN dia_chi_khach_hang dc ON dc.id_khach_hang = kh.id AND dc.is_mac_dinh = 1 " +
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
                hd.setSdtKhachHang((String) row[11]);
                hd.setDiaChiKhachHang((String) row[12]);
                hd.setTenNguoiNhan((String) row[13]);
                hd.setSdtNguoiNhan((String) row[14]);
                hd.setDiaChiGiaoHang((String) row[15]);
                hd.setTenNhanVien((String) row[16]);
                hd.setMaNhanVien((String) row[17]);
                hd.setMaVoucher((String) row[18]);
                hd.setTenVoucher((String) row[19]);
                hd.setLoaiGiamGia((String) row[20]);
                hd.setGiaTriGiam(toDouble(row[21]));
                hd.setGiamToiDa(toDouble(row[22]));
                hd.setDonToiThieu(toDouble(row[23]));
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
                "cthd.don_gia, cthd.gia_ban_ra, cthd.tong_tien, cthd.trang_thai, " +
                "sp.ten_san_pham, sp.ma_san_pham, ctsp.ma, ms.ten, sz.ten " +
                "FROM chi_tiet_hoa_don cthd " +
                "JOIN chi_tiet_san_pham ctsp ON cthd.id_san_pham_chi_tiet = ctsp.id " +
                "JOIN san_pham sp ON ctsp.id_san_pham = sp.id " +
                "LEFT JOIN mau_sac ms ON ctsp.id_mau_sac = ms.id " +
                "LEFT JOIN size sz ON ctsp.id_size = sz.id " +
                "WHERE cthd.id_hoa_don = :idHoaDon";

        List<HoaDonChiTiet> list = new ArrayList<>();
        try (Session session = getSession()) {
            session.doWork(connection -> {
                String jdbcSql = sql.replace(":idHoaDon", "?");
                try (PreparedStatement statement = connection.prepareStatement(jdbcSql)) {
                    statement.setInt(1, hoaDonId);
                    try (ResultSet row = statement.executeQuery()) {
                        while (row.next()) {
                            HoaDonChiTiet hdct = new HoaDonChiTiet();
                            hdct.setId(row.getInt(1));
                            hdct.setIdHoaDon(row.getInt(2));
                            hdct.setIdSanPhamChiTiet(row.getInt(3));
                            hdct.setSoLuong(row.getInt(4));
                            hdct.setDonGia(row.getDouble(5));
                            hdct.setGiaBanRa(row.getDouble(6));
                            hdct.setTongTien(row.getDouble(7));
                            hdct.setTrangThai(row.getInt(8));
                            hdct.setTenSanPham(row.getString(9));
                            hdct.setMaSanPham(row.getString(10));
                            hdct.setMaBienThe(row.getString(11));
                            hdct.setMauSac(row.getString(12));
                            hdct.setKichThuoc(row.getString(13));
                            list.add(hdct);
                        }
                    }
                }
            });
        } catch (Exception e) {
            throw new IllegalStateException("Không thể tải sản phẩm của hóa đơn " + hoaDonId, e);
        }
        return list;
    }


    public List<LichSuHoaDon> getLichSuByHoaDonId(Integer hoaDonId) {
        String sql = "SELECT id, ma, thoi_gian, ghi_chu, trang_thai " +
                "FROM lich_su_hoa_don WHERE id_hoa_don = :id ORDER BY thoi_gian DESC, id DESC";
        List<LichSuHoaDon> list = new ArrayList<>();
        try (Session session = getSession()) {
            NativeQuery<Object[]> query = session.createNativeQuery(sql);
            query.setParameter("id", hoaDonId);
            for (Object[] row : query.getResultList()) {
                list.add(new LichSuHoaDon(toInteger(row[0]), (String) row[1], toDate(row[2]),
                        (String) row[3], toInteger(row[4])));
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }

    public List<ThanhToanHoaDon> getThanhToanByHoaDonId(Integer hoaDonId) {
        String sql = "SELECT tthd.id, tthd.ma_giao_dich, pttt.ten_pttt, tthd.so_tien, " +
                "tthd.thoi_gian, tthd.trang_thai, tthd.gho_chu " +
                "FROM thanh_toan_hoa_don tthd " +
                "LEFT JOIN phuong_thuc_thanh_toan pttt ON tthd.id_pttt = pttt.id " +
                "WHERE tthd.id_hoa_don = :id ORDER BY tthd.thoi_gian DESC, tthd.id DESC";
        List<ThanhToanHoaDon> list = new ArrayList<>();
        try (Session session = getSession()) {
            NativeQuery<Object[]> query = session.createNativeQuery(sql);
            query.setParameter("id", hoaDonId);
            for (Object[] row : query.getResultList()) {
                list.add(new ThanhToanHoaDon(toInteger(row[0]), (String) row[1], (String) row[2],
                        toDouble(row[3]), toDate(row[4]), toInteger(row[5]), (String) row[6]));
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
            if (result > 0) {
                String historySql = "INSERT INTO lich_su_hoa_don (id_hoa_don, ma, thoi_gian, ghi_chu, trang_thai) " +
                        "VALUES (:id, :ma, GETDATE(), :ghiChu, :status)";
                session.createNativeQuery(historySql)
                        .setParameter("id", id)
                        .setParameter("ma", "LS-" + id + "-" + System.currentTimeMillis())
                        .setParameter("ghiChu", "Cập nhật trạng thái hóa đơn: " + getTrangThaiLabel(status))
                        .setParameter("status", status)
                        .executeUpdate();
            }
            tx.commit();
            return result > 0;
        } catch (Exception e) {
            if (tx != null) tx.rollback();
            e.printStackTrace();
            return false;
        }
    }

    private String getTrangThaiLabel(Integer status) {
        if (status == null) return "Không xác định";
        switch (status) {
            case 0: return "Chờ xử lý";
            case 1: return "Đã thanh toán";
            case 2: return "Đã hủy";
            case 3: return "Đã xóa";
            default: return "Không xác định";
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
    public List<HoaDon> getAllInvoicesForExport(String keyword, Integer status, String fromDate, String toDate) {
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
        if (fromDate != null && !fromDate.trim().isEmpty()) sql.append("AND CAST(hd.ngay_tao AS DATE) >= CAST(:fromDate AS DATE) ");
        if (toDate != null && !toDate.trim().isEmpty()) sql.append("AND CAST(hd.ngay_tao AS DATE) <= CAST(:toDate AS DATE) ");
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
            if (fromDate != null && !fromDate.trim().isEmpty()) query.setParameter("fromDate", fromDate);
            if (toDate != null && !toDate.trim().isEmpty()) query.setParameter("toDate", toDate);
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

    // ================== THỐNG KÊ CHO TRANG DASHBOARD ==================

    /**
     * Đếm số đơn hàng trong khoảng [from, to] (theo ngày tạo), không tính đơn đã xóa mềm (trạng thái 3).
     * status = null -> lấy tất cả trạng thái còn lại.
     */
    public int getOrderCountBetween(String from, String to, Integer status) {
        StringBuilder sql = new StringBuilder(
                "SELECT COUNT(*) FROM hoa_don WHERE trang_thai <> 3 " +
                        "AND CAST(ngay_tao AS DATE) BETWEEN CAST(:from AS DATE) AND CAST(:to AS DATE) ");
        if (status != null) sql.append("AND trang_thai = :status ");
        try (Session session = getSession()) {
            NativeQuery<?> query = session.createNativeQuery(sql.toString());
            query.setParameter("from", from);
            query.setParameter("to", to);
            if (status != null) query.setParameter("status", status);
            return toInteger(query.getSingleResult());
        } catch (Exception e) {
            e.printStackTrace();
            return 0;
        }
    }

    /**
     * Tổng doanh thu trong khoảng [from, to]. status = 1 -> chỉ đơn đã thanh toán (doanh thu thực tế).
     * status = null -> tất cả đơn chưa xóa/hủy (doanh thu dự kiến).
     */
    public double getRevenueSum(String from, String to, Integer status) {
        StringBuilder sql = new StringBuilder(
                "SELECT ISNULL(SUM(tong_tien_thanh_toan), 0) FROM hoa_don " +
                        "WHERE trang_thai NOT IN (2, 3) " +
                        "AND CAST(ngay_tao AS DATE) BETWEEN CAST(:from AS DATE) AND CAST(:to AS DATE) ");
        if (status != null) sql.append("AND trang_thai = :status ");
        try (Session session = getSession()) {
            NativeQuery<?> query = session.createNativeQuery(sql.toString());
            query.setParameter("from", from);
            query.setParameter("to", to);
            if (status != null) query.setParameter("status", status);
            return toDouble(query.getSingleResult());
        } catch (Exception e) {
            e.printStackTrace();
            return 0.0;
        }
    }

    /**
     * Đếm số biến thể sản phẩm khác nhau đã bán (đơn đã thanh toán) trong khoảng [from, to].
     */
    public int getDistinctProductCountBetween(String from, String to) {
        String sql = "SELECT COUNT(DISTINCT cthd.id_san_pham_chi_tiet) " +
                "FROM chi_tiet_hoa_don cthd JOIN hoa_don hd ON cthd.id_hoa_don = hd.id " +
                "WHERE hd.trang_thai = 1 " +
                "AND CAST(hd.ngay_tao AS DATE) BETWEEN CAST(:from AS DATE) AND CAST(:to AS DATE)";
        try (Session session = getSession()) {
            NativeQuery<?> query = session.createNativeQuery(sql);
            query.setParameter("from", from);
            query.setParameter("to", to);
            return toInteger(query.getSingleResult());
        } catch (Exception e) {
            e.printStackTrace();
            return 0;
        }
    }

    /**
     * Doanh thu theo thời gian (biểu đồ) - chỉ tính đơn đã thanh toán (trạng thái 1).
     * groupBy: "day" | "week" | "month".
     */
    public List<DoanhThuDiemDTO> getRevenueSeries(String from, String to, String groupBy) {
        String nhanExpr;
        String groupExpr;
        switch (groupBy == null ? "day" : groupBy) {
            case "month":
                nhanExpr = "FORMAT(ngay_tao, 'yyyy-MM')";
                groupExpr = "FORMAT(ngay_tao, 'yyyy-MM')";
                break;
            case "week":
                nhanExpr = "CONCAT(DATEPART(ISO_WEEK, ngay_tao), '/', DATEPART(YEAR, ngay_tao))";
                groupExpr = "DATEPART(YEAR, ngay_tao), DATEPART(ISO_WEEK, ngay_tao)";
                break;
            default:
                nhanExpr = "CONVERT(varchar(10), ngay_tao, 120)";
                groupExpr = "CONVERT(varchar(10), ngay_tao, 120)";
        }

        String sql = "SELECT " + nhanExpr + " AS nhan, " +
                "SUM(tong_tien_thanh_toan) AS doanh_thu, COUNT(*) AS so_don " +
                "FROM hoa_don " +
                "WHERE trang_thai = 1 " +
                "AND CAST(ngay_tao AS DATE) BETWEEN CAST(:from AS DATE) AND CAST(:to AS DATE) " +
                "GROUP BY " + groupExpr + " " +
                "ORDER BY MIN(ngay_tao)";

        List<DoanhThuDiemDTO> list = new ArrayList<>();
        try (Session session = getSession()) {
            NativeQuery<Object[]> query = session.createNativeQuery(sql);
            query.setParameter("from", from);
            query.setParameter("to", to);
            for (Object[] row : query.getResultList()) {
                list.add(new DoanhThuDiemDTO((String) row[0], toDouble(row[1]), toInteger(row[2])));
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }

    /**
     * Đếm số đơn hàng theo từng trạng thái trong khoảng [from, to].
     * key: trạng thái (0=Chờ xử lý,1=Đã thanh toán,2=Đã hủy,3=Đã xóa), value: số lượng.
     */
    public Map<Integer, Integer> getStatusDistribution(String from, String to) {
        String sql = "SELECT trang_thai, COUNT(*) FROM hoa_don " +
                "WHERE CAST(ngay_tao AS DATE) BETWEEN CAST(:from AS DATE) AND CAST(:to AS DATE) " +
                "GROUP BY trang_thai";
        Map<Integer, Integer> map = new LinkedHashMap<>();
        try (Session session = getSession()) {
            NativeQuery<Object[]> query = session.createNativeQuery(sql);
            query.setParameter("from", from);
            query.setParameter("to", to);
            for (Object[] row : query.getResultList()) {
                map.put(toInteger(row[0]), toInteger(row[1]));
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return map;
    }
}
