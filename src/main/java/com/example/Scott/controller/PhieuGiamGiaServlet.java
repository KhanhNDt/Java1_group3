package com.example.Scott.controller;

import com.example.Scott.entity.PhieuGiamGia;
import com.example.Scott.responsitory.PhieuGiamGiaResponsitory;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;

import org.apache.poi.ss.usermodel.*;
import org.apache.poi.xssf.usermodel.XSSFWorkbook;

import java.io.IOException;
import java.math.BigDecimal;
import java.text.SimpleDateFormat;
import java.util.List;

@WebServlet(name = "PhieuGiamGiaServlet", value = {
        "/phieugiamgia/hien-thi",
        "/phieugiamgia/view-add",
        "/phieugiamgia/add",
        "/phieugiamgia/update",
        "/phieugiamgia/delete",
        "/phieugiamgia/view-update",
        "/phieugiamgia/search",
        "/phieugiamgia/export-excel"
})
public class PhieuGiamGiaServlet extends HttpServlet {

    private final PhieuGiamGiaResponsitory repo = new PhieuGiamGiaResponsitory();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String uri = request.getRequestURI();

        if (uri.endsWith("/view-add")) {
            viewAdd(request, response);
        } else if (uri.endsWith("/view-update")) {
            viewUpdate(request, response);
        } else if (uri.endsWith("/delete")) {
            delete(request, response);
        } else if (uri.endsWith("/search")) {
            search(request, response);
        } else if (uri.endsWith("/export-excel")) {
            exportExcel(request, response);
        } else {
            hienThi(request, response);
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        request.setCharacterEncoding("UTF-8");
        String uri = request.getRequestURI();

        if (uri.endsWith("/add")) {
            addPhieuGiamGia(request, response);
        } else if (uri.endsWith("/update")) {
            updatePhieuGiamGia(request, response);
        }
    }

    // Auto update status by expiration date
    private void autoUpdateStatus(PhieuGiamGia pgg) {
        if (pgg != null && pgg.getNgayKetThuc() != null) {
            java.util.Date today = new java.util.Date();
            if (pgg.getNgayKetThuc().before(today)) {
                pgg.setTrangThai(0);
            } else {
                pgg.setTrangThai(1);
            }
        }
    }

    // Hiển thị danh sách
    private void hienThi(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        List<PhieuGiamGia> list = repo.getAll();
        for (PhieuGiamGia pgg : list) {
            autoUpdateStatus(pgg);
        }

        request.setAttribute("menu", "phieugiamgia");
        request.setAttribute("listPhieuGiamGia", list);

        moveFlash(request);

        request.getRequestDispatcher("/views/phieugiamgian3/phieugiamgias.jsp")
                .forward(request, response);
    }

    // Form thêm mới
    private void viewAdd(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        request.getRequestDispatcher("/views/phieugiamgian3/viewadd.jsp")
                .forward(request, response);
    }

    // Form cập nhật
    private void viewUpdate(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        try {
            Integer id = Integer.valueOf(request.getParameter("id"));
            PhieuGiamGia pgg = repo.getOne(id);
            autoUpdateStatus(pgg);

            request.setAttribute("phieugiamgiaS", pgg);
            request.getRequestDispatcher("/views/phieugiamgian3/updatePGG.jsp")
                    .forward(request, response);
        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect(request.getContextPath() + "/phieugiamgia/hien-thi");
        }
    }

    // Tìm kiếm
    private void search(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String keyword = request.getParameter("keyword");
        String loaiGiamGia = request.getParameter("loaiGiamGia");
        String trangThaiStr = request.getParameter("trangThai");
        String fromStr = request.getParameter("from");
        String toStr = request.getParameter("to");

        if (keyword == null) keyword = "";
        if (loaiGiamGia == null) loaiGiamGia = "";

        Integer trangThai = null;
        if (trangThaiStr != null && !trangThaiStr.trim().isEmpty()) {
            try {
                trangThai = Integer.valueOf(trangThaiStr.trim());
            } catch (NumberFormatException ignored) {}
        }

        java.sql.Date from = parseDate(fromStr);
        java.sql.Date to = parseDate(toStr);

        List<PhieuGiamGia> list = repo.searchFull(keyword, loaiGiamGia, trangThai, from, to);
        for (PhieuGiamGia pgg : list) {
            autoUpdateStatus(pgg);
        }

        request.setAttribute("menu", "phieugiamgia");
        request.setAttribute("listPhieuGiamGia", list);

        request.getRequestDispatcher("/views/phieugiamgian3/phieugiamgias.jsp")
                .forward(request, response);
    }

