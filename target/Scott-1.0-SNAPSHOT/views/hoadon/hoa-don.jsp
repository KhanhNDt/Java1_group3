<%--
  Created by IntelliJ IDEA.
  User: acer
  Date: 11/07/2026
  Time: 2:57 CH
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" pageEncoding="UTF-8" %>
<%@ taglib uri="jakarta.tags.core" prefix="c" %>
<%@ taglib uri="jakarta.tags.fmt" prefix="fmt" %>
<fmt:setLocale value="vi_VN"/>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <title>Quản lý hóa đơn</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.css" rel="stylesheet">
    <style>
        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
            font-family: 'Segoe UI', sans-serif;
        }

        body {
            background: #f4f7fe;
        }

        .sidebar {
            position: fixed;
            left: 0;
            top: 0;
            width: 260px;
            height: 100vh;
            background: #5E35B1;
            color: white;
            overflow-y: auto;
            z-index: 1000;
        }

        .logo {
            text-align: center;
            padding: 30px 20px;
        }

        .logo h2 {
            font-weight: bold;
            letter-spacing: 2px;
        }

        .logo span {
            color: #FFD54F;
        }

        .menu {
            padding: 10px;
        }

        .menu a {
            display: flex;
            align-items: center;
            text-decoration: none;
            color: white;
            padding: 14px 18px;
            margin-bottom: 8px;
            border-radius: 12px;
            transition: .3s;
        }

        .menu a i {
            font-size: 20px;
            margin-right: 15px;
        }

        .menu a:hover {
            background: white;
            color: #5E35B1;
        }

        .menu .active {
            background: white;
            color: #5E35B1;
        }

        .bottom {
            position: absolute;
            bottom: 20px;
            width: 100%;
            padding: 0 10px;
        }

        .bottom a {
            display: flex;
            align-items: center;
            color: white;
            text-decoration: none;
            padding: 14px 18px;
            border-radius: 12px;
        }

        .bottom a:hover {
            background: #7E57C2;
        }

        .main-content {
            margin-left: 260px;
            padding: 30px;
            min-height: 100vh;
        }

        .card-box {
            background: white;
            border-radius: 12px;
            padding: 20px;
            box-shadow: 0 2px 10px rgba(0, 0, 0, 0.05);
        }

        .badge-success {
            background: #D8F5E7;
            color: #1E7E34;
            padding: 6px 12px;
            border-radius: 20px;
        }

        .badge-warning {
            background: #FFF3CD;
            color: #856404;
            padding: 6px 12px;
            border-radius: 20px;
        }

        .badge-danger {
            background: #FDE3E3;
            color: #B02A37;
            padding: 6px 12px;
            border-radius: 20px;
        }

        .badge-secondary {
            background: #E9ECEF;
            color: #6C757D;
            padding: 6px 12px;
            border-radius: 20px;
        }

        .filter-bar {
            background: white;
            border-radius: 12px;
            padding: 20px;
            margin-bottom: 25px;
            box-shadow: 0 2px 10px rgba(0, 0, 0, 0.05);
        }

        .btn-primary-custom {
            background: #5E35B1;
            border: none;
            color: white;
        }

        .btn-primary-custom:hover {
            background: #4A2A8F;
            color: white;
        }

        .table th {
            white-space: nowrap;
        }

        .table td {
            vertical-align: middle;
        }

        .pagination .page-item.active .page-link {
            background: #5E35B1;
            border-color: #5E35B1;
            color: white;
        }

        .pagination .page-link {
            color: #5E35B1;
        }
    </style>
</head>
<body>

<jsp:include page="/views/layout/sidebar.jsp"/>

