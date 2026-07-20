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

        <div class="mt-4 d-flex justify-content-between">
            <a href="${pageContext.request.contextPath}/nhan-vien/detail?id=0" class="btn btn-secondary">
                <i class="bi bi-arrow-left">`</i> Quay lại thêm nhân viên
            </a>
            <a href="${pageContext.request.contextPath}/nhan-vien/hien-thi" class="btn btn-primary">
                Về danh sách
            </a>
        </div>
    </div>
</div>
</body>
</html>