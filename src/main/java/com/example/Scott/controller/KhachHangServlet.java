package com.example.Scott.controller;

import com.example.Scott.entity.KhachHang;
import com.example.Scott.responsitory.DiaChiKhachHangResponsitory;
import com.example.Scott.responsitory.KhachHangResponsitory;
import jakarta.servlet.*;
import jakarta.servlet.http.*;
import jakarta.servlet.annotation.*;

import java.io.IOException;

@WebServlet(name = "KhachHangServlet", value = {
        "/khachhang/hien-thi",
        "/khachhang/add",
        "/khachhang/delete",
        "/khachhang/update",
        "/khachhang/view-update",
        "/khachhang/search"

})
public class KhachHangServlet extends HttpServlet {

    private KhachHangResponsitory khachHangResponsitory = new KhachHangResponsitory();
    private DiaChiKhachHangResponsitory diaChiKhachHangResponsitory = new DiaChiKhachHangResponsitory();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String uri = request.getRequestURI();
        if (uri.contains("hien-thi")) {
            this.hienThiKhachHang(request, response);
        } else if(uri.contains("delete")){
            this.deleteKhachHang(request, response);
        } else if(uri.contains("view-update")){
            this.viewUpdateKhachHang(request,response);
        } else{
            this.searchKhachHang(request,response);
        }
    }

    private void searchKhachHang(HttpServletRequest request,
                                 HttpServletResponse response)
            throws ServletException, IOException {

        String keyword = request.getParameter("keyword");

        request.setAttribute(
                "listKhachHang",
                khachHangResponsitory.search(keyword));

        request.getRequestDispatcher("/views/khachhangn3/khachhangs.jsp")
                .forward(request,response);

    }

    private void viewUpdateKhachHang(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        request.setAttribute("menu", "khachhang");
        Integer id = Integer.valueOf(request.getParameter("id"));
        KhachHang KH = khachHangResponsitory.getOne(id);
        request.setAttribute("khachHangS",KH);
        request.getRequestDispatcher("/views/khachhangn3/updateKH.jsp").forward(request,response);
    }

    private void deleteKhachHang(HttpServletRequest request, HttpServletResponse response) throws IOException {
        Integer id = Integer.valueOf(request.getParameter("id"));
        KhachHang KH = khachHangResponsitory.getOne(id);
        khachHangResponsitory.DeleteKhachHang(KH);
        response.sendRedirect("/khachhang/hien-thi");
    }

    private void hienThiKhachHang(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        request.setAttribute("menu", "khachhang");
        request.setAttribute("listKhachHang", khachHangResponsitory.getAll());
        request.setAttribute("lstDiaChiKH", diaChiKhachHangResponsitory.getAll());
        request.getRequestDispatcher("/views/khachhangn3/khachhangs.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
String uri = request.getRequestURI();
if (uri.contains("add")){
    this.addKhachHang(request,response);
}else {
    this.updateKhachHang(request,response);
}
    }

    private void updateKhachHang(HttpServletRequest request, HttpServletResponse response) throws IOException {
        Integer id = Integer.valueOf(request.getParameter("id"));
        String ma = request.getParameter("ma");
        String hoTen = request.getParameter("hoTen");
        String sdt = request.getParameter("sdt");
        String diaChi = request.getParameter("diaChi");
        KhachHang KH = new KhachHang(id,ma,hoTen,sdt,diaChi);
        khachHangResponsitory.UpdateKhachHang(KH);
        response.sendRedirect("/khachhang/hien-thi");
    }

    private void addKhachHang(HttpServletRequest request, HttpServletResponse response) throws IOException {
        String ma = request.getParameter("ma");
        String hoTen = request.getParameter("hoTen");
        String sdt = request.getParameter("sdt");
        String diaChi = request.getParameter("diaChi");
        KhachHang KH = new KhachHang(null,ma,hoTen,sdt,diaChi);
        khachHangResponsitory.addKhachHang(KH);
        response.sendRedirect("/khachhang/hien-thi");

    }
}
