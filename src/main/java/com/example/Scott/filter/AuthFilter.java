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
 * --------------------------------
 * 1) AUTHENTICATION: chặn mọi request chưa đăng nhập (không có "user" trong
 *    session), tự động đá về /login. Ngoại lệ: trang login, file tĩnh
 *    (css/js/ảnh...) vì các trang này phải xem được TRƯỚC khi đăng nhập.
 *
 * 2) AUTHORIZATION: khu vực "Quản lý nhân viên" (/nhan-vien/*) chỉ dành cho
 *    tài khoản có chức vụ "Admin". Nhân viên thường cố truy cập sẽ bị chặn
 *    và trả về trang 403 (access-denied.jsp), KHÔNG cho render dữ liệu.
 *
 * Filter chạy sau CharacterEncodingFilter (do đặt tên A -> C theo alphabet,
 * container sẽ nạp theo thứ tự @WebFilter khai báo trong web.xml/scan;
 * để chắc chắn thứ tự, có thể khai báo trong web.xml nếu cần).
 */
@WebFilter("/*")
public class AuthFilter implements Filter {

    // Các đường dẫn không cần đăng nhập vẫn phải truy cập được
    private static final String[] PUBLIC_PATHS = {
            "/login",
            "/assets/",
            "/assets.jsp",
            "/logo.png",
            "/index.jsp"
    };

    // Các đường dẫn chỉ Admin mới được vào
    private static final String[] ADMIN_ONLY_PATHS = {
            "/nhan-vien/"
    };

    @Override
    public void init(FilterConfig filterConfig) {
    }

    @Override
    public void doFilter(ServletRequest req, ServletResponse res, FilterChain chain)
            throws IOException, ServletException {

        HttpServletRequest request = (HttpServletRequest) req;
        HttpServletResponse response = (HttpServletResponse) res;

        String contextPath = request.getContextPath();
        String uri = request.getRequestURI();
        String path = uri.substring(contextPath.length());
        // Chuẩn hoá path rỗng ("/") thành "/index.jsp" để khớp welcome-file
        if (path.isEmpty()) {
            path = "/";
        }

        // 1) Cho qua thẳng các đường dẫn public, không cần check đăng nhập
        if (isPublicPath(path)) {
            chain.doFilter(req, res);
            return;
        }

        // 2) AUTHENTICATION: chưa đăng nhập -> đá về trang login
        HttpSession session = request.getSession(false);
        TaiKhoan user = (session != null) ? (TaiKhoan) session.getAttribute("user") : null;

        if (user == null) {
            response.sendRedirect(contextPath + "/login");
            return;
        }

        // 3) AUTHORIZATION: khu vực Admin-only
        if (isAdminOnlyPath(path) && !isAdmin(user)) {
            request.setAttribute("error", "Bạn không có quyền truy cập chức năng này.");
            request.getRequestDispatcher("/access-denied.jsp").forward(request, response);
            return;
        }

        // Hợp lệ -> cho đi tiếp
        chain.doFilter(req, res);
    }

    private boolean isPublicPath(String path) {
        for (String p : PUBLIC_PATHS) {
            if (path.equals(p) || path.startsWith(p)) {
                return true;
            }
        }
        return false;
    }

    private boolean isAdminOnlyPath(String path) {
        for (String p : ADMIN_ONLY_PATHS) {
            if (path.startsWith(p)) {
                return true;
            }
        }
        return false;
    }

    private boolean isAdmin(TaiKhoan user) {
        NhanVien nv = user.getNhanVien();
        return nv != null && "Admin".equalsIgnoreCase(nv.getChucVu());
    }

    @Override
    public void destroy() {
    }
}
