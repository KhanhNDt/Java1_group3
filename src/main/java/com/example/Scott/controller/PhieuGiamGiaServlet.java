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

    // Trạng thái phiếu giảm giá: 0 = Ngừng hoạt động, 1 = Đang hoạt động, 2 = Sắp diễn ra.
    //
    // Auto update status theo ngày hiện tại mỗi khi hiển thị:
    //  - Đã quá ngày kết thúc  -> luôn chuyển về "Ngừng hoạt động" (0). Ưu tiên
    //    cao nhất, ghi đè mọi trạng thái khác vì phiếu đã hết hạn thật sự.
    //  - Đang ở trạng thái "Sắp diễn ra" (2) mà đã tới/qua ngày bắt đầu
    //    -> tự động chuyển sang "Đang hoạt động" (1).
    //  - KHÔNG tự ép về "Đang hoạt động" nếu admin đã chủ động tắt (0) trong
    //    lúc phiếu chưa hết hạn, để không ghi đè lựa chọn thủ công của admin.
    private void autoUpdateStatus(PhieuGiamGia pgg) {
        if (pgg == null) return;
        java.util.Date today = new java.util.Date();

        if (pgg.getNgayKetThuc() != null && pgg.getNgayKetThuc().before(today)) {
            pgg.setTrangThai(0);
            return;
        }

        if (pgg.getTrangThai() != null && pgg.getTrangThai() == 2
                && pgg.getNgayBatDau() != null && !pgg.getNgayBatDau().after(today)) {
            pgg.setTrangThai(1);
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

        moveFlash(request);
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

            moveFlash(request);
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

            String loi = validate(maVoucher, tenVoucher, loaiGiamGia, giaTriGiamGia,
                    donToiThieu, soLuong, ngayBatDau, ngayKetThuc, null);
            if (loi != null) {
                request.getSession().setAttribute("error", loi);
                response.sendRedirect(request.getContextPath() + "/phieugiamgia/view-add");
                return;
            }

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

            // Xác định trạng thái ban đầu dựa theo ngày bắt đầu / kết thúc:
            //  - Ngày kết thúc đã qua (hiếm khi xảy ra vì validate chặn) -> Ngừng hoạt động.
            //  - Ngày bắt đầu ở tương lai (sau hôm nay) -> Sắp diễn ra.
            //  - Còn lại (đã trong khoảng hiệu lực) -> Đang hoạt động.
            java.util.Date today = new java.util.Date();
            if (ngayKetThuc != null && ngayKetThuc.before(today)) {
                pgg.setTrangThai(0);
            } else if (ngayBatDau != null && ngayBatDau.after(today)) {
                pgg.setTrangThai(2);
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
                String maVoucher = request.getParameter("maVoucher");
                String tenVoucher = request.getParameter("tenVoucher");
                String loaiGiamGia = request.getParameter("loaiGiamGia");
                BigDecimal giaTriGiamGia = parseBigDecimal(request.getParameter("giaTriGiamGia"));
                BigDecimal donToiThieu = parseBigDecimal(request.getParameter("donToiThieu"));
                Integer soLuong = parseInteger(request.getParameter("soLuong"));
                java.sql.Date ngayBatDau = parseDate(request.getParameter("ngayBatDau"));
                java.sql.Date ngayKetThuc = parseDate(request.getParameter("ngayKetThuc"));

                String loi = validate(maVoucher, tenVoucher, loaiGiamGia, giaTriGiamGia,
                        donToiThieu, soLuong, ngayBatDau, ngayKetThuc, id);
                if (loi != null) {
                    request.getSession().setAttribute("error", loi);
                    response.sendRedirect(request.getContextPath() + "/phieugiamgia/view-update?id=" + id);
                    return;
                }

                pgg.setMaVoucher(maVoucher);
                pgg.setTenVoucher(tenVoucher);
                pgg.setLoaiGiamGia(loaiGiamGia);
                pgg.setGiaTriGiamGia(giaTriGiamGia);

                if ("%".equals(loaiGiamGia)) {
                    pgg.setGiamToiDa(parseBigDecimal(request.getParameter("giamToiDa")));
                } else {
                    pgg.setGiamToiDa(null);
                }

                pgg.setDonToiThieu(donToiThieu);
                pgg.setSoLuong(soLuong);
                pgg.setNgayBatDau(ngayBatDau);
                pgg.setNgayKetThuc(ngayKetThuc);

                // Trạng thái không còn cho chỉnh tay: chỉ dựa vào mốc ngày
                // bắt đầu/kết thúc vừa nhập để tự tính lại.
                java.util.Date today = new java.util.Date();
                if (ngayKetThuc != null && ngayKetThuc.before(today)) {
                    pgg.setTrangThai(0);
                } else if (ngayBatDau != null && ngayBatDau.after(today)) {
                    pgg.setTrangThai(2);
                } else {
                    pgg.setTrangThai(1);
                }

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
        for (PhieuGiamGia pgg : list) {
            autoUpdateStatus(pgg);
        }

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
            String trangThaiText;
            if (pgg.getTrangThai() != null && pgg.getTrangThai() == 1) {
                trangThaiText = "Đang hoạt động";
            } else if (pgg.getTrangThai() != null && pgg.getTrangThai() == 2) {
                trangThaiText = "Sắp diễn ra";
            } else {
                trangThaiText = "Ngừng hoạt động";
            }
            row.createCell(10).setCellValue(trangThaiText);
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

    /**
     * Kiểm tra dữ liệu phiếu giảm giá trước khi lưu (dùng chung cho Thêm & Sửa).
     * excludeId: null khi thêm mới; là id hiện tại khi sửa (để không tự báo trùng mã với chính nó).
     * Trả về null nếu hợp lệ, ngược lại trả về chuỗi mô tả (các) lỗi.
     */
    private String validate(String maVoucher, String tenVoucher, String loaiGiamGia,
                            BigDecimal giaTriGiamGia, BigDecimal donToiThieu, Integer soLuong,
                            java.sql.Date ngayBatDau, java.sql.Date ngayKetThuc, Integer excludeId) {

        StringBuilder loi = new StringBuilder();

        // ----- Mã voucher: bắt buộc + không trùng -----
        if (maVoucher == null || maVoucher.trim().isEmpty()) {
            loi.append("Mã voucher không được để trống. ");
        } else if (repo.existsByMaVoucher(maVoucher.trim(), excludeId)) {
            loi.append("Mã voucher \"").append(maVoucher.trim()).append("\" đã tồn tại, vui lòng chọn mã khác. ");
        }

        // ----- Tên voucher: bắt buộc -----
        if (tenVoucher == null || tenVoucher.trim().isEmpty()) {
            loi.append("Tên voucher không được để trống. ");
        }

        // ----- Giá trị giảm: bắt buộc, không âm; riêng loại "%" chỉ trong khoảng 0-100 -----
        if (giaTriGiamGia == null) {
            loi.append("Giá trị giảm không được để trống. ");
        } else if ("%".equals(loaiGiamGia)) {
            if (giaTriGiamGia.compareTo(BigDecimal.ZERO) < 0 || giaTriGiamGia.compareTo(BigDecimal.valueOf(100)) > 0) {
                loi.append("Giá trị giảm (%) chỉ được trong khoảng 0-100. ");
            }
        } else if (giaTriGiamGia.compareTo(BigDecimal.ZERO) < 0) {
            loi.append("Giá trị giảm không được là số âm. ");
        }

        // ----- Đơn tối thiểu: không được âm (được phép để trống = không giới hạn) -----
        if (donToiThieu != null && donToiThieu.compareTo(BigDecimal.ZERO) < 0) {
            loi.append("Đơn tối thiểu không được là số âm. ");
        }

        // ----- Số lượng: không được âm (được phép để trống = không giới hạn) -----
        if (soLuong != null && soLuong < 0) {
            loi.append("Số lượng không được là số âm. ");
        }

        // ----- Ngày bắt đầu / kết thúc: bắt buộc + ngày bắt đầu phải nhỏ hơn ngày kết thúc -----
        if (ngayBatDau == null) {
            loi.append("Ngày bắt đầu không hợp lệ. ");
        }
        if (ngayKetThuc == null) {
            loi.append("Ngày kết thúc không hợp lệ. ");
        }
        if (ngayBatDau != null && ngayKetThuc != null && !ngayBatDau.before(ngayKetThuc)) {
            loi.append("Ngày bắt đầu phải nhỏ hơn ngày kết thúc. ");
        }

        return loi.length() == 0 ? null : loi.toString().trim();
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

    // Trả về null khi ô để trống (vd: "Số lượng" để trống nghĩa là KHÔNG GIỚI HẠN).
    // TRƯỚC ĐÂY hàm này trả về 0 khi để trống, khiến voucher bị lưu soLuong=0
    // thay vì NULL -> điều kiện "COALESCE(soLuongDaDung,0) < soLuong" ở
    // getValidVouchers() luôn luôn sai (0 < 0 = false) -> phiếu giảm giá
    // không bao giờ xuất hiện trong danh sách voucher ở màn Bán hàng tại quầy,
    // dù màn quản lý vẫn hiển thị "Đang hoạt động" bình thường.
    private Integer parseInteger(String value) {
        if (value == null || value.trim().isEmpty()) return null;
        try {
            return Integer.valueOf(value.trim());
        } catch (Exception e) {
            return null;
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