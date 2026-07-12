<%@ page contentType="text/html;charset=UTF-8" language="java"%>

<!DOCTYPE html>
<html>
<head>
    <title>Chi tiết phiếu giảm giá</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
</head>
<body>

<div class="container mt-4">

    <h3>Chi tiết phiếu giảm giá</h3>

    <table class="table table-bordered">

        <tr>
            <th>Mã Voucher</th>
            <td>${phieugiamgiaS.maVoucher}</td>
        </tr>

        <tr>
            <th>Tên Voucher</th>
            <td>${phieugiamgiaS.tenVoucher}</td>
        </tr>

        <tr>
            <th>Loại giảm giá</th>
            <td>${phieugiamgiaS.loaiGiamGia}</td>
        </tr>

        <tr>
            <th>Số lượng</th>
            <td>${phieugiamgiaS.soLuong}</td>
        </tr>

        <tr>
            <th>Ngày bắt đầu</th>
            <td>${phieugiamgiaS.ngayBatDau}</td>
        </tr>

        <tr>
            <th>Ngày kết thúc</th>
            <td>${phieugiamgiaS.ngayKetThuc}</td>
        </tr>

        <tr>
            <th>Trạng thái</th>
            <td>${phieugiamgiaS.trangThai}</td>
        </tr>

    </table>

    <a href="${pageContext.request.contextPath}/phieugiamgia/hien-thi"
       class="btn btn-secondary">
        Quay lại
    </a>

</div>

</body>
</html>