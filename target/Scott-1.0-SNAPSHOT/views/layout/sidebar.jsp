<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
<link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.css" rel="stylesheet">
<link href="${pageContext.request.contextPath}/assets/css/style.css?v=mono3" rel="stylesheet">
<aside class="admin-sidebar" id="adminSidebar" aria-label="Điều hướng quản trị">
    <div class="admin-sidebar__brand">
        <div class="admin-sidebar__logo-wrap">
            <img src="${pageContext.request.contextPath}/assets/images/scott-logo.png" alt="Scott">
        </div>
        <div class="admin-sidebar__brand-copy">
            <span class="admin-sidebar__brand-name">SCOTT ADMIN</span>
            <span class="admin-sidebar__brand-subtitle">Quản trị hệ thống</span>
        </div>
        <button type="button" class="admin-sidebar__toggle" id="adminSidebarToggle"
                aria-label="Thu gọn hoặc mở rộng thanh menu" aria-expanded="true">
            <i class="bi bi-chevron-left"></i>
        </button>
    </div>

    <nav class="admin-sidebar__nav">
        <div class="admin-sidebar__section-label">Tổng quan</div>

        <a href="${pageContext.request.contextPath}/ban-hang-tai-quay"
           class="admin-sidebar__item ${menu == 'banhang' ? 'active' : ''}"
           data-sidebar-tooltip="Bán hàng tại quầy">
            <span class="admin-sidebar__icon"><i class="bi bi-cart-check"></i></span>
            <span class="admin-sidebar__label">Bán hàng tại quầy</span>
        </a>

        <c:if test="${fn:toLowerCase(sessionScope.user.nhanVien.chucVu) == 'admin'}">
            <a href="${pageContext.request.contextPath}/dashboard"
               class="admin-sidebar__item ${menu == 'dashboard' ? 'active' : ''}"
               data-sidebar-tooltip="Thống kê">
                <span class="admin-sidebar__icon"><i class="bi bi-grid-1x2"></i></span>
                <span class="admin-sidebar__label">Thống kê</span>
            </a>
        </c:if>

        <a href="${pageContext.request.contextPath}/quanlyhoadon"
           class="admin-sidebar__item ${menu == 'quanlyhoadon' ? 'active' : ''}"
           data-sidebar-tooltip="Quản lý hóa đơn">
            <span class="admin-sidebar__icon"><i class="bi bi-receipt-cutoff"></i></span>
            <span class="admin-sidebar__label">Quản lý hóa đơn</span>
        </a>

        <div class="admin-sidebar__section-label mt-3">Kinh doanh</div>

        <div class="admin-sidebar__group ${menu == 'sanpham' ? 'open' : ''}"
             id="adminProductMenu" data-active="${menu == 'sanpham'}">
            <button type="button"
                    class="admin-sidebar__group-toggle ${menu == 'sanpham' ? 'active' : ''}"
                    data-sidebar-submenu-toggle data-sidebar-tooltip="Quản lý sản phẩm"
                    aria-controls="adminProductSubmenu" aria-expanded="${menu == 'sanpham'}">
                <span class="admin-sidebar__icon"><i class="bi bi-box-seam"></i></span>
                <span class="admin-sidebar__label">Quản lý sản phẩm</span>
                <span class="admin-sidebar__caret"><i class="bi bi-chevron-down"></i></span>
            </button>
            <div class="admin-sidebar__submenu" id="adminProductSubmenu">
                <a href="${pageContext.request.contextPath}/san-pham/hien-thi"
                   class="admin-sidebar__item ${menu == 'sanpham' && submenu != 'bienthe' ? 'active' : ''}"
                   data-sidebar-tooltip="Danh sách sản phẩm">
                    <span class="admin-sidebar__icon"><i class="bi bi-list-ul"></i></span>
                    <span class="admin-sidebar__label">Danh sách sản phẩm</span>
                </a>
                <a href="${pageContext.request.contextPath}/san-pham/chi-tiet/hien-thi"
                   class="admin-sidebar__item ${submenu == 'bienthe' ? 'active' : ''}"
                   data-sidebar-tooltip="Biến thể sản phẩm">
                    <span class="admin-sidebar__icon"><i class="bi bi-layers"></i></span>
                    <span class="admin-sidebar__label">Biến thể sản phẩm</span>
                </a>
            </div>
        </div>

        <a href="${pageContext.request.contextPath}/thuoc-tinh/hien-thi?type=danh-muc"
           class="admin-sidebar__item ${menu == 'thuoctinh' ? 'active' : ''}"
           data-sidebar-tooltip="Thuộc tính sản phẩm">
            <span class="admin-sidebar__icon"><i class="bi bi-sliders2"></i></span>
            <span class="admin-sidebar__label">Thuộc tính sản phẩm</span>
        </a>

        <a href="${pageContext.request.contextPath}/phieugiamgia/hien-thi"
           class="admin-sidebar__item ${menu == 'phieugiamgia' ? 'active' : ''}"
           data-sidebar-tooltip="Phiếu giảm giá">
            <span class="admin-sidebar__icon"><i class="bi bi-ticket-perforated"></i></span>
            <span class="admin-sidebar__label">Phiếu giảm giá</span>
        </a>

        <div class="admin-sidebar__section-label mt-3">Hệ thống</div>

        <a href="${pageContext.request.contextPath}/khachhang/hien-thi"
           class="admin-sidebar__item ${menu == 'khachhang' ? 'active' : ''}"
           data-sidebar-tooltip="Khách hàng">
            <span class="admin-sidebar__icon"><i class="bi bi-people"></i></span>
            <span class="admin-sidebar__label">Khách hàng</span>
        </a>

        <c:if test="${fn:toLowerCase(sessionScope.user.nhanVien.chucVu) == 'admin'}">
            <a href="${pageContext.request.contextPath}/nhan-vien/hien-thi"
               class="admin-sidebar__item ${menu == 'nhanvien' ? 'active' : ''}"
               data-sidebar-tooltip="Nhân viên">
                <span class="admin-sidebar__icon"><i class="bi bi-person-badge"></i></span>
                <span class="admin-sidebar__label">Nhân viên</span>
            </a>
        </c:if>
    </nav>

    <div class="admin-sidebar__footer">
        <div class="admin-sidebar__profile">
            <div class="admin-sidebar__avatar">A</div>
            <div class="admin-sidebar__profile-copy">
                <strong>${not empty sessionScope.user.nhanVien.hoTen ? sessionScope.user.nhanVien.hoTen : sessionScope.user.tenDangNhap}</strong>
                <small>${not empty sessionScope.user.nhanVien.chucVu ? sessionScope.user.nhanVien.chucVu : 'Scott Fashion'}</small>
            </div>
        </div>
        <a href="${pageContext.request.contextPath}/logout"
           class="admin-sidebar__item" data-sidebar-tooltip="Đăng xuất"
           style="margin-top:8px;">
            <span class="admin-sidebar__icon"><i class="bi bi-box-arrow-right"></i></span>
            <span class="admin-sidebar__label">Đăng xuất</span>
        </a>
    </div>
</aside>

<script src="${pageContext.request.contextPath}/assets/js/main.js?v=mono3" defer></script>
