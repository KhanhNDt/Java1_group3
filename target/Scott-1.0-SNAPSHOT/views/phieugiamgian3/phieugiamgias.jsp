<<<<<<< HEAD
=======
<%--
  Created by IntelliJ IDEA.
  User: Nvc36
<<<<<<< HEAD
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
=======
--%>
>>>>>>> cc06950ebd043233153dbd35954652938fe69495
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <title>Quản lý phiếu giảm giá - Scott Admin</title>

    <!-- Bootstrap 5 CSS & Icons -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.css" rel="stylesheet">

    <style>
        body {
            background-color: #f4f6f9;
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
        }

        .content {
            margin-left: 250px;
            padding: 25px 30px;
        }

        .card {
            border: none;
            border-radius: 10px;
            box-shadow: 0 4px 12px rgba(0, 0, 0, 0.05);
            background: #fff;
        }

        .card-header {
            background-color: #ffffff;
            font-weight: 600;
            border-bottom: 1px solid #edf2f7;
            padding: 16px 20px;
        }

        .table thead th {
            background-color: #f8f9fa;
            color: #495057;
            font-size: 0.8rem;
            text-transform: uppercase;
            letter-spacing: 0.5px;
        }
    </style>
</head>

<body>

<%@ include file="/views/layout/sidebar.jsp" %>

