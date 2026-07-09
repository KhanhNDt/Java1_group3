package com.example.Scott.controller;

import com.example.Scott.responsitory.DiaChiKhachHangResponsitory;
import com.example.Scott.responsitory.KhachHangResponsitory;
import jakarta.servlet.*;
import jakarta.servlet.http.*;
import jakarta.servlet.annotation.*;

import java.io.IOException;

@WebServlet(name = "KhachHangServlet", value ={
        "/khachhang/hien-thi",
        "/khachhang/add",
        "/khachhang/delete",
        "/khachhang/update",
})
public class KhachHangServlet extends HttpServlet {

    private KhachHangResponsitory khachHangResponsitory =  new KhachHangResponsitory();
    private DiaChiKhachHangResponsitory diaChiKhachHangResponsitory = new DiaChiKhachHangResponsitory();
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
String uri = request.getRequestURI();
if(uri.contains("hien-thi")){
    this.hienThiKhachHang(request,response);
}else{
    this.deleteKhachHang(request,response);
}
    }

    private void deleteKhachHang(HttpServletRequest request, HttpServletResponse response) {

    }

    private void hienThiKhachHang(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        request.setAttribute("listKhachHang",khachHangResponsitory.getAll());
        request.setAttribute("lstDiaChiKH",diaChiKhachHangResponsitory.getAll());
        request.getRequestDispatcher("/khachhangn3/khachhangs.jsp").forward(request,response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {

    }
}
