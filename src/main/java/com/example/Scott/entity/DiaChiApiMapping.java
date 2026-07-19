package com.example.Scott.entity;

import jakarta.persistence.*;
import lombok.*;

@Entity
@Table(name = "dia_chi_api_mapping")
@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
@Builder

public class DiaChiApiMapping {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Integer id;

    @Column(name = "id_dia_chi_khach_hang")
    private Integer idDiaChiKhachHang;

    @Column(name = "province_code")
    private Integer provinceCode;

    @Column(name = "district_code")
    private Integer districtCode;

    @Column(name = "ward_code")
    private Integer wardCode;
}
