package com.example.Scott.controller;

import com.example.Scott.entity.PhieuGiamGia;
import com.example.Scott.responsitory.PhieuGiamGiaResponsitory;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;

import java.io.IOException;
import java.math.BigDecimal;
import java.util.List;

@WebServlet(name = "PhieuGiamGiaServlet", value = {
        "/phieugiamgia/hien-thi",
        "/phieugiamgia/view-add",
        "/phieugiamgia/add",
        "/phieugiamgia/update",
        "/phieugiamgia/delete",
        "/phieugiamgia/view-update",
        "/phieugiamgia/search"
})
public class PhieuGiamGiaServlet extends HttpServlet {

    private final PhieuGiamGiaResponsitory repo = new PhieuGiamGiaResponsitory();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String uri = request.getRequestURI();

        if (uri.endsWith("/view-add")) {
            viewAdd(request, response);
        } else if (uri.endsWith("/view-update")) {
            viewUpdate(request, response);
        } else if (uri.endsWith("/delete")) {
            delete(request, response);
        } else if (uri.endsWith("/search")) {
            search(request, response);
        } else {
            hienThi(request, response);
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        request.setCharacterEncoding("UTF-8");
        String uri = request.getRequestURI();

        if (uri.endsWith("/add")) {
            addPhieuGiamGia(request, response);
        } else if (uri.endsWith("/update")) {
            updatePhieuGiamGia(request, response);
        }
    }

    // ================= HELPER TỰ ĐỘNG BẬT/TẮT TRẠNG THÁI THEO HẠN =================
    private void autoUpdateStatus(PhieuGiamGia pgg) {
        if (pgg != null && pgg.getNgayKetThuc() != null) {
            java.util.Date today = new java.util.Date();
            // Nếu ngày kết thúc nhỏ hơn ngày hiện tại -> Tắt (0), Ngược lại -> Bật (1)
            if (pgg.getNgayKetThuc().before(today)) {
                pgg.setTrangThai(0); // Ngừng hoạt động
            } else {
                pgg.setTrangThai(1); // Đang hoạt động
            }
        }
    }

    // ================= HIỂN THỊ DANH SÁCH =================
    private void hienThi(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        List<PhieuGiamGia> list = repo.getAll();
        for (PhieuGiamGia pgg : list) {
            autoUpdateStatus(pgg);
        }

        request.setAttribute("menu", "phieugiamgia");
        request.setAttribute("listPhieuGiamGia", list);

        moveFlash(request);

        request.getRequestDispatcher("/views/phieugiamgian3/phieugiamgias.jsp")
                .forward(request, response);
    }

    // ================= HIỂN THỊ FORM THÊM MỚI =================
    private void viewAdd(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        request.getRequestDispatcher("/views/phieugiamgian3/viewadd.jsp")
                .forward(request, response);
    }

    // ================= HIỂN THỊ FORM CẬP NHẬT =================
    private void viewUpdate(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        try {
            Integer id = Integer.valueOf(request.getParameter("id"));
            PhieuGiamGia pgg = repo.getOne(id);
            autoUpdateStatus(pgg);

            request.setAttribute("phieugiamgiaS", pgg);
            request.getRequestDispatcher("/views/phieugiamgian3/updatePGG.jsp")
                    .forward(request, response);
        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect(request.getContextPath() + "/phieugiamgia/hien-thi");
        }
    }

    // ================= TÌM KIẾM & LỌC THEO NGÀY =================
    private void search(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String keyword = request.getParameter("keyword");
        String loaiGiamGia = request.getParameter("loaiGiamGia");
        String trangThaiStr = request.getParameter("trangThai");
        String fromStr = request.getParameter("from");
        String toStr = request.getParameter("to");

        if (keyword == null) keyword = "";
        if (loaiGiamGia == null) loaiGiamGia = "";

        Integer trangThai = null;
        if (trangThaiStr != null && !trangThaiStr.trim().isEmpty()) {
            try {
                trangThai = Integer.valueOf(trangThaiStr.trim());
            } catch (NumberFormatException ignored) {}
        }

        java.sql.Date from = parseDate(fromStr);
        java.sql.Date to = parseDate(toStr);

        List<PhieuGiamGia> list = repo.searchFull(keyword, loaiGiamGia, trangThai, from, to);
        for (PhieuGiamGia pgg : list) {
            autoUpdateStatus(pgg);
        }

        request.setAttribute("menu", "phieugiamgia");
        request.setAttribute("listPhieuGiamGia", list);

        request.getRequestDispatcher("/views/phieugiamgian3/phieugiamgias.jsp")
                .forward(request, response);
    }

