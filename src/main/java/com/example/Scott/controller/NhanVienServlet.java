package com.example.Scott.controller;

import com.example.Scott.data.DiaChiData;
import com.example.Scott.dto.CccdDTO;
import com.example.Scott.entity.NhanVien;
import com.example.Scott.responsitory.NhanVienRepository;
import com.example.Scott.utils.MailUtils;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.MultipartConfig;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import org.apache.poi.ss.usermodel.*;
import org.apache.poi.xssf.usermodel.XSSFWorkbook;

import java.io.IOException;
import java.io.UnsupportedEncodingException;
import java.net.URLEncoder;
import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.Paths;
import java.nio.file.StandardCopyOption;
import java.util.List;
import java.util.Locale;
import java.util.UUID;

@MultipartConfig(fileSizeThreshold = 1024 * 1024, maxFileSize = 5 * 1024 * 1024, maxRequestSize = 6 * 1024 * 1024)
@WebServlet({
        "/nhan-vien/hien-thi",
        "/nhan-vien/detail",
        "/nhan-vien/view",
        "/nhan-vien/add",
        "/nhan-vien/update",
        "/nhan-vien/delete",
        "/nhan-vien/toggle",
        "/nhan-vien/search",
        "/nhan-vien/export-excel",
        "/nhan-vien/XuLyQr"
})
public class NhanVienServlet extends HttpServlet {

    // Số nhân viên hiển thị trên mỗi trang (cố định theo yêu cầu)
    private static final int PAGE_SIZE_DEFAULT = 5;
    private static final int TRANG_THAI_MAC_DINH_KHI_THEM = 1; // luôn "Đang làm" khi thêm mới

    private final NhanVienRepository repo = new NhanVienRepository();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");
        response.setCharacterEncoding("UTF-8");

        String uri = request.getRequestURI();

        if (uri.contains("/nhan-vien/delete")) {
            this.delete(request, response);
        } else if (uri.contains("/nhan-vien/XuLyQr")) {
            this.xuLyQr(request, response);
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

    private void xuLyQr(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String qrData = request.getParameter("qrData");

        if (qrData != null && !qrData.trim().isEmpty()) {
            // Cấu trúc mã QR CCCD gắn chip: SốCCCD|SốCMNDCu|HọTên|NgàySinh(DDMMYYYY)|GiớiTính|ĐịaChi|NgàyCấp
            String[] parts = qrData.split("\\|");

            if (parts.length >= 6) {
                // Đóng gói thông tin để truyền sang trang JSP hiển thị
                request.setAttribute("cccdInfo", new CccdDTO(
                        parts[0], // Số CCCD
                        parts[2], // Họ tên
                        formatNgaySinh(parts[3]), // Ngày sinh chuẩn yyyy-MM-dd hoặc dd/MM/yyyy
                        parts[4], // Giới tính
                        parts[5]  // Địa chỉ
                ));
                request.getRequestDispatcher("/views/nhanvien/ket-qua-quet-qr.jsp").forward(request, response);
                return;
            }
        }

        // Nếu quét sai định dạng hoặc không đọc được
        response.sendRedirect(request.getContextPath() + "/nhan-vien/detail?id=0&status=error&action=qr");
    }

    private String formatNgaySinh(String rawDate) {
        if (rawDate != null && rawDate.length() == 8) {
            return rawDate.substring(0, 2) + "/" + rawDate.substring(2, 4) + "/" + rawDate.substring(4, 8);
        }
        return rawDate;
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

        // Cố định 5 nhân viên / trang (không cho phép đổi qua tham số size)
        int size = PAGE_SIZE_DEFAULT;

        long totalRecords = repo.countFilter(keyword, chucVu, trangThai);
        int totalPages = (int) Math.ceil((double) totalRecords / size);
        if (totalPages < 1) totalPages = 1;
        if (page > totalPages) page = totalPages;

        int offset = (page - 1) * size;

        List<NhanVien> employees = repo.filter(keyword, chucVu, trangThai, offset, size);
        request.setAttribute("list", employees);
        if (repo.getLastError() != null) {
            request.setAttribute("dbError", repo.getLastError());
        }
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
            NhanVien nv = new NhanVien();
            // Nếu vừa quét QR CCCD/VNeID và bấm "Xác nhận, điền vào form" thì tự động điền sẵn
            // các thông tin đã quét được vào nhân viên mới (người dùng vẫn có thể sửa lại trước khi lưu).
            applyQrDataIfPresent(request, nv);
            request.setAttribute("nv", nv);
        }
        request.setAttribute("menu", "nhanvien");
        request.setAttribute("viewType", "form");
        themDuLieuDiaChi(request);
        request.getRequestDispatcher("/views/nhanvien/nhan-vien.jsp").forward(request, response);
    }

