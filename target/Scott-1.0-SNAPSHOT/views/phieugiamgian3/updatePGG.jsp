<<<<<<< HEAD
=======
<%--
  Created by IntelliJ IDEA.
  User: Nvc36
  Date: 7/11/2026
  Time: 4:23 PM
<<<<<<< HEAD
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <title>Title</title>
</head>
<body>
<form action="${pageContext.request.contextPath}/phieugiamgia/update" method="post">

    ID :
    <input type="text" name="id" value="${phieugiamgiaS.id}" readonly>
    <br>

    Mã Voucher :
    <input type="text" name="maVoucher" value="${phieugiamgiaS.maVoucher}">
    <br>

    Tên Voucher :
    <input type="text" name="tenVoucher" value="${phieugiamgiaS.tenVoucher}">
    <br>

    Giá trị giảm :
    <input type="number" name="giaTriGiamGia" value="${phieugiamgiaS.giaTriGiamGia}">
    <br>

    Giảm tối đa :
    <input type="number" name="giamToiDa" value="${phieugiamgiaS.giamToiDa}">
    <br>

    Đơn tối thiểu :
    <input type="number" name="donToiThieu" value="${phieugiamgiaS.donToiThieu}">
    <br>

    Ngày bắt đầu :
    <input type="date" name="ngayBatDau"
           value="${phieugiamgiaS.ngayBatDau}">
    <br>

    Ngày kết thúc :
    <input type="date" name="ngayKetThuc"
           value="${phieugiamgiaS.ngayKetThuc}">
    <br>

    <button type="submit">Update</button>

</form>
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
    <title>Cập nhật phiếu giảm giá - Scott Admin</title>

    <!-- Bootstrap 5 CSS & Icons -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.css" rel="stylesheet">

    <!-- Flatpickr CSS (Định dạng ngày dd/MM/yyyy) -->
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/flatpickr/dist/flatpickr.min.css">

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

        .flatpickr-input[readonly] {
            background-color: #fff !important;
        }
    </style>
</head>

<body>

<%@ include file="/views/layout/sidebar.jsp" %>

