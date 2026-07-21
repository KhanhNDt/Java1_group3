package com.example.Scott.controller;

import com.example.Scott.data.PhuongXa;
import com.example.Scott.entity.KhachHang;
import com.example.Scott.entity.DiaChiKhachHang;
import com.example.Scott.entity.DiaChiApiMapping;
import com.example.Scott.responsitory.DiaChiApiMappingRepository;
import com.example.Scott.responsitory.DiaChiKhachHangResponsitory;
import com.example.Scott.responsitory.KhachHangResponsitory;
import com.example.Scott.data.DiaChiData;
import java.io.PrintWriter;

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
        "/khachhang/view-add",
        "/khachhang/api-phuong-xa",
        "/khachhang/doi-trang-thai"
})
public class KhachHangServlet extends HttpServlet {

    private final KhachHangResponsitory khachHangResponsitory = new KhachHangResponsitory();
    private final DiaChiKhachHangResponsitory diaChiKhachHangResponsitory = new DiaChiKhachHangResponsitory();
    private final DiaChiApiMappingRepository diaChiApiMappingRepository = new DiaChiApiMappingRepository();

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
        }else if (uri.contains("doi-trang-thai")){
            this.doiTrangThai(request,response);
        }  else {
            this.viewAdd(request, response);
        }
    }

    private void doiTrangThai(HttpServletRequest request,
                              HttpServletResponse response)
            throws IOException {

        Integer id = parseInteger(request.getParameter("id"));

        if (id == null) {
            response.sendRedirect(request.getContextPath() + "/khachhang/hien-thi?error=id");
            return;
        }
        KhachHang kh = khachHangResponsitory.getOne(id);

        if (kh != null) {

            if (kh.getTrangThai() == 1) {
                kh.setTrangThai(0);
            } else {
                kh.setTrangThai(1);
            }

            khachHangResponsitory.UpdateKhachHang(kh);
        }

        response.sendRedirect(request.getContextPath() + "/khachhang/hien-thi");
    }

    private void viewAdd(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        request.setAttribute("listTinh", DiaChiData.getAllTinh());
        request.setAttribute("listPhuong", DiaChiData.getAllPhuong());
        request.getRequestDispatcher("/views/khachhangn3/viewAddKH.jsp").forward(request, response);
    }

    private void detailKhachHang(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        Integer id = parseInteger(request.getParameter("id"));
        KhachHang kh = khachHangResponsitory.getOne(id);

        DiaChiKhachHang diaChiKH = diaChiKhachHangResponsitory.getByIdKhachHang(id);

        request.setAttribute("khachHangS", kh);
        request.setAttribute("listKhachHang", khachHangResponsitory.getAll());
        request.setAttribute("diaChiKH", diaChiKH);
        request.getRequestDispatcher("/views/khachhangn3/detailKhachHang.jsp").forward(request, response);
    }

    private void searchKhachHang(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        request.setAttribute("menu", "khachhang");
        String keyword = normalize(request.getParameter("keyword"));
        String gioiTinh = normalize(request.getParameter("gioiTinh"));
        Integer trangThai = parseInteger(request.getParameter("trangThai"));
        request.setAttribute("listKhachHang", khachHangResponsitory.filter(keyword, gioiTinh, trangThai));
        request.setAttribute("lstDiaChiKH", diaChiKhachHangResponsitory.getAll());
        request.getRequestDispatcher("/views/khachhangn3/khachhangs.jsp").forward(request, response);
    }

    private void viewUpdateKhachHang(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        request.setAttribute("menu", "khachhang");
        Integer idKhachHang = parseInteger(request.getParameter("id"));
        // Lấy khách hàng
        KhachHang kh = khachHangResponsitory.getOne(idKhachHang);
        // Lấy địa chỉ của khách hàng
        DiaChiKhachHang diaChiKH = diaChiKhachHangResponsitory.getByIdKhachHang(idKhachHang);
        request.setAttribute("khachHangS", kh);
        request.setAttribute("diaChiKH", diaChiKH);
        request.setAttribute("listTinh", DiaChiData.getAllTinh());
        request.setAttribute("listPhuong", DiaChiData.getAllPhuong());
        request.getRequestDispatcher("/views/khachhangn3/updateKH.jsp").forward(request, response);
    }

    private void deleteKhachHang(HttpServletRequest request, HttpServletResponse response) throws IOException {
        Integer id = parseInteger(request.getParameter("id"));

        KhachHang kh = khachHangResponsitory.getOne(id);

        if (kh != null) {
            // Xóa địa chỉ trước
            diaChiKhachHangResponsitory.deleteByKhachHang(id);

            // Sau đó xóa khách hàng
            khachHangResponsitory.DeleteKhachHang(kh);
        }

        response.sendRedirect(request.getContextPath() + "/khachhang/hien-thi");
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

    private void updateKhachHang(HttpServletRequest request,
                                 HttpServletResponse response) throws IOException {

        Integer id = parseInteger(request.getParameter("id"));

        String ma = request.getParameter("ma");
        String hoTen = request.getParameter("hoTen");
        String sdt = request.getParameter("sdt");
        String email = request.getParameter("email");
        String diaChi = request.getParameter("diaChi");
        String gioiTinh = normalizeGioiTinh(request.getParameter("gioiTinh"));
        KhachHang hienTai = khachHangResponsitory.getOne(id);
        Integer trangThai = hienTai != null && hienTai.getTrangThai() != null
                ? hienTai.getTrangThai() : 1;

        // ==========================
        // Update khách hàng
        // ==========================

        KhachHang kh = new KhachHang(
                id,
                ma,
                hoTen,
                sdt,
                email,
                diaChi,
                gioiTinh,
                trangThai
        );

        khachHangResponsitory.UpdateKhachHang(kh);

        // ==========================
        // Lấy dữ liệu địa chỉ
        // ==========================

        String provinceStr = request.getParameter("provinceCode");
        String wardStr = request.getParameter("wardCode");

        Integer provinceCode = null;
        Integer wardCode = null;

        if (provinceStr != null && !provinceStr.trim().isEmpty()) {
            provinceCode = Integer.valueOf(provinceStr);
        }

        if (wardStr != null && !wardStr.trim().isEmpty()) {
            wardCode = Integer.valueOf(wardStr);
        }

        String diaChiCuThe = request.getParameter("mChiTiet");

        Boolean isMacDinh =
                "true".equals(request.getParameter("mMacDinh"));

        String tinhThanh = "";

        if (provinceCode != null) {
            tinhThanh = DiaChiData.getTenTinh(provinceCode);
        }

        String phuongXa = "";

        if (wardCode != null) {
            phuongXa = DiaChiData.getTenPhuong(wardCode);
        }

        // ==========================
        // Update địa chỉ
        // ==========================

        DiaChiKhachHang dc =
                diaChiKhachHangResponsitory.getByIdKhachHang(id);

        if (dc != null) {

            dc.setTinhThanh(tinhThanh);
            dc.setQuanHuyen("");
            dc.setPhuongXa(phuongXa);
            dc.setDiaChiCuThe(diaChiCuThe);
            dc.setLoaiDiaChi("Nhà riêng");
            dc.setIsMacDinh(isMacDinh);

            diaChiKhachHangResponsitory.UpdateDiaChiKH(dc);

            if (provinceCode != null && wardCode != null) {
                DiaChiApiMapping mapping = diaChiApiMappingRepository.findByDiaChiId(dc.getId());
                if (mapping == null) {
                    mapping = new DiaChiApiMapping(null, dc.getId(), provinceCode, 0, wardCode);
                    diaChiApiMappingRepository.add(mapping);
                } else {
                    mapping.setProvinceCode(provinceCode);
                    mapping.setDistrictCode(0);
                    mapping.setWardCode(wardCode);
                    diaChiApiMappingRepository.update(mapping);
                }
            }
        }

        response.sendRedirect(request.getContextPath() + "/khachhang/hien-thi");
    }

    private void addKhachHang(HttpServletRequest request,
                              HttpServletResponse response) throws IOException {

        String ma = request.getParameter("ma");
        String hoTen = request.getParameter("hoTen");
        String sdt = request.getParameter("sdt");
        String email = request.getParameter("email");
        String diaChiGoc = request.getParameter("diaChi");
        String gioiTinh = normalizeGioiTinh(request.getParameter("gioiTinh"));
        Integer trangThai = 1;

        // ==========================
        // Thêm khách hàng
        // ==========================

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


        KhachHang khachVuaThem =
                khachHangResponsitory.findByMa(ma);

        Integer idKhachHangMoi = null;

        if (khachVuaThem != null) {
            idKhachHangMoi = khachVuaThem.getId();
        }

        // ==========================
        // Lấy dữ liệu địa chỉ
        // ==========================

        String provinceStr =
                request.getParameter("provinceCode");

        String wardStr =
                request.getParameter("wardCode");

        Integer provinceCode = null;
        Integer wardCode = null;

        if (provinceStr != null && !provinceStr.trim().isEmpty()) {
            provinceCode = Integer.valueOf(provinceStr);
        }

        if (wardStr != null && !wardStr.trim().isEmpty()) {
            wardCode = Integer.valueOf(wardStr);
        }

        String diaChiCuThe =
                request.getParameter("mChiTiet");

        // ==========================
        // Lấy tên tỉnh
        // ==========================

        String tinhThanh = "";

        if (provinceCode != null) {
            tinhThanh = DiaChiData.getTenTinh(provinceCode);
        }

        // ==========================
        // Lấy tên phường
        // ==========================

        String phuongXa = "";

        if (wardCode != null) {
            phuongXa = DiaChiData.getTenPhuong(wardCode);
        }

        // Không dùng huyện
        String quanHuyen = "";

        Boolean isMacDinh =
                "true".equals(request.getParameter("mMacDinh"));

        // ==========================
        // Thêm địa chỉ
        // ==========================

        DiaChiKhachHang diaChiMoi = null;

        if (idKhachHangMoi != null
                && provinceCode != null
                && wardCode != null) {

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

            diaChiMoi =
                    diaChiKhachHangResponsitory.AddDiaChiKH(dc);
        }

        // ==========================
        // Lưu mapping
        // ==========================

        if (diaChiMoi != null) {

            DiaChiApiMapping mapping =
                    new DiaChiApiMapping();

            mapping.setIdDiaChiKhachHang(
                    diaChiMoi.getId()
            );

            mapping.setProvinceCode(provinceCode);

            // Dự án hiện không dùng cấp huyện; DB khai báo NOT NULL nên lưu 0.
            mapping.setDistrictCode(0);

            mapping.setWardCode(wardCode);

            diaChiApiMappingRepository.add(mapping);
        }

        response.sendRedirect(request.getContextPath() + "/khachhang/hien-thi");
    }

    private String normalizeGioiTinh(String value) {
        if (value == null) return null;
        String normalized = value.trim();
        if (normalized.equalsIgnoreCase("nam") || normalized.equals("1")
                || normalized.equalsIgnoreCase("true")) {
            return "Nam";
        }
        if (normalized.equalsIgnoreCase("nu") || normalized.equalsIgnoreCase("nữ")
                || normalized.equals("0") || normalized.equalsIgnoreCase("false")) {
            return "Nữ";
        }
        return null;
    }

    private String normalize(String value) {
        return value == null ? "" : value.trim();
    }

    private Integer parseInteger(String value) {
        try {
            return value == null || value.trim().isEmpty() ? null : Integer.valueOf(value.trim());
        } catch (NumberFormatException e) {
            return null;
        }
    }
}