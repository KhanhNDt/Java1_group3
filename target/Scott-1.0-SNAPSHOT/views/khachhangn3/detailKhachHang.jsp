<%@ page contentType="text/html;charset=UTF-8" language="java"%>

<!DOCTYPE html>
<html>
<head>
    <title>Chi tiết khách hàng</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">

<style>
:root{--sc-black:#111827;--sc-gray:#6b7280;--sc-line:#e5e7eb;--sc-bg:#f8fafc;}
body{background:var(--sc-bg)!important;color:#111!important;}
.main-content{margin-left:260px;padding:28px;}
.card,.main-card,.modal-content{border:1px solid var(--sc-line)!important;box-shadow:0 8px 24px rgba(0,0,0,.05)!important;}
.bg-primary,.bg-success,.bg-danger,.bg-warning{background:#111827!important;color:#fff!important;}
.text-primary,.text-success,.text-danger,.text-warning{color:#111827!important;}
.btn-primary,.btn-success,.btn-danger,.btn-warning{background:#111827!important;border-color:#111827!important;color:#fff!important;}
.btn-primary:hover,.btn-success:hover,.btn-danger:hover,.btn-warning:hover{background:#000!important;border-color:#000!important;}
.btn-outline-primary,.btn-outline-success,.btn-outline-danger,.btn-outline-warning{color:#111827!important;border-color:#9ca3af!important;}
.btn-outline-primary:hover,.btn-outline-success:hover,.btn-outline-danger:hover,.btn-outline-warning:hover{background:#111827!important;color:#fff!important;}
.badge{background:#f3f4f6!important;color:#111827!important;border:1px solid #d1d5db;}
.form-control:focus,.form-select:focus{border-color:#111827!important;box-shadow:0 0 0 .2rem rgba(17,24,39,.12)!important;}
.table thead th{background:#f3f4f6!important;color:#374151!important;}
.required:after{color:#111!important;}
</style>
</head>
<body>
<%@ include file="/views/layout/sidebar.jsp"%>
<div class="main-content">
<div class="container mt-5">

    <h3>Chi tiết khách hàng</h3>

    <table class="table table-bordered">
        <tr><th>Mã</th><td>${khachHangS.ma}</td></tr>
        <tr><th>Họ tên</th><td>${khachHangS.hoTen}</td></tr>
        <tr><th>SĐT</th><td>${khachHangS.sdt}</td></tr>
        <tr><th>Email</th><td>${khachHangS.email}</td></tr>
        <tr><th>Địa chỉ</th><td>${khachHangS.diaChi}</td></tr>
        <tr><th>Giới tính</th><td>
            <c:choose>
                <c:when test="${khachHangS.gioiTinh == 'Nam'}">Nam</c:when>
                <c:when test="${khachHangS.gioiTinh == 'Nữ'}">Nữ</c:when>
                <c:otherwise>Chưa cập nhật</c:otherwise>
            </c:choose>
        </td></tr>

    </table>

    <a href="${pageContext.request.contextPath}/khachhang/hien-thi"
       class="btn btn-secondary">
        Quay lại
    </a>


</div>
</div>
</body>
</html>