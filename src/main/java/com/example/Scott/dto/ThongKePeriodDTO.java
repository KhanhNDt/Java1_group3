package com.example.Scott.dto;

import lombok.AllArgsConstructor;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;

/**
 * Dữ liệu thống kê tổng hợp cho một khoảng thời gian cụ thể
 * (dùng cho các thẻ "Hôm nay/Tuần này/Tháng này/Năm nay" và bảng thống kê chi tiết).
 */
@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
public class ThongKePeriodDTO {
    private String nhan;          // "Hôm nay", "Tuần này", "Tháng này", "Năm nay"
    private Double doanhThu;      // tổng doanh thu (đơn đã thanh toán)
    private Integer soDon;        // tổng số đơn hàng
    private Integer soSanPham;    // số sản phẩm (biến thể) khác nhau đã bán được
    private Double giaTriTrungBinh; // giá trị trung bình / đơn
    private Double tangTruong;    // % tăng trưởng doanh thu so với kỳ liền trước

    public Double getGiaTriTrungBinhTinh() {
        if (soDon == null || soDon == 0) return 0d;
        return doanhThu / soDon;
    }
}
