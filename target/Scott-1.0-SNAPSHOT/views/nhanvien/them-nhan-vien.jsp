<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <title>Thêm nhân viên</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.css" rel="stylesheet">
    <style>
        /* CSS cho khung chọn ảnh tròn */
        .avatar-upload-box {
            width: 100px;
            height: 100px;
            border: 2px dashed #cbd5e1;
            border-radius: 50%;
            display: inline-flex;
            flex-direction: column;
            justify-content: center;
            align-items: center;
            cursor: pointer;
            overflow: hidden;
            position: relative;
            background-color: #f8fafc;
            transition: all 0.2s ease;
        }
        .avatar-upload-box:hover {
            border-color: #3b82f6;
            background-color: #f1f5f9;
        }
        .avatar-placeholder {
            display: flex;
            flex-direction: column;
            align-items: center;
            color: #64748b;
        }
        #avatar-preview-img {
            width: 100%;
            height: 100%;
            object-fit: cover;
        }
    </style>

<style>
:root{--mono:#111;--line:#dedede;--soft:#f5f5f5}
body{background:#f4f4f4!important;color:#171717!important}
.main-content{margin-left:242px!important;padding:28px!important}
.card,.table-container,.filter-card,.stat-card{border-color:var(--line)!important;box-shadow:0 4px 14px rgba(0,0,0,.045)!important}
.btn-primary,.btn-success,.btn-warning,.btn-info,.btn-danger{background:#171717!important;border-color:#171717!important;color:#fff!important}
.btn-outline-primary,.btn-outline-success,.btn-outline-danger,.btn-outline-warning{color:#171717!important;border-color:#aaa!important}
.btn-outline-primary:hover,.btn-outline-success:hover,.btn-outline-danger:hover,.btn-outline-warning:hover{background:#171717!important;color:#fff!important;border-color:#171717!important}
.badge,.status-badge{filter:grayscale(1)}
.form-control:focus,.form-select:focus{border-color:#333!important;box-shadow:0 0 0 .18rem rgba(0,0,0,.10)!important}
.table thead th{background:#f4f4f4!important;color:#222!important}
@media(max-width:900px){.main-content{margin-left:78px!important;padding:18px!important}}
</style>
</head>
<body class="bg-light">
<div class="container mt-5 mb-5" style="max-width: 600px; background: white; padding: 30px; border-radius: 10px;">
    <h2 class="text-center mb-4">THÊM NHÂN VIÊN MỚI</h2>

    <%-- Quan trọng: Phải có enctype="multipart/form-data" để truyền file ảnh lên Servlet --%>
    <form action="${pageContext.request.contextPath}/nhan-vien/add" method="post" enctype="multipart/form-data">

        <%-- Khu vực chọn ảnh đại diện --%>
        <div class="text-center mb-4">
            <label for="avatar-input" class="avatar-upload-box">
                <img id="avatar-preview-img" src="" alt="Avatar Preview" style="display: none;">
                <div id="avatar-placeholder-content" class="avatar-placeholder">
                    <i class="bi bi-camera fs-3 mb-1"></i>
                    <span style="font-size: 12px;">Chọn ảnh</span>
                </div>
            </label>
            <input type="file" id="avatar-input" name="anhDaiDienFile" accept="image/png, image/jpeg, image/jpg" class="d-none">
            <div class="form-text text-muted mt-1" style="font-size: 12px;">PNG, JPG, JPEG - Tối đa 5MB</div>
        </div>

        <div class="mb-3">
            <label>Mã nhân viên:</label>
            <input type="text" name="maNhanVien" class="form-control" required[cite: 5]>
        </div>
        <div class="mb-3">
            <label>Họ tên:</label>
            <input type="text" name="hoTen" class="form-control" required[cite: 5]>
        </div>
        <div class="mb-3">
            <label>Email:</label>
            <input type="email" name="email" class="form-control" required[cite: 5]>
        </div>
        <div class="mb-3">
            <label>Số điện thoại:</label>
            <input type="text" name="soDienThoai" class="form-control"[cite: 5]>
        </div>
        <div class="mb-3">
            <label>Ngày sinh:</label>
            <input type="date" name="ngaySinh" class="form-control"[cite: 5]>
        </div>
        <div class="mb-3">
            <label>Giới tính:</label>
            <select name="gioiTinh" class="form-select"[cite: 5]>
                <option value="true">Nam</option>
                <option value="false">Nữ</option>
            </select>
        </div>
        <div class="mb-3">
            <label>Địa chỉ:</label>
            <input type="text" name="diaChi" class="form-control"[cite: 5]>
        </div>
        <div class="mb-3">
            <label>Chức vụ:</label>
            <input type="text" name="chucVu" class="form-control"[cite: 5]>
        </div>
        <div class="mb-3">
            <label>Trạng thái:</label>
            <select name="trangThai" class="form-select"[cite: 5]>
                <option value="1">Hoạt động</option>
                <option value="0">Ngừng hoạt động</option>
            </select>
        </div>
        <button type="submit" class="btn btn-success w-100">Lưu nhân viên</button>
        <a href="${pageContext.request.contextPath}/nhan-vien/hien-thi" class="btn btn-secondary w-100 mt-2">Hủy</a>
    </form>
</div>

<%-- Script xử lý hiển thị ảnh preview ngay lập tức khi chọn file --%>
<script>
    const avatarInput = document.getElementById('avatar-input');
    const avatarPreviewImg = document.getElementById('avatar-preview-img');
    const avatarPlaceholderContent = document.getElementById('avatar-placeholder-content');

    if (avatarInput) {
        avatarInput.addEventListener('change', function(event) {
            const file = event.target.files[0];
            if (file) {
                if (file.size > 5 * 1024 * 1024) {
                    alert('Dung lượng ảnh vượt quá giới hạn tối đa 5MB!');
                    avatarInput.value = '';
                    return;
                }

                const reader = new FileReader();
                reader.onload = function(e) {
                    avatarPreviewImg.src = e.target.result;
                    avatarPreviewImg.style.display = 'block';
                    avatarPlaceholderContent.style.display = 'none';
                }
                reader.readAsDataURL(file);
            }
        });
    }
</script>
</body>
</html>