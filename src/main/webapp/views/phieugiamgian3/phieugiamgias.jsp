<%--
  Created by IntelliJ IDEA.
  User: Nvc36
  Date: 7/11/2026
  Time: 3:59 PM
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<html>
<head>
    <title>Quản lý phiếu giảm giá</title>

    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.css" rel="stylesheet">

</head>
<body>
<%@ include file="/views/layout/sidebar.jsp" %>
<%--<%@ include file="/views/layout/header.jsp" %>--%>
<div class="container mt-4">

    <c:if test="${not empty success}">
        <div class="alert alert-success alert-dismissible fade show">${success}<button class="btn-close" data-bs-dismiss="alert"></button></div>
    </c:if>
    <c:if test="${not empty error}">
        <div class="alert alert-danger alert-dismissible fade show">${error}<button class="btn-close" data-bs-dismiss="alert"></button></div>
    </c:if>

    <h3 class="text-center text-primary mb-4">
        QUẢN LÝ PHIẾU GIẢM GIÁ
    </h3>

    <form action="${pageContext.request.contextPath}/phieugiamgia/add" method="post">

        <div class="row">

            <div class="col-md-6 mb-3">
                <label>Mã voucher</label>
                <input type="text" class="form-control" name="maVoucher">
            </div>

            <div class="col-md-6 mb-3">
                <label>Tên voucher</label>
                <input type="text" class="form-control" name="tenVoucher">
            </div>

            <div class="col-md-4 mb-3">
                <label>Giá trị giảm</label>
                <input type="number"
                       class="form-control"
                       name="giaTriGiamGia"
                       step="0.01">
            </div>

            <div class="col-md-4 mb-3">
                <label>Giảm tối đa</label>
                <input type="number"
                       class="form-control"
                       name="giamToiDa"
                       step="0.01">

            </div>

            <div class="col-md-4 mb-3">
                <label>Đơn tối thiểu</label>
                <input type="number"
                       class="form-control"
                       name="donToiThieu"
                       step="0.01">
            </div>

            <div class="col-md-6 mb-3">
                <label>Ngày bắt đầu</label>
                <input type="date" class="form-control" name="ngayBatDau">
            </div>

            <div class="col-md-6 mb-3">
                <label>Ngày kết thúc</label>
                <input type="date" class="form-control" name="ngayKetThuc">
            </div>

        </div>

        <button class="btn btn-success" type="submit">
            <i class="bi bi-plus-circle"></i> Thêm
        </button>

    </form>

    <hr>

    <table class="table table-bordered table-hover text-center">

        <thead class="table-dark">

        <tr>
            <th>ID</th>
            <th>Mã</th>
            <th>Tên</th>
            <th>Giá trị giảm</th>
            <th>Giảm tối đa</th>
            <th>Đơn tối thiểu</th>
            <th>Ngày bắt đầu</th>
            <th>Ngày kết thúc</th>
            <th>Thao tác</th>
        </tr>

        </thead>

        <tbody>

        <c:forEach items="${listPhieuGiamGia}" var="p">

        <tr>

            <td>${p.id}</td>
            <td>${p.maVoucher}</td>
            <td>${p.tenVoucher}</td>
            <td>${p.giaTriGiamGia}</td>
            <td>${p.giamToiDa}</td>
            <td>${p.donToiThieu}</td>
            <td>${p.ngayBatDau}</td>
            <td>${p.ngayKetThuc}</td>

            <td>

                <a href="${pageContext.request.contextPath}/phieugiamgia/view-update?id=${p.id}"
                   class="btn btn-warning btn-sm">
                    Sửa
                </a>

                <a href="${pageContext.request.contextPath}/phieugiamgia/delete?id=${p.id}"
                   onclick="return confirm('Bạn có chắc muốn xóa?')"
                   class="btn btn-danger btn-sm">
                    Xóa
                </a>

            </td>

        </tr>

        </c:forEach>
        </tbody>

    </table>

</div>
</body>
</html>
