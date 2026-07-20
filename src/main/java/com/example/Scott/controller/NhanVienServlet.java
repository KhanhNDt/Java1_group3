package com.example.Scott.controller;

import com.example.Scott.entity.NhanVien;
import com.example.Scott.responsitory.NhanVienRepository;
import com.example.Scott.utils.MailUtils;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import org.apache.poi.ss.usermodel.*;
import org.apache.poi.xssf.usermodel.XSSFWorkbook;

import java.io.IOException;
import java.io.UnsupportedEncodingException;
import java.net.URLEncoder;
import java.util.List;

@WebServlet({
        "/nhan-vien/hien-thi",
        "/nhan-vien/detail",
        "/nhan-vien/view",
        "/nhan-vien/add",
        "/nhan-vien/update",
        "/nhan-vien/delete",
        "/nhan-vien/toggle",
        "/nhan-vien/search",
        "/nhan-vien/export-excel"
})
public class NhanVienServlet extends HttpServlet {

    private static final int PAGE_SIZE_DEFAULT = 10;
    private static final int TRANG_THAI_MAC_DINH_KHI_THEM = 1; // luôn "Đang làm" khi thêm mới

    private final NhanVienRepository repo = new NhanVienRepository();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");
        response.setCharacterEncoding("UTF-8");

        String uri = request.getRequestURI();

