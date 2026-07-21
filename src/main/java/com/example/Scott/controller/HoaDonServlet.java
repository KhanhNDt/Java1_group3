package com.example.Scott.controller;

import com.example.Scott.entity.HoaDon;
import com.example.Scott.entity.HoaDonChiTiet;
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
            case "detail":
                showDetail(req, resp);
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
        req.getRequestDispatcher("/views/hoadon/hoa-don.jsp").forward(req, resp);
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
            List<HoaDonChiTiet> details = hoaDonRepo.getChiTietByHoaDonId(id);
            req.setAttribute("invoice", hd);
            req.setAttribute("menu", "quanlyhoadon");
            req.setAttribute("details", details);
            req.setAttribute("histories", hoaDonRepo.getLichSuByHoaDonId(id));
            req.setAttribute("payments", hoaDonRepo.getThanhToanByHoaDonId(id));
            req.getRequestDispatcher("/views/hoadon/hoa-don-detail.jsp").forward(req, resp);
        } catch (NumberFormatException e) {
            req.setAttribute("error", "Mã hóa đơn yêu cầu định dạng số bất hợp lệ!");
            listInvoices(req, resp);
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
