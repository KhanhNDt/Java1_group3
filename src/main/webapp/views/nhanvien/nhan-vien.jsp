<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<!DOCTYPE html>
<html>
<head>
    <title>Quản lý nhân viên</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <style> .main-content { margin-left: 260px; padding: 30px; } </style>
</head>
<body>
<jsp:include page="/views/layout/sidebar.jsp" />
<div class="main-content">
    <c:choose>
        <c:when test="${viewType == 'list'}">
            <div class="d-flex justify-content-between mb-4"><h3>Nhân viên</h3>
                <a href="${pageContext.request.contextPath}/nhan-vien/detail?id=0" class="btn btn-success">+ Thêm mới</a></div>
            <div class="card p-3">
                <table class="table">
                    <thead><tr><th>Mã</th><th>Họ tên</th><th>Email</th><th>SĐT</th><th>Chức vụ</th><th>Thao tác</th></tr></thead>
                    <tbody>
                    <c:forEach items="${list}" var="nv">
                        <tr>
                            <td>${nv.maNhanVien}</td><td>${nv.hoTen}</td><td>${nv.email}</td>
                            <td>${nv.soDienThoai}</td><td>${nv.chucVu}</td>
                            <td>
                                <a href="${pageContext.request.contextPath}/nhan-vien/detail?id=${nv.id}" class="btn btn-sm btn-warning">Sửa</a>
                                <a href="${pageContext.request.contextPath}/nhan-vien/delete?id=${nv.id}" class="btn btn-sm btn-danger" onclick="return confirm('Xóa?')">Xóa</a>
                            </td>
                        </tr>
                    </c:forEach>
                    </tbody>
                </table>
            </div>
        </c:when>
        <c:when test="${viewType == 'form'}">
            <h3>${nv.id == null ? 'Thêm mới' : 'Cập nhật'} nhân viên</h3>
            <form action="${pageContext.request.contextPath}/nhan-vien/${nv.id == null ? 'add' : 'update'}" method="post" class="card p-4">
                <input type="hidden" name="id" value="${nv.id}">
                <div class="row">
                    <div class="col-md-6 mb-3"><label>Mã</label><input type="text" name="maNhanVien" class="form-control" value="${nv.maNhanVien}" required></div>
                    <div class="col-md-6 mb-3"><label>Họ tên</label><input type="text" name="hoTen" class="form-control" value="${nv.hoTen}" required></div>
                    <div class="col-md-6 mb-3"><label>Email</label><input type="email" name="email" class="form-control" value="${nv.email}"></div>
                    <div class="col-md-6 mb-3"><label>SĐT</label><input type="text" name="soDienThoai" class="form-control" value="${nv.soDienThoai}"></div>
                    <div class="col-md-6 mb-3"><label>Ngày sinh</label><input type="date" name="ngaySinh" class="form-control" value="<fmt:formatDate value='${nv.ngaySinh}' pattern='yyyy-MM-dd'/>"></div>
                    <div class="col-md-6 mb-3"><label>Chức vụ</label><select name="chucVu" class="form-control"><option value="Admin" ${nv.chucVu=='Admin'?'selected':''}>Admin</option><option value="Nhân viên" ${nv.chucVu=='Nhân viên'?'selected':''}>Nhân viên</option></select></div>
                    <div class="col-md-6 mb-3"><label>Giới tính</label><select name="gioiTinh" class="form-control"><option value="true" ${nv.gioiTinh?'selected':''}>Nam</option><option value="false" ${!nv.gioiTinh?'selected':''}>Nữ</option></select></div>
                    <div class="col-md-6 mb-3"><label>Trạng thái</label><select name="trangThai" class="form-control"><option value="1" ${nv.trangThai==1?'selected':''}>Đang làm</option><option value="0" ${nv.trangThai==0?'selected':''}>Ngừng</option></select></div>
                    <div class="col-md-12 mb-3"><label>Địa chỉ</label><textarea name="diaChi" class="form-control">${nv.diaChi}</textarea></div>
                </div>
                <button type="submit" class="btn btn-primary">Lưu</button>
                <a href="${pageContext.request.contextPath}/nhan-vien/hien-thi" class="btn btn-secondary">Hủy</a>
            </form>
        </c:when>
    </c:choose>
</div>
</body>
</html>