
package com.example.Scott.entity;


import com.example.Scott.entity.NhanVien;
import lombok.Data;
import jakarta.persistence.*;

@Entity
@Table(name = "Tai_khoan")
@Data
public class TaiKhoan {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private int id;

    @Column(name = "ten_dang_nhap")
    private String tenDangNhap;

    @Column(name = "mat_khau")
    private String matKhau;

    @Column(name = "trang_thai")
    private int trangThai;

    @OneToOne
    @JoinColumn(name = "id_nhan_vien")
    private NhanVien nhanVien;
}

