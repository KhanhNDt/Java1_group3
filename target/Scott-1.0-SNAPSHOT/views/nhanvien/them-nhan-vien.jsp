<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <title>Thêm nhân viên</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
</head>
<body class="bg-light">
<div class="container mt-5" style="max-width: 600px; background: white; padding: 30px; border-radius: 10px;">
    <h2 class="text-center mb-4">THÊM NHÂN VIÊN MỚI</h2>

    <%-- Form gửi dữ liệu về Servlet qua POST --%>
    <form action="/nhan-vien/add" method="post">
        <div class="mb-3">
            <label>Mã nhân viên:</label>
            <input type="text" name="maNhanVien" class="form-control" required>
        </div>
        <div class="mb-3">
            <label>Họ tên:</label>
            <input type="text" name="hoTen" class="form-control" required>
        </div>
        <div class="mb-3">
            <label>Email:</label>
            <input type="email" name="email" class="form-control" required>
        </div>
        <div class="mb-3">
            <label>Số điện thoại:</label>
            <input type="text" name="soDienThoai" class="form-control">
        </div>
        <div class="mb-3">
            <label>Ngày sinh:</label>
            <input type="date" name="ngaySinh" class="form-control">
        </div>
        <div class="mb-3">
            <label>Giới tính:</label>
            <select name="gioiTinh" class="form-select">
                <option value="true">Nam</option>
                <option value="false">Nữ</option>
            </select>
        </div>
        <div class="mb-3">
            <label>Địa chỉ:</label>
            <input type="text" name="diaChi" class="form-control">
        </div>
        <div class="mb-3">
            <label>Chức vụ:</label>
            <input type="text" name="chucVu" class="form-control">
        </div>
        <div class="mb-3">
            <label>Trạng thái:</label>
            <select name="trangThai" class="form-select">
                <option value="1">Hoạt động</option>
                <option value="0">Ngừng hoạt động</option>
            </select>
        </div>
        <button type="submit" class="btn btn-success w-100">Lưu nhân viên</button>
        <a href="/nhan-vien/hien-thi" class="btn btn-secondary w-100 mt-2">Hủy</a>
    </form>
</div>
</body>
</html>