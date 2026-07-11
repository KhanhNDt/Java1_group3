package com.example.Scott.controller;

import com.example.Scott.entity.HoaDon;
import com.example.Scott.entity.HoaDonChiTiet;
import com.example.Scott.responsitory.HoaDonRepo;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import org.apache.poi.ss.usermodel.Cell;
import org.apache.poi.ss.usermodel.Row;
import org.apache.poi.ss.usermodel.Sheet;
import org.apache.poi.ss.usermodel.Workbook;
import org.apache.poi.xssf.usermodel.XSSFWorkbook;

import java.io.IOException;
import java.util.List;

@WebServlet("/quanlyhoadon")
public class HoaDonServlet  extends HttpServlet {
    private HoaDonRepo hoaDonRepo = new HoaDonRepo();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        String action = req.getParameter("action");
        if (action == null) action = "list";

        switch (action) {
            case "list":
                listInvoices(req, resp);
                break;
            case "detail":
                showDetail(req, resp);
                break;
            case "updateStatus":
                updateStatus(req, resp);
                break;
            case "delete":
                deleteInvoice(req, resp);
                break;
            case "export":
                exportExcel(req, resp);
                break;
            default:
                listInvoices(req, resp);
        }
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        String action = req.getParameter("action");
        if ("updateNote".equals(action)) {
            int id = Integer.parseInt(req.getParameter("id"));
            String note = req.getParameter("note");
            boolean success = hoaDonRepo.updateGhiChu(id, note);
            if (success) {
                req.getSession().setAttribute("message", "Cập nhật ghi chú thành công!");
            } else {
                req.getSession().setAttribute("error", "Cập nhật ghi chú thất bại!");
            }
            resp.sendRedirect(req.getContextPath() + "/quanlyhoadon?action=detail&id=" + id);
        }
    }

    private void listInvoices(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        String keyword = req.getParameter("keyword");
        String statusParam = req.getParameter("status");
        Integer status = null;
        if (statusParam != null && !statusParam.isEmpty()) {
            try {
                status = Integer.parseInt(statusParam);
            } catch (NumberFormatException e) {
                // ignore
            }
        }
        int page = 1;
        try {
            page = Integer.parseInt(req.getParameter("page"));
        } catch (NumberFormatException ignored) {}

        int limit = 10;
        int offset = (page - 1) * limit;

        try {
            List<HoaDon> list = hoaDonRepo.getFullInvoiceListPage(keyword, status, offset, limit);
            int totalRecords = hoaDonRepo.countFullInvoiceList(keyword, status);
            int totalPages = (int) Math.ceil((double) totalRecords / limit);

            req.setAttribute("invoiceList", list);
            req.setAttribute("totalPages", totalPages);
            req.setAttribute("currentPage", page);
            req.setAttribute("keyword", keyword);
            req.setAttribute("status", status);
            req.setAttribute("totalOrdersToday", hoaDonRepo.getTotalOrdersToday());
            req.setAttribute("revenueToday", hoaDonRepo.getTotalRevenueToday());
            req.setAttribute("pending", hoaDonRepo.getPendingOrders());
            req.setAttribute("cancelled", hoaDonRepo.getCancelledOrders());

            req.getRequestDispatcher("/views/hoadon/hoa-don.jsp").forward(req, resp);
        } catch (Exception e) {
            e.printStackTrace();
            req.setAttribute("error", "Lỗi khi tải dữ liệu: " + e.getMessage());
            req.getRequestDispatcher("/views/hoadon/hoa-don.jsp").forward(req, resp);
        }
    }

    private void showDetail(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        String idParam = req.getParameter("id");
        if (idParam == null || idParam.isEmpty()) {
            req.setAttribute("error", "Thiếu mã hóa đơn!");
            req.getRequestDispatcher("/views/hoadon/hoa-don.jsp").forward(req, resp);
            return;
        }
        try {
            int id = Integer.parseInt(idParam);
            HoaDon hd = hoaDonRepo.getById(id);
            if (hd == null) {
                req.setAttribute("error", "Không tìm thấy hóa đơn!");
                req.getRequestDispatcher("/views/hoadon/hoa-don.jsp").forward(req, resp);
                return;
            }
            List<HoaDonChiTiet> details = hoaDonRepo.getChiTietByHoaDonId(id);
            req.setAttribute("invoice", hd);
            req.setAttribute("details", details);
            req.getRequestDispatcher("/views/hoadon/hoa-don-detail.jsp").forward(req, resp);
        } catch (NumberFormatException e) {
            req.setAttribute("error", "Mã hóa đơn không hợp lệ!");
            req.getRequestDispatcher("/views/hoadon/hoa-don.jsp").forward(req, resp);
        }
    }

    private void updateStatus(HttpServletRequest req, HttpServletResponse resp) throws IOException {
        try {
            int id = Integer.parseInt(req.getParameter("id"));
            int status = Integer.parseInt(req.getParameter("status"));
            boolean success = hoaDonRepo.updateTrangThai(id, status);
            if (success) {
                req.getSession().setAttribute("message", "Cập nhật trạng thái thành công!");
            } else {
                req.getSession().setAttribute("error", "Cập nhật trạng thái thất bại!");
            }
        } catch (NumberFormatException e) {
            req.getSession().setAttribute("error", "Dữ liệu không hợp lệ!");
        }
        resp.sendRedirect(req.getContextPath() + "/quanlyhoadon");
    }

    private void deleteInvoice(HttpServletRequest req, HttpServletResponse resp) throws IOException {
        try {
            int id = Integer.parseInt(req.getParameter("id"));
            boolean success = hoaDonRepo.softDeleteInvoice(id);
            if (success) {
                req.getSession().setAttribute("message", "Đã xóa hóa đơn!");
            } else {
                req.getSession().setAttribute("error", "Xóa thất bại!");
            }
        } catch (NumberFormatException e) {
            req.getSession().setAttribute("error", "Mã hóa đơn không hợp lệ!");
        }
        resp.sendRedirect(req.getContextPath() + "/quanlyhoadon");
    }

    private void exportExcel(HttpServletRequest req, HttpServletResponse resp) throws IOException {
        String keyword = req.getParameter("keyword");
        String statusParam = req.getParameter("status");
        Integer status = null;
        if (statusParam != null && !statusParam.isEmpty()) {
            try {
                status = Integer.parseInt(statusParam);
            } catch (NumberFormatException ignored) {}
        }

        try {
            List<HoaDon> list = hoaDonRepo.getAllInvoicesForExport(keyword, status);

            Workbook workbook = new XSSFWorkbook();
            Sheet sheet = workbook.createSheet("HoaDon");
            int rowIdx = 0;

            // Header
            Row header = sheet.createRow(rowIdx++);
            String[] columns = {"Mã HD", "Khách hàng", "Nhân viên", "Ngày tạo", "Ngày thanh toán", "Tổng tiền", "Voucher", "Trạng thái", "Ghi chú"};
            for (int i = 0; i < columns.length; i++) {
                Cell cell = header.createCell(i);
                cell.setCellValue(columns[i]);
            }

            // Data
            for (HoaDon hd : list) {
                Row row = sheet.createRow(rowIdx++);
                row.createCell(0).setCellValue(hd.getMaHoaDon());
                row.createCell(1).setCellValue(hd.getTenKhachHang());
                row.createCell(2).setCellValue(hd.getTenNhanVien());
                row.createCell(3).setCellValue(hd.getNgayTao() != null ? hd.getNgayTao().toString() : "");
                row.createCell(4).setCellValue(hd.getNgayThanhToan() != null ? hd.getNgayThanhToan().toString() : "");
                row.createCell(5).setCellValue(hd.getTongTienThanhToan());
                row.createCell(6).setCellValue(hd.getMaVoucher());
                row.createCell(7).setCellValue(mapStatusText(hd.getTrangThai()));
                row.createCell(8).setCellValue(hd.getGhiChu());
            }

            for (int i = 0; i < columns.length; i++) {
                sheet.autoSizeColumn(i);
            }

            resp.setContentType("application/vnd.openxmlformats-officedocument.spreadsheetml.sheet");
            resp.setHeader("Content-Disposition", "attachment; filename=danh_sach_hoa_don.xlsx");
            workbook.write(resp.getOutputStream());
            workbook.close();
        } catch (Exception e) {
            e.printStackTrace();
            req.getSession().setAttribute("error", "Xuất Excel thất bại: " + e.getMessage());
            resp.sendRedirect(req.getContextPath() + "/quanlyhoadon");
        }
    }

    private String mapStatusText(int status) {
        switch (status) {
            case 0: return "Chờ xử lý";
            case 1: return "Đã thanh toán";
            case 2: return "Đã hủy";
            case 3: return "Đã xóa";
            default: return "Khác";
        }
    }
}
