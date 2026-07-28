<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <title>Thêm mới phiếu giảm giá - Scott Admin</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.css" rel="stylesheet">
    <style>
        body { background-color: #f4f6f9; font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif; }
        .content { margin-left: 250px; padding: 25px 30px; }
        .card { border: none; border-radius: 10px; box-shadow: 0 4px 12px rgba(0, 0, 0, 0.05); }
        .card-header { background-color: #1a1a24; color: #fff; font-weight: 600; padding: 14px 20px; }
        .form-label { font-weight: 600; color: #333; }
    </style>
</head>
<body>

<%@ include file="/views/layout/sidebar.jsp" %>

<div class="content">
    <div class="d-flex justify-content-between align-items-center mb-4">
        <h3 class="fw-bold text-dark"><i class="bi bi-plus-circle text-primary me-2"></i>Thêm mới phiếu giảm giá</h3>
        <a href="${pageContext.request.contextPath}/phieugiamgia/hien-thi" class="btn btn-outline-secondary">
            <i class="bi bi-arrow-left me-1"></i> Quay lại danh sách
        </a>
    </div>

    <div class="card">
        <div class="card-header"><i class="bi bi-info-circle me-2"></i>Nhập thông tin phiếu mới</div>
        <div class="card-body p-4">
            <form action="${pageContext.request.contextPath}/phieugiamgia/add" method="post">
                <div class="row g-3">
                    <div class="col-md-6">
                        <label class="form-label">Mã Voucher <span class="text-danger">*</span></label>
                        <input type="text" class="form-control" name="maVoucher" placeholder="Ví dụ: SUMMER2026" required>
                    </div>
                    <div class="col-md-6">
                        <label class="form-label">Tên Voucher <span class="text-danger">*</span></label>
                        <input type="text" class="form-control" name="tenVoucher" placeholder="Ví dụ: Giảm giá hè" required>
                    </div>
                    <div class="col-md-6">
                        <label class="form-label">Loại giảm giá</label>
                        <select class="form-select" id="loaiGiamGia" name="loaiGiamGia" onchange="toggleGiamToiDa()">
                            <option value="%">Phần trăm (%)</option>
                            <option value="Tiền">Tiền mặt (VNĐ)</option>
                        </select>
                    </div>
                    <div class="col-md-4">
                        <label class="form-label">Giá trị giảm <span class="text-danger">*</span></label>
                        <input type="number" step="any" class="form-control" name="giaTriGiamGia" required>
                    </div>
                    <div class="col-md-4" id="groupGiamToiDa">
                        <label class="form-label">Giảm tối đa (VNĐ)</label>
                        <input type="number" step="any" class="form-control" name="giamToiDa">
                    </div>
                    <div class="col-md-4">
                        <label class="form-label">Đơn tối thiểu (VNĐ)</label>
                        <input type="number" step="any" class="form-control" name="donToiThieu">
                    </div>
                    <div class="col-md-4">
                        <label class="form-label">Số lượng <span class="text-danger">*</span></label>
                        <input type="number" class="form-control" name="soLuong" required>
                    </div>
                    <div class="col-md-4">
                        <label class="form-label">Ngày bắt đầu <span class="text-danger">*</span></label>
                        <input type="date" class="form-control" name="ngayBatDau" required>
                    </div>
                    <div class="col-md-4">
                        <label class="form-label">Ngày kết thúc <span class="text-danger">*</span></label>
                        <input type="date" class="form-control" name="ngayKetThuc" required>
                    </div>
                </div>

                <div class="mt-4 text-end">
                    <a href="${pageContext.request.contextPath}/phieugiamgia/hien-thi" class="btn btn-light border me-2">Hủy bỏ</a>
                    <button type="submit" class="btn btn-primary px-4"><i class="bi bi-plus-lg me-1"></i> Thêm mới</button>
                </div>
            </form>
        </div>
    </div>
</div>

<script>
    function toggleGiamToiDa() {
        var val = document.getElementById("loaiGiamGia").value.trim();
        var group = document.getElementById("groupGiamToiDa");
        if (val !== "%") {
            group.style.display = "none";
        } else {
            group.style.display = "block";
        }
    }

    document.addEventListener("DOMContentLoaded", function() {
        toggleGiamToiDa();
    });
</script>
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>