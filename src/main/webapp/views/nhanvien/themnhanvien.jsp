<html>

<head>
    <title>Thêm nhân viên</title>
</head>


<body>


<h2>THÊM NHÂN VIÊN</h2>


<form action="/nhanvien" method="post">


    <input type="hidden"
           name="action"
           value="add">


    Tên nhân viên:

    <input name="tenNhanVien">


    <br>


    Ngày sinh:

    <input type="date"
           name="ngaySinh">


    <br>


    Giới tính:

    <select name="gioiTinh">

        <option>Nam</option>

        <option>Nữ</option>

    </select>


    <br>


    Số điện thoại:

    <input name="soDienThoai">


    <br>


    Email:

    <input name="email">


    <br>


    <button>Lưu</button>


</form>


</body>

</html>