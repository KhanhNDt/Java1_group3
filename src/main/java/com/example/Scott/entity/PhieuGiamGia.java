package com.example.Scott.entity;

import jakarta.persistence.*;
import lombok.*;

import java.math.BigDecimal;
import java.util.Date;

@Entity
@Table(name = "phieu_giam_gia")
@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
@ToString
public class PhieuGiamGia {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Integer id;

    @Column(name = "ma_voucher", nullable = false, length = 50)
    private String maVoucher;

    @Column(name = "ten_voucher", nullable = false, length = 255)
    private String tenVoucher;

    @Column(name = "loai_giam_gia", length = 20)
    private String loaiGiamGia;

    @Column(name = "gia_tri_giam")
    private BigDecimal giaTriGiamGia;

    @Column(name = "giam_toi_da")
    private BigDecimal giamToiDa;

    @Column(name = "don_toi_thieu")
    private BigDecimal donToiThieu;

    @Column(name = "so_luong")
    private Integer soLuong;

    @Column(name = "so_luong_da_dung")
    private Integer soLuongDaDung;

    // Nếu CSDL không còn dùng cột loai_phieu thì bỏ dòng dưới.
    // Nếu CSDL vẫn có cột này thì giữ lại nhé.
    @Column(name = "loai_phieu")
    private String loaiPhieu;

    @Temporal(TemporalType.DATE) // Hoặc TIMESTAMP tùy vào kiểu dữ liệu trong DB
    @Column(name = "ngay_bat_dau")
    private Date ngayBatDau;

    @Temporal(TemporalType.DATE)
    @Column(name = "ngay_ket_thuc")
    private Date ngayKetThuc;

    @Temporal(TemporalType.TIMESTAMP)
    @Column(name = "ngay_tao", updatable = false)
    private Date ngayTao;

    @Column(name = "trang_thai")
    private Integer trangThai;

    // Tự động gán ngày tạo trước khi lưu vào database nếu ngayTao bị null
    @PrePersist
    protected void onCreate() {
        if (this.ngayTao == null) {
            this.ngayTao = new Date();
        }
        if (this.soLuongDaDung == null) {
            this.soLuongDaDung = 0;
        }
    }
}