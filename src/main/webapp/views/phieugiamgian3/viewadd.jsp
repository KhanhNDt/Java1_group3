<%--
  Created by IntelliJ IDEA.
  User: Nvc36
  Date: 7/21/2026
  Time: 8:01 PM
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <title>Thêm mới phiếu giảm giá - Scott Admin</title>

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
            padding: 14px 20px;
        }

        .form-label {
            font-weight: 600;
            color: #333;
            font-size: 0.9rem;
        }
    </style>
</head>

<body>

<%@ include file="/views/layout/sidebar.jsp" %>

<div class="content">

    <!-- Title & Navigation Button -->
    <div class="d-flex justify-content-between align-items-center mb-4">
        <h3 class="fw-bold text-dark">
            <i class="bi bi-plus-circle text-primary me-2"></i>Thêm mới phiếu giảm giá
        </h3>
        <a href="${pageContext.request.contextPath}/phieugiamgia/hien-thi" class="btn btn-outline-secondary">
            <i class="bi bi-arrow-left me-1"></i> Quay lại danh sách
        </a>
    </div>

    <!-- Card Form -->
    <div class="card">
        <div class="card-header">
            <i class="bi bi-info-circle me-2"></i>Thông tin phiếu giảm giá mới
        </div>

        <div class="card-body p-4">
            <form action="${pageContext.request.contextPath}/phieugiamgia/add" method="post">

                <div class="row g-3">
                    <!-- Mã Voucher -->
                    <div class="col-md-6">
                        <label class="form-label">Mã Voucher <span class="text-danger">*</span></label>
                        <input type="text" class="form-control" name="maVoucher" placeholder="Ví dụ: VOUCHER2026" required>
                    </div>

                    <!-- Tên Voucher -->
                    <div class="col-md-6">
                        <label class="form-label">Tên Voucher <span class="text-danger">*</span></label>
                        <input type="text" class="form-control" name="tenVoucher" placeholder="Ví dụ: Giảm giá hè 2026" required>
                    </div>

                    <!-- Loại Giảm Giá -->
                    <div class="col-md-6">
                        <label class="form-label">Loại giảm giá</label>
                        <select class="form-select" name="loaiGiamGia">
                            <option value="%">Phần trăm (%)</option>
                            <option value="Tiền">Tiền mặt (VNĐ)</option>
                        </select>
                    </div>

                    <!-- Giá trị giảm -->
                    <div class="col-md-6">
                        <label class="form-label">Giá trị giảm</label>
                        <input type="number" step="any" class="form-control" name="giaTriGiamGia" placeholder="Nhập số % hoặc số tiền">
                    </div>

                    <!-- Giảm tối đa -->
                    <div class="col-md-4">
                        <label class="form-label">Giảm tối đa (VNĐ)</label>
                        <input type="number" step="any" class="form-control" name="giamToiDa" placeholder="0">
                    </div>

                    <!-- Đơn tối thiểu -->
                    <div class="col-md-4">
                        <label class="form-label">Đơn tối thiểu (VNĐ)</label>
                        <input type="number" step="any" class="form-control" name="donToiThieu" placeholder="0">
                    </div>

                    <!-- Số lượng -->
                    <div class="col-md-4">
                        <label class="form-label">Số lượng</label>
                        <input type="number" class="form-control" name="soLuong" placeholder="100">
                    </div>

                    <!-- Ngày bắt đầu -->
                    <div class="col-md-6">
                        <label class="form-label">Ngày bắt đầu</label>
                        <input type="date" class="form-control" name="ngayBatDau">
                    </div>

                    <!-- Ngày kết thúc -->
                    <div class="col-md-6">
                        <label class="form-label">Ngày kết thúc</label>
                        <input type="date" class="form-control" name="ngayKetThuc">
                    </div>
                </div>

                <!-- Submit Button -->
                <div class="mt-4 text-end">
                    <a href="${pageContext.request.contextPath}/phieugiamgia/hien-thi" class="btn btn-light border me-2">Hủy bỏ</a>
                    <button type="submit" class="btn btn-primary px-4">
                        <i class="bi bi-save me-1"></i> Lưu phiếu
                    </button>
                </div>

            </form>
        </div>
    </div>

</div>

<!-- JS Bootstrap -->
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>