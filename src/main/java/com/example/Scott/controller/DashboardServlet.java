package com.example.Scott.controller;

import com.example.Scott.dto.DoanhThuDiemDTO;
import com.example.Scott.dto.ThongKePeriodDTO;
import com.example.Scott.dto.ThongKeSanPhamDTO;
import com.example.Scott.entity.DanhMuc;
import com.example.Scott.entity.ThuongHieu;
import com.example.Scott.responsitory.HoaDonRepo;
import com.example.Scott.responsitory.SanPhamResponsitory;
import com.example.Scott.responsitory.ThongKeRepo;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;
import java.time.DayOfWeek;
import java.time.LocalDate;
import java.time.format.DateTimeFormatter;
import java.util.List;
import java.util.Map;

@WebServlet(name = "DashboardServlet", value = "/dashboard")
public class DashboardServlet extends HttpServlet {

    private final HoaDonRepo hoaDonRepo = new HoaDonRepo();
    private final ThongKeRepo thongKeRepo = new ThongKeRepo();
    private final SanPhamResponsitory sanPhamRepo = new SanPhamResponsitory();

    private static final DateTimeFormatter ISO = DateTimeFormatter.ISO_LOCAL_DATE;

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");
        response.setCharacterEncoding("UTF-8");
        request.setAttribute("menu", "dashboard");

        LocalDate today = LocalDate.now();

        // ---------- 1. Khoảng thời gian & kiểu nhóm dữ liệu cho biểu đồ ----------
        String groupBy = clean(request.getParameter("groupBy"), "day");
        String fromParam = request.getParameter("fromDate");
        String toParam = request.getParameter("toDate");

        boolean customRange = notEmpty(fromParam) && notEmpty(toParam);
        LocalDate from = customRange ? parseDate(fromParam, today) : today;
        LocalDate to = customRange ? parseDate(toParam, today) : today;
        if (from.isAfter(to)) { // hoán đổi nếu người dùng chọn ngược
            LocalDate tmp = from; from = to; to = tmp;
        }
        String fromStr = from.format(ISO);
        String toStr = to.format(ISO);

        request.setAttribute("customRange", customRange);
        request.setAttribute("fromDate", fromStr);
        request.setAttribute("toDate", toStr);
        request.setAttribute("groupBy", groupBy);
        request.setAttribute("todayLabel", today.format(ISO));

        // ---------- 2. Thẻ tổng quan theo khoảng thời gian đã chọn ----------
        int tongDonHang = hoaDonRepo.getOrderCountBetween(fromStr, toStr, null);
        double tongDoanhThu = hoaDonRepo.getRevenueSum(fromStr, toStr, null);
        double doanhThuThucTe = hoaDonRepo.getRevenueSum(fromStr, toStr, 1);
        double doanhThuDuKien = tongDoanhThu; // đơn chưa hủy/xóa, kể cả đang chờ thanh toán
        request.setAttribute("tongDonHang", tongDonHang);
        request.setAttribute("tongDoanhThu", tongDoanhThu);
        request.setAttribute("doanhThuThucTe", doanhThuThucTe);
        request.setAttribute("doanhThuDuKien", doanhThuDuKien);

        // ---------- 3. Thẻ nhanh: Hôm nay / Tuần này / Tháng này / Năm nay ----------
        ThongKePeriodDTO homNay = buildPeriod("Hôm nay", today, today, today.minusDays(1), today.minusDays(1));
        ThongKePeriodDTO tuanNay = buildPeriod("Tuần này",
                today.with(DayOfWeek.MONDAY), today,
                today.with(DayOfWeek.MONDAY).minusWeeks(1), today.with(DayOfWeek.MONDAY).minusDays(1));
        ThongKePeriodDTO thangNay = buildPeriod("Tháng này",
                today.withDayOfMonth(1), today,
                today.withDayOfMonth(1).minusMonths(1), today.withDayOfMonth(1).minusDays(1));
        ThongKePeriodDTO namNay = buildPeriod("Năm nay",
                today.withDayOfYear(1), today,
                today.withDayOfYear(1).minusYears(1), today.withDayOfYear(1).minusDays(1));

        request.setAttribute("homNay", homNay);
        request.setAttribute("tuanNay", tuanNay);
        request.setAttribute("thangNay", thangNay);
        request.setAttribute("namNay", namNay);
        request.setAttribute("bangThongKe", List.of(homNay, tuanNay, thangNay, namNay));

        // ---------- 4. Biểu đồ doanh thu theo thời gian ----------
        List<DoanhThuDiemDTO> chartData = hoaDonRepo.getRevenueSeries(fromStr, toStr, groupBy);
        request.setAttribute("chartData", chartData);

