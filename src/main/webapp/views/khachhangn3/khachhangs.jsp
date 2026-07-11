<%@ page contentType="text/html;charset=UTF-8" language="java"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>

<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <title>Quản lý khách hàng</title>

    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.css" rel="stylesheet">
</head>

<body>

<%@ include file="/views/layout/sidebar.jsp"%>
<%@ include file="/views/layout/header.jsp"%>

<div class="container-fluid mt-4">

    <div class="card shadow">

        <div class="card-header bg-primary text-white">
            <h4 class="mb-0">Quản lý khách hàng</h4>
        </div>

        <div class="card shadow-sm mb-4">

            <div class="card-body">

                <form action="${pageContext.request.contextPath}/khachhang/search" method="get">

                    <div class="row align-items-center">

                        <!-- Tìm kiếm -->
                        <div class="col-md-3">
                            <input type="text"
                                   class="form-control"
                                   name="keyword"
                                   placeholder="Tìm mã, tên, SĐT..."
                                   value="${param.keyword}">
                        </div>

                        <!-- Giới tính -->
                        <div class="col-md-2">
                            <select class="form-select" name="gioiTinh">
                                <option value="">-- Giới tính --</option>
                                <option value="Nam">Nam</option>
                                <option value="Nữ">Nữ</option>
                            </select>
                        </div>

                        <!-- Trạng thái -->
                        <div class="col-md-2">
                            <select class="form-select" name="trangThai">
                                <option value="">-- Trạng thái --</option>
                                <option value="1">Hoạt động</option>
                                <option value="0">Ngừng hoạt động</option>
                            </select>
                        </div>

                        <!-- Nút -->
                        <div class="col-md-5 text-end">

                            <button type="submit" class="btn btn-primary">
                                <i class="bi bi-search"></i> Tìm kiếm
                            </button>

                            <a href="${pageContext.request.contextPath}/khachhang/hien-thi"
                               class="btn btn-dark">
                                <i class="bi bi-arrow-repeat"></i> Đặt lại
                            </a>

                            <button type="button"
                                    class="btn btn-success"
                                    data-bs-toggle="modal"
                                    data-bs-target="#modalThem">
                                <i class="bi bi-plus-lg"></i> Thêm mới
                            </button>

                        </div>

                    </div>

                </form>

            </div>

        </div>

    </div>

    <div class="card shadow mt-4">

        <div class="card-header bg-primary text-white">
            <h5 class="mb-0">Danh sách khách hàng</h5>
        </div>

        <div class="card-body">

            <table class="table table-bordered table-hover text-center align-middle">

                <thead class="table-primary">

                <tr>
                    <th>STT</th>
                    <th>Mã KH</th>
                    <th>Họ tên</th>
                    <th>SĐT</th>
                    <th>Email</th>
                    <th>Địa chỉ</th>
                    <th>Giới tính</th>
                    <th>Trạng thái</th>
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
                        <td>${KH.email}</td>
                        <td>${KH.diaChi}</td>
                        <td>${KH.gioiTinh}</td>

                        <td>
                            <c:choose>
                                <c:when test="${KH.trangThai == 1}">
                                    <span class="badge bg-success">Hoạt động</span>
                                </c:when>
                                <c:otherwise>
                                    <span class="badge bg-danger">Ngừng hoạt động</span>
                                </c:otherwise>
                            </c:choose>
                        </td>

                        <td>

                            <a href="${pageContext.request.contextPath}/khachhang/view-update?id=${KH.id}"
                               class="btn btn-warning btn-sm">
                                <i class="bi bi-pencil-square"></i>
                            </a>

                            <a href="${pageContext.request.contextPath}/khachhang/detail?id=${KH.id}"
                               class="btn btn-info btn-sm">
                                <i class="bi bi-eye"></i>
                            </a>

                            <a href="${pageContext.request.contextPath}/khachhang/delete?id=${KH.id}"
                               class="btn btn-danger btn-sm"
                               onclick="return confirm('Bạn có chắc muốn xóa khách hàng này?')">
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

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>

</body>
</html>