    // Thêm mới
    private void addPhieuGiamGia(HttpServletRequest request, HttpServletResponse response)
            throws IOException {

        try {
            String maVoucher = request.getParameter("maVoucher");
            String tenVoucher = request.getParameter("tenVoucher");
            String loaiGiamGia = request.getParameter("loaiGiamGia");

            BigDecimal giaTriGiamGia = parseBigDecimal(request.getParameter("giaTriGiamGia"));
            BigDecimal giamToiDa = null;
            if ("%".equals(loaiGiamGia)) {
                giamToiDa = parseBigDecimal(request.getParameter("giamToiDa"));
            }

            BigDecimal donToiThieu = parseBigDecimal(request.getParameter("donToiThieu"));
            Integer soLuong = parseInteger(request.getParameter("soLuong"));

            java.sql.Date ngayBatDau = parseDate(request.getParameter("ngayBatDau"));
            java.sql.Date ngayKetThuc = parseDate(request.getParameter("ngayKetThuc"));

            PhieuGiamGia pgg = new PhieuGiamGia();
            pgg.setMaVoucher(maVoucher);
            pgg.setTenVoucher(tenVoucher);
            pgg.setLoaiGiamGia(loaiGiamGia);
            pgg.setGiaTriGiamGia(giaTriGiamGia);
            pgg.setGiamToiDa(giamToiDa);
            pgg.setDonToiThieu(donToiThieu);
            pgg.setSoLuong(soLuong);
            pgg.setSoLuongDaDung(0);
            pgg.setNgayBatDau(ngayBatDau);
            pgg.setNgayKetThuc(ngayKetThuc);
            pgg.setNgayTao(new java.util.Date());

            java.util.Date today = new java.util.Date();
            if (ngayKetThuc != null && ngayKetThuc.before(today)) {
                pgg.setTrangThai(0);
            } else {
                pgg.setTrangThai(1);
            }

            repo.addPhieuGiamGia(pgg);
            request.getSession().setAttribute("success", "Thêm phiếu giảm giá thành công!");

        } catch (Exception e) {
            e.printStackTrace();
            request.getSession().setAttribute("error", "Thêm phiếu giảm giá thất bại!");
        }

        response.sendRedirect(request.getContextPath() + "/phieugiamgia/hien-thi");
    }

    // Cập nhật
    private void updatePhieuGiamGia(HttpServletRequest request, HttpServletResponse response)
            throws IOException {

        try {
            Integer id = Integer.valueOf(request.getParameter("id"));
            PhieuGiamGia pgg = repo.getOne(id);

            if (pgg != null) {
                String loaiGiamGia = request.getParameter("loaiGiamGia");

                pgg.setMaVoucher(request.getParameter("maVoucher"));
                pgg.setTenVoucher(request.getParameter("tenVoucher"));
                pgg.setLoaiGiamGia(loaiGiamGia);
                pgg.setGiaTriGiamGia(parseBigDecimal(request.getParameter("giaTriGiamGia")));

                if ("%".equals(loaiGiamGia)) {
                    pgg.setGiamToiDa(parseBigDecimal(request.getParameter("giamToiDa")));
                } else {
                    pgg.setGiamToiDa(null);
                }

                pgg.setDonToiThieu(parseBigDecimal(request.getParameter("donToiThieu")));
                pgg.setSoLuong(parseInteger(request.getParameter("soLuong")));
                pgg.setNgayBatDau(parseDate(request.getParameter("ngayBatDau")));
                pgg.setNgayKetThuc(parseDate(request.getParameter("ngayKetThuc")));
                pgg.setTrangThai(parseInteger(request.getParameter("trangThai")));

                repo.updatePhieuGiamGia(pgg);
                request.getSession().setAttribute("success", "Cập nhật phiếu giảm giá thành công!");
            } else {
                request.getSession().setAttribute("error", "Không tìm thấy phiếu giảm giá!");
            }

        } catch (Exception e) {
            e.printStackTrace();
            request.getSession().setAttribute("error", "Cập nhật thất bại!");
        }

        response.sendRedirect(request.getContextPath() + "/phieugiamgia/hien-thi");
    }

    // Xóa
    private void delete(HttpServletRequest request, HttpServletResponse response)
            throws IOException {

        try {
            Integer id = Integer.valueOf(request.getParameter("id"));
            PhieuGiamGia pgg = repo.getOne(id);

            if (pgg != null) {
                repo.deletePhieuGiamGia(pgg);
                request.getSession().setAttribute("success", "Xóa thành công!");
            } else {
                request.getSession().setAttribute("error", "Không tìm thấy dữ liệu để xóa!");
            }

        } catch (Exception e) {
            e.printStackTrace();
            request.getSession().setAttribute("error", "Xóa thất bại!");
        }

        response.sendRedirect(request.getContextPath() + "/phieugiamgia/hien-thi");
    }

