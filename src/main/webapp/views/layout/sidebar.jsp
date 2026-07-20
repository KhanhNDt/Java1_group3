<%@ page contentType="text/html;charset=UTF-8" language="java" %>

<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
<link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.css" rel="stylesheet">

<style>
    * {
        margin: 0;
        padding: 0;
        box-sizing: border-box;
        font-family: 'Segoe UI', sans-serif;
    }

    body {
        background: #f4f7fe;
    }
    .main-content{
        margin-left:260px !important;
        padding:25px !important;
    }
    .sidebar {
        position: fixed;
        left: 0;
        top: 0;
        width: 260px;
        height: 100vh;
        background: #131334;
        color: white;
        overflow: auto;
    }



    .logo h2 {
        font-weight: bold;
        letter-spacing: 2px;
    }


    .menu {
        padding: 10px;
    }

    .menu a {
        display: flex;
        align-items: center;
        text-decoration: none;
        color: white;
        padding: 14px 18px;
        margin-bottom: 8px;
        border-radius: 12px;
        transition: .3s;
        cursor: pointer;
    }

    .menu a i {
        font-size: 20px;
        margin-right: 15px;
    }

    .menu a:hover {
        background: rgba(239,68,68,0.15);
        color: red;
    }

    .menu .active {
        background: rgba(239,68,68,0.15);
        color: red;
    }

    /* Đổi màu chữ menu cha khi có mục con đang active để người dùng dễ nhận biết */
    .menu-parent-active {
        background: rgba(255, 255, 255, 0.15);
        font-weight: bold;
    }

    /* CSS Tùy chỉnh riêng cho Menu con (Submenu) */
    .submenu-item {
        font-size: 15px;
        padding: 10px 15px !important;
        background: rgba(255, 255, 255, 0.08);
        margin-left: 15px;
    }

    .submenu-item:hover {
        background: rgba(239,68,68,0.15) !important;
        color: red !important;
    }

    /* Xoay mũi tên mượt mà bằng thuộc tính của Bootstrap collapse */
    a[aria-expanded="true"] .arrow-icon {
        transform: rotate(180deg);
        transition: transform 0.3s;
    }

    a.collapsed .arrow-icon {
        transform: rotate(0deg);
        transition: transform 0.3s;
    }

    .arrow-icon {
        transition: transform 0.3s;
    }

    .bottom {
        position: absolute;
        bottom: 20px;
        width: 100%;
        padding: 0 10px;
    }

    .bottom a {
        display: flex;
        align-items: center;
        color: white;
        text-decoration: none;
        padding: 14px 18px;
        border-radius: 12px;
    }

    .bottom a:hover {
        background: white;
    }
    .logo2{
        display:flex;
        align-items:center;
        justify-content:center;
        gap:4px;
        padding:25px 20px;
    }

    .logo2 img{
        width:38px;
        height:38px;
        object-fit:contain;
    }

    .logo2 h2{
        margin:0;
        color:#fff;
        font-size:40px;
        font-weight:bold;
        letter-spacing:2px;
    }

    .logo2 h2 span{
        color:red;
    }
</style>

<div class="sidebar">

    <div class="logo2">
        <img src="${pageContext.request.contextPath}/logo2.png" alt="Logo">
        <h2>Scott<span>.</span></h2>
    </div>

    <div class="menu">

        <a href="${pageContext.request.contextPath}/dashboard"
           class="${menu == 'dashboard' ? 'active' : ''}">
            <i class="bi bi-grid-fill"></i>
            Dashboard
        </a>

        <a href="${pageContext.request.contextPath}/san-pham"
           class="${menu == 'sanpham' ? 'active' : ''}">
            <i class="bi bi-bag-fill"></i>
            Sản phẩm
        </a>

        <a href="${pageContext.request.contextPath}/quanlyhoadon"
           class="${menu == 'quanlyhoadon' ? 'active' : ''}">
            <i class="bi bi-file-earmark-text"></i>
            Hóa đơn
        </a>

        <a href="#">
            <i class="bi bi-graph-up-arrow"></i>
            Báo cáo
        </a>

        <a href="${pageContext.request.contextPath}/phieugiamgia/hien-thi"
           class="${menu == 'phieugiamgia' ? 'active' : ''}">
            <i class="bi bi-ticket-perforated-fill"></i>
            Phiếu Giảm Giá
        </a>

        <a href="#taiKhoanSubmenu"
           data-bs-toggle="collapse"
           role="button"
           aria-expanded="false"
           class="d-flex justify-content-between align-items-center ${menu == 'nhanvien' || menu == 'khachhang' ? 'menu-parent-active' : ''}">
            <span class="d-flex align-items-center">
                <i class="bi bi-person-bounding-box"></i>
                Quản lý tài khoản
            </span>
            <i class="bi bi-chevron-down arrow-icon" style="font-size: 14px; margin-right: 0;"></i>
        </a>

        <div class="collapse ${menu == 'nhanvien' || menu == 'khachhang' ? 'show' : ''}" id="taiKhoanSubmenu">
            <a href="${pageContext.request.contextPath}/nhan-vien/hien-thi"
               class="${menu == 'nhanvien' ? 'active' : ''} submenu-item">
                <i class="bi bi-person-badge-fill"></i>
                Nhân viên
            </a>
            <a href="${pageContext.request.contextPath}/khachhang/hien-thi"
               class="${menu == 'khachhang' ? 'active' : ''} submenu-item">
                <i class="bi bi-people-fill"></i>
                Khách hàng
            </a>
        </div>

        <a href="#">
            <i class="bi bi-gear-fill"></i>
            Cài đặt
        </a>

    </div>

    <div class="bottom">
        <a href="/logout">
            <i class="bi bi-box-arrow-right"></i> Đăng xuất
        </a>
    </div>

</div>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>