package com.example.Scott.controller;

import com.example.Scott.entity.NhanVien;
import com.example.Scott.responsitory.NhanVienRepository;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;
import java.sql.Date;
import java.util.List;

@WebServlet(name = "NhanVienServlet", value = {
        "/nhan-vien/hien-thi",
        "/nhan-vien/add",
        "/nhan-vien/update",
        "/nhan-vien/delete",
        "/nhan-vien/detail",
        "/nhan-vien/search"
})
public class NhanVienServlet extends HttpServlet {

    private final NhanVienRepository repo = new NhanVienRepository();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String uri = request.getRequestURI();

        if (uri.contains("hien-thi")) {
            hienThi(request, response);
        } else if (uri.contains("detail")) {
            detail(request, response);
        } else if (uri.contains("delete")) {
            delete(request, response);
        } else if (uri.contains("search")) {
            search(request, response);
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        request.setCharacterEncoding("UTF-8");

        String uri = request.getRequestURI();

        if (uri.contains("add")) {
            add(request, response);
        } else if (uri.contains("update")) {
            update(request, response);
        }
    }

    //================ HIỂN THỊ =================

    private void hienThi(HttpServletRequest request,
                         HttpServletResponse response)
            throws ServletException, IOException {

        List<NhanVien> list = repo.getAll();

        request.setAttribute("listNhanVien", list);

        request.getRequestDispatcher("/nhanvien.jsp")
                .forward(request, response);
    }

    //================ THÊM =================

    private void add(HttpServletRequest request,
                     HttpServletResponse response)
            throws IOException {

        NhanVien nv = new NhanVien();

        nv.setMaNhanVien(request.getParameter("maNhanVien"));
        nv.setHoTen(request.getParameter("hoTen"));
        nv.setEmail(request.getParameter("email"));
        nv.setSoDienThoai(request.getParameter("soDienThoai"));
        nv.setDiaChi(request.getParameter("diaChi"));
        nv.setChucVu(request.getParameter("chucVu"));
        nv.setAnhDaiDien(request.getParameter("anhDaiDien"));

        String ngaySinh = request.getParameter("ngaySinh");
        if (ngaySinh != null && !ngaySinh.isEmpty()) {
            nv.setNgaySinh(Date.valueOf(ngaySinh));
        }

        nv.setGioiTinh(Boolean.parseBoolean(request.getParameter("gioiTinh")));
        nv.setTrangThai(Integer.parseInt(request.getParameter("trangThai")));

        repo.add(nv);

        response.sendRedirect(request.getContextPath() + "/nhan-vien/hien-thi");
    }



    private void detail(HttpServletRequest request,
                        HttpServletResponse response)
            throws ServletException, IOException {

        Integer id = Integer.parseInt(request.getParameter("id"));

        request.setAttribute("nv", repo.getOne(id));
        request.setAttribute("listNhanVien", repo.getAll());

        request.getRequestDispatcher("/nhanvien.jsp")
                .forward(request, response);
    }



    private void update(HttpServletRequest request,
                        HttpServletResponse response)
            throws IOException {

        Integer id = Integer.parseInt(request.getParameter("id"));

        NhanVien nv = repo.getOne(id);

        nv.setMaNhanVien(request.getParameter("maNhanVien"));
        nv.setHoTen(request.getParameter("hoTen"));
        nv.setEmail(request.getParameter("email"));
        nv.setSoDienThoai(request.getParameter("soDienThoai"));
        nv.setDiaChi(request.getParameter("diaChi"));
        nv.setChucVu(request.getParameter("chucVu"));
        nv.setAnhDaiDien(request.getParameter("anhDaiDien"));

        String ngaySinh = request.getParameter("ngaySinh");
        if (ngaySinh != null && !ngaySinh.isEmpty()) {
            nv.setNgaySinh(Date.valueOf(ngaySinh));
        }

        nv.setGioiTinh(Boolean.parseBoolean(request.getParameter("gioiTinh")));
        nv.setTrangThai(Integer.parseInt(request.getParameter("trangThai")));

        repo.update(nv);

        response.sendRedirect(request.getContextPath() + "/nhan-vien/hien-thi");
    }



    private void delete(HttpServletRequest request,
                        HttpServletResponse response)
            throws IOException {

        Integer id = Integer.parseInt(request.getParameter("id"));

        repo.delete(id);

        response.sendRedirect(request.getContextPath() + "/nhan-vien/hien-thi");
    }



    private void search(HttpServletRequest request,
                        HttpServletResponse response)
            throws ServletException, IOException {

        String keyword = request.getParameter("keyword");

        List<NhanVien> list = repo.search(keyword);

        request.setAttribute("listNhanVien", list);

        request.getRequestDispatcher("/nhanvien.jsp")
                .forward(request, response);
    }
}