        // ---------- 5. Phân bố trạng thái đơn hàng ----------
        // Dùng các thuộc tính int riêng lẻ (thay vì Map<Integer,...>) để tránh lỗi EL
        // so sánh khóa Integer với literal số nguyên (mặc định EL coi literal số là Long).
        Map<Integer, Integer> statusDist = hoaDonRepo.getStatusDistribution(fromStr, toStr);
        request.setAttribute("soChoXuLy", statusDist.getOrDefault(0, 0));
        request.setAttribute("soDaThanhToan", statusDist.getOrDefault(1, 0));
        request.setAttribute("soDaHuy", statusDist.getOrDefault(2, 0));
        request.setAttribute("soDaXoa", statusDist.getOrDefault(3, 0));

        // ---------- 6. Top sản phẩm bán chạy (30 ngày gần nhất) ----------
        LocalDate top30From = today.minusDays(29);
        List<ThongKeSanPhamDTO> topSelling = thongKeRepo.getTopSellingProducts(top30From.format(ISO), today.format(ISO), 10);
        request.setAttribute("topSelling", topSelling);
        request.setAttribute("top30From", top30From.format(ISO));
        request.setAttribute("top30To", today.format(ISO));

        // ---------- 7. Thống kê tồn kho quý hiện tại (có bộ lọc) ----------
        Integer brandId = parseIntOrNull(request.getParameter("brand"));
        Integer categoryId = parseIntOrNull(request.getParameter("category"));
        Integer invStatus = parseIntOrNull(request.getParameter("invStatus"));

        int quarterIndex = (today.getMonthValue() - 1) / 3; // 0..3
        LocalDate quarterStart = LocalDate.of(today.getYear(), quarterIndex * 3 + 1, 1);
        LocalDate quarterEnd = quarterStart.plusMonths(3).minusDays(1);

        List<ThongKeSanPhamDTO> inventory = thongKeRepo.getInventoryStats(
                brandId, categoryId, invStatus, quarterStart.format(ISO), quarterEnd.format(ISO));
        request.setAttribute("inventory", inventory);
        request.setAttribute("quarterStart", quarterStart.format(ISO));
        request.setAttribute("quarterEnd", quarterEnd.format(ISO));
        request.setAttribute("brandId", brandId);
        request.setAttribute("categoryId", categoryId);
        request.setAttribute("invStatus", invStatus);

        List<ThuongHieu> brands = sanPhamRepo.getAllThuongHieu();
        List<DanhMuc> categories = sanPhamRepo.getAllDanhMuc();
        request.setAttribute("brands", brands);
        request.setAttribute("categories", categories);

        request.getRequestDispatcher("/dashboard.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        doGet(request, response);
    }

    /**
     * Tính số liệu tổng hợp cho 1 khoảng [from, to], so sánh tăng trưởng doanh thu với khoảng liền trước [prevFrom, prevTo].
     */
    private ThongKePeriodDTO buildPeriod(String nhan, LocalDate from, LocalDate to,
                                         LocalDate prevFrom, LocalDate prevTo) {
        String fromStr = from.format(ISO);
        String toStr = to.format(ISO);

        double doanhThu = hoaDonRepo.getRevenueSum(fromStr, toStr, 1);
        int soDon = hoaDonRepo.getOrderCountBetween(fromStr, toStr, null);
        int soSanPham = hoaDonRepo.getDistinctProductCountBetween(fromStr, toStr);

        double doanhThuTruoc = hoaDonRepo.getRevenueSum(prevFrom.format(ISO), prevTo.format(ISO), 1);
        double tangTruong;
        if (doanhThuTruoc <= 0) {
            tangTruong = doanhThu > 0 ? 100.0 : 0.0;
        } else {
            tangTruong = (doanhThu - doanhThuTruoc) * 100.0 / doanhThuTruoc;
        }

        double giaTriTB = soDon == 0 ? 0.0 : doanhThu / soDon;

        return new ThongKePeriodDTO(nhan, doanhThu, soDon, soSanPham, giaTriTB, tangTruong);
    }

    private boolean notEmpty(String s) {
        return s != null && !s.trim().isEmpty();
    }

    private String clean(String s, String fallback) {
        return notEmpty(s) ? s.trim() : fallback;
    }

    private LocalDate parseDate(String s, LocalDate fallback) {
        try {
            return LocalDate.parse(s.trim());
        } catch (Exception e) {
            return fallback;
        }
    }

    private Integer parseIntOrNull(String s) {
        if (!notEmpty(s)) return null;
        try {
            return Integer.parseInt(s.trim());
        } catch (NumberFormatException e) {
            return null;
        }
    }
}