    /**
     * Điền sẵn thông tin nhân viên mới từ dữ liệu CCCD vừa quét QR (nếu có truyền lên qua query string
     * từ trang kết quả quét QR khi người dùng bấm "Xác nhận, điền vào form").
     */
    private void applyQrDataIfPresent(HttpServletRequest request, NhanVien nv) {
        String hoTen = request.getParameter("qrHoTen");
        String ngaySinh = request.getParameter("qrNgaySinh"); // định dạng dd/MM/yyyy
        String gioiTinh = request.getParameter("qrGioiTinh"); // "Nam" / "Nữ"
        String diaChi = request.getParameter("qrDiaChi");

        boolean coDuLieuQr = (hoTen != null && !hoTen.trim().isEmpty())
                || (ngaySinh != null && !ngaySinh.trim().isEmpty())
                || (gioiTinh != null && !gioiTinh.trim().isEmpty())
                || (diaChi != null && !diaChi.trim().isEmpty());
        if (!coDuLieuQr) return;

        if (hoTen != null && !hoTen.trim().isEmpty()) nv.setHoTen(hoTen.trim());
        if (diaChi != null && !diaChi.trim().isEmpty()) nv.setDiaChi(diaChi.trim());
        if (gioiTinh != null && !gioiTinh.trim().isEmpty()) {
            nv.setGioiTinh("Nam".equalsIgnoreCase(gioiTinh.trim()));
        }
        if (ngaySinh != null && !ngaySinh.trim().isEmpty()) {
            try {
                String[] p = ngaySinh.trim().split("/");
                if (p.length == 3) {
                    java.util.Calendar cal = java.util.Calendar.getInstance();
                    cal.clear();
                    cal.set(Integer.parseInt(p[2]), Integer.parseInt(p[1]) - 1, Integer.parseInt(p[0]));
                    nv.setNgaySinh(cal.getTime());
                }
            } catch (Exception ignored) {
                // Sai định dạng ngày sinh từ QR -> bỏ qua, để trống cho người dùng tự nhập
            }
        }
        request.setAttribute("qrFilled", true);
    }

