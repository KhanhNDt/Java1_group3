package com.example.Scott.controller;

import com.example.Scott.entity.NhanVien;
import com.example.Scott.responsitory.NhanVienRepository;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;
import java.sql.Date;

@WebServlet({
        "/nhan-vien/hien-thi",
        "/nhan-vien/detail",
        "/nhan-vien/add",
        "/nhan-vien/update",
        "/nhan-vien/delete",
        "/nhan-vien/search"
})
public class NhanVienServlet extends HttpServlet {

    private final NhanVienRepository repo = new NhanVienRepository();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String uri = request.getRequestURI();

        if (uri.contains("/nhan-vien/delete")) {
            this.delete(request, response);
        } else if (uri.contains("/nhan-vien/detail")) {
            this.detail(request, response);
        } else if (uri.contains("/nhan-vien/search")) {
            this.search(request, response);
        } else {
            this.hienThi(request, response);
        }
    }

    private void hienThi(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        request.setAttribute("menu", "nhanvien");
        request.setAttribute("list", repo.getAll());
        request.setAttribute("viewType", "list");
        request.getRequestDispatcher("/views/nhanvien/nhan-vien.jsp").forward(request, response);
    }

    private void detail(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String idStr = request.getParameter("id");
        if (idStr != null && !idStr.equals("0")) {
            request.setAttribute("nv", repo.getOne(Integer.valueOf(idStr)));
        } else {
            request.setAttribute("nv", new NhanVien());
        }
        request.setAttribute("menu", "nhanvien");
        request.setAttribute("viewType", "form");
        request.getRequestDispatcher("/views/nhanvien/nhan-vien.jsp").forward(request, response);
    }

    private void delete(HttpServletRequest request, HttpServletResponse response) throws IOException {
        repo.delete(Integer.valueOf(request.getParameter("id")));
        response.sendRedirect(request.getContextPath() + "/nhan-vien/hien-thi");
    }

    private void search(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        request.setAttribute("list", repo.search(request.getParameter("keyword")));
        request.setAttribute("viewType", "list");
        request.getRequestDispatcher("/views/nhanvien/nhan-vien.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        try {
            NhanVien nv = new NhanVien();

            // 1. Lấy và Log dữ liệu đầu vào để kiểm tra xem có nhận được dữ liệu không
            String maNV = request.getParameter("maNhanVien");
            String hoTen = request.getParameter("hoTen");
            String ngaySinhStr = request.getParameter("ngaySinh");

            System.out.println("Debug Form: ma=" + maNV + ", hoTen=" + hoTen + ", ngaySinh=" + ngaySinhStr);

            // 2. Mapping
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

            // Xử lý Boolean/Int an toàn
            nv.setGioiTinh(Boolean.parseBoolean(request.getParameter("gioiTinh")));
            nv.setTrangThai(Integer.parseInt(request.getParameter("trangThai")));

            // 3. Thực hiện lưu
            if (request.getRequestURI().contains("/add")) {
                boolean success = repo.add(nv);
                System.out.println("Kết quả add: " + success);
            } else {
                nv.setId(Integer.parseInt(request.getParameter("id")));
                boolean success = repo.update(nv);
                System.out.println("Kết quả update: " + success);
            }

            response.sendRedirect(request.getContextPath() + "/nhan-vien/hien-thi");

        } catch (Exception e) {
            // NẾU CÓ LỖI (Ví dụ: Format ngày sai, thiếu trường...), nó sẽ hiện ở đây
            e.printStackTrace();
            response.getWriter().println("<h1>Lỗi hệ thống: " + e.getMessage() + "</h1>");
        }
    }
}