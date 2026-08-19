package com.example.Scott.controller;

import com.example.Scott.entity.AnhMauSac;
import com.example.Scott.entity.ChiTietSanPham;
import com.example.Scott.entity.HoaDon;
import com.example.Scott.entity.HoaDonChiTiet;
import com.example.Scott.entity.KhachHang;
import com.example.Scott.entity.NhanVien;
import com.example.Scott.entity.PhieuGiamGia;
import com.example.Scott.entity.TaiKhoan;
import com.example.Scott.responsitory.AnhMauSacResponsitory;
import com.example.Scott.responsitory.ChiTietSanPhamResponsitory;
import com.example.Scott.responsitory.HoaDonRepo;
import com.example.Scott.responsitory.KhachHangResponsitory;
import com.example.Scott.responsitory.PhieuGiamGiaResponsitory;
import com.example.Scott.service.ThanhToanService;
import com.example.Scott.utils.QrPaymentSessionManager;
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
 * - GET action=timTheoMa: AJAX tra cuu CHINH XAC 1 bien the theo ma (dung khi quet QR).
 * - POST action=thanhToan: tao hoa don (JSON body), tra ve JSON ket qua.
 */
@WebServlet(name = "BanHangServlet", value = {"/ban-hang-tai-quay"})
public class BanHangServlet extends HttpServlet {

