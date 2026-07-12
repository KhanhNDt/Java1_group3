package com.example.Scott.controller;

import com.example.Scott.entity.NhanVien;
import com.example.Scott.responsitory.NhanVienRepository;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;

import java.io.IOException;
import java.text.SimpleDateFormat;
import java.util.Date;

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
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String uri = request.getRequestURI();

        if (uri.contains("hien-thi")) {

            request.setAttribute("list", repo.getAll());

        } else if (uri.contains("detail")) {

            Integer id = Integer.valueOf(request.getParameter("id"));

            request.setAttribute("nv", repo.getOne(id));
            request.setAttribute("list", repo.getAll());

        } else if (uri.contains("delete")) {

            Integer id = Integer.valueOf(request.getParameter("id"));

            repo.delete(id);

            response.sendRedirect(request.getContextPath() + "/nhan-vien/hien-thi");
            return;

        } else if (uri.contains("search")) {

            String keyword = request.getParameter("keyword");

            request.setAttribute("list", repo.search(keyword));
        }

        request.getRequestDispatcher("/views/nhan-vien.jsp")
                .forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        request.setCharacterEncoding("UTF-8");

        String uri = request.getRequestURI();

        try {

            NhanVien nv = new NhanVien();

            nv.setMaNhanVien(request.getParameter("maNhanVien"));
            nv.setHoTen(request.getParameter("hoTen"));
            nv.setEmail(request.getParameter("email"));
            nv.setSoDienThoai(request.getParameter("soDienThoai"));

            String ngay = request.getParameter("ngaySinh");

            if (ngay != null && !ngay.isEmpty()) {

                Date date = new SimpleDateFormat("yyyy-MM-dd").parse(ngay);

                nv.setNgaySinh(date);
            }

            nv.setGioiTinh(Boolean.valueOf(request.getParameter("gioiTinh")));

            nv.setDiaChi(request.getParameter("diaChi"));

            nv.setChucVu(request.getParameter("chucVu"));

            nv.setAnhDaiDien(request.getParameter("anhDaiDien"));

            nv.setTrangThai(
                    Integer.valueOf(request.getParameter("trangThai"))
            );

            if (uri.contains("add")) {

                repo.add(nv);

            } else if (uri.contains("update")) {

                nv.setId(Integer.valueOf(request.getParameter("id")));

                repo.update(nv);

            }

        } catch (Exception e) {

            e.printStackTrace();
        }

        response.sendRedirect(request.getContextPath() + "/nhan-vien/hien-thi");
        return;
    }
}