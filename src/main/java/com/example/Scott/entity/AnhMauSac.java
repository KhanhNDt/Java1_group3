package com.example.Scott.entity;

import jakarta.persistence.*;
import lombok.*;

/**
 * Ảnh riêng theo TỪNG MÀU của một sản phẩm (ví dụ áo đỏ và áo xanh có ảnh khác nhau).
 * Không gắn theo size vì các size của cùng 1 màu thường dùng chung 1 ảnh.
 * Nếu một màu chưa có ảnh riêng ở đây, chỗ hiển thị nên fallback về
 * SanPham.hinhAnh (ảnh bìa cấp sản phẩm).
 */
@Entity
@Table(name = "anh_mau_sac", uniqueConstraints = {
        @UniqueConstraint(columnNames = {"id_san_pham", "id_mau_sac"})
})
@Getter @Setter @NoArgsConstructor @AllArgsConstructor @Builder
public class AnhMauSac {
    @Id @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Integer id;

    @ManyToOne(fetch = FetchType.EAGER)
    @JoinColumn(name = "id_san_pham")
    private SanPham sanPham;

    @ManyToOne(fetch = FetchType.EAGER)
    @JoinColumn(name = "id_mau_sac")
    private MauSac mauSac;

    @Column(name = "duong_dan_anh", nullable = false, length = 500)
    private String duongDanAnh;
}