<div class="main-content">

    <div class="d-flex justify-content-between align-items-center mb-3">
        <h2>Quản lý hóa đơn</h2>
        <a href="${pageContext.request.contextPath}/order" class="btn btn-primary-custom">
            <i class="bi bi-plus-circle"></i> Tạo hóa đơn mới
        </a>
    </div>

    <c:if test="${not empty sessionScope.message}">
        <div class="alert alert-success alert-dismissible fade show" role="alert">
                ${sessionScope.message}
            <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
        </div>
        <c:remove var="message" scope="session"/>
    </c:if>
    <c:if test="${not empty sessionScope.error}">
        <div class="alert alert-danger alert-dismissible fade show" role="alert">
                ${sessionScope.error}
            <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
        </div>
        <c:remove var="error" scope="session"/>
    </c:if>

    <div class="row g-3 mb-4">
        <div class="col-md-4">
            <div class="card-box">
                <h6 class="text-muted">Doanh thu hôm nay</h6>
                <h2 class="text-primary">
                    <fmt:formatNumber value="${revenueToday}" type="currency" currencySymbol="₫"/>
                </h2>
            </div>
        </div>
        <div class="col-md-4">
            <div class="card-box">
                <h6 class="text-muted">Đơn chờ xử lý</h6>
                <h2 class="text-warning">${pending}</h2>
            </div>
        </div>
        <div class="col-md-4">
            <div class="card-box">
                <h6 class="text-muted">Đơn đã hủy</h6>
                <h2 class="text-danger">${cancelled}</h2>
            </div>
        </div>
    </div>

    <div class="filter-bar">
        <form action="${pageContext.request.contextPath}/quanlyhoadon" method="get" class="row g-3 align-items-end">

            <div class="col-md-2">
                <label class="form-label fw-bold">Tìm kiếm</label>
                <input type="text" name="keyword" class="form-control" placeholder="Mã, tên KH, SĐT..."
                       value="${keyword}">
            </div>

            <div class="col-md-2">
                <label class="form-label fw-bold">Trạng thái</label>
                <select name="status" class="form-select">
                    <option value="">Tất cả</option>
                    <option value="0" ${status == 0 ? 'selected' : ''}>Chờ xử lý</option>
                    <option value="1" ${status == 1 ? 'selected' : ''}>Đã thanh toán</option>
                    <option value="2" ${status == 2 ? 'selected' : ''}>Đã hủy</option>
                    <option value="3" ${status == 3 ? 'selected' : ''}>Đã xóa</option>
                </select>
            </div>

            <div class="col-md-2">
                <label class="form-label fw-bold">Hình thức</label>
                <select name="paymentMethod" class="form-select">
                    <option value="">Tất cả</option>
                    <option value="1">Tiền mặt</option>
                    <option value="2">Chuyển khoản</option>
                </select>
            </div>

            <div class="col-md-1">
                <label class="form-label fw-bold">Từ</label>
                <input type="number" name="fromPrice" class="form-control" placeholder="0" value="${fromPrice}">
            </div>
            <div class="col-md-1">
                <label class="form-label fw-bold">Đến</label>
                <input type="number" name="toPrice" class="form-control" placeholder="∞" value="${toPrice}">
            </div>

            <div class="col-md-2 d-flex gap-2">
                <button type="submit" class="btn btn-primary-custom w-100">
                    <i class="bi bi-search"></i> Tìm
                </button>
                <a href="${pageContext.request.contextPath}/quanlyhoadon?action=export&keyword=${keyword}&status=${status}"
                   class="btn btn-success w-100">
                    <i class="bi bi-file-earmark-excel"></i> Excel
                </a>
            </div>
        </form>
    </div>

    <div class="card-box">
        <table class="table table-striped table-hover align-middle">
            <thead class="table-light">
            <tr>
                <th>STT</th>
                <th>Mã hóa đơn</th>
                <th>Ngày tạo</th>
                <th>Ngày thanh toán</th>
                <th>Tổng tiền</th>
                <th>Mã NV</th>
                <th>Tên khách hàng</th>
                <th>Địa chỉ</th>
                <th>SĐT</th>
                <th>Trạng thái</th>
                <th>Thao tác</th>
            </tr>
            </thead>
            <tbody>
            <c:forEach var="hd" items="${invoiceList}" varStatus="loop">
                <tr>
                    <td>${loop.index + 1 + (currentPage - 1) * 10}</td>
                    <td><span class="fw-bold">${hd.maHoaDon}</span></td>
                    <td><fmt:formatDate value="${hd.ngayTao}" pattern="dd/MM/yyyy HH:mm"/></td>
                    <td><fmt:formatDate value="${hd.ngayThanhToan}" pattern="dd/MM/yyyy HH:mm"/></td>
                    <td><fmt:formatNumber value="${hd.tongTienThanhToan}" type="currency" currencySymbol="₫"/></td>
                    <td>${hd.maNhanVien}</td>
                    <td>${hd.tenKhachHang}</td>
                    <td>${hd.diaChiKhachHang}</td>
                    <td>${hd.sdtKhachHang}</td>
                    <td>
                        <c:choose>
                            <c:when test="${hd.trangThai == 1}"><span
                                    class="badge-success">Đã thanh toán</span></c:when>
                            <c:when test="${hd.trangThai == 0}"><span class="badge-warning">Chờ xử lý</span></c:when>
                            <c:when test="${hd.trangThai == 2}"><span class="badge-danger">Đã hủy</span></c:when>
                            <c:when test="${hd.trangThai == 3}"><span class="badge-secondary">Đã xóa</span></c:when>
                        </c:choose>
                    </td>
                    <td>
                        <div class="d-flex gap-1">
                            <a href="${pageContext.request.contextPath}/quanlyhoadon?action=detail&id=${hd.id}"
                               class="btn btn-sm btn-outline-info" title="Chi tiết">
                                <i class="bi bi-eye"></i>
                            </a>
                            <div class="dropdown">
                                <button class="btn btn-sm btn-outline-secondary dropdown-toggle"
                                        data-bs-toggle="dropdown">
                                    <i class="bi bi-pencil"></i>
                                </button>
                                <ul class="dropdown-menu">
                                    <li><a class="dropdown-item"
                                           href="${pageContext.request.contextPath}/quanlyhoadon?action=updateStatus&id=${hd.id}&status=1">Đã
                                        thanh toán</a></li>
                                    <li><a class="dropdown-item"
                                           href="${pageContext.request.contextPath}/quanlyhoadon?action=updateStatus&id=${hd.id}&status=0">Chờ
                                        xử lý</a></li>
                                    <li><a class="dropdown-item"
                                           href="${pageContext.request.contextPath}/quanlyhoadon?action=updateStatus&id=${hd.id}&status=2">Đã
                                        hủy</a></li>
                                </ul>
                            </div>
                            <a href="${pageContext.request.contextPath}/quanlyhoadon?action=delete&id=${hd.id}"
                               class="btn btn-sm btn-outline-danger"
                               onclick="return confirm('Xóa hóa đơn này?')" title="Xóa">
                                <i class="bi bi-trash"></i>
                            </a>
                        </div>
                    </td>
                </tr>
            </c:forEach>
            <c:if test="${empty invoiceList}">
                <tr>
                    <td colspan="11" class="text-center py-4 text-muted">Không có hóa đơn nào.</td>
                </tr>
            </c:if>
            </tbody>
        </table>

        <!-- Phân trang -->
        <c:if test="${totalPages > 1}">
            <nav class="mt-3">
                <ul class="pagination justify-content-center">
                    <c:if test="${currentPage > 1}">
                        <li class="page-item">
                            <a class="page-link"
                               href="?page=${currentPage - 1}&keyword=${keyword}&status=${status}&fromPrice=${fromPrice}&toPrice=${toPrice}&paymentMethod=${paymentMethod}">Previous</a>
                        </li>
                    </c:if>
                    <c:forEach begin="1" end="${totalPages}" var="i">
                        <li class="page-item ${i == currentPage ? 'active' : ''}">
                            <a class="page-link"
                               href="?page=${i}&keyword=${keyword}&status=${status}&fromPrice=${fromPrice}&toPrice=${toPrice}&paymentMethod=${paymentMethod}">${i}</a>
                        </li>
                    </c:forEach>
                    <c:if test="${currentPage < totalPages}">
                        <li class="page-item">
                            <a class="page-link"
                               href="?page=${currentPage + 1}&keyword=${keyword}&status=${status}&fromPrice=${fromPrice}&toPrice=${toPrice}&paymentMethod=${paymentMethod}">Next</a>
                        </li>
                    </c:if>
                </ul>
            </nav>
        </c:if>
    </div>
</div>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>