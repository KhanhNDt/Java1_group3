package com.example.Scott.controller;

import com.example.Scott.entity.HoaDon;
import com.example.Scott.entity.HoaDonChiTiet;
import com.example.Scott.entity.ThanhToanHoaDon;
import com.example.Scott.responsitory.HoaDonRepo;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import org.apache.poi.ss.usermodel.*;
import org.apache.poi.xssf.usermodel.XSSFWorkbook;

import java.io.IOException;
import java.io.OutputStream;
import java.util.List;

@WebServlet("/quanlyhoadon")
public class HoaDonServlet extends HttpServlet {
    private final HoaDonRepo hoaDonRepo = new HoaDonRepo();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        req.setCharacterEncoding("UTF-8");
        resp.setCharacterEncoding("UTF-8");

        String action = req.getParameter("action");
        if (action == null) action = "list";

        switch (action) {
            case "list":
                listInvoices(req, resp);
                break;
            case "search":
                // Live search (AJAX): trả về fragment bảng, không render lại cả trang.
                liveSearchInvoices(req, resp);
                break;
            case "detail":
                showDetail(req, resp);
                break;
            case "receipt":
                showReceipt(req, resp);
                break;
//            case "delete":
//                deleteInvoice(req, resp);
//                break;
            case "export":
                exportExcel(req, resp);
                break;
            default:
                listInvoices(req, resp);
        }
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        req.setCharacterEncoding("UTF-8");
        resp.setCharacterEncoding("UTF-8");