<div class="content">

    <!-- Header & Back Button -->
    <div class="d-flex justify-content-between align-items-center mb-4">
        <h3 class="fw-bold text-dark mb-0">
            <i class="bi bi-pencil-square me-2"></i>Cập nhật phiếu giảm giá
        </h3>
        <a href="${pageContext.request.contextPath}/phieugiamgia/hien-thi" class="btn btn-outline-secondary">
            <i class="bi bi-arrow-left me-1"></i> Quay lại
        </a>
    </div>

    <!-- Form Cập Nhật -->
    <div class="card">
        <div class="card-header fw-bold text-dark">
            Thông tin phiếu giảm giá ID: #${phieugiamgiaS.id}
        </div>
        <div class="card-body p-4">
            <form action="${pageContext.request.contextPath}/phieugiamgia/update" method="post">
                <!-- ID Ẩn để submit -->
                <input type="hidden" name="id" value="${phieugiamgiaS.id}">

                <div class="row g-3">
                    <!-- Mã Voucher -->
                    <div class="col-md-6">
                        <label class="form-label fw-semibold">Mã giảm giá <span class="text-danger">*</span></label>
                        <input type="text" class="form-control" name="maVoucher"
                               value="${phieugiamgiaS.maVoucher}" required placeholder="Ví dụ: VOUCHER2026">
                    </div>

                    <!-- Tên Voucher -->
                    <div class="col-md-6">
                        <label class="form-label fw-semibold">Tên giảm giá <span class="text-danger">*</span></label>
                        <input type="text" class="form-control" name="tenVoucher"
                               value="${phieugiamgiaS.tenVoucher}" required placeholder="Ví dụ: Giảm giá mùa hè">
                    </div>

                    <!-- Loại giảm giá -->
                    <div class="col-md-4">
                        <label class="form-label fw-semibold">Loại giảm giá <span class="text-danger">*</span></label>
                        <select class="form-select" id="loaiGiamGia" name="loaiGiamGia" onchange="toggleGiamToiDa()">
                            <option value="%" ${phieugiamgiaS.loaiGiamGia == '%' ? 'selected' : ''}>Phần trăm (%)</option>
                            <option value="Tiền" ${phieugiamgiaS.loaiGiamGia == 'Tiền' ? 'selected' : ''}>Tiền mặt (VNĐ)</option>
                        </select>
                    </div>

                    <!-- Giá trị giảm -->
                    <div class="col-md-4">
                        <label class="form-label fw-semibold">Giá trị giảm <span class="text-danger">*</span></label>
                        <input type="number" step="any" class="form-control" name="giaTriGiamGia"
                               value="${phieugiamgiaS.giaTriGiamGia}" required placeholder="Nhập số tiền hoặc %">
                    </div>

                    <!-- Giảm tối đa (Tự ẩn nếu là tiền mặt) -->
                    <div class="col-md-4" id="boxGiamToiDa">
                        <label class="form-label fw-semibold">Giảm tối đa (đ)</label>
                        <input type="number" step="any" class="form-control" id="giamToiDa" name="giamToiDa"
                               value="${phieugiamgiaS.giamToiDa}" placeholder="Nhập số tiền giảm tối đa">
                    </div>

                    <!-- Đơn tối thiểu -->
                    <div class="col-md-6">
                        <label class="form-label fw-semibold">Giá trị đơn tối thiểu (đ) <span class="text-danger">*</span></label>
                        <input type="number" step="any" class="form-control" name="donToiThieu"
                               value="${phieugiamgiaS.donToiThieu}" required placeholder="Nhập điều kiện đơn hàng">
                    </div>

                    <!-- Số lượng -->
                    <div class="col-md-6">
                        <label class="form-label fw-semibold">Số lượng phát hành <span class="text-danger">*</span></label>
                        <input type="number" class="form-control" name="soLuong"
                               value="${phieugiamgiaS.soLuong}" required min="1">
                    </div>

                    <!-- Ngày bắt đầu (định dạng dd/mm/yyyy) -->
                    <div class="col-md-4">
                        <label class="form-label fw-semibold">Ngày bắt đầu <span class="text-danger">*</span></label>
                        <input type="text" class="form-control datepicker" name="ngayBatDau"
                               value="<fmt:formatDate value='${phieugiamgiaS.ngayBatDau}' pattern='yyyy-MM-dd'/>" required placeholder="dd/mm/yyyy">
                    </div>

                    <!-- Ngày kết thúc (định dạng dd/mm/yyyy) -->
                    <div class="col-md-4">
                        <label class="form-label fw-semibold">Ngày kết thúc <span class="text-danger">*</span></label>
                        <input type="text" class="form-control datepicker" name="ngayKetThuc"
                               value="<fmt:formatDate value='${phieugiamgiaS.ngayKetThuc}' pattern='yyyy-MM-dd'/>" required placeholder="dd/mm/yyyy">
                    </div>

                    <!-- Trạng thái -->
                    <div class="col-md-4">
                        <label class="form-label fw-semibold">Trạng thái <span class="text-danger">*</span></label>
                        <select class="form-select" name="trangThai">
                            <option value="1" ${phieugiamgiaS.trangThai == 1 ? 'selected' : ''}>Đang hoạt động</option>
                            <option value="0" ${phieugiamgiaS.trangThai == 0 ? 'selected' : ''}>Ngừng hoạt động</option>
                        </select>
                    </div>
                </div>

                <!-- Action Buttons -->
                <div class="mt-4 text-end">
                    <a href="${pageContext.request.contextPath}/phieugiamgia/hien-thi" class="btn btn-light me-2">Hủy bỏ</a>
                    <button type="submit" class="btn btn-dark px-4">
                        <i class="bi bi-save me-1"></i> Lưu thay đổi
                    </button>
                </div>
            </form>
        </div>
    </div>

</div>

<!-- JS Bootstrap -->
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>

<!-- JS Flatpickr & Tiếng Việt -->
<script src="https://cdn.jsdelivr.net/npm/flatpickr"></script>
<script src="https://npmcdn.com/flatpickr/dist/l10n/vn.js"></script>

<script>
    // Kích hoạt ô ngày tháng định dạng dd/mm/yyyy
    flatpickr(".datepicker", {
        dateFormat: "Y-m-d",
        altInput: true,
        altFormat: "d/m/Y",
        locale: "vn"
    });

    // Hàm kiểm tra và Ẩn/Hiện ô "Giảm tối đa"
    function toggleGiamToiDa() {
        var loaiGiam = document.getElementById("loaiGiamGia").value;
        var boxGiamToiDa = document.getElementById("boxGiamToiDa");
        var inputGiamToiDa = document.getElementById("giamToiDa");

        if (loaiGiam === "Tiền") {
            boxGiamToiDa.style.display = "none";
            inputGiamToiDa.value = ""; // Xóa value khi ẩn
        } else {
            boxGiamToiDa.style.display = "block";
        }
    }

    // Chạy khi tải trang lần đầu
    window.onload = function() {
        toggleGiamToiDa();
    };
</script>

</body>
</html>
>>>>>>> main
