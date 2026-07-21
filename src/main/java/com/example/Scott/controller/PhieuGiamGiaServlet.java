package com.example.Scott.controller;

import com.example.Scott.entity.PhieuGiamGia;
import com.example.Scott.responsitory.PhieuGiamGiaResponsitory;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;

import java.io.IOException;
import java.math.BigDecimal;

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
    protected void doGet(HttpServletRequest request,
                         HttpServletResponse response)
            throws ServletException, IOException {

        String uri = request.getRequestURI();

        if (uri.contains("hien-thi")) {
            hienThi(request, response);
        } else if (uri.contains("view-add")) {
            viewAdd(request, response);
        } else if (uri.contains("view-update")) {
            viewUpdate(request, response);
        } else if (uri.contains("delete")) {
            delete(request, response);
        } else if (uri.contains("search")) {
            search(request, response);
        }
    }

    @Override
    protected void doPost(HttpServletRequest request,
                          HttpServletResponse response)
            throws ServletException, IOException {

        request.setCharacterEncoding("UTF-8");

        String uri = request.getRequestURI();

        if (uri.contains("add")) {
            addPhieuGiamGia(request, response);
        } else if (uri.contains("update")) {
            updatePhieuGiamGia(request, response);
        }
    }

    // ================= HIỂN THỊ DANH SÁCH =================
    private void hienThi(HttpServletRequest request,
                         HttpServletResponse response)
            throws ServletException, IOException {

        request.setAttribute("menu", "phieugiamgia");
        request.setAttribute("listPhieuGiamGia", repo.getAll());

        moveFlash(request);

        request.getRequestDispatcher("/views/phieugiamgian3/phieugiamgias.jsp")
                .forward(request, response);
    }

    // ================= HIỂN THỊ FORM THÊM MỚI =================
    private void viewAdd(HttpServletRequest request,
                         HttpServletResponse response)
            throws ServletException, IOException {

        request.getRequestDispatcher("/views/phieugiamgian3/viewadd.jsp")
                .forward(request, response);
    }

    // ================= HIỂN THỊ FORM CẬP NHẬT =================
    private void viewUpdate(HttpServletRequest request,
                            HttpServletResponse response)
            throws ServletException, IOException {

        try {
            Integer id = Integer.valueOf(request.getParameter("id"));
            PhieuGiamGia pgg = repo.getOne(id);

            request.setAttribute("phieugiamgiaS", pgg);
            request.getRequestDispatcher("/views/phieugiamgian3/updatePGG.jsp")
                    .forward(request, response);
        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect(request.getContextPath() + "/phieugiamgia/hien-thi");
        }
    }

    // ================= TÌM KIẾM =================
    private void search(HttpServletRequest request,
                        HttpServletResponse response)
            throws ServletException, IOException {

        String keyword = request.getParameter("keyword");

        if (keyword == null) {
            keyword = "";
        }

        request.setAttribute("menu", "phieugiamgia");
        request.setAttribute("listPhieuGiamGia", repo.search(keyword));

        request.getRequestDispatcher("/views/phieugiamgian3/phieugiamgias.jsp")
                .forward(request, response);
    }

    // ================= XỬ LÝ THÊM MỚI (POST) =================
    private void addPhieuGiamGia(HttpServletRequest request,
                                 HttpServletResponse response)
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
            pgg.setTrangThai(1);

            repo.addPhieuGiamGia(pgg);

            request.getSession().setAttribute("success", "Thêm phiếu giảm giá thành công!");

        } catch (Exception e) {
            e.printStackTrace();
            request.getSession().setAttribute("error", "Thêm phiếu giảm giá thất bại!");
        }

        response.sendRedirect(request.getContextPath() + "/phieugiamgia/hien-thi");
    }

    // ================= XỬ LÝ CẬP NHẬT (POST) =================
    private void updatePhieuGiamGia(HttpServletRequest request,
                                    HttpServletResponse response)
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
    private void delete(HttpServletRequest request,
                        HttpServletResponse response)
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
        return new BigDecimal(value.trim());
    }

    private Integer parseInteger(String value) {
        if (value == null || value.trim().isEmpty()) return 0;
        return Integer.valueOf(value.trim());
    }

    private java.sql.Date parseDate(String value) {
        if (value == null || value.trim().isEmpty()) return null;
        return java.sql.Date.valueOf(value.trim());
    }
}