package com.example.Scott.entity;

import jakarta.persistence.*;
import lombok.AllArgsConstructor;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;
import lombok.ToString;
import java.util.Date;

    @Entity
    @Table(name = "nhan_vien")
    @Getter
    @Setter
    @ToString
    @NoArgsConstructor
    @AllArgsConstructor
    public class NhanVien {

        @Id
        @GeneratedValue(strategy = GenerationType.IDENTITY)
        private int id;

        @Column(name = "ma_nhan_vien")
        private String maNhanVien;

        @Column(name = "ho_ten")
        private String hoTen;

        private String email;

        @Column(name = "so_dien_thoai")
        private String soDienThoai;

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
        private int trangThai;

    }

