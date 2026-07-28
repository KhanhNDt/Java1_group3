package com.example.Scott.dto;

import lombok.AllArgsConstructor;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;

import java.math.BigDecimal;

/**
 * Một dòng biến thể sản phẩm dùng chung cho:
 * - Bảng "Top sản phẩm bán chạy"
 * - Bảng "Thống kê tồn kho"
 */
@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
public class ThongKeSanPhamDTO {
    private String maSanPham;
    private String tenSanPham;
    private String tenThuongHieu;
    private String tenDanhMuc;
    private String mauSac;
    private String kichThuoc;
    private String chatLieu;
    private BigDecimal giaBan;
    private Integer tonKho;
    private Integer daBan;
    private Integer trangThai; // 1 = đang bán / còn hàng, 0 = ngừng bán (dựa theo chi_tiet_san_pham.trang_thai)

    public double getTyLeBanRa() {
        int tong = (daBan == null ? 0 : daBan) + (tonKho == null ? 0 : tonKho);
        if (tong == 0) return 0d;
        return (daBan == null ? 0 : daBan) * 100.0 / tong;
    }
}
