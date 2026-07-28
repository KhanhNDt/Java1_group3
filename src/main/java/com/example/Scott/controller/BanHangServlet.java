package com.example.Scott.controller;

import com.example.Scott.entity.ChiTietSanPham;
import com.example.Scott.entity.HoaDon;
import com.example.Scott.entity.HoaDonChiTiet;
import com.example.Scott.entity.KhachHang;
import com.example.Scott.entity.NhanVien;
import com.example.Scott.entity.PhieuGiamGia;
import com.example.Scott.entity.TaiKhoan;
import com.example.Scott.responsitory.ChiTietSanPhamResponsitory;
import com.example.Scott.responsitory.HoaDonRepo;
import com.example.Scott.responsitory.KhachHangResponsitory;
import com.example.Scott.responsitory.PhieuGiamGiaResponsitory;
import com.google.gson.Gson;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.BufferedReader;
import java.io.IOException;
import java.util.ArrayList;
import java.util.LinkedHashMap;
import java.util.List;
import java.util.Map;

/**
 * Man hinh Ban hang tai quay: ca Nhan vien lan Quan ly (Admin) deu truy cap duoc.
 * - GET (khong action): hien thi giao dien ban hang.
 * - GET action=timSanPham: AJAX tim bien the san pham con hang.
 * - GET action=timKhachHang: AJAX tra cuu khach hang theo so dien thoai.
 * - GET action=danhSachVoucher: AJAX lay danh sach phieu giam gia con hieu luc.
 * - POST action=thanhToan: tao hoa don (JSON body), tra ve JSON ket qua.
 */
@WebServlet(name = "BanHangServlet", value = {"/ban-hang-tai-quay"})
public class BanHangServlet extends HttpServlet {

    private final ChiTietSanPhamResponsitory chiTietSanPhamRepo = new ChiTietSanPhamResponsitory();
    private final KhachHangResponsitory khachHangRepo = new KhachHangResponsitory();
    private final PhieuGiamGiaResponsitory phieuGiamGiaRepo = new PhieuGiamGiaResponsitory();
    private final HoaDonRepo hoaDonRepo = new HoaDonRepo();
    private final Gson gson = new Gson();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        req.setCharacterEncoding("UTF-8");
        resp.setCharacterEncoding("UTF-8");

        String action = req.getParameter("action");
        if (action == null) action = "hienthi";

        switch (action) {
            case "timSanPham":
                timSanPham(req, resp);
                break;
            case "timKhachHang":
                timKhachHang(req, resp);
                break;
            case "danhSachVoucher":
                danhSachVoucher(req, resp);
                break;
            default:
                hienThiGiaoDien(req, resp);
        }
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        req.setCharacterEncoding("UTF-8");
        resp.setCharacterEncoding("UTF-8");

