<%--
  Created by IntelliJ IDEA.
  User: Nvc36
--%>
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
            background-color: #1a1a24;
            color: #ffffff;
            font-weight: 600;
            border-top-left-radius: 10px !important;
            border-top-right-radius: 10px !important;
            padding: 12px 20px;
        }

        .table thead th {
            background-color: #1a1a24 !important;
            color: #ffffff !important;
            font-weight: 600;
            border-bottom: none;
            white-space: nowrap;
        }

        .table td {
            vertical-align: middle;
            font-size: 0.95rem;
        }

        .code-voucher {
            font-weight: 600;
            color: #0d6efd;
        }

        .badge-status-active {
            background-color: #e6f7ff;
            color: #1890ff;
            border: 1px solid #91d5ff;
            padding: 6px 10px;
        }

        .badge-status-inactive {
            background-color: #fff1f0;
            color: #ff4d4f;
            border: 1px solid #ffa39e;
            padding: 6px 10px;
        }
    </style>
</head>

<body>

<%@ include file="/views/layout/sidebar.jsp" %>

<div class="content">

    <!-- Title & Action Button -->
    <div class="d-flex justify-content-between align-items-center mb-4">
        <h3 class="fw-bold text-dark">
            <i class="bi bi-ticket-perforated-fill text-primary me-2"></i>Quản lý phiếu giảm giá
        </h3>
        <div>
            <button class="btn btn-outline-success me-2">
                <i class="bi bi-file-earmark-excel me-1"></i> Xuất Excel
            </button>
            <a href="${pageContext.request.contextPath}/phieugiamgia/view-add" class="btn btn-dark">
                <i class="bi bi-plus-circle me-1"></i> Thêm mới
            </a>
        </div>
    </div>

    <!-- Thông báo kết quả -->
    <c:if test="${not empty success}">
        <div class="alert alert-success alert-dismissible fade show" role="alert">
            <i class="bi bi-check-circle-fill me-2"></i>${success}
            <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
        </div>
    </c:if>

    <c:if test="${not empty error}">
        <div class="alert alert-danger alert-dismissible fade show" role="alert">
            <i class="bi bi-exclamation-triangle-fill me-2"></i>${error}
            <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
        </div>
    </c:if>

    <!-- Bộ lọc tìm kiếm -->
    <div class="card mb-4">
        <div class="card-header">
            <i class="bi bi-funnel-fill me-2"></i>Bộ lọc tìm kiếm
        </div>
        <div class="card-body">
            <form action="${pageContext.request.contextPath}/phieugiamgia/search" method="get">
                <div class="row g-3">
                    <div class="col-md-4">
                        <label class="form-label fw-semibold">Tìm kiếm</label>
                        <input type="text" class="form-control" name="keyword" value="${param.keyword}" placeholder="Nhập mã hoặc tên phiếu giảm giá...">
                    </div>

                    <div class="col-md-3">
                        <label class="form-label fw-semibold">Loại giảm</label>
                        <select class="form-select" name="loaiGiamGia">
                            <option value="">Tất cả</option>
                            <option value="Tiền" ${param.loaiGiamGia == 'Tiền' ? 'selected' : ''}>Tiền mặt</option>
                            <option value="%" ${param.loaiGiamGia == '%' ? 'selected' : ''}>Phần trăm (%)</option>
                        </select>
                    </div>

                    <div class="col-md-3">
                        <label class="form-label fw-semibold">Trạng thái</label>
                        <select class="form-select" name="trangThai">
                            <option value="">Tất cả</option>
                            <option value="1" ${param.trangThai == '1' ? 'selected' : ''}>Đang hoạt động</option>
                            <option value="0" ${param.trangThai == '0' ? 'selected' : ''}>Ngừng hoạt động</option>
                        </select>
                    </div>

                    <div class="col-md-2 d-flex align-items-end">
                        <button type="submit" class="btn btn-primary w-100">
                            <i class="bi bi-search me-1"></i> Tìm kiếm
                        </button>
                    </div>
                </div>

                <div class="row g-3 mt-1">
                    <div class="col-md-3">
                        <label class="form-label fw-semibold">Từ ngày</label>
                        <input type="date" class="form-control" name="from" value="${param.from}">
                    </div>

                    <div class="col-md-3">
                        <label class="form-label fw-semibold">Đến ngày</label>
                        <input type="date" class="form-control" name="to" value="${param.to}">
                    </div>
                </div>
            </form>
        </div>
    </div>

    <!-- Bảng danh sách phiếu giảm giá -->
    <div class="card">
        <div class="card-header">
            <i class="bi bi-table me-2"></i>Danh sách phiếu giảm giá
        </div>

        <div class="card-body table-responsive p-0">
            <table class="table table-hover text-center align-middle mb-0">
                <thead>
                <tr>
                    <th>STT</th>
                    <th>Mã giảm giá</th>
                    <th>Tên giảm giá</th>
                    <th>Loại giảm</th>
                    <th>Giá trị giảm</th>
                    <th>Giảm tối đa</th>
                    <th>Đơn tối thiểu</th>
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
                        <td class="code-voucher">${p.maVoucher}</td>
                        <td class="text-start">${p.tenVoucher}</td>
                        <td>
                            <c:choose>
                                <c:when test="${p.loaiGiamGia=='%'}">
                                    <span class="badge bg-warning text-dark">Phần trăm</span>
                                </c:when>
                                <c:otherwise>
                                    <span class="badge bg-info text-white">Tiền mặt</span>
                                </c:otherwise>
                            </c:choose>
                        </td>
                        <td class="fw-bold">
                            <c:choose>
                                <c:when test="${p.loaiGiamGia=='%'}">
                                    ${p.giaTriGiamGia}%
                                </c:when>
                                <c:otherwise>
                                    <fmt:formatNumber value="${p.giaTriGiamGia}" type="number"/> đ
                                </c:otherwise>
                            </c:choose>
                        </td>
                        <td><fmt:formatNumber value="${p.giamToiDa}" type="number"/> đ</td>
                        <td><fmt:formatNumber value="${p.donToiThieu}" type="number"/> đ</td>
                        <td><span class="badge bg-light text-dark border">${p.soLuong}</span></td>
                        <td><fmt:formatDate value="${p.ngayBatDau}" pattern="dd/MM/yyyy"/></td>
                        <td><fmt:formatDate value="${p.ngayKetThuc}" pattern="dd/MM/yyyy"/></td>
                        <td>
                            <c:choose>
                                <c:when test="${p.trangThai==1}">
                                    <span class="badge badge-status-active rounded-pill">Đang hoạt động</span>
                                </c:when>
                                <c:otherwise>
                                    <span class="badge badge-status-inactive rounded-pill">Ngừng hoạt động</span>
                                </c:otherwise>
                            </c:choose>
                        </td>
                        <td>
                            <a href="${pageContext.request.contextPath}/phieugiamgia/view-update?id=${p.id}"
                               class="btn btn-outline-warning btn-sm"
                               title="Sửa">
                                <i class="bi bi-pencil-square"></i>
                            </a>
                        </td>
                    </tr>
                </c:forEach>
                </tbody>
            </table>
        </div>
    </div>

</div>

<!-- JS Bootstrap -->
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>