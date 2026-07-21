<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
<link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.css" rel="stylesheet">
<style>
    :root{--sidebar-w:242px;--black:#111;--dark:#1b1b1b;--gray-900:#262626;--gray-700:#555;--gray-500:#8a8a8a;--gray-300:#d8d8d8;--gray-100:#f3f3f3;--white:#fff}
    *{box-sizing:border-box} body{margin:0;background:#f4f4f4;color:#171717;font-family:Inter,"Segoe UI",Arial,sans-serif}
    .sidebar{position:fixed;inset:0 auto 0 0;width:var(--sidebar-w);height:100vh;background:#111;color:#bdbdbd;border-right:1px solid #2d2d2d;display:flex;flex-direction:column;z-index:1040}
    .logo{height:92px;padding:16px 22px;border-bottom:1px solid #292929;display:flex;align-items:center;justify-content:center}
    .logo img{max-width:154px;max-height:58px;filter:brightness(0) invert(1);object-fit:contain}
    .menu{padding:18px 12px;overflow:auto;flex:1}.menu-label{padding:0 12px 9px;font-size:10px;letter-spacing:1.2px;text-transform:uppercase;color:#717171;font-weight:700}
    .menu a{display:flex;align-items:center;gap:12px;text-decoration:none;color:#aaa;padding:11px 13px;margin:3px 0;border-radius:8px;border:1px solid transparent;font-size:14px;transition:.18s}.menu a i{width:20px;text-align:center;font-size:17px}.menu a:hover{background:#202020;color:#fff}.menu a.active{background:#fff;color:#111;border-color:#fff;font-weight:700}
    .submenu{margin-left:18px;border-left:1px solid #393939;padding-left:7px}.submenu a{font-size:13px;padding:9px 11px}
    .bottom{border-top:1px solid #292929;padding:13px 12px 18px}.bottom a{display:flex;gap:12px;align-items:center;color:#999;text-decoration:none;padding:10px 13px;border-radius:8px}.bottom a:hover{background:#202020;color:#fff}
    .main-content{margin-left:var(--sidebar-w)!important;min-height:100vh;padding:28px!important}
    .card{border:1px solid #dedede!important;border-radius:12px!important;box-shadow:0 4px 14px rgba(0,0,0,.045)!important}.card-header{background:#fff!important;color:#171717!important;border-bottom:1px solid #e5e5e5!important}.btn{border-radius:8px}.btn-primary,.btn-success,.btn-warning,.btn-info{background:#171717!important;border-color:#171717!important;color:#fff!important}.btn-primary:hover,.btn-success:hover,.btn-warning:hover,.btn-info:hover{background:#333!important;border-color:#333!important}.btn-danger{background:#fff!important;color:#171717!important;border-color:#bdbdbd!important}.btn-danger:hover{background:#171717!important;color:#fff!important;border-color:#171717!important}.btn-secondary{background:#ededed!important;color:#171717!important;border-color:#d5d5d5!important}.text-primary,.text-success,.text-danger{color:#171717!important}.bg-primary,.bg-success,.bg-warning,.bg-danger{background:#171717!important;color:#fff!important}.alert-success,.alert-danger{background:#fff!important;border-color:#cfcfcf!important;color:#171717!important}.form-control,.form-select{border-color:#d1d1d1;border-radius:8px}.form-control:focus,.form-select:focus{border-color:#333;box-shadow:0 0 0 .18rem rgba(0,0,0,.10)}
    @media(max-width:900px){.sidebar{width:78px}.logo{padding:12px}.logo img{width:56px}.menu a{justify-content:center}.menu a span,.menu-label,.bottom span,.submenu{display:none}.main-content{margin-left:78px!important;padding:18px!important}}
</style>
<div class="sidebar">
    <div class="logo"><img src="${pageContext.request.contextPath}/assets/images/scott-logo.png" alt="Scott"></div>
    <div class="menu">
        <div class="menu-label">Menu chính</div>
        <a href="${pageContext.request.contextPath}/dashboard" class="${menu == 'dashboard' ? 'active' : ''}"><i class="bi bi-grid"></i><span>Thống kê</span></a>
        <a href="${pageContext.request.contextPath}/quanlyhoadon" class="${menu == 'quanlyhoadon' ? 'active' : ''}"><i class="bi bi-receipt"></i><span>Quản lý hóa đơn</span></a>
        <a href="${pageContext.request.contextPath}/san-pham/hien-thi" class="${menu == 'sanpham' ? 'active' : ''}"><i class="bi bi-box-seam"></i><span>Quản lý sản phẩm</span></a>
        <div class="submenu" style="display:${menu == 'sanpham' ? 'block' : 'none'}">
            <a href="${pageContext.request.contextPath}/san-pham/hien-thi" class="${menu == 'sanpham' && submenu != 'bienthe' ? 'active' : ''}"><i class="bi bi-list-ul"></i><span>Danh sách sản phẩm</span></a>
            <a href="${pageContext.request.contextPath}/san-pham/chi-tiet/hien-thi" class="${submenu == 'bienthe' ? 'active' : ''}"><i class="bi bi-layers"></i><span>Biến thể sản phẩm</span></a>
        </div>
        <a href="${pageContext.request.contextPath}/thuoc-tinh/hien-thi?type=danh-muc" class="${menu == 'thuoctinh' ? 'active' : ''}"><i class="bi bi-sliders"></i><span>Thuộc tính sản phẩm</span></a>
        <a href="${pageContext.request.contextPath}/phieugiamgia/hien-thi" class="${menu == 'phieugiamgia' ? 'active' : ''}"><i class="bi bi-ticket-perforated"></i><span>Phiếu giảm giá</span></a>
        <a href="${pageContext.request.contextPath}/khachhang/hien-thi" class="${menu == 'khachhang' ? 'active' : ''}"><i class="bi bi-people"></i><span>Khách hàng</span></a>
        <a href="${pageContext.request.contextPath}/nhan-vien/hien-thi" class="${menu == 'nhanvien' ? 'active' : ''}"><i class="bi bi-person-badge"></i><span>Nhân viên</span></a>
    </div>
    <div class="bottom"><a href="#"><i class="bi bi-gear"></i><span>Cài đặt</span></a><a href="#"><i class="bi bi-box-arrow-right"></i><span>Đăng xuất</span></a></div>
</div>
