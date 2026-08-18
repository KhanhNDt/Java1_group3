package com.example.Scott.controller;

import com.example.Scott.data.PhuongXa;
import com.example.Scott.entity.KhachHang;
import com.example.Scott.entity.DiaChiKhachHang;
import com.example.Scott.entity.DiaChiApiMapping;
import com.example.Scott.responsitory.DiaChiApiMappingRepository;
import com.example.Scott.responsitory.DiaChiKhachHangResponsitory;
import com.example.Scott.responsitory.KhachHangResponsitory;
import com.example.Scott.data.DiaChiData;
import com.fasterxml.jackson.core.type.TypeReference;
import com.fasterxml.jackson.databind.ObjectMapper;
import java.io.PrintWriter;

import jakarta.servlet.*;
import jakarta.servlet.http.*;
import jakarta.servlet.annotation.*;

import java.io.IOException;
import java.util.List;
import java.util.Map;

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

    // Số khách hàng hiển thị trên mỗi trang (cố định theo yêu cầu)
    private static final int PAGE_SIZE = 5;

    private final KhachHangResponsitory khachHangResponsitory = new KhachHangResponsitory();
    private final DiaChiKhachHangResponsitory diaChiKhachHangResponsitory = new DiaChiKhachHangResponsitory();
    private final DiaChiApiMappingRepository diaChiApiMappingRepository = new DiaChiApiMappingRepository();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        System.out.println("==== KhachHangServlet ====");
        String uri = request.getRequestURI();

        if (uri.contains("hien-thi") || uri.contains("search")) {
            this.hienThiKhachHang(request, response);
        }  else if (uri.contains("view-update")) {
            this.viewUpdateKhachHang(request, response);
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
        // Mã khách hàng luôn do hệ thống tự sinh (KH0001, KH0002...), chỉ hiển thị gợi ý ở đây,
        // giá trị THẬT SỰ được sinh lại ở addKhachHang() để tránh trùng nếu có khách khác vừa thêm.
        request.setAttribute("goiYMaKhachHang", khachHangResponsitory.generateNextMa());
        request.getRequestDispatcher("/views/khachhangn3/viewAddKH.jsp").forward(request, response);
    }

    private void detailKhachHang(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        Integer id = parseInteger(request.getParameter("id"));
        KhachHang kh = khachHangResponsitory.getOne(id);

        // Lấy TOÀN BỘ địa chỉ của khách hàng (hỗ trợ nhiều địa chỉ)
        List<DiaChiKhachHang> diaChiKHList = diaChiKhachHangResponsitory.getListByIdKhachHang(id);

        request.setAttribute("khachHangS", kh);
        request.setAttribute("diaChiKHList", diaChiKHList);
        request.getRequestDispatcher("/views/khachhangn3/detailKhachHang.jsp").forward(request, response);
    }

    /**
     * Danh sách khách hàng: tìm kiếm + lọc theo giới tính/trạng thái + phân trang (5 khách/trang).
     * Dùng chung cho cả "/khachhang/hien-thi" và "/khachhang/search".
     */
    private void hienThiKhachHang(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        request.setAttribute("menu", "khachhang");

        String keyword = normalize(request.getParameter("keyword"));
        String gioiTinh = normalize(request.getParameter("gioiTinh"));
        Integer trangThai = parseInteger(request.getParameter("trangThai"));

        Integer pageParam = parseInteger(request.getParameter("page"));
        int page = pageParam == null ? 1 : pageParam;
        if (page < 1) page = 1;

        long totalRecords = khachHangResponsitory.countFilter(keyword, gioiTinh, trangThai);
        int totalPages = (int) Math.ceil((double) totalRecords / PAGE_SIZE);
        if (totalPages < 1) totalPages = 1;
        if (page > totalPages) page = totalPages;

        int offset = (page - 1) * PAGE_SIZE;

        List<KhachHang> list = khachHangResponsitory.filter(keyword, gioiTinh, trangThai, offset, PAGE_SIZE);

        request.setAttribute("listKhachHang", list);
        request.setAttribute("totalRecords", totalRecords);
        request.setAttribute("totalPages", totalPages);
        request.setAttribute("currentPage", page);
        request.setAttribute("size", PAGE_SIZE);
        request.setAttribute("keyword", request.getParameter("keyword"));
        request.setAttribute("gioiTinh", request.getParameter("gioiTinh"));
        request.setAttribute("trangThai", request.getParameter("trangThai"));

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

        String hoTen = request.getParameter("hoTen");
        String sdt = request.getParameter("sdt");
        String email = request.getParameter("email");
        String diaChi = request.getParameter("diaChi");
        String gioiTinh = normalizeGioiTinh(request.getParameter("gioiTinh"));
        KhachHang hienTai = khachHangResponsitory.getOne(id);
        Integer trangThai = hienTai != null && hienTai.getTrangThai() != null
                ? hienTai.getTrangThai() : 1;
        // Mã khách hàng KHÔNG được sửa: luôn giữ nguyên mã đã có trong DB, bỏ qua
        // bất kỳ giá trị "ma" nào gửi lên từ form (kể cả khi bị chỉnh sửa qua devtools).
        String ma = hienTai != null ? hienTai.getMa() : null;

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

        // Mã khách hàng LUÔN do hệ thống tự sinh (không nhận từ form), để tránh trùng mã
        // hoặc bị chỉnh sửa/bịa mã tùy ý.
        String ma = khachHangResponsitory.generateNextMa();
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

        // Hibernate IDENTITY sinh ID ngay khi persist() -> lấy trực tiếp từ đối tượng vừa thêm,
        // KHÔNG tra lại theo "ma" (vì "ma" có thể để trống hoặc trùng, dẫn tới sai/mất khách hàng).
        Integer idKhachHangMoi = kh.getId();

        // Dự phòng: nếu vì lý do nào đó ID chưa được gán, mới thử tra lại theo mã (chỉ khi mã có giá trị)
        if (idKhachHangMoi == null && ma != null && !ma.trim().isEmpty()) {
            KhachHang khachVuaThem = khachHangResponsitory.findByMa(ma);
            if (khachVuaThem != null) {
                idKhachHangMoi = khachVuaThem.getId();
            }
        }

        // ==========================
        // Thêm địa chỉ (hỗ trợ NHIỀU địa chỉ, gửi lên dạng JSON)
        // ==========================

        if (idKhachHangMoi != null) {
            themDanhSachDiaChi(idKhachHangMoi, request.getParameter("diaChiListJson"));
        }

        response.sendRedirect(request.getContextPath() + "/khachhang/hien-thi");
    }

    /**
     * Nhận JSON dạng mảng địa chỉ (từ form thêm khách hàng, hỗ trợ nhiều địa chỉ) và
     * lưu từng địa chỉ + mapping tỉnh/phường tương ứng.
     * Mỗi phần tử JSON có dạng:
     * { "provinceCode": 1, "wardCode": 12, "tinhThanh": "...", "phuongXa": "...", "diaChiCuThe": "...", "isMacDinh": true }
     */
    private void themDanhSachDiaChi(Integer idKhachHang, String diaChiListJson) {
        if (diaChiListJson == null || diaChiListJson.trim().isEmpty()) {
            return;
        }
        try {
            ObjectMapper mapper = new ObjectMapper();
            List<Map<String, Object>> danhSach = mapper.readValue(
                    diaChiListJson, new TypeReference<List<Map<String, Object>>>() {});

            for (Map<String, Object> item : danhSach) {
                Integer provinceCode = toInteger(item.get("provinceCode"));
                Integer wardCode = toInteger(item.get("wardCode"));
                String diaChiCuThe = item.get("diaChiCuThe") == null ? "" : item.get("diaChiCuThe").toString();
                Boolean isMacDinh = Boolean.TRUE.equals(item.get("isMacDinh"));

                String tinhThanh = provinceCode != null ? DiaChiData.getTenTinh(provinceCode) : "";
                String phuongXa = wardCode != null ? DiaChiData.getTenPhuong(wardCode) : "";

                DiaChiKhachHang dc = new DiaChiKhachHang(
                        null,
                        idKhachHang,
                        tinhThanh,
                        "",
                        phuongXa,
                        diaChiCuThe,
                        "Nhà riêng",
                        isMacDinh
                );

                DiaChiKhachHang daLuu = diaChiKhachHangResponsitory.AddDiaChiKH(dc);

                if (daLuu != null && provinceCode != null && wardCode != null) {
                    DiaChiApiMapping mapping = new DiaChiApiMapping();
                    mapping.setIdDiaChiKhachHang(daLuu.getId());
                    mapping.setProvinceCode(provinceCode);
                    // Dự án hiện không dùng cấp huyện; DB khai báo NOT NULL nên lưu 0.
                    mapping.setDistrictCode(0);
                    mapping.setWardCode(wardCode);
                    diaChiApiMappingRepository.add(mapping);
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    private Integer toInteger(Object value) {
        if (value == null) return null;
        if (value instanceof Number) return ((Number) value).intValue();
        try {
            return Integer.valueOf(value.toString().trim());
        } catch (NumberFormatException e) {
            return null;
        }
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