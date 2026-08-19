package com.example.Scott.service;

import com.example.Scott.controller.BanHangServlet;
import com.example.Scott.entity.HoaDon;
import com.example.Scott.entity.HoaDonChiTiet;
import com.example.Scott.entity.KhachHang;
import com.example.Scott.responsitory.HoaDonRepo;
import com.example.Scott.responsitory.KhachHangResponsitory;

import java.util.ArrayList;
import java.util.LinkedHashMap;
import java.util.List;
import java.util.Map;

/**
 * Logic dùng chung để tạo hóa đơn bán hàng tại quầy.
 *
 * Quy tắc khách hàng:
 * - Khách vãng lai: không cần SĐT / email / địa chỉ, không tự tạo KhachHang mới.
 * - Khách quen: frontend gửi SĐT của khách đã chọn trong CSDL.
 */
public class ThanhToanService {

    private final KhachHangResponsitory khachHangRepo = new KhachHangResponsitory();
    private final HoaDonRepo hoaDonRepo = new HoaDonRepo();

    public Map<String, Object> xuLyThanhToan(BanHangServlet.ThanhToanRequest payload, Integer idNhanVien) {
        Map<String, Object> result = new LinkedHashMap<>();

        if (idNhanVien == null) {
            result.put("success", false);
            result.put("message", "Không xác định được nhân viên tạo hóa đơn.");
            return result;
        }

        if (payload == null) {
            result.put("success", false);
            result.put("message", "Dữ liệu đơn hàng không hợp lệ.");
            return result;
        }

        if (payload.gioHang == null || payload.gioHang.isEmpty()) {
            result.put("success", false);
            result.put("message", "Giỏ hàng đang trống, vui lòng chọn sản phẩm trước khi thanh toán.");
            return result;
        }

        String sdt = payload.sdtKhachHang == null ? "" : payload.sdtKhachHang.trim();
        String email = payload.emailKhachHang == null ? "" : payload.emailKhachHang.trim();
        String diaChi = payload.diaChiKhachHang == null ? "" : payload.diaChiKhachHang.trim();

        // Có nhập SĐT thì phải đúng định dạng. Để trống hoàn toàn = khách vãng lai.
        if (!sdt.isEmpty() && !sdt.matches("\\d{9,11}")) {
            result.put("success", false);
            result.put("message", "Số điện thoại khách hàng phải gồm 9-11 chữ số.");
            return result;
        }

        if (!email.isEmpty() && !email.matches("^[^\\s@]+@[^\\s@]+\\.[^\\s@]+$")) {
            result.put("success", false);
            result.put("message", "Email khách hàng không hợp lệ.");
            return result;
        }

        try {
            // ================= KHÁCH HÀNG =================
            // null = khách vãng lai.
            Integer idKhachHang = null;
            KhachHang kh = null;

            if (!sdt.isEmpty()) {
                // Đây là khách quen đã chọn trên giao diện.
                kh = khachHangRepo.findBySdt(sdt);

                if (kh == null) {
                    // Không tự sinh khách mới ở luồng bán hàng.
                    // Tránh trường hợp dữ liệu khách bị tạo ngoài màn Quản lý khách hàng.
                    result.put("success", false);
                    result.put("message", "Không tìm thấy khách hàng đã chọn trong hệ thống.");
                    return result;
                }

                idKhachHang = kh.getId();

                // Chỉ bổ sung email/địa chỉ nếu DB đang thiếu và frontend có dữ liệu.
                boolean canCapNhat = false;

                if ((kh.getEmail() == null || kh.getEmail().trim().isEmpty()) && !email.isEmpty()) {
                    kh.setEmail(email);
                    canCapNhat = true;
                }

                if ((kh.getDiaChi() == null || kh.getDiaChi().trim().isEmpty()) && !diaChi.isEmpty()) {
                    kh.setDiaChi(diaChi);
                    canCapNhat = true;
                }

                if (canCapNhat) {
                    khachHangRepo.UpdateKhachHang(kh);
                }
            }

            // ================= GIỎ HÀNG =================
            List<HoaDonChiTiet> gioHang = new ArrayList<>();

            for (BanHangServlet.GioHangItem gh : payload.gioHang) {
                if (gh.idSanPhamChiTiet == null || gh.soLuong == null || gh.soLuong <= 0) {
                    continue;
                }

                HoaDonChiTiet ct = new HoaDonChiTiet();
                ct.setIdSanPhamChiTiet(gh.idSanPhamChiTiet);
                ct.setSoLuong(gh.soLuong);
                gioHang.add(ct);
            }

            if (gioHang.isEmpty()) {
                result.put("success", false);
                result.put("message", "Giỏ hàng không có sản phẩm hợp lệ.");
                return result;
            }

            // ================= PHƯƠNG THỨC THANH TOÁN =================
            String phuongThuc =
                    payload.phuongThucThanhToan == null || payload.phuongThucThanhToan.trim().isEmpty()
                            ? "TIENMAT"
                            : payload.phuongThucThanhToan.trim().toUpperCase();

            if (!phuongThuc.equals("TIENMAT") && !phuongThuc.equals("CHUYENKHOAN")) {
                phuongThuc = "TIENMAT";
            }

            // ================= TẠO HÓA ĐƠN =================
            // idKhachHang = null đối với khách vãng lai.
            HoaDon hoaDon = hoaDonRepo.taoHoaDonBanHang(
                    idKhachHang,
                    idNhanVien,
                    payload.idPhieuGiamGia,
                    gioHang,
                    payload.ghiChu,
                    payload.idHoaDonCho,
                    phuongThuc,
                    payload.tienKhachDua
            );

            result.put("success", true);
            result.put("message", "Thanh toán thành công!");
            result.put("maHoaDon", hoaDon.getMaHoaDon());
            result.put("idHoaDon", hoaDon.getId());
            result.put("tongTienThanhToan", hoaDon.getTongTienThanhToan());
            result.put("maKhachHang", kh != null ? kh.getMa() : null);
            result.put("tenKhachHang", kh != null ? kh.getHoTen() : "Khách lẻ");
            result.put("phuongThucThanhToan", phuongThuc);

            if ("TIENMAT".equals(phuongThuc) && payload.tienKhachDua != null) {
                result.put("tienKhachDua", payload.tienKhachDua);
                result.put(
                        "tienThua",
                        payload.tienKhachDua - hoaDon.getTongTienThanhToan()
                );
            }

        } catch (IllegalStateException | IllegalArgumentException e) {
            result.put("success", false);
            result.put("message", e.getMessage());
        } catch (Exception e) {
            e.printStackTrace();
            result.put("success", false);
            result.put("message", "Lỗi hệ thống khi tạo hóa đơn: " + e.getMessage());
        }

        return result;
    }
}