<div class="content">

    <!-- Header & Action Buttons -->
    <div class="d-flex justify-content-between align-items-center mb-4">
        <h3 class="fw-bold text-dark mb-0">
            <i class="bi bi-journal-text me-2"></i>Quản lý phiếu giảm giá
        </h3>
        <div>
            <!-- Link Gọi Xuất Excel -->
            <a href="${pageContext.request.contextPath}/phieugiamgia/export-excel" class="btn btn-outline-success me-2">
                <i class="bi bi-file-earmark-excel me-1"></i> Xuất Excel
            </a>
            <!-- Link Thêm Mới -->
            <a href="${pageContext.request.contextPath}/phieugiamgia/view-add" class="btn btn-dark">
                <i class="bi bi-plus-circle me-1"></i> Thêm mới
            </a>
        </div>
    </div>

    <!-- Thông báo Flash Thành công (Ép màu xanh lá) -->
    <c:if test="${not empty success}">
        <div class="alert alert-dismissible fade show border-0 shadow-sm mb-3"
             style="background-color: #d1e7dd !important; color: #0f5132 !important;" role="alert">
            <i class="bi bi-check-circle-fill me-2" style="color: #198754 !important;"></i>
            <strong style="color: #0f5132 !important;">${success}</strong>
            <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
        </div>
    </c:if>

    <!-- Thông báo Flash Lỗi (Ép màu đỏ) -->
    <c:if test="${not empty error}">
        <div class="alert alert-dismissible fade show border-0 shadow-sm mb-3"
             style="background-color: #f8d7da !important; color: #842029 !important;" role="alert">
            <i class="bi bi-exclamation-triangle-fill me-2" style="color: #dc3545 !important;"></i>
            <strong style="color: #842029 !important;">${error}</strong>
            <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
        </div>
    </c:if>

    <!-- Bộ Lọc Tìm Kiếm -->
    <div class="card mb-4">
        <div class="card-header fw-bold text-dark">
            <i class="bi bi-funnel me-1"></i> Bộ lọc tìm kiếm
        </div>
        <div class="card-body p-4">
            <form action="${pageContext.request.contextPath}/phieugiamgia/search" method="get">
                <div class="row g-3">
                    <!-- Tìm kiếm keyword -->
                    <div class="col-md-4">
                        <label class="form-label small text-muted">Tìm kiếm</label>
                        <input type="text" class="form-control" name="keyword"
                               value="${param.keyword}" placeholder="Nhập mã hoặc tên phiếu giảm giá...">
                    </div>

                    <!-- Loại giảm -->
                    <div class="col-md-3">
                        <label class="form-label small text-muted">Loại giảm</label>
                        <select class="form-select" name="loaiGiamGia">
                            <option value="">Tất cả</option>
                            <option value="%" ${param.loaiGiamGia == '%' ? 'selected' : ''}>Phần trăm (%)</option>
                            <option value="Tiền" ${param.loaiGiamGia == 'Tiền' ? 'selected' : ''}>Tiền mặt</option>
                        </select>
                    </div>

                    <!-- Trạng thái -->
                    <div class="col-md-3">
                        <label class="form-label small text-muted">Trạng thái</label>
                        <select class="form-select" name="trangThai">
                            <option value="">Tất cả</option>
                            <option value="1" ${param.trangThai == '1' ? 'selected' : ''}>Đang hoạt động</option>
                            <option value="0" ${param.trangThai == '0' ? 'selected' : ''}>Ngừng hoạt động</option>
                        </select>
                    </div>

                    <!-- Nút Tìm Kiếm -->
                    <div class="col-md-2 d-flex align-items-end">
                        <button type="submit" class="btn btn-dark w-100">
                            <i class="bi bi-search me-1"></i> Tìm kiếm
                        </button>
                    </div>

                    <!-- Từ ngày (Sử dụng type="date" gốc chuẩn trình duyệt) -->
                    <div class="col-md-3">
                        <label class="form-label small text-muted">Từ ngày</label>
                        <input type="date" class="form-control" name="from"
                               value="${param.from}" lang="vi">
                    </div>

                    <!-- Đến ngày (Sử dụng type="date" gốc chuẩn trình duyệt) -->
                    <div class="col-md-3">
                        <label class="form-label small text-muted">Đến ngày</label>
                        <input type="date" class="form-control" name="to"
                               value="${param.to}" lang="vi">
                    </div>
                </div>
            </form>
        </div>
    </div>

    <!-- Bảng Danh Sách Phiếu Giảm Giá -->
    <div class="card">
        <div class="card-header fw-bold text-dark">
            <i class="bi bi-list-ul me-1"></i> Danh sách phiếu giảm giá
        </div>
        <div class="card-body p-0">
            <div class="table-responsive">
                <table class="table table-hover align-middle mb-0">
                    <thead>
                    <tr>
                        <th class="ps-3">STT</th>
                        <th>MÃ GIẢM GIÁ</th>
                        <th>TÊN GIẢM GIÁ</th>
                        <th>LOẠI GIẢM</th>
                        <th>GIÁ TRỊ GIẢM</th>
                        <th>GIẢM TỐI ĐA</th>
                        <th>ĐƠN TỐI THIỂU</th>
                        <th>SỐ LƯỢNG</th>
                        <th>NGÀY BẮT ĐẦU</th>
                        <th>NGÀY KẾT THÚC</th>
                        <th>TRẠNG THÁI</th>
                        <th class="text-center pe-3">HÀNH ĐỘNG</th>
                    </tr>
                    </thead>
                    <tbody>
                    <c:forEach items="${listPhieuGiamGia}" var="pgg" varStatus="loop">
                        <tr>
                            <td class="ps-3 text-muted">${loop.index + 1}</td>
                            <td><strong class="text-dark">${pgg.maVoucher}</strong></td>
                            <td>${pgg.tenVoucher}</td>
                            <td>
                                    <span class="badge ${pgg.loaiGiamGia == '%' ? 'bg-dark' : 'bg-light text-dark border'}">
                                            ${pgg.loaiGiamGia == '%' ? 'Phần trăm' : 'Tiền mặt'}
                                    </span>
                            </td>
                            <td>
                                <strong class="text-dark">
                                    <fmt:formatNumber value="${pgg.giaTriGiamGia}" type="number" maxFractionDigits="0"/>
                                        ${pgg.loaiGiamGia == '%' ? '%' : ' đ'}
                                </strong>
                            </td>
                            <td>
                                <c:choose>
                                    <c:when test="${not empty pgg.giamToiDa}">
                                        <fmt:formatNumber value="${pgg.giamToiDa}" type="number" maxFractionDigits="0"/> đ
                                    </c:when>
                                    <c:otherwise>-</c:otherwise>
                                </c:choose>
                            </td>
                            <td>
                                <fmt:formatNumber value="${pgg.donToiThieu}" type="number" maxFractionDigits="0"/> đ
                            </td>
                            <td>
                                <span class="badge bg-light text-dark border">${pgg.soLuong}</span>
                            </td>
                            <td><fmt:formatDate value="${pgg.ngayBatDau}" pattern="dd/MM/yyyy"/></td>
                            <td><fmt:formatDate value="${pgg.ngayKetThuc}" pattern="dd/MM/yyyy"/></td>
                            <td>
                                    <span class="badge ${pgg.trangThai == 1 ? 'bg-light text-dark border' : 'bg-secondary'}">
                                            ${pgg.trangThai == 1 ? 'Đang hoạt động' : 'Ngừng hoạt động'}
                                    </span>
                            </td>
                            <td class="text-center pe-3">
                                <a href="${pageContext.request.contextPath}/phieugiamgia/view-update?id=${pgg.id}"
                                   class="btn btn-sm btn-outline-secondary border-0" title="Chỉnh sửa">
                                    <i class="bi bi-pencil-square fs-6"></i>
                                </a>
                            </td>
                        </tr>
                    </c:forEach>
                    <c:if test="${empty listPhieuGiamGia}">
                        <tr>
                            <td colspan="12" class="text-center py-4 text-muted">
                                Không tìm thấy dữ liệu phiếu giảm giá nào!
                            </td>
                        </tr>
                    </c:if>
                    </tbody>
                </table>
            </div>
        </div>
    </div>

</div>

<!-- JS Bootstrap -->
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>

</body>
</html>
>>>>>>> main
