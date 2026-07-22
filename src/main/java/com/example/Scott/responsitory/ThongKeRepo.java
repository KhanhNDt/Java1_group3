package com.example.Scott.responsitory;

import com.example.Scott.dto.ThongKeSanPhamDTO;
import com.example.Scott.utils.HibernateConfig;
import org.hibernate.Session;
import org.hibernate.query.NativeQuery;

import java.math.BigDecimal;
import java.util.ArrayList;
import java.util.List;

/**
 * Repository phục vụ riêng cho trang Thống kê (dashboard):
 * - Top sản phẩm bán chạy
 * - Thống kê tồn kho / đã bán theo biến thể sản phẩm
 *
 * Cùng nguyên tắc với các repo khác: mỗi method tự mở/đóng Session riêng (try-with-resources)
 * để tránh dùng chung 1 Session giữa nhiều request/thread.
 */
public class ThongKeRepo {

    private Session getSession() {
        return HibernateConfig.getFACTORY().openSession();
    }

    private Integer toInteger(Object obj) {
        return obj != null ? ((Number) obj).intValue() : 0;
    }

    private BigDecimal toBigDecimal(Object obj) {
        if (obj == null) return BigDecimal.ZERO;
        if (obj instanceof BigDecimal) return (BigDecimal) obj;
        return BigDecimal.valueOf(((Number) obj).doubleValue());
    }

    /**
     * Top sản phẩm bán chạy nhất trong khoảng [from, to] (chỉ tính đơn đã thanh toán = 1).
     */
    public List<ThongKeSanPhamDTO> getTopSellingProducts(String from, String to, int limit) {
        String sql = "SELECT sp.ma_san_pham, sp.ten_san_pham, th.ten AS ten_thuong_hieu, dm.ten_danh_muc, " +
                "ms.ten AS mau_sac, sz.ten AS kich_thuoc, ctsp.gia_ban, ctsp.so_luong_ton, " +
                "SUM(cthd.so_luong) AS da_ban " +
                "FROM chi_tiet_hoa_don cthd " +
                "JOIN hoa_don hd ON cthd.id_hoa_don = hd.id " +
                "JOIN chi_tiet_san_pham ctsp ON cthd.id_san_pham_chi_tiet = ctsp.id " +
                "JOIN san_pham sp ON ctsp.id_san_pham = sp.id " +
                "LEFT JOIN thuong_hieu th ON sp.id_thuong_hieu = th.id " +
                "LEFT JOIN danh_muc dm ON sp.id_danh_muc = dm.id " +
                "LEFT JOIN mau_sac ms ON ctsp.id_mau_sac = ms.id " +
                "LEFT JOIN size sz ON ctsp.id_size = sz.id " +
                "WHERE hd.trang_thai = 1 " +
                "AND CAST(hd.ngay_tao AS DATE) BETWEEN CAST(:from AS DATE) AND CAST(:to AS DATE) " +
                "GROUP BY sp.ma_san_pham, sp.ten_san_pham, th.ten, dm.ten_danh_muc, " +
                "ms.ten, sz.ten, ctsp.gia_ban, ctsp.so_luong_ton " +
                "ORDER BY SUM(cthd.so_luong) DESC";

        List<ThongKeSanPhamDTO> list = new ArrayList<>();
        try (Session session = getSession()) {
            NativeQuery<Object[]> query = session.createNativeQuery(sql);
            query.setParameter("from", from);
            query.setParameter("to", to);
            query.setMaxResults(limit);
            for (Object[] row : query.getResultList()) {
                ThongKeSanPhamDTO dto = new ThongKeSanPhamDTO();
                dto.setMaSanPham((String) row[0]);
                dto.setTenSanPham((String) row[1]);
                dto.setTenThuongHieu((String) row[2]);
                dto.setTenDanhMuc((String) row[3]);
                dto.setMauSac((String) row[4]);
                dto.setKichThuoc((String) row[5]);
                dto.setGiaBan(toBigDecimal(row[6]));
                dto.setTonKho(toInteger(row[7]));
                dto.setDaBan(toInteger(row[8]));
                list.add(dto);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }

    /**
     * Thống kê tồn kho hiện tại theo biến thể, kèm số lượng đã bán (đơn đã thanh toán)
     * trong khoảng [from, to]. Có thể lọc theo thương hiệu / danh mục / trạng thái biến thể.
     */
    public List<ThongKeSanPhamDTO> getInventoryStats(Integer brandId, Integer categoryId, Integer status,
                                                     String from, String to) {
        StringBuilder sql = new StringBuilder(
                "SELECT sp.ma_san_pham, sp.ten_san_pham, th.ten AS ten_thuong_hieu, dm.ten_danh_muc, " +
                        "ms.ten AS mau_sac, sz.ten AS kich_thuoc, ctsp.gia_ban, ctsp.so_luong_ton, ctsp.trang_thai, " +
                        "ISNULL(sold.da_ban, 0) AS da_ban " +
                        "FROM chi_tiet_san_pham ctsp " +
                        "JOIN san_pham sp ON ctsp.id_san_pham = sp.id " +
                        "LEFT JOIN thuong_hieu th ON sp.id_thuong_hieu = th.id " +
                        "LEFT JOIN danh_muc dm ON sp.id_danh_muc = dm.id " +
                        "LEFT JOIN mau_sac ms ON ctsp.id_mau_sac = ms.id " +
                        "LEFT JOIN size sz ON ctsp.id_size = sz.id " +
                        "LEFT JOIN ( " +
                        "    SELECT cthd.id_san_pham_chi_tiet AS id_ctsp, SUM(cthd.so_luong) AS da_ban " +
                        "    FROM chi_tiet_hoa_don cthd " +
                        "    JOIN hoa_don hd ON cthd.id_hoa_don = hd.id " +
                        "    WHERE hd.trang_thai = 1 " +
                        "    AND CAST(hd.ngay_tao AS DATE) BETWEEN CAST(:from AS DATE) AND CAST(:to AS DATE) " +
                        "    GROUP BY cthd.id_san_pham_chi_tiet " +
                        ") sold ON sold.id_ctsp = ctsp.id " +
                        "WHERE 1 = 1 "
        );
        if (brandId != null) sql.append("AND sp.id_thuong_hieu = :brandId ");
        if (categoryId != null) sql.append("AND sp.id_danh_muc = :categoryId ");
        if (status != null) sql.append("AND ctsp.trang_thai = :status ");
        sql.append("ORDER BY sp.ma_san_pham, ms.ten, sz.ten");

        List<ThongKeSanPhamDTO> list = new ArrayList<>();
        try (Session session = getSession()) {
            NativeQuery<Object[]> query = session.createNativeQuery(sql.toString());
            query.setParameter("from", from);
            query.setParameter("to", to);
            if (brandId != null) query.setParameter("brandId", brandId);
            if (categoryId != null) query.setParameter("categoryId", categoryId);
            if (status != null) query.setParameter("status", status);
            for (Object[] row : query.getResultList()) {
                ThongKeSanPhamDTO dto = new ThongKeSanPhamDTO();
                dto.setMaSanPham((String) row[0]);
                dto.setTenSanPham((String) row[1]);
                dto.setTenThuongHieu((String) row[2]);
                dto.setTenDanhMuc((String) row[3]);
                dto.setMauSac((String) row[4]);
                dto.setKichThuoc((String) row[5]);
                dto.setGiaBan(toBigDecimal(row[6]));
                dto.setTonKho(toInteger(row[7]));
                dto.setTrangThai(toInteger(row[8]));
                dto.setDaBan(toInteger(row[9]));
                list.add(dto);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return list;
    }
}
