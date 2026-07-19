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
public class LichSuHoaDon {
    private Integer id;
    private String ma;
    private Date thoiGian;
    private String ghiChu;
    private Integer trangThai;
}
