<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>

<html>
<head>
    <title>Quản lý nhân viên</title>

    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.css" rel="stylesheet">
    <style>
        body{
        font-family: Arial;
        background:#f5f5f5;
    }


    .container{

        width:90%;
        margin:auto;
        background:white;
        padding:20px;

    }


    h2{

        text-align:center;

        color:#333;

    }


    table{

        width:100%;
        border-collapse:collapse;

    }


    th{

        background:#198754;
        color:white;

        padding:10px;

    }


    td{

        border:1px solid #ddd;
        padding:10px;

    }


    button{

        padding:8px 15px;
        border:none;
        cursor:pointer;

    }


    .add{

        background:#198754;
        color:white;
        margin:15px 0;

    }


    a{

        text-decoration:none;
        margin:5px;

    }</style>
</head>

<body>
<%@ include file="/views/layout/sidebar.jsp"%>
<div class="container">

    <h2>QUẢN LÝ NHÂN VIÊN</h2>

    <form action="/nhanvien" method="get">

        <input type="hidden" name="action" value="search">

        <input type="text"
               name="keyword"
               placeholder="Nhập tên nhân viên">

        <button>Tìm kiếm</button>

    </form>


    <a href="nhanvien/them.jsp">
        <button class="add">
            + Thêm nhân viên
        </button>
    </a>


    <table>

        <tr>
            <th>Mã NV</th>
            <th>Tên nhân viên</th>
            <th>Ngày sinh</th>
            <th>Giới tính</th>
            <th>SĐT</th>
            <th>Email</th>
            <th>Chức năng</th>
        </tr>


        <c:forEach items="${list}" var="nv">

            <tr>

                <td>${nv.maNhanVien}</td>

                <td>${nv.tenNhanVien}</td>

                <td>${nv.ngaySinh}</td>

                <td>${nv.gioiTinh}</td>

                <td>${nv.soDienThoai}</td>

                <td>${nv.email}</td>


                <td>

                    <a href="/nhanvien?action=view&id=${nv.maNhanVien}">
                        Chi tiết
                    </a>


                    <a href="/nhanvien?action=edit&id=${nv.maNhanVien}">
                        Sửa
                    </a>


                    <a onclick="return confirm('Bạn có muốn xóa?')"
                       href="/nhanvien?action=delete&id=${nv.maNhanVien}">
                        Xóa
                    </a>


                </td>

            </tr>


        </c:forEach>


    </table>


</div>

</body>
</html>