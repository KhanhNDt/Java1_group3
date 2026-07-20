<%@ page contentType="text/html;charset=UTF-8" language="java"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>

<!DOCTYPE html>
<html>
<head>
    <title>Quản lý phiếu giảm giá</title>

    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.css" rel="stylesheet">

    <style>
        body{
            background:#f5f6fa;
        }
        .card{
            border-radius:15px;
        }
    </style>

</head>
<body>

<%@ include file="/views/layout/sidebar.jsp"%>
<div class="main-content2 ">
<div style="margin-left:260px;padding:30px;">

    <h2 class="fw-bold mb-4">
        Quản lý giảm giá / Phiếu giảm giá
    </h2>

    <div class="card shadow-sm mb-4">
        <div class="card-body">

            <form action="${pageContext.request.contextPath}/phieugiamgia/search" method="get">

                <div class="row">

                    <div class="col-md-3">
                        <label>Tìm kiếm</label>
                        <input type="text"
                               class="form-control"
                               name="keyword"
                               placeholder="Tìm theo tên hoặc mã">
                    </div>

                    <div class="col-md-3">
                        <label>Ngày bắt đầu</label>
                        <input type="date"
                               class="form-control"
                               name="ngayBatDau">
                    </div>

                    <div class="col-md-3">
                        <label>Ngày kết thúc</label>
                        <input type="date"
                               class="form-control"
                               name="ngayKetThuc">
                    </div>

                    <div class="col-md-3">
                        <label>Trạng thái</label>

                        <select class="form-select" name="trangThai">
                            <option value="">Tất cả</option>
                            <option value="1">Đang hoạt động</option>
                            <option value="0">Ngừng hoạt động</option>
                        </select>
                    </div>

                </div>

                <div class="text-end mt-3">

                    <a href="${pageContext.request.contextPath}/phieugiamgia/hien-thi"
                       class="btn btn-secondary">
                        <i class="bi bi-arrow-clockwise"></i>
                        Đặt lại
                    </a>

                    <button type="button"
                            class="btn btn-outline-dark">
                        <i class="bi bi-file-earmark-excel"></i>
                        Xuất Excel
                    </button>

                    <a href="#formThem"
                       class="btn btn-danger">
                        <i class="bi bi-plus-lg"></i>
                        Thêm phiếu giảm giá
                    </a>

                    <button class="btn btn-primary">
                        <i class="bi bi-search"></i>
                        Tìm kiếm
                    </button>

                </div>

            </form>

        </div>
    </div>

    <div class="card shadow-sm">

        <div class="card-body">

            <h5 class="mb-3">
                Danh sách phiếu giảm giá
            </h5>

            <table class="table table-hover text-center align-middle">

                <thead class="table-light">

                <tr>

                    <th>STT</th>

                    <th>Mã</th>

                    <th>Tên</th>

                    <th>Loại</th>

                    <th>Số lượng</th>

                    <th>Ngày bắt đầu</th>

                    <th>Ngày kết thúc</th>

                    <th>Trạng thái</th>

                    <th>Hành động</th>

                </tr>

                </thead>

                <tbody>
                <c:forEach items="${listPhieuGiamGia}" var="p" varStatus="st">

                    <tr>

                        <td>${st.count}</td>

                        <td>${p.maVoucher}</td>

                        <td>${p.tenVoucher}</td>

                        <td>
            <span class="badge bg-danger">
                    ${p.loaiGiamGia}
            </span>
                        </td>

                        <td>${p.soLuong}</td>

                        <td>${p.ngayBatDau}</td>

                        <td>${p.ngayKetThuc}</td>

                        <td>

                            <c:if test="${p.trangThai==1}">
                <span class="badge bg-success">
                    Đang hoạt động
                </span>
                            </c:if>

                            <c:if test="${p.trangThai==0}">
                <span class="badge bg-secondary">
                    Ngừng hoạt động
                </span>
                            </c:if>

                        </td>

                        <td>

                            <!-- Detail -->
                            <a href="${pageContext.request.contextPath}/phieugiamgia/detail?id=${p.id}"
                               class="btn btn-info btn-sm">
                                <i class="bi bi-eye"></i>
                            </a>

                            <!-- Update -->
                            <a href="${pageContext.request.contextPath}/phieugiamgia/view-update?id=${p.id}"
                               class="btn btn-warning btn-sm">
                                <i class="bi bi-pencil-square"></i>
                            </a>

                            <!-- Delete -->
                            <a href="${pageContext.request.contextPath}/phieugiamgia/delete?id=${p.id}"
                               onclick="return confirm('Bạn có chắc muốn xóa?')"
                               class="btn btn-danger btn-sm">
                                <i class="bi bi-trash"></i>
                            </a>

                        </td>

                    </tr>

                </c:forEach>

                </tbody>

            </table>

            <nav class="mt-4">

                <ul class="pagination justify-content-center">

                    <li class="page-item disabled">
                        <a class="page-link">&lt;</a>
                    </li>

                    <li class="page-item active">
                        <a class="page-link">1</a>
                    </li>

                    <li class="page-item disabled">
                        <a class="page-link">&gt;</a>
                    </li>

                </ul>

            </nav>

        </div>

    </div>
</div>
</div>

</body>

</html>