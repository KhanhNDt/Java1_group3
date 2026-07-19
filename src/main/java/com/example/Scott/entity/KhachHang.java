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

  @Column(name ="gioi_tinh")
  private String gioiTinh;

    @Column(name = "trang_thai")
private Integer trangThai;

}
