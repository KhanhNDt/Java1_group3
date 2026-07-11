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
    <title>Title</title>
</head>
<body>
<form action="/khachhang/update" method="post">
    ID :<input type="text" name="id" value="${khachHangS.id}">
    <br>
    Ma KH : <input type="text" name="ma" value="${khachHangS.ma}"/>
    <br>
    Ho Ten: <input type="text" name="hoTen" value="${khachHangS.hoTen}"/>
    <br>
    SDT : <input type="text" name="sdt" value="${khachHangS.sdt}"/>
    <br>
    Dia Chi : <input type="text" name="diaChi" value="${khachHangS.diaChi}"/>
    <br>
    <button type="submit">Update</button>
</form>
</body>
</html>
