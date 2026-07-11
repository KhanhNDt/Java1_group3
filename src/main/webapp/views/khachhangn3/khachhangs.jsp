<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<!DOCTYPE html>
<html>
<head>
    <title>Quản lý khách hàng</title>

    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.css" rel="stylesheet">

</head>

<body>

<%@ include file="/views/layout/sidebar.jsp" %>
<%@ include file="/views/layout/header.jsp" %>

<div style="margin-left:20px;padding:30px;">

    <h2 class="text-center mb-4 fw-bold">
        QUẢN LÝ KHÁCH HÀNG
    </h2>

    <!-- Card nhập thông tin -->
    <div class="card shadow mb-4">

        <div class="card-header bg-primary text-white">
            <h5 class="mb-0">Thiết lập thông tin khách hàng</h5>
        </div>

        <div class="card-body">

            <form action="/khachhang/add" method="post">

                <div class="row">

                    <div class="col-md-6">
                        <label class="form-label">Mã khách hàng</label>
                        <input
                                type="text"
                                class="form-control"
                                name="ma"
                                value="${khachHangS.ma}">
                    </div>

                    <div class="col-md-6">
                        <label class="form-label">Số điện thoại</label>
                        <input
                                type="text"
                                class="form-control"
                                name="sdt"
                                value="${khachHangS.sdt}">
                    </div>

                </div>

                <div class="row mt-3">

                    <div class="col-md-6">
                        <label class="form-label">Họ tên</label>
                        <input
                                type="text"
                                class="form-control"
                                name="hoTen"
                                value="${khachHangS.hoTen}">
                    </div>

                    <div class="col-md-6">
                        <label class="form-label">Địa chỉ</label>
                        <input
                                type="text"
                                class="form-control"
                                name="diaChi"
                                value="${khachHangS.diaChi}">
                    </div>

                </div>

                <div class="text-center mt-4">

                    <button class="btn btn-success" type="submit">
                        <i class="bi bi-plus-circle"></i>
                        Thêm
                    </button>

                    <button class="btn btn-warning" type="button">
                        <i class="bi bi-pencil-square"></i>
                        Sửa
                    </button>

                    <button class="btn btn-danger" type="button">
                        <i class="bi bi-trash"></i>
                        Xóa
                    </button>

                    <a href="${pageContext.request.contextPath}/khachhang/hien-thi"
                       class="btn btn-secondary">
                        <i class="bi bi-arrow-clockwise"></i>
                        Làm mới
                    </a>

                </div>

            </form>

        </div>

    </div>

    <!-- Card danh sách -->
    <div class="card shadow">

        <div class="card-header bg-primary text-white">
            <h5 class="mb-0">Thông tin khách hàng</h5>
        </div>

        <div class="card-body">

            <form action="${pageContext.request.contextPath}/khachhang/search" method="get">

                <div class="row mb-3">

                    <div class="col-md-4">

                        <input type="text"
                               name="keyword"
                               class="form-control"
                               placeholder="Nhập mã hoặc tên">

                    </div>

                    <div class="col-md-2">

                        <button class="btn btn-primary">
                            Tìm kiếm
                        </button>

                    </div>

                </div>

            </form>

            </div>

            <table class="table table-bordered table-hover text-center align-middle">

                <thead class="table-primary">

                <tr>

                    <th>STT</th>

                    <th>Mã KH</th>

                    <th>Họ tên</th>

                    <th>SĐT</th>

                    <th>Địa chỉ</th>

                    <th>Chức năng</th>

                </tr>

                </thead>

                <tbody>

                <c:forEach items="${listKhachHang}" var="KH" varStatus="st">

                    <tr>

                        <td>${st.count}</td>

                        <td>${KH.ma}</td>

                        <td>${KH.hoTen}</td>

                        <td>${KH.sdt}</td>

                        <td>${KH.diaChi}</td>

                        <td>

                            <a
                                    href="/khachhang/view-update?id=${KH.id}"
                                    class="btn btn-warning btn-sm">

                                <i class="bi bi-pencil-square"></i>

                            </a>

                            <a
                                    href="/khachhang/delete?id=${KH.id}"
                                    class="btn btn-danger btn-sm">

                                <i class="bi bi-trash"></i>

                            </a>

                        </td>

                    </tr>

                </c:forEach>

                </tbody>

            </table>

        </div>

    </div>

</div>

</body>
</html>