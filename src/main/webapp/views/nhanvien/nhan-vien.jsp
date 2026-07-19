<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<!DOCTYPE html>
<html>
<head>
    <title>Scott. - Quản lý nhân viên</title>
    <!-- Bootstrap 5 -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.css" rel="stylesheet">
    <style>
        /* Đẩy nội dung sang phải để không bị sidebar (260px) đè lên */
        .main-wrapper {
            margin-left: 260px;
            padding: 30px;
            background-color: #f4f7fe;
            min-height: 100vh;
        }
        .card { border-radius: 12px; border: none; box-shadow: 0 4px 6px rgba(0,0,0,0.05); margin-bottom: 25px; }
    </style>
</head>
<body>

<%-- NHÚNG SIDEBAR TỪ FILE DÙNG CHUNG --%>
<jsp:include page="/views/layout/sidebar.jsp" />

<%-- NỘI DUNG CHÍNH --%>
<div class="main-wrapper">
    <div class="container-fluid">

        <c:choose>
            <%-- TRƯỜNG HỢP 1: DANH SÁCH --%>
            <c:when test="${empty nv}">
                <h3 class="mb-4 fw-bold text-secondary">QUẢN LÝ NHÂN VIÊN</h3>

                <div class="card p-4">
                    <div class="d-flex justify-content-between mb-4">
                        <form action="${pageContext.request.contextPath}/nhan-vien/search" method="get" class="d-flex">
                            <input type="text" name="keyword" class="form-control me-2" placeholder="Tìm kiếm...">
                            <button type="submit" class="btn btn-primary"><i class="bi bi-search"></i></button>
                        </form>
                        <a href="${pageContext.request.contextPath}/nhan-vien/detail?id=0" class="btn btn-success">
                            <i class="bi bi-plus-lg"></i> Thêm nhân viên
                        </a>
                    </div>

                    <table class="table table-hover align-middle">
                        <thead class="table-light">
                        <tr><th>Mã NV</th><th>Họ tên</th><th>Email</th><th>SĐT</th><th>Chức vụ</th><th>Thao tác</th></tr>
                        </thead>
                        <tbody>
                        <c:forEach items="${list}" var="item">
                            <tr>
                                <td>${item.maNhanVien}</td>
                                <td>${item.hoTen}</td>
                                <td>${item.email}</td>
                                <td>${item.soDienThoai}</td>
                                <td>${item.chucVu}</td>
                                <td>
                                    <a href="${pageContext.request.contextPath}/nhan-vien/view-update?id=${item.id}" class="btn btn-sm btn-outline-warning"><i class="bi bi-pencil-fill"></i></a>
                                    <a href="${pageContext.request.contextPath}/nhan-vien/delete?id=${item.id}" class="btn btn-sm btn-outline-danger" onclick="return confirm('Xóa?')"><i class="bi bi-trash-fill"></i></a>
                                </td>
                            </tr>
                        </c:forEach>
                        </tbody>
                    </table>
                </div>
            </c:when>

            <%-- TRƯỜNG HỢP 2: FORM THÊM/SỬA --%>
            <c:otherwise>
                <h3 class="mb-4 fw-bold text-secondary">
                        ${nv.id == 0 ? 'Thêm mới nhân viên' : 'Cập nhật nhân viên'}
                </h3>
                <div class="card p-4">
                    <form action="${nv.id == 0 ? pageContext.request.contextPath.concat('/nhan-vien/add') : pageContext.request.contextPath.concat('/nhan-vien/update')}" method="post">
                        <input type="hidden" name="id" value="${nv.id}">
                        <div class="row">
                            <div class="col-md-6 mb-3">
                                <label>Mã nhân viên</label>
                                <input type="text" name="maNhanVien" class="form-control" value="${nv.maNhanVien}" required>
                            </div>
                            <div class="col-md-6 mb-3">
                                <label>Họ tên</label>
                                <input type="text" name="hoTen" class="form-control" value="${nv.hoTen}" required>
                            </div>
                        </div>
                        <button type="submit" class="btn btn-primary px-4">Lưu</button>
                        <a href="${pageContext.request.contextPath}/nhan-vien/hien-thi" class="btn btn-secondary px-4">Quay lại</a>
                    </form>
                </div>
            </c:otherwise>
        </c:choose>

    </div>
</div>
</body>
</html>