    // XUẤT EXCEL
    private void exportExcel(HttpServletRequest request, HttpServletResponse response) throws IOException {
        List<PhieuGiamGia> list = repo.getAll();

        Workbook workbook = new XSSFWorkbook();
        Sheet sheet = workbook.createSheet("Danh Sách Phiếu Giảm Giá");

        // Header style
        CellStyle headerStyle = workbook.createCellStyle();
        Font font = workbook.createFont();
        font.setBold(true);
        headerStyle.setFont(font);

        Row headerRow = sheet.createRow(0);
        String[] headers = {"STT", "Mã Voucher", "Tên Voucher", "Loại", "Giá Trị", "Giảm Tối Đa", "Đơn Tối Thiểu", "Số Lượng", "Ngày Bắt Đầu", "Ngày Kết Thúc", "Trạng Thái"};
        for (int i = 0; i < headers.length; i++) {
            Cell cell = headerRow.createCell(i);
            cell.setCellValue(headers[i]);
            cell.setCellStyle(headerStyle);
        }

        SimpleDateFormat sdf = new SimpleDateFormat("dd/MM/yyyy");
        int rowNum = 1;
        for (int i = 0; i < list.size(); i++) {
            PhieuGiamGia pgg = list.get(i);
            Row row = sheet.createRow(rowNum++);

            row.createCell(0).setCellValue(i + 1);
            row.createCell(1).setCellValue(pgg.getMaVoucher() != null ? pgg.getMaVoucher() : "");
            row.createCell(2).setCellValue(pgg.getTenVoucher() != null ? pgg.getTenVoucher() : "");
            row.createCell(3).setCellValue(pgg.getLoaiGiamGia() != null ? pgg.getLoaiGiamGia() : "");
            row.createCell(4).setCellValue(pgg.getGiaTriGiamGia() != null ? pgg.getGiaTriGiamGia().toString() : "0");
            row.createCell(5).setCellValue(pgg.getGiamToiDa() != null ? pgg.getGiamToiDa().toString() : "-");
            row.createCell(6).setCellValue(pgg.getDonToiThieu() != null ? pgg.getDonToiThieu().toString() : "0");
            row.createCell(7).setCellValue(pgg.getSoLuong() != null ? pgg.getSoLuong() : 0);
            row.createCell(8).setCellValue(pgg.getNgayBatDau() != null ? sdf.format(pgg.getNgayBatDau()) : "");
            row.createCell(9).setCellValue(pgg.getNgayKetThuc() != null ? sdf.format(pgg.getNgayKetThuc()) : "");
            row.createCell(10).setCellValue(pgg.getTrangThai() != null && pgg.getTrangThai() == 1 ? "Đang hoạt động" : "Ngừng hoạt động");
        }

        // Auto size columns
        for (int i = 0; i < headers.length; i++) {
            sheet.autoSizeColumn(i);
        }

        response.setContentType("application/vnd.openxmlformats-officedocument.spreadsheetml.sheet");
        response.setHeader("Content-Disposition", "attachment; filename=danh_sach_phieu_giam_gia.xlsx");

        workbook.write(response.getOutputStream());
        workbook.close();
    }

    private void moveFlash(HttpServletRequest request) {
        Object success = request.getSession().getAttribute("success");
        Object error = request.getSession().getAttribute("error");

        if (success != null) {
            request.setAttribute("success", success);
            request.getSession().removeAttribute("success");
        }

        if (error != null) {
            request.setAttribute("error", error);
            request.getSession().removeAttribute("error");
        }
    }

    private BigDecimal parseBigDecimal(String value) {
        if (value == null || value.trim().isEmpty()) return null;
        try {
            return new BigDecimal(value.trim());
        } catch (Exception e) {
            return null;
        }
    }

    private Integer parseInteger(String value) {
        if (value == null || value.trim().isEmpty()) return 0;
        try {
            return Integer.valueOf(value.trim());
        } catch (Exception e) {
            return 0;
        }
    }

    private java.sql.Date parseDate(String value) {
        if (value == null || value.trim().isEmpty()) return null;
        try {
            return java.sql.Date.valueOf(value.trim());
        } catch (Exception e) {
            return null;
        }
    }
}