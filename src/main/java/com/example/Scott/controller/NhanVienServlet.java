package com.example.Scott.controller;

import com.example.Scott.entity.NhanVien;
import com.example.Scott.responsitory.NhanVienRepository;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;

import java.io.IOException;

@WebServlet({
        "/nhan-vien/hien-thi",
        "/nhan-vien/detail",
        "/nhan-vien/add",
        "/nhan-vien/update",
        "/nhan-vien/delete",
        "/nhan-vien/search",
        "/nhan-vien/view-update" // Thêm mapping này để gọi phương thức viewUpdate
})
public class NhanVienServlet extends HttpServlet {

    private final NhanVienRepository repo = new NhanVienRepository();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String uri = request.getRequestURI();

        if (uri.contains("hien-thi")) {
            this.hienThiNhanVien(request, response);
        } else if (uri.contains("delete")) {
            this.deleteNhanVien(request, response);
        } else if (uri.contains("view-update")) {
            this.viewUpdateNhanVien(request, response);
        } else if (uri.contains("search")) {
            this.searchNhanVien(request, response);
        } else if (uri.contains("detail")) {
            this.detailNhanVien(request, response);
        } else {
            this.hienThiNhanVien(request, response);
        }
    }

    private void hienThiNhanVien(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.setAttribute("menu", "nhanvien");
        request.setAttribute("list", repo.getAll());
        request.getRequestDispatcher("/views/nhanvien/nhan-vien.jsp").forward(request, response);
    }

    private void detailNhanVien(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        Integer id = Integer.valueOf(request.getParameter("id"));
        request.setAttribute("nv", repo.getOne(id));
        request.setAttribute("list", repo.getAll());
        request.getRequestDispatcher("/views/nhanvien/nhan-vien.jsp").forward(request, response);
    }

    private void searchNhanVien(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String keyword = request.getParameter("keyword");
        request.setAttribute("list", repo.search(keyword));
        request.getRequestDispatcher("/views/nhanvien/nhan-vien.jsp").forward(request, response);
    }

    private void viewUpdateNhanVien(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.setAttribute("menu", "nhanvien");
        Integer id = Integer.valueOf(request.getParameter("id"));
        request.setAttribute("nv", repo.getOne(id));
        request.getRequestDispatcher("/views/nhanvien/update-nhan-vien.jsp").forward(request, response);
    }

    private void deleteNhanVien(HttpServletRequest request, HttpServletResponse response)
            throws IOException {
        Integer id = Integer.valueOf(request.getParameter("id"));
        repo.delete(id);
        response.sendRedirect(request.getContextPath() + "/nhan-vien/hien-thi");
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String uri = request.getRequestURI();

        if (uri.contains("add")) {
            this.saveOrUpdate(request, response, false); // false = là thêm mới
        } else if (uri.contains("update")) {
            this.saveOrUpdate(request, response, true);  // true = là cập nhật
        }
    }

    private void saveOrUpdate(HttpServletRequest request, HttpServletResponse response, boolean isUpdate) throws IOException {
        try {
            NhanVien nv = new NhanVien();

            // Sử dụng BeanUtils để tự động mapping từ form vào Object
            // Giúp bạn không phải gọi request.getParameter() cho từng trường
            org.apache.commons.beanutils.BeanUtils.populate(nv, request.getParameterMap());

            // Xử lý riêng trường hợp ID và Checkbox nếu cần thiết
            if (isUpdate) {
                nv.setId(Integer.parseInt(request.getParameter("id")));
                repo.update(nv);
            } else {
                repo.add(nv);
            }

            // Sau khi lưu xong, quay về trang danh sách
            response.sendRedirect(request.getContextPath() + "/nhan-vien/hien-thi");

        } catch (Exception e) {
            e.printStackTrace();
            response.getWriter().println("Lỗi lưu dữ liệu: " + e.getMessage());
        }
    }
}