        String action = req.getParameter("action");
        if ("thanhToan".equals(action)) {
            thanhToan(req, resp);
        } else {
            resp.sendError(HttpServletResponse.SC_METHOD_NOT_ALLOWED, "Hành động không được hỗ trợ");
        }
    }

    private void hienThiGiaoDien(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        req.setAttribute("menu", "banhang");
        req.getRequestDispatcher("/views/banhang/ban-hang.jsp").forward(req, resp);
    }

    // ================= AJAX: tìm sản phẩm còn hàng =================
    private void timSanPham(HttpServletRequest req, HttpServletResponse resp) throws IOException {
        String keyword = req.getParameter("keyword");
        List<ChiTietSanPham> list = chiTietSanPhamRepo.searchForBanHang(keyword);

        List<Map<String, Object>> items = new ArrayList<>();
        for (ChiTietSanPham ct : list) {
            Map<String, Object> item = new LinkedHashMap<>();
            item.put("id", ct.getId());
            item.put("ma", ct.getMa());
            item.put("maSanPham", ct.getSanPham() != null ? ct.getSanPham().getMaSanPham() : "");
            item.put("tenSanPham", ct.getSanPham() != null ? ct.getSanPham().getTenSanPham() : "");
            item.put("mauSac", ct.getMauSac() != null ? ct.getMauSac().getTen() : "");
            item.put("kichThuoc", ct.getSize() != null ? ct.getSize().getTen() : "");
            item.put("giaBan", ct.getGiaBan());
            item.put("soLuongTon", ct.getSoLuongTon());
            items.add(item);
        }

        Map<String, Object> result = new LinkedHashMap<>();
        result.put("success", true);
        result.put("items", items);
        writeJson(resp, result);
    }

    // ================= AJAX: tra cứu khách hàng theo SĐT =================
    private void timKhachHang(HttpServletRequest req, HttpServletResponse resp) throws IOException {
        String sdt = req.getParameter("sdt");
        Map<String, Object> result = new LinkedHashMap<>();

        KhachHang kh = khachHangRepo.findBySdt(sdt);
        if (kh != null) {
            result.put("success", true);
            result.put("found", true);
            Map<String, Object> data = new LinkedHashMap<>();
            data.put("id", kh.getId());
            data.put("ma", kh.getMa());
            data.put("hoTen", kh.getHoTen());
            data.put("sdt", kh.getSdt());
            data.put("email", kh.getEmail());
            data.put("diaChi", kh.getDiaChi());
            result.put("khachHang", data);
        } else {
            result.put("success", true);
            result.put("found", false);
        }
        writeJson(resp, result);
    }

    // ================= AJAX: danh sách voucher còn hiệu lực =================
    private void danhSachVoucher(HttpServletRequest req, HttpServletResponse resp) throws IOException {
        List<PhieuGiamGia> vouchers = phieuGiamGiaRepo.getValidVouchers();
        List<Map<String, Object>> items = new ArrayList<>();
        for (PhieuGiamGia p : vouchers) {
            Map<String, Object> item = new LinkedHashMap<>();
            item.put("id", p.getId());
            item.put("maVoucher", p.getMaVoucher());
            item.put("tenVoucher", p.getTenVoucher());
            item.put("loaiGiamGia", p.getLoaiGiamGia());
            item.put("giaTriGiamGia", p.getGiaTriGiamGia());
            item.put("giamToiDa", p.getGiamToiDa());
            item.put("donToiThieu", p.getDonToiThieu());
            items.add(item);
        }
        Map<String, Object> result = new LinkedHashMap<>();
        result.put("success", true);
        result.put("items", items);
        writeJson(resp, result);
    }

    // ================= POST: thanh toán / tạo hóa đơn =================
    private void thanhToan(HttpServletRequest req, HttpServletResponse resp) throws IOException {
        Map<String, Object> result = new LinkedHashMap<>();
        try {
            HttpSession session = req.getSession(false);
            TaiKhoan user = (session != null) ? (TaiKhoan) session.getAttribute("user") : null;
            NhanVien nhanVien = user != null ? user.getNhanVien() : null;
            if (nhanVien == null) {
                result.put("success", false);
                result.put("message", "Phiên đăng nhập đã hết hạn, vui lòng đăng nhập lại.");
                writeJson(resp, result);
                return;
            }

            ThanhToanRequest payload = docJsonBody(req);
            if (payload == null) {
                result.put("success", false);
                result.put("message", "Dữ liệu gửi lên không hợp lệ.");
                writeJson(resp, result);
                return;
            }

            String sdt = payload.sdtKhachHang == null ? "" : payload.sdtKhachHang.trim();
            if (!sdt.matches("\\d{9,11}")) {
                result.put("success", false);
                result.put("message", "Số điện thoại khách hàng là bắt buộc và phải gồm 9-11 chữ số.");
                writeJson(resp, result);
                return;
            }

            if (payload.gioHang == null || payload.gioHang.isEmpty()) {
                result.put("success", false);
                result.put("message", "Giỏ hàng đang trống, vui lòng chọn sản phẩm trước khi thanh toán.");
                writeJson(resp, result);
                return;
            }

            // Email khách hàng là bắt buộc và phải đúng định dạng
            String email = payload.emailKhachHang == null ? "" : payload.emailKhachHang.trim();
            if (email.isEmpty()) {
                result.put("success", false);
                result.put("message", "Email khách hàng là bắt buộc, vui lòng nhập email.");
                writeJson(resp, result);
                return;
            }
            if (!email.matches("^[^\\s@]+@[^\\s@]+\\.[^\\s@]+$")) {
                result.put("success", false);
                result.put("message", "Email khách hàng không hợp lệ.");
                writeJson(resp, result);
                return;
            }

            // Địa chỉ khách hàng là bắt buộc
            String diaChi = payload.diaChiKhachHang == null ? "" : payload.diaChiKhachHang.trim();
            if (diaChi.isEmpty()) {
                result.put("success", false);
                result.put("message", "Địa chỉ khách hàng là bắt buộc, vui lòng nhập địa chỉ.");
                writeJson(resp, result);
                return;
            }

            // Tìm hoặc tạo khách hàng theo số điện thoại (bắt buộc phải nhập SĐT)
            KhachHang kh = khachHangRepo.findBySdt(sdt);
            if (kh == null) {
                kh = new KhachHang();
                kh.setMa(khachHangRepo.generateNextMa());
                kh.setSdt(sdt);
                String ten = payload.tenKhachHang == null || payload.tenKhachHang.trim().isEmpty()
                        ? "Khách lẻ" : payload.tenKhachHang.trim();
                kh.setHoTen(ten);
                if (!email.isEmpty()) kh.setEmail(email);
                if (!diaChi.isEmpty()) kh.setDiaChi(diaChi);
                kh.setTrangThai(1);
                khachHangRepo.addKhachHang(kh);
                kh = khachHangRepo.findBySdt(sdt);
            } else {
                // Khách quen: bổ sung email/địa chỉ nếu hồ sơ cũ đang thiếu
                boolean canCapNhat = false;
                if ((kh.getEmail() == null || kh.getEmail().trim().isEmpty())) {
                    kh.setEmail(email);
                    canCapNhat = true;
                }
                if ((kh.getDiaChi() == null || kh.getDiaChi().trim().isEmpty())) {
                    kh.setDiaChi(diaChi);
                    canCapNhat = true;
                }
                if (canCapNhat) khachHangRepo.UpdateKhachHang(kh);
            }

            List<HoaDonChiTiet> gioHang = new ArrayList<>();
            for (GioHangItem gh : payload.gioHang) {
                if (gh.idSanPhamChiTiet == null || gh.soLuong == null || gh.soLuong <= 0) continue;
                HoaDonChiTiet ct = new HoaDonChiTiet();
                ct.setIdSanPhamChiTiet(gh.idSanPhamChiTiet);
                ct.setSoLuong(gh.soLuong);
                gioHang.add(ct);
            }

            HoaDon hoaDon = hoaDonRepo.taoHoaDonBanHang(
                    kh.getId(),
                    nhanVien.getId(),
                    payload.idPhieuGiamGia,
                    gioHang,
                    payload.ghiChu
            );

            result.put("success", true);
            result.put("message", "Thanh toán thành công!");
            result.put("maHoaDon", hoaDon.getMaHoaDon());
            result.put("idHoaDon", hoaDon.getId());
            result.put("tongTienThanhToan", hoaDon.getTongTienThanhToan());
            result.put("maKhachHang", kh.getMa());
        } catch (IllegalStateException | IllegalArgumentException e) {
            result.put("success", false);
            result.put("message", e.getMessage());
        } catch (Exception e) {
            e.printStackTrace();
            result.put("success", false);
            result.put("message", "Lỗi hệ thống khi tạo hóa đơn: " + e.getMessage());
        }
        writeJson(resp, result);
    }

    private ThanhToanRequest docJsonBody(HttpServletRequest req) throws IOException {
        StringBuilder sb = new StringBuilder();
        try (BufferedReader reader = req.getReader()) {
            String line;
            while ((line = reader.readLine()) != null) sb.append(line);
        }
        if (sb.length() == 0) return null;
        return gson.fromJson(sb.toString(), ThanhToanRequest.class);
    }

    private void writeJson(HttpServletResponse resp, Object data) throws IOException {
        resp.setContentType("application/json;charset=UTF-8");
        resp.getWriter().write(gson.toJson(data));
    }

    // ================= DTO cho request thanh toán =================
    public static class ThanhToanRequest {
        String sdtKhachHang;
        String tenKhachHang;
        String emailKhachHang;
        String diaChiKhachHang;
        Integer idPhieuGiamGia;
        String ghiChu;
        List<GioHangItem> gioHang;
    }

    public static class GioHangItem {
        Integer idSanPhamChiTiet;
        Integer soLuong;
    }
}
