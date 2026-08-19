package com.example.Scott.filter;

import com.example.Scott.entity.NhanVien;
import com.example.Scott.entity.TaiKhoan;
import jakarta.servlet.Filter;
import jakarta.servlet.FilterChain;
import jakarta.servlet.FilterConfig;
import jakarta.servlet.ServletException;
import jakarta.servlet.ServletRequest;
import jakarta.servlet.ServletResponse;
import jakarta.servlet.annotation.WebFilter;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;

/**
 * AUTHENTICATION + AUTHORIZATION
 *
 * QUYỀN:
 *
 * 1. ADMIN
 *    - Được truy cập toàn bộ hệ thống.
 *
 * 2. NHÂN VIÊN
 *    - Chỉ được truy cập:
 *      + Bán hàng tại quầy
 *      + Khách hàng
 *      + Quản lý hóa đơn
 *
 * 3. Chưa đăng nhập
 *    - Chuyển về /login
 */
@WebFilter("/*")
public class AuthFilter implements Filter {

    /**
     * Những URL không cần đăng nhập.
     */
    private static final String[] PUBLIC_PATHS = {
            "/login",
            "/assets/",
            "/assets.jsp",
            "/logo.png",
            "/index.jsp"
    };

    /**
     * Những URL nhân viên được phép sử dụng.
     *
     * Admin không bị giới hạn bởi danh sách này.
     */
    private static final String[] EMPLOYEE_ALLOWED_PATHS = {

            // =========================
            // BÁN HÀNG TẠI QUẦY
            // =========================
            "/ban-hang-tai-quay",

            // =========================
            // KHÁCH HÀNG
            // =========================
            "/khachhang/",

            // =========================
            // HÓA ĐƠN
            // =========================
            "/quanlyhoadon",

            // =========================
            // ĐĂNG XUẤT
            // Nếu project dùng URL này
            // =========================
            "/logout",
            "/dang-xuat"
    };

    @Override
    public void init(FilterConfig filterConfig) {
    }

    @Override
    public void doFilter(
            ServletRequest req,
            ServletResponse res,
            FilterChain chain
    ) throws IOException, ServletException {

        HttpServletRequest request =
                (HttpServletRequest) req;

        HttpServletResponse response =
                (HttpServletResponse) res;

        String contextPath =
                request.getContextPath();

        String uri =
                request.getRequestURI();

        String path =
                uri.substring(contextPath.length());

        if (path == null || path.isEmpty()) {
            path = "/";
        }

        // =====================================================
        // 1. PUBLIC URL
        // =====================================================
        if (isPublicPath(path)) {
            chain.doFilter(req, res);
            return;
        }

        // =====================================================
        // 2. KIỂM TRA ĐĂNG NHẬP
        // =====================================================
        HttpSession session =
                request.getSession(false);

        TaiKhoan user =
                session != null
                        ? (TaiKhoan) session.getAttribute("user")
                        : null;

        if (user == null) {

            response.sendRedirect(
                    contextPath + "/login"
            );

            return;
        }

        // =====================================================
        // 3. ADMIN -> ĐƯỢC TRUY CẬP TOÀN BỘ
        // =====================================================
        if (isAdmin(user)) {

            chain.doFilter(req, res);
            return;
        }

        // =====================================================
        // 4. NHÂN VIÊN -> CHỈ ĐƯỢC 3 KHU VỰC
        // =====================================================
        if (isEmployee(user)) {

            if (isEmployeeAllowedPath(path)) {

                chain.doFilter(req, res);
                return;
            }

            // Nhân viên truy cập URL ngoài quyền
            // -> chuyển về Bán hàng tại quầy
            response.sendRedirect(
                    contextPath + "/ban-hang-tai-quay"
            );

            return;
        }

        // =====================================================
        // 5. ROLE KHÔNG XÁC ĐỊNH
        // =====================================================
        request.setAttribute(
                "error",
                "Bạn không có quyền truy cập chức năng này."
        );

        request.getRequestDispatcher(
                "/access-denied.jsp"
        ).forward(request, response);
    }

    /**
     * URL public.
     */
    private boolean isPublicPath(String path) {

        for (String p : PUBLIC_PATHS) {

            if (path.equals(p)
                    || path.startsWith(p)) {

                return true;
            }
        }

        return false;
    }

    /**
     * Kiểm tra URL nhân viên được phép truy cập.
     */
    private boolean isEmployeeAllowedPath(
            String path
    ) {

        for (String p : EMPLOYEE_ALLOWED_PATHS) {

            if (path.equals(p)
                    || path.startsWith(p)) {

                return true;
            }
        }

        return false;
    }

    /**
     * ADMIN
     */
    private boolean isAdmin(TaiKhoan user) {

        if (user == null) {
            return false;
        }

        NhanVien nv =
                user.getNhanVien();

        if (nv == null
                || nv.getChucVu() == null) {

            return false;
        }

        return "Admin".equalsIgnoreCase(
                nv.getChucVu().trim()
        );
    }

    /**
     * NHÂN VIÊN.
     *
     * Tất cả tài khoản có nhân viên nhưng không phải Admin
     * được coi là Nhân viên thường.
     */
    private boolean isEmployee(TaiKhoan user) {

        if (user == null) {
            return false;
        }

        NhanVien nv =
                user.getNhanVien();

        if (nv == null) {
            return false;
        }

        return !isAdmin(user);
    }

    @Override
    public void destroy() {
    }
}