        if (uri.contains("/nhan-vien/delete")) {
            this.delete(request, response);
        } else if (uri.contains("/nhan-vien/toggle")) {
            this.toggle(request, response);
        } else if (uri.contains("/nhan-vien/view")) {
            this.view(request, response);
        } else if (uri.contains("/nhan-vien/detail")) {
            this.detail(request, response);
        } else if (uri.contains("/nhan-vien/export-excel")) {
            this.exportExcel(request, response);
        } else {
            // /nhan-vien/hien-thi hoặc /nhan-vien/search đều đổ về danh sách có bộ lọc
            this.hienThi(request, response);
        }
    }

    /**
     * Danh sách nhân viên: tìm kiếm + lọc theo chức vụ/trạng thái + phân trang
     */
    private void hienThi(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String keyword = request.getParameter("keyword");
        String chucVu = request.getParameter("chucVu");
        String trangThaiParam = request.getParameter("trangThai");

        Integer trangThai = null;
        if (trangThaiParam != null && !trangThaiParam.trim().isEmpty()) {
            try {
                trangThai = Integer.parseInt(trangThaiParam.trim());
            } catch (NumberFormatException ignored) {
            }
        }

        int page = parseIntSafe(request.getParameter("page"), 1);
        if (page < 1) page = 1;

        int size = parseIntSafe(request.getParameter("size"), PAGE_SIZE_DEFAULT);
        if (size < 1) size = PAGE_SIZE_DEFAULT;

        long totalRecords = repo.countFilter(keyword, chucVu, trangThai);
        int totalPages = (int) Math.ceil((double) totalRecords / size);
        if (totalPages < 1) totalPages = 1;
        if (page > totalPages) page = totalPages;

        int offset = (page - 1) * size;

        request.setAttribute("list", repo.filter(keyword, chucVu, trangThai, offset, size));
        request.setAttribute("totalRecords", totalRecords);
        request.setAttribute("totalPages", totalPages);
        request.setAttribute("currentPage", page);
        request.setAttribute("size", size);
        request.setAttribute("keyword", keyword);
        request.setAttribute("chucVu", chucVu);
        request.setAttribute("trangThai", trangThaiParam);

        // Thông báo thành công/thất bại sau khi redirect từ add/update/delete/toggle
        request.setAttribute("status", request.getParameter("status"));
        request.setAttribute("action", request.getParameter("action"));

        request.setAttribute("menu", "nhanvien");
        request.setAttribute("viewType", "list");
        request.getRequestDispatcher("/views/nhanvien/nhan-vien.jsp").forward(request, response);
    }

    /**
     * Form thêm mới / cập nhật
     */
    private void detail(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String idStr = request.getParameter("id");
        if (idStr != null && !idStr.equals("0")) {
            try {
                request.setAttribute("nv", repo.getOne(Integer.valueOf(idStr)));
            } catch (NumberFormatException e) {
                request.setAttribute("nv", new NhanVien());
            }
        } else {
            request.setAttribute("nv", new NhanVien());
        }
        request.setAttribute("menu", "nhanvien");
        request.setAttribute("viewType", "form");
        request.getRequestDispatcher("/views/nhanvien/nhan-vien.jsp").forward(request, response);
    }

    /**
     * Xem chi tiết (chỉ đọc) - dùng cho icon con mắt
     */
    private void view(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String idStr = request.getParameter("id");
        NhanVien nv = null;
        if (idStr != null) {
            try {
                nv = repo.getOne(Integer.valueOf(idStr));
            } catch (NumberFormatException ignored) {
            }
        }
        if (nv == null) {
            response.sendRedirect(request.getContextPath() + "/nhan-vien/hien-thi");
            return;
        }
        request.setAttribute("nv", nv);
        request.setAttribute("menu", "nhanvien");
        request.setAttribute("viewType", "view");
        request.getRequestDispatcher("/views/nhanvien/nhan-vien.jsp").forward(request, response);
    }

    private void delete(HttpServletRequest request, HttpServletResponse response) throws IOException {
        boolean success = false;
        try {
            success = repo.delete(Integer.valueOf(request.getParameter("id")));
        } catch (NumberFormatException ignored) {
        }
        String status = success ? "success" : "error";
        response.sendRedirect(request.getContextPath() + "/nhan-vien/hien-thi"
                + buildBackQuery(request) + "&status=" + status + "&action=delete");
    }

    /**
     * Bật/tắt nhanh trạng thái Đang làm - Đã nghỉ (công tắc gạt trong bảng)
     */
    private void toggle(HttpServletRequest request, HttpServletResponse response) throws IOException {
        boolean success = false;
        try {
            int id = Integer.parseInt(request.getParameter("id"));
            NhanVien nv = repo.getOne(id);
            if (nv != null) {
                int newStatus = nv.getTrangThai() == 1 ? 0 : 1;
                success = repo.updateTrangThai(id, newStatus);
            }
        } catch (NumberFormatException ignored) {
        }
        String status = success ? "success" : "error";
        response.sendRedirect(request.getContextPath() + "/nhan-vien/hien-thi"
                + buildBackQuery(request) + "&status=" + status + "&action=toggle");
    }

    /**
     * Xuất Excel danh sách nhân viên đang được lọc trên giao diện (giữ nguyên keyword/chucVu/trangThai hiện tại)
     */
    private void exportExcel(HttpServletRequest request, HttpServletResponse response) throws IOException {
        String keyword = request.getParameter("keyword");
        String chucVu = request.getParameter("chucVu");
        String trangThaiParam = request.getParameter("trangThai");
        Integer trangThai = null;
        if (trangThaiParam != null && !trangThaiParam.trim().isEmpty()) {
            try {
                trangThai = Integer.parseInt(trangThaiParam.trim());
            } catch (NumberFormatException ignored) {
            }
        }

        List<NhanVien> list = repo.filterAll(keyword, chucVu, trangThai);

        try (XSSFWorkbook workbook = new XSSFWorkbook()) {
            Sheet sheet = workbook.createSheet("Nhan vien");

            CellStyle headerStyle = workbook.createCellStyle();
            Font headerFont = workbook.createFont();
            headerFont.setBold(true);
            headerFont.setColor(IndexedColors.WHITE.getIndex());
            headerStyle.setFont(headerFont);
            headerStyle.setFillForegroundColor(IndexedColors.DARK_BLUE.getIndex());
            headerStyle.setFillPattern(FillPatternType.SOLID_FOREGROUND);

            String[] headers = {"Mã NV", "Họ tên", "Email", "SĐT", "Ngày sinh", "Giới tính",
                    "Địa chỉ", "Chức vụ", "Trạng thái"};

            Row headerRow = sheet.createRow(0);
            for (int i = 0; i < headers.length; i++) {
                Cell cell = headerRow.createCell(i);
                cell.setCellValue(headers[i]);
                cell.setCellStyle(headerStyle);
            }

            CellStyle dateStyle = workbook.createCellStyle();
            dateStyle.setDataFormat(workbook.createDataFormat().getFormat("dd/MM/yyyy"));

            int rowIdx = 1;
            for (NhanVien nv : list) {
                Row row = sheet.createRow(rowIdx++);
                row.createCell(0).setCellValue(nv.getMaNhanVien());
                row.createCell(1).setCellValue(nv.getHoTen());
                row.createCell(2).setCellValue(nv.getEmail());
                row.createCell(3).setCellValue(nv.getSoDienThoai());

                Cell dateCell = row.createCell(4);
                if (nv.getNgaySinh() != null) {
                    dateCell.setCellValue(nv.getNgaySinh());
                    dateCell.setCellStyle(dateStyle);
                }

                row.createCell(5).setCellValue(nv.isGioiTinh() ? "Nam" : "Nữ");
                row.createCell(6).setCellValue(nv.getDiaChi());
                row.createCell(7).setCellValue(nv.getChucVu());
                row.createCell(8).setCellValue(nv.getTrangThai() == 1 ? "Đang làm" : "Đã nghỉ");
            }

            for (int i = 0; i < headers.length; i++) {
                sheet.autoSizeColumn(i);
            }

            response.setContentType("application/vnd.openxmlformats-officedocument.spreadsheetml.sheet");
            response.setHeader("Content-Disposition", "attachment; filename=\"danh-sach-nhan-vien.xlsx\"");

            workbook.write(response.getOutputStream());
            response.getOutputStream().flush();
        }
    }

    /**
     * Giữ lại các tham số lọc/trang hiện tại khi redirect quay lại danh sách
     */
    private String buildBackQuery(HttpServletRequest request) {
        StringBuilder sb = new StringBuilder("?");
        appendParam(sb, request, "keyword");
        appendParam(sb, request, "chucVu");
        appendParam(sb, request, "trangThai");
        appendParam(sb, request, "page");
        appendParam(sb, request, "size");
        return sb.toString();
    }

    private void appendParam(StringBuilder sb, HttpServletRequest request, String name) {
        String value = request.getParameter(name);
        if (value != null && !value.isEmpty()) {
            if (sb.length() > 1) sb.append("&");
            try {
                sb.append(name).append("=").append(URLEncoder.encode(value, "UTF-8"));
            } catch (UnsupportedEncodingException e) {
                // UTF-8 luôn được hỗ trợ trên mọi JVM nên nhánh này thực tế không xảy ra
                sb.append(name).append("=").append(value);
            }
        }
    }

    private int parseIntSafe(String value, int defaultValue) {
        if (value == null || value.trim().isEmpty()) return defaultValue;
        try {
            return Integer.parseInt(value.trim());
        } catch (NumberFormatException e) {
            return defaultValue;
        }
    }

    /**
     * Gộp 4 phần địa chỉ (Tỉnh/Huyện/Xã/Địa chỉ cụ thể) thành 1 chuỗi lưu vào cột dia_chi.
     * Nếu form gửi sẵn field "diaChi" đầy đủ (ví dụ JS đã gộp sẵn) thì ưu tiên dùng luôn.
     */
    private String buildDiaChi(HttpServletRequest request) {
        String diaChiGop = request.getParameter("diaChi");
        if (diaChiGop != null && !diaChiGop.trim().isEmpty()) {
            return diaChiGop.trim();
        }

        String cuThe = request.getParameter("diaChiCuThe");
        String xa = request.getParameter("xaPhuong");
        String huyen = request.getParameter("quanHuyen");
        String tinh = request.getParameter("tinhThanh");

        StringBuilder sb = new StringBuilder();
        appendPart(sb, cuThe);
        appendPart(sb, xa);
        appendPart(sb, huyen);
        appendPart(sb, tinh);
        return sb.toString();
    }

    private void appendPart(StringBuilder sb, String part) {
        if (part != null && !part.trim().isEmpty()) {
            if (sb.length() > 0) sb.append(", ");
            sb.append(part.trim());
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");
        response.setCharacterEncoding("UTF-8");

        boolean isAdd = request.getRequestURI().contains("/add");

        try {
            NhanVien nv = new NhanVien();

            String hoTen = request.getParameter("hoTen");
            String ngaySinhStr = request.getParameter("ngaySinh");

            // Mã nhân viên KHÔNG lấy từ form nữa (ô này chỉ hiển thị, không cho sửa) -> xử lý riêng bên dưới
            nv.setHoTen(hoTen);
            nv.setEmail(request.getParameter("email"));
            nv.setSoDienThoai(request.getParameter("soDienThoai"));
            nv.setChucVu(request.getParameter("chucVu"));
            nv.setDiaChi(buildDiaChi(request));

            // Xử lý Date an toàn
            if (ngaySinhStr != null && !ngaySinhStr.isEmpty()) {
                nv.setNgaySinh(java.sql.Date.valueOf(ngaySinhStr));
            }

            // Giới tính: radio button "true"/"false"
            nv.setGioiTinh(Boolean.parseBoolean(request.getParameter("gioiTinh")));

            boolean success;
            if (isAdd) {
                // Mã nhân viên tự sinh phía server (NV001, NV002, ...), không tin dữ liệu gửi từ client
                nv.setMaNhanVien(repo.generateNextMa());
                // Trạng thái KHÔNG cho chọn khi thêm mới -> luôn mặc định "Đang làm"
                nv.setTrangThai(TRANG_THAI_MAC_DINH_KHI_THEM);
                success = repo.add(nv);

                if (success) {
                    // Gửi mail xác nhận đăng ký thành công (không chặn luồng nếu gửi lỗi)
                    MailUtils.sendWelcomeEmail(nv.getEmail(), nv.getHoTen(), nv.getMaNhanVien());
                }
            } else {
                int id = Integer.parseInt(request.getParameter("id"));
                NhanVien existing = repo.getOne(id);
                // Mã nhân viên là định danh cố định -> luôn giữ nguyên giá trị cũ trong DB, không cho đổi
                nv.setMaNhanVien(existing != null ? existing.getMaNhanVien() : request.getParameter("maNhanVien"));
                // Trạng thái không nằm trong form sửa -> giữ nguyên trạng thái hiện có trong DB
                nv.setTrangThai(existing != null ? existing.getTrangThai() : TRANG_THAI_MAC_DINH_KHI_THEM);
                nv.setId(id);
                success = repo.update(nv);
            }

            if (success) {
                String action = isAdd ? "add" : "update";
                response.sendRedirect(request.getContextPath() + "/nhan-vien/hien-thi?status=success&action=" + action);
            } else {
                request.setAttribute("error", "Lưu dữ liệu thất bại. Vui lòng kiểm tra lại thông tin (mã nhân viên có thể đã tồn tại).");
                request.setAttribute("nv", nv);
                request.setAttribute("menu", "nhanvien");
                request.setAttribute("viewType", "form");
                request.getRequestDispatcher("/views/nhanvien/nhan-vien.jsp").forward(request, response);
            }

        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("error", "Lỗi hệ thống: " + e.getMessage());
            request.setAttribute("menu", "nhanvien");
            request.setAttribute("viewType", "form");
            request.getRequestDispatcher("/views/nhanvien/nhan-vien.jsp").forward(request, response);
        }
    }
}