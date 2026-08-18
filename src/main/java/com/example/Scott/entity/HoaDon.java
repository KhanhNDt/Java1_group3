package com.example.Scott.entity;

import jakarta.persistence.*;
import lombok.*;

import java.util.Date;


@Entity
@Table(name = "hoa_don")
@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
@Builder
public class HoaDon {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Integer id;

    @Column(name = "id_khach_hang")
    private Integer idKhachHang;

    @Column(name = "id_nhan_vien")
    private Integer idNhanVien;

    @Column(name = "id_phieu_giam_gia")
    private Integer idPhieuGiamGia;

    @Column(name = "ma_hoa_don")
    private String maHoaDon;

    @Temporal(TemporalType.TIMESTAMP)
    @Column(name = "ngay_tao")
    private Date ngayTao;

    @Temporal(TemporalType.TIMESTAMP)
    @Column(name = "ngay_thanh_toan")
    private Date ngayThanhToan;

    @Column(name = "tong_tien_thanh_toan")
    private Double tongTienThanhToan;

    @Column(name = "trang_thai")
    private Integer trangThai;

    @Column(name = "ghi_chu")
    private String ghiChu;


    @Transient
    private String tenKhachHang;

    @Transient
    private String sdtKhachHang;

    @Transient
    private String diaChiKhachHang;

    @Transient
    private String tenNguoiNhan;

    @Transient
    private String sdtNguoiNhan;

    @Transient
    private String diaChiGiaoHang;

    @Transient
    private String tenNhanVien;

    @Transient
    private String maNhanVien;

    @Transient
    private String maVoucher;

    @Transient
    private String tenVoucher;

    @Transient
    private String loaiGiamGia;

    @Transient
    private Double giaTriGiam;

    @Transient
    private Double giamToiDa;

    @Transient
    private Double donToiThieu;

    @Transient
    private String tenPhuongThucThanhToan;

    @Transient
    private Integer soLuongSanPham;

    // ==== Các giá trị chỉ dùng để hiển thị hóa đơn in (không lưu DB, được tính lại mỗi lần xem chi tiết) ====
    @Transient
    private Double tienHangGoc; // tổng tiền hàng trước khi giảm giá (cộng dồn từ chi tiết hóa đơn)

    @Transient
    private Double tienGiam; // số tiền đã được giảm = tienHangGoc - tongTienThanhToan

    @Transient
    private Double tienKhachDua; // chỉ có giá trị khi thanh toán tiền mặt

    @Transient
    private Double tienThua; // tiền thừa trả khách, chỉ có giá trị khi thanh toán tiền mặt
}
