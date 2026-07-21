package com.example.Scott.controller;

import com.example.Scott.entity.PhieuGiamGia;
import com.example.Scott.responsitory.PhieuGiamGiaResponsitory;
import jakarta.servlet.*;
import jakarta.servlet.http.*;
import jakarta.servlet.annotation.*;

import java.io.IOException;
import java.math.BigDecimal;

@WebServlet(name = "PhieuGiamGiaServlet", value ={
        "/phieugiamgia/hien-thi",
        "/phieugiamgia/add",
        "/phieugiamgia/delete",
        "/phieugiamgia/update",
        "/phieugiamgia/view-update",
        "/phieugiamgia/search"
})

public class PhieuGiamGiaServlet extends HttpServlet {
    private PhieuGiamGiaResponsitory phieuGiamGiaResponsitory= new PhieuGiamGiaResponsitory();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String uri = request.getRequestURI();
        if (uri.contains("hien-thi")) {
            this.hienThiPhieuGiamGia(request, response);
        } else if(uri.contains("delete")){
            this.deletePhieuGiamGia(request, response);
        } else if(uri.contains("view-update")){
            this.viewUpdatePhieuGiamGia(request,response);
        } else{
            this.searchPhieuGiamGia(request,response);
        }
    }

    private void searchPhieuGiamGia(HttpServletRequest request, HttpServletResponse response) {
    }

    private void deletePhieuGiamGia(HttpServletRequest request, HttpServletResponse response) throws IOException {
        Integer id = Integer.valueOf(request.getParameter("id"));
        try {
            PhieuGiamGia PGG = phieuGiamGiaResponsitory.getOne(id);
            phieuGiamGiaResponsitory.DeletePhieuGiamGia(PGG);
            request.getSession().setAttribute("success", "Xóa phiếu giảm giá thành công.");
        } catch (Exception e) {
            request.getSession().setAttribute("error", "Xóa phiếu giảm giá thất bại: " + e.getMessage());
        }
        response.sendRedirect(request.getContextPath() + "/phieugiamgia/hien-thi");
    }

    private void viewUpdatePhieuGiamGia(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        request.setAttribute("menu", "phieugiamgia");
        Integer id = Integer.valueOf(request.getParameter("id"));
       PhieuGiamGia PGG = phieuGiamGiaResponsitory.getOne(id);
        request.setAttribute("phieugiamgiaS",PGG);
        request.getRequestDispatcher("/views/phieugiamgian3/updatePGG.jsp").forward(request,response);
    }

    private void hienThiPhieuGiamGia(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        request.setAttribute("menu", "phieugiamgia");
        request.setAttribute("listPhieuGiamGia", phieuGiamGiaResponsitory.getAll());
        moveFlash(request);
        request.getRequestDispatcher("/views/phieugiamgian3/phieugiamgias.jsp").forward(request,response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String uri = request.getRequestURI();
        if (uri.contains("add")){
            this.addPhieuGiamGia(request,response);
        }else {
            this.updatePhieuGiamGia(request,response);
        }
    }

    private void updatePhieuGiamGia(HttpServletRequest request, HttpServletResponse response) throws IOException {
        Integer id = Integer.valueOf(request.getParameter("id"));
        String maVoucher = request.getParameter("maVoucher");
        String tenVoucher = request.getParameter("tenVoucher");
        BigDecimal giaTriGiamGia = new BigDecimal(request.getParameter("giaTriGiamGia"));
        BigDecimal giamToiDa = new BigDecimal(request.getParameter("giamToiDa"));
        BigDecimal donToiThieu = new BigDecimal(request.getParameter("donToiThieu"));
        java.sql.Date ngayBatDau = java.sql.Date.valueOf(request.getParameter("ngayBatDau"));
        java.sql.Date ngayKetThuc = java.sql.Date.valueOf(request.getParameter("ngayKetThuc"));
        PhieuGiamGia PGG = new PhieuGiamGia(id,maVoucher,tenVoucher,giaTriGiamGia,giamToiDa,donToiThieu,ngayBatDau,ngayKetThuc);
        try {
            phieuGiamGiaResponsitory.updatePhieuGiamGia(PGG);
            request.getSession().setAttribute("success", "Cập nhật phiếu giảm giá thành công.");
        } catch (Exception e) {
            request.getSession().setAttribute("error", "Cập nhật phiếu giảm giá thất bại: " + e.getMessage());
        }
        response.sendRedirect(request.getContextPath() + "/phieugiamgia/hien-thi");
    }

    private void addPhieuGiamGia(HttpServletRequest request, HttpServletResponse response) throws IOException {

        String maVoucher = request.getParameter("maVoucher");
        String tenVoucher = request.getParameter("tenVoucher");
        BigDecimal giaTriGiamGia = new BigDecimal(request.getParameter("giaTriGiamGia"));
        BigDecimal giamToiDa = new BigDecimal(request.getParameter("giamToiDa"));
        BigDecimal donToiThieu = new BigDecimal(request.getParameter("donToiThieu"));
        java.sql.Date ngayBatDau = java.sql.Date.valueOf(request.getParameter("ngayBatDau"));
        java.sql.Date ngayKetThuc = java.sql.Date.valueOf(request.getParameter("ngayKetThuc"));
        PhieuGiamGia PGG = new PhieuGiamGia(null,maVoucher,tenVoucher,giaTriGiamGia,giamToiDa,donToiThieu,ngayBatDau,ngayKetThuc);
        try {
            phieuGiamGiaResponsitory.addPhieuGiamGia(PGG);
            request.getSession().setAttribute("success", "Thêm phiếu giảm giá thành công.");
        } catch (Exception e) {
            request.getSession().setAttribute("error", "Thêm phiếu giảm giá thất bại: " + e.getMessage());
        }
        response.sendRedirect(request.getContextPath() + "/phieugiamgia/hien-thi");
    }

    private void moveFlash(HttpServletRequest request) {
        Object success = request.getSession().getAttribute("success");
        Object error = request.getSession().getAttribute("error");
        if (success != null) { request.setAttribute("success", success); request.getSession().removeAttribute("success"); }
        if (error != null) { request.setAttribute("error", error); request.getSession().removeAttribute("error"); }
    }
}
