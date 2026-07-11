package com.example.Scott.entity;

import jakarta.persistence.*;
import lombok.*;

import java.math.BigDecimal;
import java.util.Date;

@Entity
@Table(name = "phieu_giam_gia")
@ToString
@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
public class PhieuGiamGia {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column
    private Integer id;
    @Column(name = "ma_voucher")
    private String maVoucher;
    @Column(name = "ten_voucher")
    private String tenVoucher;
    @Column(name = "loai_giam_gia")
    private String loaiGiamGia;
    @Column(name = "so_luong")
    private Integer soLuong;
    @Column(name = "ngay_bat_dau")
    private Date ngayBatDau;
    @Column(name = "ngay_ket_thuc")
    private Date ngayKetThuc;
    @Column(name = "trang_thai")
    private Integer trangThai;
}