        String action = req.getParameter("action");
        resp.sendError(HttpServletResponse.SC_METHOD_NOT_ALLOWED, "Màn hình hóa đơn chỉ cho phép xem dữ liệu");
    }

    private void listInvoices(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        // Tự động hủy các hóa đơn "Chờ xử lý" đã bị giữ quá 24h, trước khi tải danh sách,
        // để đảm bảo màn hình luôn phản ánh đúng quy tắc: hóa đơn chờ quá hạn -> Đã hủy.
        hoaDonRepo.huyCacHoaDonChoQuaHan();
        naplDuLieuDanhSach(req, resp);
        req.getRequestDispatcher("/views/hoadon/hoa-don.jsp").forward(req, resp);
    }

    /**
     * Live search (gọi bằng AJAX từ ô tìm kiếm/ngày trên màn Quản lý hóa đơn): nạp lại danh sách
     * theo đúng bộ lọc hiện tại nhưng chỉ trả về fragment bảng + phân trang, không render lại cả trang.
     */
    private void liveSearchInvoices(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        naplDuLieuDanhSach(req, resp);
        req.getRequestDispatcher("/views/hoadon/hoa-don-table-fragment.jsp").forward(req, resp);
    }

    /**
     * Nạp dữ liệu danh sách hóa đơn theo bộ lọc (keyword/status/fromDate/toDate/page) vào request,
     * dùng chung cho cả tải trang thông thường và live search AJAX.
     */
    private void naplDuLieuDanhSach(HttpServletRequest req, HttpServletResponse resp) {
        String keyword = req.getParameter("keyword");
        String fromDate = req.getParameter("fromDate");
        String toDate = req.getParameter("toDate");
        String statusParam = req.getParameter("status");
        Integer status = null;

        if (statusParam != null && !statusParam.trim().isEmpty()) {
            try {
                status = Integer.parseInt(statusParam);
            } catch (NumberFormatException ignored) {}
        }

        // Ngày bắt đầu luôn phải nhỏ hơn ngày kết thúc: nếu dữ liệu gửi lên không hợp lệ
        // (vượt qua được kiểm tra live phía trình duyệt) thì bỏ qua bộ lọc ngày thay vì trả kết quả sai.
        if (fromDate != null && !fromDate.trim().isEmpty() && toDate != null && !toDate.trim().isEmpty()
                && fromDate.compareTo(toDate) >= 0) {
            req.setAttribute("error", "Ngày bắt đầu phải nhỏ hơn ngày kết thúc. Bộ lọc ngày đã được bỏ qua.");
            fromDate = null;
            toDate = null;
        }

        int page = 1;
        try {
            String pageParam = req.getParameter("page");
            if (pageParam != null) page = Integer.parseInt(pageParam);
        } catch (NumberFormatException ignored) {}

        int limit = 10;
        int offset = (page - 1) * limit;

        try {
            List<HoaDon> list = hoaDonRepo.getFullInvoiceListPage(keyword, status, fromDate, toDate, offset, limit);
            int totalRecords = hoaDonRepo.countFullInvoiceList(keyword, status, fromDate, toDate);
            int totalPages = (int) Math.ceil((double) totalRecords / limit);

            req.setAttribute("invoiceList", list);
            req.setAttribute("totalPages", totalPages);
            req.setAttribute("currentPage", page);
            req.setAttribute("keyword", keyword);
            req.setAttribute("status", status);
            req.setAttribute("fromDate", fromDate);
            req.setAttribute("toDate", toDate);

            // Các chỉ số thống kê nhanh
            req.setAttribute("totalOrdersToday", hoaDonRepo.getTotalOrdersToday());
            req.setAttribute("revenueToday", hoaDonRepo.getTotalRevenueToday());
            req.setAttribute("pending", hoaDonRepo.getPendingOrders());
            req.setAttribute("cancelled", hoaDonRepo.getCancelledOrders());
            req.setAttribute("menu", "quanlyhoadon");

        } catch (Exception e) {
            e.printStackTrace();
            req.setAttribute("error", "Lỗi hệ thống khi tải dữ liệu: " + e.getMessage());
        }
        req.setAttribute("menu", "quanlyhoadon");
    }

    private void showDetail(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        String idParam = req.getParameter("id");
        if (idParam == null || idParam.isEmpty()) {
            req.setAttribute("error", "Thiếu mã hóa đơn cần xem!");
            listInvoices(req, resp);
            return;
        }
        try {
            int id = Integer.parseInt(idParam);
            HoaDon hd = hoaDonRepo.getById(id);
            if (hd == null) {
                req.setAttribute("error", "Không tìm thấy thông tin chi tiết hóa đơn!");
                listInvoices(req, resp);
                return;
            }
            if (hd.getTrangThai() != null && hd.getTrangThai() == 0) {
                // Hóa đơn đang "Chờ xử lý" chỉ được quản lý bên màn Bán hàng tại quầy.
                req.setAttribute("error", "Hóa đơn " + hd.getMaHoaDon() + " đang ở trạng thái Chờ xử lý tại quầy, vui lòng quản lý tại màn hình Bán hàng tại quầy.");
                listInvoices(req, resp);
                return;
            }
            List<HoaDonChiTiet> details = hoaDonRepo.getChiTietByHoaDonId(id);
            List<ThanhToanHoaDon> payments = hoaDonRepo.getThanhToanByHoaDonId(id);

            // Tính tổng tiền hàng gốc (trước giảm) từ chi tiết, và số tiền đã giảm so với hóa đơn,
            // để hiển thị đầy đủ trên form in hóa đơn (giống hóa đơn giấy: Tổng tiền / Tiền giảm / Phải thu).
            double tienHangGoc = 0;
            int tongSoLuong = 0;
            for (HoaDonChiTiet ct : details) {
                if (ct.getTongTien() != null) tienHangGoc += ct.getTongTien();
                if (ct.getSoLuong() != null) tongSoLuong += ct.getSoLuong();
            }
            hd.setSoLuongSanPham(tongSoLuong);
            double tongThanhToan = hd.getTongTienThanhToan() == null ? 0 : hd.getTongTienThanhToan();
            hd.setTienHangGoc(tienHangGoc);
            hd.setTienGiam(Math.max(0, tienHangGoc - tongThanhToan));

            // Tiền khách đưa/thối lại (chỉ có khi thanh toán tiền mặt) được ghi kèm trong ghi chú
            // của bản ghi thanh toán dạng "Thanh toán tiền mặt. Khách đưa: X - Trả lại: Y"
            // (xem HoaDonRepo#taoHoaDonBanHang) — không có cột riêng trong DB nên phải đọc lại từ đây.
            for (ThanhToanHoaDon p : payments) {
                if (p.getGhiChu() != null && p.getGhiChu().contains("Khách đưa:")) {
                    java.util.regex.Matcher m = java.util.regex.Pattern
                            .compile("Khách đưa:\\s*([-\\d.]+)\\s*-\\s*Trả lại:\\s*([-\\d.]+)")
                            .matcher(p.getGhiChu());
                    if (m.find()) {
                        try {
                            hd.setTienKhachDua(Double.parseDouble(m.group(1)));
                            hd.setTienThua(Double.parseDouble(m.group(2)));
                        } catch (NumberFormatException ignored) { }
                    }
                    break;
                }
            }

            req.setAttribute("invoice", hd);
            req.setAttribute("menu", "quanlyhoadon");
            req.setAttribute("details", details);
            req.setAttribute("histories", hoaDonRepo.getLichSuByHoaDonId(id));
            req.setAttribute("payments", payments);
            req.getRequestDispatcher("/views/hoadon/hoa-don-detail.jsp").forward(req, resp);
        } catch (NumberFormatException e) {
            req.setAttribute("error", "Mã hóa đơn yêu cầu định dạng số bất hợp lệ!");
            listInvoices(req, resp);
        }
    }


    /**
     * Trả về riêng mẫu hóa đơn in nhiệt để nhúng vào modal/iframe.
     * Không render sidebar và không chuyển sang trang chi tiết đầy đủ.
     */
    private void showReceipt(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        String idParam = req.getParameter("id");
        if (idParam == null || idParam.trim().isEmpty()) {
            resp.sendError(HttpServletResponse.SC_BAD_REQUEST, "Thiếu mã hóa đơn.");
            return;
        }

        try {
            int id = Integer.parseInt(idParam);
            HoaDon hd = hoaDonRepo.getById(id);
            if (hd == null) {
                resp.sendError(HttpServletResponse.SC_NOT_FOUND, "Không tìm thấy hóa đơn.");
                return;
            }

            if (hd.getTrangThai() != null && hd.getTrangThai() == 0) {
                resp.sendError(HttpServletResponse.SC_BAD_REQUEST, "Hóa đơn đang chờ xử lý, chưa thể in.");
                return;
            }

            List<HoaDonChiTiet> details = hoaDonRepo.getChiTietByHoaDonId(id);
            List<ThanhToanHoaDon> payments = hoaDonRepo.getThanhToanByHoaDonId(id);

            double tienHangGoc = 0;
            int tongSoLuong = 0;
            for (HoaDonChiTiet ct : details) {
                if (ct.getTongTien() != null) tienHangGoc += ct.getTongTien();
                if (ct.getSoLuong() != null) tongSoLuong += ct.getSoLuong();
            }

            hd.setSoLuongSanPham(tongSoLuong);
            double tongThanhToan = hd.getTongTienThanhToan() == null ? 0 : hd.getTongTienThanhToan();
            hd.setTienHangGoc(tienHangGoc);
            hd.setTienGiam(Math.max(0, tienHangGoc - tongThanhToan));

            for (ThanhToanHoaDon p : payments) {
                if (p.getGhiChu() != null && p.getGhiChu().contains("Khách đưa:")) {
                    java.util.regex.Matcher m = java.util.regex.Pattern
                            .compile("Khách đưa:\\s*([-\\d.]+)\\s*-\\s*Trả lại:\\s*([-\\d.]+)")
                            .matcher(p.getGhiChu());
                    if (m.find()) {
                        try {
                            hd.setTienKhachDua(Double.parseDouble(m.group(1)));
                            hd.setTienThua(Double.parseDouble(m.group(2)));
                        } catch (NumberFormatException ignored) { }
                    }
                    break;
                }
            }

            req.setAttribute("invoice", hd);
            req.setAttribute("details", details);
            req.setAttribute("payments", payments);
            req.getRequestDispatcher("/views/hoadon/hoa-don-receipt.jsp").forward(req, resp);
        } catch (NumberFormatException e) {
            resp.sendError(HttpServletResponse.SC_BAD_REQUEST, "Mã hóa đơn không hợp lệ.");
        }
    }

