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
 * Logic dùng chung để tạo hóa đơn bán hàng tại quầy (tìm/tạo khách hàng + tạo hóa đơn).
 * Được gọi bởi:
 *  - BanHangServlet (thanh toán tiền mặt, hoặc khách bấm "Khách đã chuyển khoản xong")
 *  - SePayWebhookServlet (khi ngân hàng báo có tiền về khớp với đơn hàng QR đang chờ)
 * Tách riêng ra đây để 2 nơi gọi không bị trùng lặp / lệch logic.
 */
public class ThanhToanService {

    private final KhachHangResponsitory khachHangRepo = new KhachHangResponsitory();
    private final HoaDonRepo hoaDonRepo = new HoaDonRepo();

    /**
     * @param payload    dữ liệu đơn hàng (giỏ hàng, khách hàng, ghi chú, phương thức...)
     * @param idNhanVien nhân viên đứng tên tạo hóa đơn (thu ngân đang đăng nhập lúc mở phiên QR)
     * @return map kết quả: success (boolean), message, và nếu thành công thì có thêm
     *         maHoaDon, idHoaDon, tongTienThanhToan, maKhachHang, phuongThucThanhToan...
     */
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

        String sdt = payload.sdtKhachHang == null ? "" : payload.sdtKhachHang.trim();
        if (!sdt.matches("\\d{9,11}")) {
            result.put("success", false);
            result.put("message", "Số điện thoại khách hàng là bắt buộc và phải gồm 9-11 chữ số.");
            return result;
        }

        if (payload.gioHang == null || payload.gioHang.isEmpty()) {
            result.put("success", false);
            result.put("message", "Giỏ hàng đang trống, vui lòng chọn sản phẩm trước khi thanh toán.");
            return result;
        }

        String email = payload.emailKhachHang == null ? "" : payload.emailKhachHang.trim();
        if (!email.isEmpty() && !email.matches("^[^\\s@]+@[^\\s@]+\\.[^\\s@]+$")) {
            result.put("success", false);
            result.put("message", "Email khách hàng không hợp lệ.");
            return result;
        }

        String diaChi = payload.diaChiKhachHang == null ? "" : payload.diaChiKhachHang.trim();
        if (diaChi.isEmpty()) {
            result.put("success", false);
            result.put("message", "Địa chỉ khách hàng là bắt buộc, vui lòng nhập địa chỉ.");
            return result;
        }

        try {
            KhachHang kh = khachHangRepo.findBySdt(sdt);
            if (kh == null) {
                kh = new KhachHang();
                kh.setMa(khachHangRepo.generateNextMa());
                kh.setSdt(sdt);
                String ten = payload.tenKhachHang == null || payload.tenKhachHang.trim().isEmpty()
                        ? "Khách lẻ" : payload.tenKhachHang.trim();
                kh.setHoTen(ten);
                kh.setEmail(email);
                kh.setDiaChi(diaChi);
                kh.setTrangThai(1);
                khachHangRepo.addKhachHang(kh);
                kh = khachHangRepo.findBySdt(sdt);
            } else {
                boolean canCapNhat = false;
                if (kh.getEmail() == null || kh.getEmail().trim().isEmpty()) {
                    kh.setEmail(email);
                    canCapNhat = true;
                }
                if (kh.getDiaChi() == null || kh.getDiaChi().trim().isEmpty()) {
                    kh.setDiaChi(diaChi);
                    canCapNhat = true;
                }
                if (canCapNhat) khachHangRepo.UpdateKhachHang(kh);
            }

            List<HoaDonChiTiet> gioHang = new ArrayList<>();
            for (BanHangServlet.GioHangItem gh : payload.gioHang) {
                if (gh.idSanPhamChiTiet == null || gh.soLuong == null || gh.soLuong <= 0) continue;
                HoaDonChiTiet ct = new HoaDonChiTiet();
                ct.setIdSanPhamChiTiet(gh.idSanPhamChiTiet);
                ct.setSoLuong(gh.soLuong);
                gioHang.add(ct);
            }

            String phuongThuc = payload.phuongThucThanhToan == null || payload.phuongThucThanhToan.trim().isEmpty()
                    ? "TIENMAT" : payload.phuongThucThanhToan.trim().toUpperCase();
            if (!phuongThuc.equals("TIENMAT") && !phuongThuc.equals("CHUYENKHOAN")) {
                phuongThuc = "TIENMAT";
            }

            HoaDon hoaDon = hoaDonRepo.taoHoaDonBanHang(
                    kh.getId(),
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
            result.put("maKhachHang", kh.getMa());
            result.put("phuongThucThanhToan", phuongThuc);
            if ("TIENMAT".equals(phuongThuc) && payload.tienKhachDua != null) {
                result.put("tienKhachDua", payload.tienKhachDua);
                result.put("tienThua", payload.tienKhachDua - hoaDon.getTongTienThanhToan());
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
