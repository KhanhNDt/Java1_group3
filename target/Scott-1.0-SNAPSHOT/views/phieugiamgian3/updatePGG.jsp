<%@ page contentType="text/html;charset=UTF-8" language="java"%>

<!DOCTYPE html>
<html>
<head>
    <title>Cập nhật phiếu giảm giá</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
</head>
<body>

<div class="container mt-4">

    <h3 class="mb-3">Cập nhật phiếu giảm giá</h3>

    <form action="${pageContext.request.contextPath}/phieugiamgia/update" method="post">

        <input type="hidden" name="id" value="${phieugiamgiaS.id}">

        <div class="mb-3">
            <label>Mã Voucher</label>
            <input type="text" class="form-control" name="maVoucher" value="${phieugiamgiaS.maVoucher}">
        </div>

        <div class="mb-3">
            <label>Tên Voucher</label>
            <input type="text" class="form-control" name="tenVoucher" value="${phieugiamgiaS.tenVoucher}">
        </div>

        <div class="mb-3">
            <label>Loại giảm giá</label>
            <input type="text" class="form-control" name="loaiGiamGia" value="${phieugiamgiaS.loaiGiamGia}">
        </div>

        <div class="mb-3">
            <label>Số lượng</label>
            <input type="number" class="form-control" name="soLuong" value="${phieugiamgiaS.soLuong}">
        </div>

        <div class="mb-3">
            <label>Ngày bắt đầu</label>
            <input type="date" class="form-control" name="ngayBatDau" value="${phieugiamgiaS.ngayBatDau}">
        </div>

        <div class="mb-3">
            <label>Ngày kết thúc</label>
            <input type="date" class="form-control" name="ngayKetThuc" value="${phieugiamgiaS.ngayKetThuc}">
        </div>

        <div class="mb-3">
            <label>Trạng thái</label>
            <select class="form-select" name="trangThai">
                <option value="1" ${phieugiamgiaS.trangThai==1?'selected':''}>Hoạt động</option>
                <option value="0" ${phieugiamgiaS.trangThai==0?'selected':''}>Ngừng hoạt động</option>
            </select>
        </div>

        <button class="btn btn-success">Cập nhật</button>

        <a href="${pageContext.request.contextPath}/phieugiamgia/hien-thi"
           class="btn btn-secondary">
            Quay lại
        </a>

    </form>

</div>

</body>
</html>