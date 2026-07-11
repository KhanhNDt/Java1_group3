<%@ page contentType="text/html;charset=UTF-8" language="java"%>

<!DOCTYPE html>
<html>
<head>
    <title>Chi tiết khách hàng</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
</head>
<body>

<div class="container mt-5">

    <h3>Chi tiết khách hàng</h3>

    <table class="table table-bordered">
        <tr><th>Mã</th><td>${khachHangS.ma}</td></tr>
        <tr><th>Họ tên</th><td>${khachHangS.hoTen}</td></tr>
        <tr><th>SĐT</th><td>${khachHangS.sdt}</td></tr>
        <tr><th>Email</th><td>${khachHangS.email}</td></tr>
        <tr><th>Địa chỉ</th><td>${khachHangS.diaChi}</td></tr>
        <tr><th>Giới tính</th><td>${khachHangS.gioiTinh}</td></tr>
        <tr><th>Trạng thái</th><td>${khachHangS.trangThai}</td></tr>
    </table>

    <a href="${pageContext.request.contextPath}/khachhang/hien-thi"
       class="btn btn-secondary">
        Quay lại
    </a>

</div>

</body>
</html>