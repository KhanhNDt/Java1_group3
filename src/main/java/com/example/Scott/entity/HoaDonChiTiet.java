package com.example.Scott.entity;
import jakarta.persistence.*;
import lombok.*;


@Entity
@Table(name = "chi_tiet_hoa_don")
@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
@Builder
public class HoaDonChiTiet {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Integer id;

    @Column(name = "id_hoa_don")
    private Integer idHoaDon;

    @Column(name = "id_san_pham_chi_tiet")
    private Integer idSanPhamChiTiet;

    @Column(name = "so_luong")
    private Integer soLuong;

    @Column(name = "don_gia")
    private Double donGia;

    @Column(name = "gia_ban_ra")
    private Double giaBanRa;

    @Column(name = "tong_tien")
    private Double tongTien;

    @Column(name = "trang_thai")
    private Integer trangThai;

    @Transient
    private String tenSanPham;

    @Transient
    private String maSanPham;

    @Transient
    private String maBienThe;

    @Transient
    private String mauSac;

    @Transient
    private String kichThuoc;
}
