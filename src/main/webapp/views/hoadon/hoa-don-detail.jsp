<%--
  Created by IntelliJ IDEA.
  User: acer
  Date: 11/07/2026
  Time: 3:30 CH
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" pageEncoding="UTF-8" %>
<%@ taglib uri="jakarta.tags.core" prefix="c" %>
<%@ taglib uri="jakarta.tags.fmt" prefix="fmt" %>
<fmt:setLocale value="vi_VN"/>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Chi tiết hóa đơn</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.css" rel="stylesheet">
    <style>
        @media print {
            .no-print {
                display: none !important;
            }

            .container {
                width: 100% !important;
            }
        }

        body {
            background: #f4f7fe;
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

        .btn-primary-custom {
            background: #5E35B1;
            border: none;
            color: white;
        }

        .btn-primary-custom:hover {
            background: #4A2A8F;
            color: white;
        }
    </style>
</head>
<body>

<!-- Sidebar -->
<jsp:include page="/views/layout/sidebar.jsp"/>

<div class="main-content">
    <div class="d-flex justify-content-between align-items-center mb-3">
        <h2>Chi tiết hóa đơn #${invoice.maHoaDon}</h2>
        <div class="no-print">
            <a href="${pageContext.request.contextPath}/quanlyhoadon" class="btn btn-secondary">
                <i class="bi bi-arrow-left"></i> Quay lại
            </a>
        </div>
    </div>

    <!-- Thông báo -->
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

    <div class="row">
        <!-- Thông tin hóa đơn -->
        <div class="col-md-6">
            <div class="card-box">
                <h5>Thông tin hóa đơn</h5>
                <table class="table table-borderless">
                    <tr>
                        <th>Mã hóa đơn:</th>
                        <td>${invoice.maHoaDon}</td>
                    </tr>
                    <tr>
                        <th>Khách hàng:</th>
                        <td>${invoice.tenKhachHang}</td>
                    </tr>
                    <tr>
                        <th>Nhân viên:</th>
                        <td>${invoice.tenNhanVien}</td>
                    </tr>
                    <tr>
                        <th>Ngày tạo:</th>
                        <td><fmt:formatDate value="${invoice.ngayTao}" pattern="dd/MM/yyyy HH:mm"/></td>
                    </tr>
                    <tr>
                        <th>Ngày thanh toán:</th>
                        <td><fmt:formatDate value="${invoice.ngayThanhToan}" pattern="dd/MM/yyyy HH:mm"/></td>
                    </tr>
                    <tr>
                        <th>Tổng tiền:</th>
                        <td><fmt:formatNumber value="${invoice.tongTienThanhToan}" type="currency"
                                              currencySymbol="₫"/></td>
                    </tr>
                    <tr>
                        <th>Voucher:</th>
                        <td>${invoice.maVoucher}</td>
                    </tr>
                    <tr>
                        <th>Ghi chú:</th>
                        <td>${invoice.ghiChu}</td>
                    </tr>
                    <tr>
                        <th>Trạng thái:</th>
                        <td>
                            <c:choose>
                                <c:when test="${invoice.trangThai == 1}"><span
                                        class="badge-success">Đã thanh toán</span></c:when>
                                <c:when test="${invoice.trangThai == 0}"><span
                                        class="badge-warning">Chờ xử lý</span></c:when>
                                <c:when test="${invoice.trangThai == 2}"><span
                                        class="badge-danger">Đã hủy</span></c:when>
                                <c:when test="${invoice.trangThai == 3}"><span
                                        class="badge-secondary">Đã xóa</span></c:when>
                                <c:otherwise>Khác</c:otherwise>
                            </c:choose>
                        </td>
                    </tr>
                </table>
            </div>
        </div>

        <!-- Form cập nhật ghi chú (no-print) -->
        <div class="col-md-6 no-print">
            <div class="card-box">
                <h5>Cập nhật ghi chú</h5>
                <form action="${pageContext.request.contextPath}/quanlyhoadon" method="post">
                    <input type="hidden" name="action" value="updateNote">
                    <input type="hidden" name="id" value="${invoice.id}">
                    <div class="mb-3">
                        <textarea name="note" class="form-control" rows="3">${invoice.ghiChu}</textarea>
                    </div>
                    <button type="submit" class="btn btn-primary-custom"><i class="bi bi-save"></i> Cập nhật</button>
                    <button onclick="window.print()" class="btn btn-info"><i class="bi bi-printer"></i> In hóa đơn
                    </button>
                </form>
            </div>
        </div>
    </div>

    <!-- Danh sách sản phẩm -->
    <div class="card-box mt-4">
        <h5>Sản phẩm đã mua</h5>
        <table class="table table-striped table-hover align-middle">
            <thead class="table-light">
            <tr>
                <th>STT</th>
                <th>Sản phẩm</th>
                <th>Số lượng</th>
                <th>Đơn giá</th>
                <th>Thành tiền</th>
            </tr>
            </thead>
            <tbody>
            <c:forEach var="ct" items="${details}" varStatus="loop">
                <tr>
                    <td>${loop.index + 1}</td>
                    <td>${ct.tenSanPham}</td>
                    <td>${ct.soLuong}</td>
                    <td><fmt:formatNumber value="${ct.giaBanRa}" type="currency" currencySymbol="₫"/></td>
                    <td><fmt:formatNumber value="${ct.tongTien}" type="currency" currencySymbol="₫"/></td>
                </tr>
            </c:forEach>
            <c:if test="${empty details}">
                <tr>
                    <td colspan="5" class="text-center text-muted">Không có sản phẩm nào.</td>
                </tr>
            </c:if>
            </tbody>
        </table>
    </div>
</div>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>