    /**
     * Nạp danh sách Tỉnh/Phường (dữ liệu nội bộ, dùng chung với modal chọn địa chỉ
     * của khách hàng) để hiển thị trong form thêm/sửa nhân viên.
     */
    private void themDuLieuDiaChi(HttpServletRequest request) {
        request.setAttribute("listTinh", DiaChiData.getAllTinh());
        request.setAttribute("listPhuong", DiaChiData.getAllPhuong());
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

                row.createCell(5).setCellValue(nv.getGioiTinh() ? "Nam" : "Nữ");
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

    /**
     * Lưu file ảnh đại diện nhân viên từ Part multipart "anhDaiDienFile" (nếu có) lên đĩa
     * và trả về đường dẫn tương đối (VD "uploads/employees/xxx.jpg") để lưu vào cột anh_dai_dien.
     * Trả về null nếu người dùng không chọn file nào -> giữ nguyên ảnh cũ khi cập nhật.
     */
    private String saveEmployeeImageIfPresent(HttpServletRequest request) throws ServletException {
        Part part;
        try {
            part = request.getPart("anhDaiDienFile");
        } catch (IOException | ServletException e) {
            return null; // không phải request multipart hoặc không có part này
        }
        if (part == null || part.getSize() == 0) return null;

        String contentType = part.getContentType();
        if (contentType == null || !(contentType.equals("image/jpeg") || contentType.equals("image/png") || contentType.equals("image/webp"))) {
            throw new ServletException("Ảnh đại diện chỉ chấp nhận JPG, PNG hoặc WEBP.");
        }

        String submitted = Paths.get(part.getSubmittedFileName()).getFileName().toString();
        String ext = submitted.contains(".") ? submitted.substring(submitted.lastIndexOf('.')).toLowerCase(Locale.ROOT) : ".jpg";
        String fileName = UUID.randomUUID().toString().replace("-", "") + ext;
        String relativeDir = "uploads/employees";
        String realDir = request.getServletContext().getRealPath("/" + relativeDir);
        if (realDir == null) throw new ServletException("Không xác định được thư mục lưu ảnh trên máy chủ.");

        try {
            Path dir = Paths.get(realDir);
            Files.createDirectories(dir);
            try (java.io.InputStream input = part.getInputStream()) {
                Files.copy(input, dir.resolve(fileName), StandardCopyOption.REPLACE_EXISTING);
            }
        } catch (IOException e) {
            throw new ServletException("Không thể lưu ảnh đại diện: " + e.getMessage(), e);
        }
        return relativeDir + "/" + fileName;
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
            String email = request.getParameter("email");
            String ngaySinhStr = request.getParameter("ngaySinh");

            // Chặn lưu bản ghi rỗng: nếu Họ tên/Email trống (do lỗi trình duyệt, form gửi thiếu dữ liệu,
            // hay thao tác bất thường) thì báo lỗi rõ ràng thay vì lưu 1 dòng trống vào DB.
            if (hoTen == null || hoTen.trim().isEmpty() || email == null || email.trim().isEmpty()) {
                request.setAttribute("error", "Thiếu dữ liệu bắt buộc (Họ tên/Email trống). " +
                        "Vui lòng nhập lại đầy đủ thông tin và thử lưu lại. " +
                        "Nếu vẫn gặp lỗi này, hãy tải lại trang (F5) trước khi nhập.");
                nv.setId(isAdd ? 0 : parseIntSafe(request.getParameter("id"), 0));
                nv.setHoTen(hoTen);
                nv.setEmail(email);
                nv.setSoDienThoai(request.getParameter("soDienThoai"));
                nv.setChucVu(request.getParameter("chucVu"));
                nv.setDiaChi(buildDiaChi(request));
                request.setAttribute("nv", nv);
                request.setAttribute("menu", "nhanvien");
                request.setAttribute("viewType", "form");
                themDuLieuDiaChi(request);
                request.getRequestDispatcher("/views/nhanvien/nhan-vien.jsp").forward(request, response);
                return;
            }

            // Mã nhân viên KHÔNG lấy từ form nữa (ô này chỉ hiển thị, không cho sửa) -> xử lý riêng bên dưới
            nv.setHoTen(hoTen);
            nv.setEmail(email);
            nv.setSoDienThoai(request.getParameter("soDienThoai"));
            nv.setChucVu(request.getParameter("chucVu"));
            nv.setDiaChi(buildDiaChi(request));

            // Xử lý Date an toàn
            if (ngaySinhStr != null && !ngaySinhStr.isEmpty()) {
                nv.setNgaySinh(java.sql.Date.valueOf(ngaySinhStr));
            }

            // Giới tính: radio button "true"/"false"
            nv.setGioiTinh(Boolean.parseBoolean(request.getParameter("gioiTinh")));

            // Ảnh đại diện: chỉ lưu file mới nếu người dùng có chọn; nếu không, giữ nguyên ảnh cũ (khi sửa).
            String anhMoi;
            try {
                anhMoi = saveEmployeeImageIfPresent(request);
            } catch (ServletException imgEx) {
                request.setAttribute("error", imgEx.getMessage());
                nv.setId(isAdd ? 0 : parseIntSafe(request.getParameter("id"), 0));
                nv.setHoTen(hoTen);
                nv.setEmail(email);
                nv.setSoDienThoai(request.getParameter("soDienThoai"));
                nv.setChucVu(request.getParameter("chucVu"));
                nv.setDiaChi(buildDiaChi(request));
                if (!isAdd) {
                    NhanVien existingNv = repo.getOne(parseIntSafe(request.getParameter("id"), 0));
                    if (existingNv != null) nv.setAnhDaiDien(existingNv.getAnhDaiDien());
                }
                request.setAttribute("nv", nv);
                request.setAttribute("menu", "nhanvien");
                request.setAttribute("viewType", "form");
                themDuLieuDiaChi(request);
                request.getRequestDispatcher("/views/nhanvien/nhan-vien.jsp").forward(request, response);
                return;
            }
            if (anhMoi != null) {
                nv.setAnhDaiDien(anhMoi);
            }

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
                // Nếu không chọn ảnh mới, giữ nguyên ảnh cũ trong DB (tránh bị xóa ảnh khi chỉ sửa thông tin khác)
                if (anhMoi == null) {
                    nv.setAnhDaiDien(existing != null ? existing.getAnhDaiDien() : null);
                }
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
                themDuLieuDiaChi(request);
                request.getRequestDispatcher("/views/nhanvien/nhan-vien.jsp").forward(request, response);
            }

        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("error", "Lỗi hệ thống: " + e.getMessage());
            request.setAttribute("menu", "nhanvien");
            request.setAttribute("viewType", "form");
            themDuLieuDiaChi(request);
            request.getRequestDispatcher("/views/nhanvien/nhan-vien.jsp").forward(request, response);
        }
    }
}