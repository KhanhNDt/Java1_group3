package com.example.Scott.entity;

import jakarta.persistence.*;
import lombok.*;

@Entity
@Table(name = "size")
@Getter @Setter @NoArgsConstructor @AllArgsConstructor @Builder
public class Size {
    @Id @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Integer id;
    private String ma;
    private String ten;
    @Column(name = "trang_thai")
    private Integer trangThai;
}
