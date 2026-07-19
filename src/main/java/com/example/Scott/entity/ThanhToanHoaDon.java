package com.example.Scott.entity;

import lombok.AllArgsConstructor;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;

import java.util.Date;

@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
public class ThanhToanHoaDon {
    private Integer id;
    private String maGiaoDich;
    private String tenPhuongThuc;
    private Double soTien;
    private Date thoiGian;
    private Integer trangThai;
    private String ghiChu;
}
