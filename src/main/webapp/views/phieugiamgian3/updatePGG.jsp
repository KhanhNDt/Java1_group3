<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <title>Danh sách phiếu giảm giá - Scott Admin</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.css" rel="stylesheet">
    <style>
        body { background-color: #f4f6f9; font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif; }
        .content { margin-left: 250px; padding: 25px 30px; }
        .card { border: none; border-radius: 10px; box-shadow: 0 4px 12px rgba(0,0,0,0.05); }
    </style>
</head>
<body>

<%@ include file="/views/layout/sidebar.jsp" %>

<div class="content">

    <div class="d-flex justify-content-between align-items-center mb-4">
        <h3 class="fw-bold text-dark"><i class="bi bi-tags-fill text-primary me-2"></i>Quản lý phiếu giảm giá</h3>
        <a href="${pageContext.request.contextPath}/phieugiamgia/view-add" class="btn btn-primary">
            <i class="bi bi-plus-lg me-1"></i> Thêm mới
        </a>
    </div>

    <!-- Thông báo Flash -->
    <c:if test="${not empty success}">
        <div class="alert alert-success alert-dismissible fade show" role="alert">
                ${success}
            <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
        </div>
    </c:if>

    <div class="card">
        <div class="card-body p-0">
            <div class="table-responsive">
                <table class="table table-hover align-middle mb-0">
                    <thead class="table-dark">
                    <tr>
                        <th>ID</th>
                        <th>Mã Voucher</th>
                        <th>Tên Voucher</th>
                        <th>Loại</th>
                        <th>Giá trị</th>
                        <th>Giảm tối đa</th>
                        <th>Số lượng</th>
                        <th>Trạng thái</th>
                        <th class="text-center">Thao tác</th>
                    </tr>
                    </thead>
                    <tbody>
                    <c:forEach items="${listPhieuGiamGia}" var="pgg">
                        <tr>
                            <td>${pgg.id}</td>
                            <td><strong>${pgg.maVoucher}</strong></td>
                            <td>${pgg.tenVoucher}</td>
                            <td>
                                    <span class="badge ${pgg.loaiGiamGia == '%' ? 'bg-info' : 'bg-warning'} text-dark">
                                            ${pgg.loaiGiamGia}
                                    </span>
                            </td>
                            <td>
                                <fmt:formatNumber value="${pgg.giaTriGiamGia}" type="currency" currencySymbol="" maxFractionDigits="0"/>
                                    ${pgg.loaiGiamGia == '%' ? '%' : 'VNĐ'}
                            </td>
                            <td>
                                <c:choose>
                                    <c:when test="${not empty pgg.giamToiDa}">
                                        <fmt:formatNumber value="${pgg.giamToiDa}" type="currency" currencySymbol="VNĐ" maxFractionDigits="0"/>
                                    </c:when>
                                    <c:otherwise>-</c:otherwise>
                                </c:choose>
                            </td>
                            <td>${pgg.soLuong}</td>
                            <td>
                                    <span class="badge ${pgg.trangThai == 1 ? 'bg-success' : 'bg-secondary'}">
                                            ${pgg.trangThai == 1 ? 'Đang hoạt động' : 'Ngừng hoạt động'}
                                    </span>
                            </td>
                            <td class="text-center">
                                <!-- Nút Sửa gọi đường dẫn view-update kèm ID -->
                                <a href="${pageContext.request.contextPath}/phieugiamgia/view-update?id=${pgg.id}" class="btn btn-sm btn-outline-warning me-1">
                                    <i class="bi bi-pencil-square"></i> Sửa
                                </a>
                                <a href="${pageContext.request.contextPath}/phieugiamgia/delete?id=${pgg.id}"
                                   class="btn btn-sm btn-outline-danger"
                                   onclick="return confirm('Bạn có chắc chắn muốn xóa?')">
                                    <i class="bi bi-trash"></i> Xóa
                                </a>
                            </td>
                        </tr>
                    </c:forEach>
                    </tbody>
                </table>
            </div>
        </div>
    </div>
</div>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>