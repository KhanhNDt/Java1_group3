package com.example.Scott.entity;

import jakarta.persistence.*;
import lombok.*;

@Entity
@Table (name = "dia_chi_khach_hang")
@Getter
@Setter
@ToString
@NoArgsConstructor
@AllArgsConstructor
@Builder
public class DiaChiKhachHang {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)

    @Column
    private Integer id;

    @Column(name = "id_khach_hang")
    private Integer idKhachHang;

    @Column(name = "tinh_thanh")
    private String tinhThanh;

    @Column(name = "quan_huyen")
    private String quanHuyen;

    @Column(name = "phuong_xa")
    private String phuongXa;

    @Column(name = "dia_chi_cu_the")
    private String diaChiCuThe;

    @Column(name = "loai_dia_chi")
    private String loaiDiaChi;

    @Column(name = "is_mac_dinh")
    private Boolean isMacDinh;




}
