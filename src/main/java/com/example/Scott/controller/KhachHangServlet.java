package com.example.Scott.controller;

import com.example.Scott.entity.KhachHang;
import com.example.Scott.entity.DiaChiKhachHang;
import com.example.Scott.entity.DiaChiApiMapping;
import com.example.Scott.responsitory.DiaChiApiMappingRepository;
import com.example.Scott.responsitory.DiaChiKhachHangResponsitory;
import com.example.Scott.responsitory.KhachHangResponsitory;
import jakarta.servlet.*;
import jakarta.servlet.http.*;
import jakarta.servlet.annotation.*;

import java.io.IOException;
import java.util.List;

@WebServlet(name = "KhachHangServlet", value = {
        "/khachhang/hien-thi",
        "/khachhang/add",
        "/khachhang/delete",
        "/khachhang/update",
        "/khachhang/view-update",
        "/khachhang/search",
        "/khachhang/detail",
        "/khachhang/view-add"
})
public class KhachHangServlet extends HttpServlet {

    private final KhachHangResponsitory khachHangResponsitory = new KhachHangResponsitory();
    private final DiaChiKhachHangResponsitory diaChiKhachHangResponsitory = new DiaChiKhachHangResponsitory();
 private  final DiaChiApiMappingRepository diaChiApiMappingRepository = new DiaChiApiMappingRepository();
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        System.out.println("==== KhachHangServlet ====");
        String uri = request.getRequestURI();

        if (uri.contains("hien-thi")) {
            this.hienThiKhachHang(request, response);
        } else if (uri.contains("delete")) {
            this.deleteKhachHang(request, response);
        } else if (uri.contains("view-update")) {
            this.viewUpdateKhachHang(request, response);
        } else if (uri.contains("search")) {
            this.searchKhachHang(request, response);
        } else if (uri.contains("detail")) {
            this.detailKhachHang(request, response);
        } else {
            this.viewAdd(request, response);
        }
    }

    private void viewAdd(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        request.getRequestDispatcher("/views/khachhangn3/viewAddKH.jsp").forward(request, response);
    }

    private void detailKhachHang(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        Integer id = Integer.valueOf(request.getParameter("id"));
        KhachHang kh = khachHangResponsitory.getOne(id);

        request.setAttribute("khachHangS", kh);
        request.setAttribute("listKhachHang", khachHangResponsitory.getAll());

        request.getRequestDispatcher("/views/khachhangn3/detailKhachHang.jsp").forward(request, response);
    }

    private void searchKhachHang(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String keyword = request.getParameter("keyword");
        request.setAttribute("listKhachHang", khachHangResponsitory.search(keyword));
        request.getRequestDispatcher("/views/khachhangn3/khachhangs.jsp").forward(request, response);
    }

    private void viewUpdateKhachHang(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        request.setAttribute("menu", "khachhang");
        Integer id = Integer.valueOf(request.getParameter("id"));
        KhachHang kh = khachHangResponsitory.getOne(id);
        request.setAttribute("khachHangS", kh);
        request.getRequestDispatcher("/views/khachhangn3/updateKH.jsp").forward(request, response);
    }

    private void deleteKhachHang(HttpServletRequest request, HttpServletResponse response) throws IOException {
        Integer id = Integer.valueOf(request.getParameter("id"));
        KhachHang kh = khachHangResponsitory.getOne(id);
        if (kh != null) {
            khachHangResponsitory.DeleteKhachHang(kh);// Đồng bộ tên hàm viết thường chữ cái đầu
        }
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
        if (uri.contains("add")) {
            this.addKhachHang(request, response);
        } else {
            this.updateKhachHang(request, response);
        }
    }

    private void updateKhachHang(HttpServletRequest request, HttpServletResponse response) throws IOException {
        Integer id = Integer.valueOf(request.getParameter("id"));
        String ma = request.getParameter("ma");
        String hoTen = request.getParameter("hoTen");
        String sdt = request.getParameter("sdt");
        String email = request.getParameter("email");
        String diaChi = request.getParameter("diaChi");
        String gioiTinh = request.getParameter("gioiTinh");
        Integer trangThai = Integer.valueOf(request.getParameter("trangThai"));

        KhachHang kh = new KhachHang(id, ma, hoTen, sdt, email, diaChi, gioiTinh, trangThai);
        khachHangResponsitory.UpdateKhachHang(kh); // Đồng bộ tên hàm
        response.sendRedirect("/khachhang/hien-thi");
    }

    private void addKhachHang(HttpServletRequest request, HttpServletResponse response) throws IOException {

        String ma = request.getParameter("ma");
        String hoTen = request.getParameter("hoTen");
        String sdt = request.getParameter("sdt");
        String email = request.getParameter("email");
        String diaChiGoc = request.getParameter("diaChi");
        String gioiTinh = request.getParameter("gioiTinh");
        Integer trangThai = Integer.valueOf(request.getParameter("trangThai"));

        // Thêm khách hàng
        KhachHang kh = new KhachHang(
                null,
                ma,
                hoTen,
                sdt,
                email,
                diaChiGoc,
                gioiTinh,
                trangThai
        );

        khachHangResponsitory.addKhachHang(kh);

        // Lấy lại khách hàng vừa thêm
        KhachHang khachVuaThem = khachHangResponsitory.findByMa(ma);
        Integer idKhachHangMoi = (khachVuaThem != null)
                ? khachVuaThem.getId()
                : null;

        // Lấy dữ liệu địa chỉ
        String tinhThanh = request.getParameter("mTinhText");
        String quanHuyen = request.getParameter("mHuyenText");
        String phuongXa = request.getParameter("mXaText");
        String diaChiCuThe = request.getParameter("mChiTiet");

        Integer provinceCode = Integer.valueOf(request.getParameter("provinceCode"));
        Integer districtCode = Integer.valueOf(request.getParameter("districtCode"));
        Integer wardCode = Integer.valueOf(request.getParameter("wardCode"));

        String paramMacDinh = request.getParameter("mMacDinh");
        Boolean isMacDinh = paramMacDinh != null && paramMacDinh.equals("true");

        DiaChiKhachHang diaChiMoi = null;

        if (idKhachHangMoi != null) {

            DiaChiKhachHang dc = new DiaChiKhachHang(
                    null,
                    idKhachHangMoi,
                    tinhThanh,
                    quanHuyen,
                    phuongXa,
                    diaChiCuThe,
                    "Nhà riêng",
                    isMacDinh
            );

            diaChiMoi = diaChiKhachHangResponsitory.AddDiaChiKH(dc);
        }

        if (diaChiMoi != null) {

            DiaChiApiMapping mapping = new DiaChiApiMapping();

            mapping.setIdDiaChiKhachHang(diaChiMoi.getId());
            mapping.setProvinceCode(provinceCode);
            mapping.setDistrictCode(districtCode);
            mapping.setWardCode(wardCode);

            diaChiApiMappingRepository.add(mapping);
        }

        response.sendRedirect("/khachhang/hien-thi");
    }
}