    private final ChiTietSanPhamResponsitory chiTietSanPhamRepo = new ChiTietSanPhamResponsitory();
    private final AnhMauSacResponsitory anhMauSacRepo = new AnhMauSacResponsitory();
    private final KhachHangResponsitory khachHangRepo = new KhachHangResponsitory();
    private final PhieuGiamGiaResponsitory phieuGiamGiaRepo = new PhieuGiamGiaResponsitory();
    private final HoaDonRepo hoaDonRepo = new HoaDonRepo();
    private final ThanhToanService thanhToanService = new ThanhToanService();
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
            case "boLocSanPham":
                boLocSanPham(req, resp);
                break;
            case "timKhachHang":
                timKhachHang(req, resp);
                break;
            case "danhSachKhachHang":
                danhSachKhachHang(req, resp);
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
            case "kiemTraQR":
                kiemTraTrangThaiQR(req, resp);
                break;
            case "timTheoMa":
                timTheoMa(req, resp);
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
        } else if ("taoPhienQR".equals(action)) {
            taoPhienQR(req, resp);
        } else if ("xacNhanQR".equals(action)) {
            xacNhanThuCongQR(req, resp);
        } else {
            resp.sendError(HttpServletResponse.SC_METHOD_NOT_ALLOWED, "Hành động không được hỗ trợ");
        }
    }

    private void hienThiGiaoDien(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        req.setAttribute("menu", "banhang");
        req.getRequestDispatcher("/views/banhang/ban-hang.jsp").forward(req, resp);
    }

    // ================= AJAX: tìm sản phẩm còn hàng (có lọc + phân trang) =================
    private void timSanPham(HttpServletRequest req, HttpServletResponse resp) throws IOException {
        String keyword = req.getParameter("keyword");
        Integer idMauSac = parseIntOrNull(req.getParameter("mauSac"));
        Integer idSize = parseIntOrNull(req.getParameter("size"));
        java.math.BigDecimal giaMin = parseGiaOrNull(req.getParameter("giaMin"));
        java.math.BigDecimal giaMax = parseGiaOrNull(req.getParameter("giaMax"));
        String tonKho = req.getParameter("tonKho"); // "tat-ca" | "con-hang" | "het-hang"

        int page = parseIntOrNull(req.getParameter("page")) != null ? parseIntOrNull(req.getParameter("page")) : 1;
        int pageSize = parseIntOrNull(req.getParameter("pageSize")) != null ? parseIntOrNull(req.getParameter("pageSize")) : 10;
        if (page < 1) page = 1;
        if (pageSize < 1) pageSize = 10;
        if (pageSize > 50) pageSize = 50;

        List<ChiTietSanPham> list = chiTietSanPhamRepo.searchForBanHangPage(
                keyword, idMauSac, idSize, giaMin, giaMax, tonKho, page, pageSize);
        long tongSauLoc = chiTietSanPhamRepo.countForBanHang(keyword, idMauSac, idSize, giaMin, giaMax, tonKho);

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
            item.put("hinhAnh", layAnhBienThe(ct));
            items.add(item);
        }

        long totalPages = pageSize > 0 ? (long) Math.ceil(tongSauLoc / (double) pageSize) : 1;
        if (totalPages < 1) totalPages = 1;

        Map<String, Object> pagination = new LinkedHashMap<>();
        pagination.put("page", page);
        pagination.put("pageSize", pageSize);
        pagination.put("totalItems", tongSauLoc);
        pagination.put("totalPages", totalPages);

        Map<String, Object> result = new LinkedHashMap<>();
        result.put("success", true);
        result.put("items", items);
        result.put("pagination", pagination);
        writeJson(resp, result);
    }

    // ================= AJAX: tra cứu CHÍNH XÁC 1 biến thể theo mã (dùng khi quét QR) =================
    private void timTheoMa(HttpServletRequest req, HttpServletResponse resp) throws IOException {
        String ma = req.getParameter("ma");
        Map<String, Object> result = new LinkedHashMap<>();

        ChiTietSanPham ct = ma == null ? null : chiTietSanPhamRepo.timTheoMaChinhXac(ma);
        if (ct == null) {
            result.put("success", false);
            result.put("message", "Không tìm thấy sản phẩm với mã \"" + (ma == null ? "" : ma) + "\" (có thể đã ngừng bán).");
            writeJson(resp, result);
            return;
        }

        Map<String, Object> item = new LinkedHashMap<>();
        item.put("id", ct.getId());
        item.put("ma", ct.getMa());
        item.put("maSanPham", ct.getSanPham() != null ? ct.getSanPham().getMaSanPham() : "");
        item.put("tenSanPham", ct.getSanPham() != null ? ct.getSanPham().getTenSanPham() : "");
        item.put("mauSac", ct.getMauSac() != null ? ct.getMauSac().getTen() : "");
        item.put("kichThuoc", ct.getSize() != null ? ct.getSize().getTen() : "");
        item.put("giaBan", ct.getGiaBan());
        item.put("soLuongTon", ct.getSoLuongTon());
        item.put("hinhAnh", layAnhBienThe(ct));

        result.put("success", true);
        result.put("item", item);
        writeJson(resp, result);
    }

    // ================= AJAX: dữ liệu để dựng bộ lọc (màu / size / khoảng giá) =================
    private void boLocSanPham(HttpServletRequest req, HttpServletResponse resp) throws IOException {
        List<Map<String, Object>> mauSacList = new ArrayList<>();
        for (com.example.Scott.entity.MauSac ms : chiTietSanPhamRepo.getMauSacDangBan()) {
            Map<String, Object> m = new LinkedHashMap<>();
            m.put("id", ms.getId());
            m.put("ten", ms.getTen());
            mauSacList.add(m);
        }
        List<Map<String, Object>> sizeList = new ArrayList<>();
        for (com.example.Scott.entity.Size sz : chiTietSanPhamRepo.getSizeDangBan()) {
            Map<String, Object> m = new LinkedHashMap<>();
            m.put("id", sz.getId());
            m.put("ten", sz.getTen());
            sizeList.add(m);
        }
        java.math.BigDecimal[] khoangGia = chiTietSanPhamRepo.getKhoangGiaBanHang();

        Map<String, Object> result = new LinkedHashMap<>();
        result.put("success", true);
        result.put("mauSac", mauSacList);
        result.put("size", sizeList);
        result.put("giaMin", khoangGia[0]);
        result.put("giaMax", khoangGia[1]);
        writeJson(resp, result);
    }

    private Integer parseIntOrNull(String s) {
        if (s == null || s.trim().isEmpty()) return null;
        try { return Integer.parseInt(s.trim()); } catch (NumberFormatException e) { return null; }
    }

    private java.math.BigDecimal parseGiaOrNull(String s) {
        if (s == null || s.trim().isEmpty()) return null;
        try { return new java.math.BigDecimal(s.trim()); } catch (NumberFormatException e) { return null; }
    }

    /**
     * Lấy ảnh hiển thị cho 1 biến thể: ưu tiên ảnh riêng theo màu (nếu màu đó đã có ảnh
     * riêng trong bảng anh_mau_sac), nếu chưa có thì dùng ảnh bìa chung của sản phẩm.
     */
    private String layAnhBienThe(ChiTietSanPham ct) {
        if (ct.getSanPham() == null) return null;
        if (ct.getMauSac() != null) {
            AnhMauSac anh = anhMauSacRepo.getBySanPhamVaMau(ct.getSanPham().getId(), ct.getMauSac().getId());
            if (anh != null && anh.getDuongDanAnh() != null && !anh.getDuongDanAnh().isEmpty()) {
                return anh.getDuongDanAnh();
            }
        }
        return ct.getSanPham().getHinhAnh();
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

    // ================= AJAX: danh sách khách hàng đang hoạt động để chọn tại quầy =================
    private void danhSachKhachHang(HttpServletRequest req, HttpServletResponse resp) throws IOException {
        String keyword = req.getParameter("keyword");
        if (keyword != null) keyword = keyword.trim();

        // Dùng luôn bộ lọc đang có sẵn của KhachHangResponsitory:
        // keyword tìm theo thông tin khách, trạng thái = 1 (đang hoạt động).
        List<KhachHang> list = khachHangRepo.filter(keyword, null, 1, 0, 500);

        List<Map<String, Object>> items = new ArrayList<>();
        for (KhachHang kh : list) {
            Map<String, Object> item = new LinkedHashMap<>();
            item.put("id", kh.getId());
            item.put("ma", kh.getMa());
            item.put("hoTen", kh.getHoTen());
            item.put("sdt", kh.getSdt());
            item.put("email", kh.getEmail());
            item.put("diaChi", kh.getDiaChi());
            items.add(item);
        }

        Map<String, Object> result = new LinkedHashMap<>();
        result.put("success", true);
        result.put("items", items);
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
        // Hóa đơn chờ đã bị giữ quá 24h mà chưa xử lý sẽ tự động chuyển "Đã hủy" trước khi lấy danh sách,
        // nên hóa đơn quá hạn sẽ tự biến mất khỏi "Đơn hàng chờ" ngay trong lần tải danh sách kế tiếp.
        hoaDonRepo.huyCacHoaDonChoQuaHan();
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
            // Mốc thời gian tạo (epoch millis) để frontend tính ngược thời gian còn lại trước khi
            // hóa đơn chờ này tự động bị hủy sau 24h, hiển thị đếm ngược trên tab đơn hàng chờ.
            item.put("ngayTao", hd.getNgayTao() != null ? hd.getNgayTao().getTime() : null);
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

    // ================= POST: thanh toán / tạo hóa đơn (dùng cho Tiền mặt) =================
    private void thanhToan(HttpServletRequest req, HttpServletResponse resp) throws IOException {
        NhanVien nhanVien = layNhanVienDangDangNhap(req);
        Map<String, Object> result = new LinkedHashMap<>();
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

        result = thanhToanService.xuLyThanhToan(payload, nhanVien.getId());
        writeJson(resp, result);
    }

    private NhanVien layNhanVienDangDangNhap(HttpServletRequest req) {
        HttpSession session = req.getSession(false);
        TaiKhoan user = (session != null) ? (TaiKhoan) session.getAttribute("user") : null;
        return user != null ? user.getNhanVien() : null;
    }

    // ================= POST: mở phiên chờ thanh toán QR (chuyển khoản) =================
    // Không tạo hóa đơn ngay. Chỉ lưu tạm đơn hàng + sinh mã tham chiếu để nhúng vào nội dung
    // chuyển khoản QR, dùng cho webhook SePay khớp giao dịch sau này.
    private void taoPhienQR(HttpServletRequest req, HttpServletResponse resp) throws IOException {
        Map<String, Object> result = new LinkedHashMap<>();
        NhanVien nhanVien = layNhanVienDangDangNhap(req);
        if (nhanVien == null) {
            result.put("success", false);
            result.put("message", "Phiên đăng nhập đã hết hạn, vui lòng đăng nhập lại.");
            writeJson(resp, result);
            return;
        }

        ThanhToanRequest payload = docJsonBody(req);
        if (payload == null || payload.gioHang == null || payload.gioHang.isEmpty()) {
            result.put("success", false);
            result.put("message", "Giỏ hàng đang trống, vui lòng chọn sản phẩm trước khi thanh toán.");
            writeJson(resp, result);
            return;
        }

        QrPaymentSessionManager.PhienQR phien = new QrPaymentSessionManager.PhienQR();
        phien.maThamChieu = QrPaymentSessionManager.taoMaThamChieu();
        phien.soTienDuKien = payload.soTienDuKien != null ? payload.soTienDuKien : 0;
        phien.idNhanVien = nhanVien.getId();
        phien.payload = payload;
        QrPaymentSessionManager.luuPhien(phien);

        result.put("success", true);
        result.put("maThamChieu", phien.maThamChieu);
        writeJson(resp, result);
    }

    // ================= GET: frontend poll để biết phiên QR đã được thanh toán tự động chưa =================
    private void kiemTraTrangThaiQR(HttpServletRequest req, HttpServletResponse resp) throws IOException {
        Map<String, Object> result = new LinkedHashMap<>();
        String ma = req.getParameter("ma");
        QrPaymentSessionManager.PhienQR phien = QrPaymentSessionManager.layPhien(ma);
        if (phien == null) {
            result.put("success", false);
            result.put("message", "Không tìm thấy phiên thanh toán (có thể đã hết hạn).");
            writeJson(resp, result);
            return;
        }
        result.put("success", true);
        switch (phien.trangThai) {
            case DA_THANH_TOAN:
                result.put("trangThai", "paid");
                result.put("idHoaDon", phien.idHoaDon);
                result.put("maHoaDon", phien.maHoaDon);
                break;
            case LOI:
                result.put("trangThai", "loi");
                result.put("message", phien.thongBaoLoi);
                break;
            default:
                result.put("trangThai", "cho");
        }
        writeJson(resp, result);
    }

    // ================= POST: thu ngân bấm xác nhận thủ công (dự phòng khi webhook chưa kịp báo) =================
    private void xacNhanThuCongQR(HttpServletRequest req, HttpServletResponse resp) throws IOException {
        Map<String, Object> result = new LinkedHashMap<>();
        NhanVien nhanVien = layNhanVienDangDangNhap(req);
        if (nhanVien == null) {
            result.put("success", false);
            result.put("message", "Phiên đăng nhập đã hết hạn, vui lòng đăng nhập lại.");
            writeJson(resp, result);
            return;
        }
        String ma = req.getParameter("ma");
        QrPaymentSessionManager.PhienQR phien = QrPaymentSessionManager.layPhien(ma);
        if (phien == null) {
            result.put("success", false);
            result.put("message", "Không tìm thấy phiên thanh toán (có thể đã hết hạn), vui lòng thử lại từ đầu.");
            writeJson(resp, result);
            return;
        }

        synchronized (phien) {
            if (phien.trangThai == QrPaymentSessionManager.TrangThai.DA_THANH_TOAN) {
                result.put("success", true);
                result.put("maHoaDon", phien.maHoaDon);
                result.put("idHoaDon", phien.idHoaDon);
                writeJson(resp, result);
                return;
            }
            result = thanhToanService.xuLyThanhToan(phien.payload, phien.idNhanVien);
            if (Boolean.TRUE.equals(result.get("success"))) {
                phien.trangThai = QrPaymentSessionManager.TrangThai.DA_THANH_TOAN;
                phien.idHoaDon = (Integer) result.get("idHoaDon");
                phien.maHoaDon = (String) result.get("maHoaDon");
            }
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
        public String sdtKhachHang;
        public String tenKhachHang;
        public String emailKhachHang;
        public String diaChiKhachHang;
        public Integer idPhieuGiamGia;
        public String ghiChu;
        public List<GioHangItem> gioHang;
        public Integer idHoaDonCho;
        public String phuongThucThanhToan; // "TIENMAT" hoặc "CHUYENKHOAN"
        public Double tienKhachDua;        // Chỉ áp dụng khi phuongThucThanhToan = TIENMAT
        public Double soTienDuKien;        // Chỉ dùng khi mở phiên QR: số tiền hiển thị trên QR để webhook khớp giao dịch
    }

    public static class GioHangItem {
        public Integer idSanPhamChiTiet;
        public Integer soLuong;
    }
}
