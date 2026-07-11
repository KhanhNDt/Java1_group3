<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%--
  Created by IntelliJ IDEA.
  User: Giang
  Date: 7/10/2026
  Time: 2:34 PM
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <title>Quản lý khách hàng</title>

    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
</head>
<body>
<%@ include file="/views/layout/sidebar.jsp" %>
<%@ include file="/views/layout/header.jsp" %>
<div style="margin-left:280px;padding:30px;">

    <h2>Quản lý khách hàng</h2>
</div>
<form action="/khachhang/add" method="post">
    Ma KH: <input type="text" name="ma" value="${khachHangS.ma}"/>
    <br>
    Ho Ten : <input type="text" name="hoTen" value="${khachHangS.hoTen}"/>
    <br>
    SDT : <input type="text" name="sdt" value="${khachHangS.sdt}"/>
    <br>
    Dia Chi: <input type="text" name="diaChi" value="${khachHangS.diaChi}"/>
    <br>
    <button type="submit">ADD</button>
</form>
    <table border="1">
        <thead>
        <tr>
            <th>ID</th>
            <th>MA</th>
            <th>HoTen</th>
            <th>SDT</th>
            <th>DiaChi</th>
        </tr>
        </thead>
        <tbody>
        <c:forEach items="${listKhachHang}" var="KH">
            <tr>
                <td>${KH.id}</td>
                <td>${KH.ma}</td>
                <td>${KH.hoTen}</td>
                <td>${KH.sdt}</td>
                <td>${KH.diaChi}</td>
            </tr>
        </c:forEach>
        </tbody>
    </table>
</body>
</html>
