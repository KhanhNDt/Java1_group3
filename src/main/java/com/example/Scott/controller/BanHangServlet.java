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
            case "hoaDonCho":
                danhSachHoaDonCho(req, resp);
                break;
            case "chiTietHoaDonCho":
                chiTietHoaDonCho(req, resp);
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
        } else if ("giuDon".equals(action)) {
            giuDon(req, resp);
        } else if ("huyHoaDonCho".equals(action)) {
            huyHoaDonCho(req, resp);
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

    // ================= AJAX: danh sách hóa đơn CHỜ XỬ LÝ (liên kết bảng hoa_don) =================
    private void danhSachHoaDonCho(HttpServletRequest req, HttpServletResponse resp) throws IOException {
        List<HoaDon> list = hoaDonRepo.layDanhSachHoaDonCho();
        List<Map<String, Object>> items = new ArrayList<>();
        for (HoaDon hd : list) {
            Map<String, Object> item = new LinkedHashMap<>();
            item.put("id", hd.getId());
            item.put("maHoaDon", hd.getMaHoaDon());
            item.put("tenKhachHang", hd.getTenKhachHang());
            item.put("sdtKhachHang", hd.getSdtKhachHang());
            item.put("tongTienThanhToan", hd.getTongTienThanhToan());
            item.put("soLuongSanPham", hd.getSoLuongSanPham());
            items.add(item);
        }
        Map<String, Object> result = new LinkedHashMap<>();
        result.put("success", true);
        result.put("items", items);
        writeJson(resp, result);
    }

    // ================= AJAX: chi tiết 1 hóa đơn chờ để tải lại vào giỏ hàng =================
    private void chiTietHoaDonCho(HttpServletRequest req, HttpServletResponse resp) throws IOException {
        Map<String, Object> result = new LinkedHashMap<>();
        try {
            Integer id = Integer.parseInt(req.getParameter("id"));
            HoaDon hd = hoaDonRepo.getById(id);
            if (hd == null || hd.getTrangThai() == null || hd.getTrangThai() != 0) {
                result.put("success", false);
                result.put("message", "Hóa đơn chờ không tồn tại hoặc đã được xử lý.");
                writeJson(resp, result);
                return;
            }
            List<HoaDonChiTiet> chiTietList = hoaDonRepo.getChiTietByHoaDonId(id);
            List<Map<String, Object>> gioHang = new ArrayList<>();
            for (HoaDonChiTiet ct : chiTietList) {
                ChiTietSanPham sp = chiTietSanPhamRepo.getOne(ct.getIdSanPhamChiTiet());
                Map<String, Object> item = new LinkedHashMap<>();
                item.put("id", ct.getIdSanPhamChiTiet());
                item.put("ma", ct.getMaBienThe());
                item.put("tenSanPham", ct.getTenSanPham());
                item.put("mauSac", ct.getMauSac());
                item.put("kichThuoc", ct.getKichThuoc());
                item.put("giaBan", ct.getGiaBanRa());
                item.put("soLuong", ct.getSoLuong());
                item.put("soLuongTon", sp != null ? sp.getSoLuongTon() : ct.getSoLuong());
                gioHang.add(item);
            }

            Map<String, Object> data = new LinkedHashMap<>();
            data.put("id", hd.getId());
            data.put("maHoaDon", hd.getMaHoaDon());
            data.put("sdtKhachHang", hd.getSdtKhachHang());
            data.put("tenKhachHang", hd.getTenKhachHang());
            data.put("emailKhachHang", null);
            data.put("diaChiKhachHang", hd.getDiaChiKhachHang());
            data.put("idPhieuGiamGia", hd.getIdPhieuGiamGia());
            data.put("ghiChu", hd.getGhiChu());
            data.put("gioHang", gioHang);

            result.put("success", true);
            result.put("hoaDon", data);
        } catch (NumberFormatException e) {
            result.put("success", false);
            result.put("message", "Mã hóa đơn không hợp lệ.");
        }
        writeJson(resp, result);
    }

    // ================= POST: giữ đơn (lưu hóa đơn chờ xử lý vào CSDL) =================
    private void giuDon(HttpServletRequest req, HttpServletResponse resp) throws IOException {
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
            if (payload == null || payload.gioHang == null || payload.gioHang.isEmpty()) {
                result.put("success", false);
                result.put("message", "Giỏ hàng đang trống, không có gì để giữ.");
                writeJson(resp, result);
                return;
            }

            Integer idKhachHang = null;
            String sdt = payload.sdtKhachHang == null ? "" : payload.sdtKhachHang.trim();
            if (sdt.matches("\\d{9,11}")) {
                KhachHang kh = khachHangRepo.findBySdt(sdt);
                if (kh == null) {
                    kh = new KhachHang();
                    kh.setMa(khachHangRepo.generateNextMa());
                    kh.setSdt(sdt);
                    String ten = payload.tenKhachHang == null || payload.tenKhachHang.trim().isEmpty()
                            ? "Khách lẻ" : payload.tenKhachHang.trim();
                    kh.setHoTen(ten);
                    if (payload.emailKhachHang != null && !payload.emailKhachHang.trim().isEmpty()) kh.setEmail(payload.emailKhachHang.trim());
                    if (payload.diaChiKhachHang != null && !payload.diaChiKhachHang.trim().isEmpty()) kh.setDiaChi(payload.diaChiKhachHang.trim());
                    kh.setTrangThai(1);
                    khachHangRepo.addKhachHang(kh);
                    kh = khachHangRepo.findBySdt(sdt);
                }
                idKhachHang = kh != null ? kh.getId() : null;
            }

            List<HoaDonChiTiet> gioHang = new ArrayList<>();
            for (GioHangItem gh : payload.gioHang) {
                if (gh.idSanPhamChiTiet == null || gh.soLuong == null || gh.soLuong <= 0) continue;
                HoaDonChiTiet ct = new HoaDonChiTiet();
                ct.setIdSanPhamChiTiet(gh.idSanPhamChiTiet);
                ct.setSoLuong(gh.soLuong);
                gioHang.add(ct);
            }

            HoaDon hd = hoaDonRepo.giuHoaDonCho(payload.idHoaDonCho, idKhachHang, nhanVien.getId(),
                    payload.idPhieuGiamGia, gioHang, payload.ghiChu);

            result.put("success", true);
            result.put("message", "Đã giữ đơn hàng, xem lại ở mục Hóa đơn chờ.");
            result.put("idHoaDonCho", hd.getId());
            result.put("maHoaDon", hd.getMaHoaDon());
        } catch (IllegalStateException | IllegalArgumentException e) {
            result.put("success", false);
            result.put("message", e.getMessage());
        } catch (Exception e) {
            e.printStackTrace();
            result.put("success", false);
            result.put("message", "Lỗi hệ thống khi giữ đơn: " + e.getMessage());
        }
        writeJson(resp, result);
    }

    // ================= POST: hủy 1 hóa đơn chờ =================
    private void huyHoaDonCho(HttpServletRequest req, HttpServletResponse resp) throws IOException {
        Map<String, Object> result = new LinkedHashMap<>();
        try {
            Integer id = Integer.parseInt(req.getParameter("id"));
            boolean ok = hoaDonRepo.huyHoaDonCho(id);
            result.put("success", ok);
            if (!ok) result.put("message", "Không thể hủy hóa đơn này (có thể đã được xử lý).");
        } catch (Exception e) {
            result.put("success", false);
            result.put("message", "Lỗi khi hủy hóa đơn chờ: " + e.getMessage());
        }
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

            String phuongThuc = payload.phuongThucThanhToan == null || payload.phuongThucThanhToan.trim().isEmpty()
                    ? "TIENMAT" : payload.phuongThucThanhToan.trim().toUpperCase();
            if (!phuongThuc.equals("TIENMAT") && !phuongThuc.equals("CHUYENKHOAN")) {
                phuongThuc = "TIENMAT";
            }

            HoaDon hoaDon = hoaDonRepo.taoHoaDonBanHang(
                    kh.getId(),
                    nhanVien.getId(),
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
        Integer idHoaDonCho;
        String phuongThucThanhToan; // "TIENMAT" hoặc "CHUYENKHOAN"
        Double tienKhachDua;        // Chỉ áp dụng khi phuongThucThanhToan = TIENMAT
    }

    public static class GioHangItem {
        Integer idSanPhamChiTiet;
        Integer soLuong;
    }
}
