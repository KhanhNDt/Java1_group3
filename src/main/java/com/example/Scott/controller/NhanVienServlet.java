package com.example.Scott.controller;

import com.example.Scott.entity.NhanVien;
import com.example.Scott.responsitory.NhanVienRepository;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;

import java.io.IOException;
import java.io.UnsupportedEncodingException;
import java.net.URLEncoder;

@WebServlet({
        "/nhan-vien/hien-thi",
        "/nhan-vien/detail",
        "/nhan-vien/view",
        "/nhan-vien/add",
        "/nhan-vien/update",
        "/nhan-vien/delete",
        "/nhan-vien/toggle",
        "/nhan-vien/search"
})
public class NhanVienServlet extends HttpServlet {

    private static final int PAGE_SIZE_DEFAULT = 10;

    private final NhanVienRepository repo = new NhanVienRepository();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");
        response.setCharacterEncoding("UTF-8");

        String uri = request.getRequestURI();

        if (uri.contains("/nhan-vien/delete")) {
            this.delete(request, response);
        } else if (uri.contains("/nhan-vien/toggle")) {
            this.toggle(request, response);
        } else if (uri.contains("/nhan-vien/view")) {
            this.view(request, response);
        } else if (uri.contains("/nhan-vien/detail")) {
            this.detail(request, response);
        } else {
            // /nhan-vien/hien-thi hoặc /nhan-vien/search đều đổ về danh sách có bộ lọc
            this.hienThi(request, response);
        }
    }

    /**
     * Danh sách nhân viên: tìm kiếm + lọc theo chức vụ/trạng thái + phân trang
     */
    private void hienThi(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String keyword = request.getParameter("keyword");
        String chucVu = request.getParameter("chucVu");
        String trangThaiParam = request.getParameter("trangThai");

        Integer trangThai = null;
        if (trangThaiParam != null && !trangThaiParam.trim().isEmpty()) {
            try {
                trangThai = Integer.parseInt(trangThaiParam.trim());
            } catch (NumberFormatException ignored) {
            }
        }

        int page = parseIntSafe(request.getParameter("page"), 1);
        if (page < 1) page = 1;

        int size = parseIntSafe(request.getParameter("size"), PAGE_SIZE_DEFAULT);
        if (size < 1) size = PAGE_SIZE_DEFAULT;

        long totalRecords = repo.countFilter(keyword, chucVu, trangThai);
        int totalPages = (int) Math.ceil((double) totalRecords / size);
        if (totalPages < 1) totalPages = 1;
        if (page > totalPages) page = totalPages;

        int offset = (page - 1) * size;

        request.setAttribute("list", repo.filter(keyword, chucVu, trangThai, offset, size));
        request.setAttribute("totalRecords", totalRecords);
        request.setAttribute("totalPages", totalPages);
        request.setAttribute("currentPage", page);
        request.setAttribute("size", size);
        request.setAttribute("keyword", keyword);
        request.setAttribute("chucVu", chucVu);
        request.setAttribute("trangThai", trangThaiParam);

        request.setAttribute("menu", "nhanvien");
        request.setAttribute("viewType", "list");
        request.getRequestDispatcher("/views/nhanvien/nhan-vien.jsp").forward(request, response);
    }

    /**
     * Form thêm mới / cập nhật
     */
    private void detail(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String idStr = request.getParameter("id");
        if (idStr != null && !idStr.equals("0")) {
            try {
                request.setAttribute("nv", repo.getOne(Integer.valueOf(idStr)));
            } catch (NumberFormatException e) {
                request.setAttribute("nv", new NhanVien());
            }
        } else {
            request.setAttribute("nv", new NhanVien());
        }
        request.setAttribute("menu", "nhanvien");
        request.setAttribute("viewType", "form");
        request.getRequestDispatcher("/views/nhanvien/nhan-vien.jsp").forward(request, response);
    }

    /**
     * Xem chi tiết (chỉ đọc) - dùng cho icon con mắt
     */
    private void view(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String idStr = request.getParameter("id");
        NhanVien nv = null;
        if (idStr != null) {
            try {
                nv = repo.getOne(Integer.valueOf(idStr));
            } catch (NumberFormatException ignored) {
            }
        }
        if (nv == null) {
            response.sendRedirect(request.getContextPath() + "/nhan-vien/hien-thi");
            return;
        }
        request.setAttribute("nv", nv);
        request.setAttribute("menu", "nhanvien");
        request.setAttribute("viewType", "view");
        request.getRequestDispatcher("/views/nhanvien/nhan-vien.jsp").forward(request, response);
    }

    private void delete(HttpServletRequest request, HttpServletResponse response) throws IOException {
        try {
            repo.delete(Integer.valueOf(request.getParameter("id")));
        } catch (NumberFormatException ignored) {
        }
        response.sendRedirect(request.getContextPath() + "/nhan-vien/hien-thi" + buildBackQuery(request));
    }

    /**
     * Bật/tắt nhanh trạng thái Đang làm - Đã nghỉ (công tắc gạt trong bảng)
     */
    private void toggle(HttpServletRequest request, HttpServletResponse response) throws IOException {
        try {
            int id = Integer.parseInt(request.getParameter("id"));
            NhanVien nv = repo.getOne(id);
            if (nv != null) {
                int newStatus = nv.getTrangThai() == 1 ? 0 : 1;
                repo.updateTrangThai(id, newStatus);
            }
        } catch (NumberFormatException ignored) {
        }
        response.sendRedirect(request.getContextPath() + "/nhan-vien/hien-thi" + buildBackQuery(request));
    }

    /**
     * Giữ lại các tham số lọc/trang hiện tại khi redirect quay lại danh sách
     */
    private String buildBackQuery(HttpServletRequest request) {
        StringBuilder sb = new StringBuilder("?");
        appendParam(sb, request, "keyword");
        appendParam(sb, request, "chucVu");
        appendParam(sb, request, "trangThai");
        appendParam(sb, request, "page");
        appendParam(sb, request, "size");
        return sb.toString();
    }

    private void appendParam(StringBuilder sb, HttpServletRequest request, String name) {
        String value = request.getParameter(name);
        if (value != null && !value.isEmpty()) {
            if (sb.length() > 1) sb.append("&");
            try {
                sb.append(name).append("=").append(URLEncoder.encode(value, "UTF-8"));
            } catch (UnsupportedEncodingException e) {
                // UTF-8 luôn được hỗ trợ trên mọi JVM nên nhánh này thực tế không xảy ra
                sb.append(name).append("=").append(value);
            }
        }
    }

    private int parseIntSafe(String value, int defaultValue) {
        if (value == null || value.trim().isEmpty()) return defaultValue;
        try {
            return Integer.parseInt(value.trim());
        } catch (NumberFormatException e) {
            return defaultValue;
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");
        response.setCharacterEncoding("UTF-8");

        try {
            NhanVien nv = new NhanVien();

            String maNV = request.getParameter("maNhanVien");
            String hoTen = request.getParameter("hoTen");
            String ngaySinhStr = request.getParameter("ngaySinh");

            nv.setMaNhanVien(maNV);
            nv.setHoTen(hoTen);
            nv.setEmail(request.getParameter("email"));
            nv.setSoDienThoai(request.getParameter("soDienThoai"));
            nv.setChucVu(request.getParameter("chucVu"));
            nv.setDiaChi(request.getParameter("diaChi"));

            // Xử lý Date an toàn
            if (ngaySinhStr != null && !ngaySinhStr.isEmpty()) {
                nv.setNgaySinh(java.sql.Date.valueOf(ngaySinhStr));
            }

            // Xử lý Boolean/Int an toàn (không để null gây NumberFormatException)
            nv.setGioiTinh(Boolean.parseBoolean(request.getParameter("gioiTinh")));

            String trangThaiStr = request.getParameter("trangThai");
            nv.setTrangThai(parseIntSafe(trangThaiStr, 1));

            boolean success;
            if (request.getRequestURI().contains("/add")) {
                success = repo.add(nv);
            } else {
                nv.setId(Integer.parseInt(request.getParameter("id")));
                success = repo.update(nv);
            }

            if (success) {
                response.sendRedirect(request.getContextPath() + "/nhan-vien/hien-thi");
            } else {
                request.setAttribute("error", "Lưu dữ liệu thất bại. Vui lòng kiểm tra lại thông tin (mã nhân viên có thể đã tồn tại).");
                request.setAttribute("nv", nv);
                request.setAttribute("menu", "nhanvien");
                request.setAttribute("viewType", "form");
                request.getRequestDispatcher("/views/nhanvien/nhan-vien.jsp").forward(request, response);
            }

        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("error", "Lỗi hệ thống: " + e.getMessage());
            request.setAttribute("menu", "nhanvien");
            request.setAttribute("viewType", "form");
            request.getRequestDispatcher("/views/nhanvien/nhan-vien.jsp").forward(request, response);
        }
    }
}