//    private void deleteInvoice(HttpServletRequest req, HttpServletResponse resp) throws IOException {
//        try {
//            String idStr = req.getParameter("id");
//            if (idStr != null) {
//                int id = Integer.parseInt(idStr);
//                boolean success = hoaDonRepo.softDeleteInvoice(id);
//                if (success) {
//                    req.getSession().setAttribute("message", "Hóa đơn đã được chuyển vào trạng thái Xóa mềm!");
//                } else {
//                    req.getSession().setAttribute("error", "Thực hiện xóa hóa đơn không thành công!");
//                }
//            }
//        } catch (NumberFormatException e) {
//            req.getSession().setAttribute("error", "Mã ID hóa đơn không hợp lệ!");
//        }
//        resp.sendRedirect(req.getContextPath() + "/quanlyhoadon");
//    }

    private void exportExcel(HttpServletRequest req, HttpServletResponse resp) throws IOException {
        String keyword = req.getParameter("keyword");
        String fromDate = req.getParameter("fromDate");
        String toDate = req.getParameter("toDate");
        String statusParam = req.getParameter("status");
        Integer status = null;
        if (statusParam != null && !statusParam.isEmpty()) {
            try {
                status = Integer.parseInt(statusParam);
            } catch (NumberFormatException ignored) {}
        }

        List<HoaDon> list = hoaDonRepo.getAllInvoicesForExport(keyword, status, fromDate, toDate);

        // Sử dụng Try-with-resources để tự động giải phóng tài nguyên Workbook tránh rò rỉ bộ nhớ
        try (Workbook workbook = new XSSFWorkbook()) {
            Sheet sheet = workbook.createSheet("Danh Sách Hóa Đơn");
            int rowIdx = 0;

            // Thiết lập font đậm cho Header
            Font headerFont = workbook.createFont();
            headerFont.setBold(true);
            CellStyle headerCellStyle = workbook.createCellStyle();
            headerCellStyle.setFont(headerFont);

            // Tạo Header
            Row header = sheet.createRow(rowIdx++);
            String[] columns = {"Mã HD", "Khách hàng", "Nhân viên", "Ngày tạo", "Ngày thanh toán", "Tổng tiền", "Voucher", "Trạng thái", "Ghi chú"};
            for (int i = 0; i < columns.length; i++) {
                Cell cell = header.createCell(i);
                cell.setCellValue(columns[i]);
                cell.setCellStyle(headerCellStyle);
            }

            // Điền dữ liệu
            for (HoaDon hd : list) {
                Row row = sheet.createRow(rowIdx++);
                row.createCell(0).setCellValue(hd.getMaHoaDon());
                row.createCell(1).setCellValue(hd.getTenKhachHang() != null ? hd.getTenKhachHang() : "Khách vãng lai");
                row.createCell(2).setCellValue(hd.getTenNhanVien());
                row.createCell(3).setCellValue(hd.getNgayTao() != null ? hd.getNgayTao().toString() : "");
                row.createCell(4).setCellValue(hd.getNgayThanhToan() != null ? hd.getNgayThanhToan().toString() : "");
                row.createCell(5).setCellValue(hd.getTongTienThanhToan());
                row.createCell(6).setCellValue(hd.getMaVoucher() != null ? hd.getMaVoucher() : "");
                row.createCell(7).setCellValue(mapStatusText(hd.getTrangThai()));
                row.createCell(8).setCellValue(hd.getGhiChu() != null ? hd.getGhiChu() : "");
            }

            // Tự động căn chỉnh độ rộng cột gọn gàng
            for (int i = 0; i < columns.length; i++) {
                sheet.autoSizeColumn(i);
            }

            // Thiết lập đúng định dạng phản hồi File Excel
            resp.setContentType("application/vnd.openxmlformats-officedocument.spreadsheetml.sheet");
            resp.setHeader("Content-Disposition", "attachment; filename=danh_sach_hoa_don.xlsx");

            try (OutputStream out = resp.getOutputStream()) {
                workbook.write(out);
                out.flush(); // Đẩy dữ liệu đi hoàn toàn
            }
        } catch (Exception e) {
            e.printStackTrace();
            // Chỉ redirect khi Response chưa commit để tránh IllegalStateException
            if (!resp.isCommitted()) {
                req.getSession().setAttribute("error", "Xuất dữ liệu Excel thất bại: " + e.getMessage());
                resp.sendRedirect(req.getContextPath() + "/quanlyhoadon");
            }
        }
    }

    private String mapStatusText(int status) {
        switch (status) {
            case 0: return "Chờ xử lý";
            case 1: return "Đã thanh toán";
            case 2: return "Đã hủy";
            case 3: return "Đã xóa (Mềm)";
            default: return "Không xác định";
        }
    }
}
