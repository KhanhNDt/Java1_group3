package com.example.Scott.dto;

import lombok.Getter;

import java.math.BigDecimal;

/**
 * DTO (Data Transfer Object) dùng riêng cho BẢNG DANH SÁCH sản phẩm.
 *
 * Tại sao cần DTO riêng thay vì dùng thẳng entity SanPham?
 * - "Hàng tồn" và "Khoảng giá" KHÔNG phải là cột có sẵn trong bảng san_pham,
 *   mà là số liệu TỔNG HỢP (SUM/MIN/MAX) từ các dòng chi_tiet_san_pham (biến thể)
 *   thuộc về sản phẩm đó.
 * - Nếu load cả list SanPham rồi lặp qua gọi getBySanPham(id) cho từng dòng
 *   (kiểu N+1 query) sẽ rất chậm khi danh sách lớn.
 * - Thay vào đó ta viết 1 câu HQL duy nhất, GROUP BY theo sản phẩm, trả thẳng
 *   ra đối tượng DTO này (Hibernate gọi là "constructor expression").
 */
@Getter
public class SanPhamListDTO {
    private final Integer id;
    private final String maSanPham;
    private final String tenSanPham;
    private final String tenDanhMuc;
    private final String tenThuongHieu;
    private final Integer trangThai;   // trạng thái do người quản lý set (Đang bán / Ngừng bán)
    private final Long tongTon;        // tổng số lượng tồn kho cộng dồn từ tất cả biến thể
    private final BigDecimal giaMin;   // giá bán thấp nhất trong các biến thể
    private final BigDecimal giaMax;   // giá bán cao nhất trong các biến thể

    public SanPhamListDTO(Integer id, String maSanPham, String tenSanPham, String tenDanhMuc,
                           String tenThuongHieu, Integer trangThai, Long tongTon,
                           BigDecimal giaMin, BigDecimal giaMax) {
        this.id = id;
        this.maSanPham = maSanPham;
        this.tenSanPham = tenSanPham;
        this.tenDanhMuc = tenDanhMuc;
        this.tenThuongHieu = tenThuongHieu;
        this.trangThai = trangThai;
        this.tongTon = tongTon;
        this.giaMin = giaMin;
        this.giaMax = giaMax;
    }

    /** "Còn hàng" nếu tổng tồn kho > 0, ngược lại "Hết hàng" — độc lập với trạng thái Đang/Ngừng bán. */
    public boolean isConHang() {
        return tongTon != null && tongTon > 0;
    }
}
