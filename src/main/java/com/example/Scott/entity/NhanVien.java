package com.example.Scott.entity;

import jakarta.persistence.*;
import lombok.AllArgsConstructor;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;

import java.util.Date;

    @Entity
    @Table(name = "nhan_vien")
    @Getter
    @Setter
    @NoArgsConstructor
    @AllArgsConstructor
    public class NhanVien {

        @Id
        @GeneratedValue(strategy = GenerationType.IDENTITY)
        @Column(name = "id")
        private Integer id;

        @Column(name = "ma_nhan_vien", nullable = false, unique = true)
        private String maNhanVien;

        @Column(name = "ho_ten", nullable = false)
        private String hoTen;

        @Column(name = "email")
        private String email;

        @Column(name = "so_dien_thoai")
        private String soDienThoai;

        @Temporal(TemporalType.DATE)
        @Column(name = "ngay_sinh")
        private Date ngaySinh;

        @Column(name = "gioi_tinh")
        private Boolean gioiTinh;

        @Column(name = "dia_chi")
        private String diaChi;

        @Column(name = "chuc_vu")
        private String chucVu;

        @Column(name = "anh_dai_dien")
        private String anhDaiDien;

        @Column(name = "trang_thai")
        private Integer trangThai;

    }

