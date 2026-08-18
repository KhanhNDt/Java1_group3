<%@ page contentType="text/html;charset=UTF-8" language="java"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>

<!DOCTYPE html>
<html>
<head>
    <title>Chi tiết khách hàng</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.css" rel="stylesheet">

    <style>
        .address-item{ border:1px solid #ddd; border-radius:8px; padding:12px; margin-bottom:10px; background:#fff; }
        .default-address{ border-left:4px solid #0d6efd; }
        .badge-default{ background:#dbeafe; color:#2563eb; padding:3px 8px; border-radius:4px; font-size:11px; }
    </style>
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
            <tr><th>Địa chỉ gốc</th><td>${khachHangS.diaChi}</td></tr>
            <tr><th>Giới tính</th><td>
                <c:choose>
                    <c:when test="${khachHangS.gioiTinh == 'Nam'}">Nam</c:when>
                    <c:when test="${khachHangS.gioiTinh == 'Nữ'}">Nữ</c:when>
                    <c:otherwise>Chưa cập nhật</c:otherwise>
                </c:choose>
            </td></tr>

        </table>

        <h5 class="mt-4 mb-3">Địa chỉ nhận hàng</h5>

        <c:choose>
            <c:when test="${empty diaChiKHList}">
                <div class="text-muted">Chưa có địa chỉ nào.</div>
            </c:when>
            <c:otherwise>
                <c:forEach items="${diaChiKHList}" var="dc" varStatus="st">
                    <div class="address-item${dc.isMacDinh ? ' default-address' : ''}">
                        <div class="d-flex justify-content-between align-items-start">
                            <div>
                                <div class="fw-bold">
                                    Địa chỉ ${st.count}
                                    <c:if test="${dc.isMacDinh}">
                                        <span class="badge-default ms-2">Mặc định</span>
                                    </c:if>
                                </div>
                                <div class="mt-2">
                                        ${dc.diaChiCuThe}, ${dc.phuongXa}, ${dc.tinhThanh}
                                </div>
                            </div>
                        </div>
                    </div>
                </c:forEach>
            </c:otherwise>
        </c:choose>

        <a href="${pageContext.request.contextPath}/khachhang/hien-thi"
           class="btn btn-secondary mt-3">
            Quay lại
        </a>


    </div>
</div>
</body>
</html>