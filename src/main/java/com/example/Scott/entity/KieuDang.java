package com.example.Scott.entity;

import jakarta.persistence.*;
import lombok.*;

@Entity
@Table(name = "kieu_dang")
@Getter @Setter @NoArgsConstructor @AllArgsConstructor @Builder
public class KieuDang {
    @Id @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Integer id;
    @Column(name = "ten_kieu_dang")
    private String tenKieuDang;
    @Column(name = "trang_thai")
    private Integer trangThai;
}