    // ================= XỬ LÝ THÊM MỚI (POST) =================
    private void addPhieuGiamGia(HttpServletRequest request, HttpServletResponse response)
            throws IOException {

        try {
            String maVoucher = request.getParameter("maVoucher");
            String tenVoucher = request.getParameter("tenVoucher");
            String loaiGiamGia = request.getParameter("loaiGiamGia");

            BigDecimal giaTriGiamGia = parseBigDecimal(request.getParameter("giaTriGiamGia"));
            BigDecimal giamToiDa = parseBigDecimal(request.getParameter("giamToiDa"));
            BigDecimal donToiThieu = parseBigDecimal(request.getParameter("donToiThieu"));
            Integer soLuong = parseInteger(request.getParameter("soLuong"));

            java.sql.Date ngayBatDau = parseDate(request.getParameter("ngayBatDau"));
            java.sql.Date ngayKetThuc = parseDate(request.getParameter("ngayKetThuc"));

            PhieuGiamGia pgg = new PhieuGiamGia();
            pgg.setMaVoucher(maVoucher);
            pgg.setTenVoucher(tenVoucher);
            pgg.setLoaiGiamGia(loaiGiamGia);
            pgg.setGiaTriGiamGia(giaTriGiamGia);
            pgg.setGiamToiDa(giamToiDa);
            pgg.setDonToiThieu(donToiThieu);
            pgg.setSoLuong(soLuong);
            pgg.setSoLuongDaDung(0);
            pgg.setNgayBatDau(ngayBatDau);
            pgg.setNgayKetThuc(ngayKetThuc);
            pgg.setNgayTao(new java.util.Date());

            // Tự động gán trạng thái lúc tạo mới
            java.util.Date today = new java.util.Date();
            if (ngayKetThuc != null && ngayKetThuc.before(today)) {
                pgg.setTrangThai(0); // Hết hạn -> Ngừng hoạt động
            } else {
                pgg.setTrangThai(1); // Còn hạn -> Đang hoạt động
            }

            repo.addPhieuGiamGia(pgg);

            request.getSession().setAttribute("success", "Thêm phiếu giảm giá thành công!");

        } catch (Exception e) {
            e.printStackTrace();
            request.getSession().setAttribute("error", "Thêm phiếu giảm giá thất bại!");
        }

        response.sendRedirect(request.getContextPath() + "/phieugiamgia/hien-thi");
    }

    // ================= XỬ LÝ CẬP NHẬT (POST) =================
    private void updatePhieuGiamGia(HttpServletRequest request, HttpServletResponse response)
            throws IOException {

        try {
            Integer id = Integer.valueOf(request.getParameter("id"));
            PhieuGiamGia pgg = repo.getOne(id);

            if (pgg != null) {
                pgg.setMaVoucher(request.getParameter("maVoucher"));
                pgg.setTenVoucher(request.getParameter("tenVoucher"));
                pgg.setLoaiGiamGia(request.getParameter("loaiGiamGia"));

                pgg.setGiaTriGiamGia(parseBigDecimal(request.getParameter("giaTriGiamGia")));
                pgg.setGiamToiDa(parseBigDecimal(request.getParameter("giamToiDa")));
                pgg.setDonToiThieu(parseBigDecimal(request.getParameter("donToiThieu")));
                pgg.setSoLuong(parseInteger(request.getParameter("soLuong")));

                pgg.setNgayBatDau(parseDate(request.getParameter("ngayBatDau")));
                pgg.setNgayKetThuc(parseDate(request.getParameter("ngayKetThuc")));

                pgg.setTrangThai(parseInteger(request.getParameter("trangThai")));

                repo.updatePhieuGiamGia(pgg);

                request.getSession().setAttribute("success", "Cập nhật phiếu giảm giá thành công!");
            } else {
                request.getSession().setAttribute("error", "Không tìm thấy phiếu giảm giá!");
            }

        } catch (Exception e) {
            e.printStackTrace();
            request.getSession().setAttribute("error", "Cập nhật thất bại!");
        }

        response.sendRedirect(request.getContextPath() + "/phieugiamgia/hien-thi");
    }

    // ================= XỬ LÝ XÓA =================
    private void delete(HttpServletRequest request, HttpServletResponse response)
            throws IOException {

        try {
            Integer id = Integer.valueOf(request.getParameter("id"));
            PhieuGiamGia pgg = repo.getOne(id);

            if (pgg != null) {
                repo.deletePhieuGiamGia(pgg);
                request.getSession().setAttribute("success", "Xóa thành công!");
            } else {
                request.getSession().setAttribute("error", "Không tìm thấy dữ liệu để xóa!");
            }

        } catch (Exception e) {
            e.printStackTrace();
            request.getSession().setAttribute("error", "Xóa thất bại!");
        }

        response.sendRedirect(request.getContextPath() + "/phieugiamgia/hien-thi");
    }

    // ================= CHUYỂN FLASH MESSAGE =================
    private void moveFlash(HttpServletRequest request) {
        Object success = request.getSession().getAttribute("success");
        Object error = request.getSession().getAttribute("error");

        if (success != null) {
            request.setAttribute("success", success);
            request.getSession().removeAttribute("success");
        }

        if (error != null) {
            request.setAttribute("error", error);
            request.getSession().removeAttribute("error");
        }
    }

    // ================= HELPER PARSE AN TOÀN =================
    private BigDecimal parseBigDecimal(String value) {
        if (value == null || value.trim().isEmpty()) return BigDecimal.ZERO;
        try {
            return new BigDecimal(value.trim());
        } catch (Exception e) {
            return BigDecimal.ZERO;
        }
    }

    private Integer parseInteger(String value) {
        if (value == null || value.trim().isEmpty()) return 0;
        try {
            return Integer.valueOf(value.trim());
        } catch (Exception e) {
            return 0;
        }
    }

    private java.sql.Date parseDate(String value) {
        if (value == null || value.trim().isEmpty()) return null;
        try {
            return java.sql.Date.valueOf(value.trim());
        } catch (Exception e) {
            return null;
        }
    }
}