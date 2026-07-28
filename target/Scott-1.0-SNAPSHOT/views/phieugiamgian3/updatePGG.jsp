<%--
  Created by IntelliJ IDEA.
  User: Nvc36
  Date: 7/11/2026
  Time: 4:23 PM
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
