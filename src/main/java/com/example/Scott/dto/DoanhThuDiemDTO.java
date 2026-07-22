package com.example.Scott.dto;

import lombok.AllArgsConstructor;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;

/**
 * Một điểm dữ liệu trên biểu đồ doanh thu (theo ngày / tuần / tháng).
 */
@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
public class DoanhThuDiemDTO {
    private String nhan;       // nhãn hiển thị: "2026-04-29", "2026-W18", "2026-04"...
    private Double doanhThu;   // tổng doanh thu (chỉ tính đơn đã thanh toán)
    private Integer soDon;     // số đơn hàng trong khoảng đó
}
