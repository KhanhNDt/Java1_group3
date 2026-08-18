<%@ page contentType="text/html;charset=UTF-8" language="java" pageEncoding="UTF-8" %>
<%@ taglib uri="jakarta.tags.core" prefix="c" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <title>Kết quả quét mã QR CCCD</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.css" rel="stylesheet">
    <style>
        body { background: #f5f7fb; font-family: 'Segoe UI', sans-serif; }
        .result-container { max-width: 600px; margin: 50px auto; background: #fff; padding: 30px; border-radius: 14px; box-shadow: 0 4px 20px rgba(0,0,0,0.08); }
        .info-row { display: flex; padding: 12px 0; border-bottom: 1px solid #f0f0f0; }
        .info-label { width: 160px; font-weight: 600; color: #555; }
        .info-value { flex: 1; color: #111; }
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
<body>
<div class="container">
    <div class="result-container">
        <div class="d-flex align-items-center mb-4 text-success">
            <i class="bi bi-check-circle-fill fs-2 me-2"></i>
            <h3 class="mb-0">Quét mã QR CCCD thành công!</h3>
        </div>

        <div class="info-row">
            <div class="info-label">Số CCCD:</div>
            <div class="info-value"><strong>${cccdInfo.soCccd}</strong></div>
        </div>
        <div class="info-row">
            <div class="info-label">Họ và tên:</div>
            <div class="info-value">${cccdInfo.hoTen}</div>
        </div>
        <div class="info-row">
            <div class="info-label">Ngày sinh:</div>
            <div class="info-value">${cccdInfo.ngaySinh}</div>
        </div>
        <div class="info-row">
            <div class="info-label">Giới tính:</div>
            <div class="info-value">${cccdInfo.gioiTinh}</div>
        </div>
        <div class="info-row">
            <div class="info-label">Địa chỉ:</div>
            <div class="info-value">${cccdInfo.diaChi}</div>
        </div>

        <div class="alert alert-info d-flex align-items-start mt-2" role="alert">
            <i class="bi bi-info-circle-fill me-2 mt-1"></i>
            <div>Kiểm tra lại thông tin phía trên, sau đó bấm <strong>"Xác nhận, điền vào form"</strong> để tự động điền các trường tương ứng trong form thêm nhân viên mới. Bạn vẫn có thể chỉnh sửa lại trước khi lưu.</div>
        </div>

        <c:url var="confirmUrl" value="/nhan-vien/detail">
            <c:param name="id" value="0"/>
            <c:param name="qrHoTen" value="${cccdInfo.hoTen}"/>
            <c:param name="qrNgaySinh" value="${cccdInfo.ngaySinh}"/>
            <c:param name="qrGioiTinh" value="${cccdInfo.gioiTinh}"/>
            <c:param name="qrDiaChi" value="${cccdInfo.diaChi}"/>
        </c:url>

        <div class="mt-4 d-flex justify-content-between">
            <a href="${pageContext.request.contextPath}/nhan-vien/detail?id=0" class="btn btn-secondary">
                <i class="bi bi-arrow-left"></i> Nhập tay (bỏ qua)
            </a>
            <a href="${confirmUrl}" class="btn btn-success">
                <i class="bi bi-check2-circle"></i> Xác nhận, điền vào form
            </a>
            <a href="${pageContext.request.contextPath}/nhan-vien/hien-thi" class="btn btn-primary">
                Về danh sách
            </a>
        </div>
    </div>
</div>
</body>
</html>