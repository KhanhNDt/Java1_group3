package com.example.Scott.entity;

import jakarta.persistence.*;
import lombok.*;

@Entity
@Table(name = "khach_hang")
@Getter
@Setter
@ToString
@NoArgsConstructor
@AllArgsConstructor
@Builder
public class KhachHang {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)

    @Column
    private Integer id;

    @Column
    private String ma;

    @Column (name = "ho_ten")
    private  String hoTen;

    @Column
    private  String sdt;

    @Column
    private String email;

    @Column(name = "dia_chi")
    private String diaChi;

    @Column(name = "gioi_tinh", length = 20)
    private String gioiTinh;

    @PostLoad
    @PrePersist
    @PreUpdate
    private void chuanHoaGioiTinh() {
        if (gioiTinh == null) return;
        String value = gioiTinh.trim();
        if (value.equalsIgnoreCase("nam") || value.equals("1") || value.equalsIgnoreCase("true")) {
            gioiTinh = "Nam";
        } else if (value.equalsIgnoreCase("nu") || value.equalsIgnoreCase("nữ")
                || value.equals("0") || value.equalsIgnoreCase("false")) {
            gioiTinh = "Nữ";
        } else if (value.isEmpty()) {
            gioiTinh = null;
        }
    }

    @Column(name = "trang_thai")
    private Integer trangThai;

}
