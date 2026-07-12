<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>

<!DOCTYPE html>
<html>
<head>

    <title>Quản lý nhân viên</title>

    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css"
          rel="stylesheet">

    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.2/css/all.min.css"
          rel="stylesheet">

</head>

<body class="bg-light">

<div class="container mt-4">

    <div class="card shadow">

        <div class="card-header bg-primary text-white">

            <h3>
                <i class="fa-solid fa-user-tie"></i>
                QUẢN LÝ NHÂN VIÊN
            </h3>

        </div>

        <div class="card-body">

            <div class="row mb-3">

                <div class="col-md-8">

                    <form action="search" method="get">

                        <div class="input-group">

                            <input
                                    type="text"
                                    class="form-control"
                                    name="keyword"
                                    placeholder="Nhập mã hoặc họ tên nhân viên">

                            <button class="btn btn-primary">

                                <i class="fa-solid fa-magnifying-glass"></i>

                                Tìm kiếm

                            </button>

                        </div>

                    </form>

                </div>

                <div class="col-md-4 text-end">

                    <a href="create"

                       class="btn btn-success">

                        <i class="fa-solid fa-plus"></i>

                        Thêm nhân viên

                    </a>

                </div>

            </div>

            <table class="table table-bordered table-hover align-middle text-center">

                <thead class="table-dark">

                <tr>

                    <th>STT</th>

                    <th>Mã NV</th>

                    <th>Họ tên</th>

                    <th>Email</th>

                    <th>SĐT</th>

                    <th>Ngày sinh</th>

                    <th>Giới tính</th>

                    <th>Địa chỉ</th>

                    <th>Chức vụ</th>

                    <th>Ảnh</th>

                    <th>Trạng thái</th>

                    <th width="180">Thao tác</th>

                </tr>

                </thead>

                <tbody>

                <c:forEach items="${listNhanVien}" var="nv" varStatus="st">

                    <tr>

                        <td>${st.count}</td>

                        <td>${nv.maNhanVien}</td>

                        <td>${nv.hoTen}</td>

                        <td>${nv.email}</td>

                        <td>${nv.soDienThoai}</td>

                        <td>${nv.ngaySinh}</td>

                        <td>

                            <c:choose>

                                <c:when test="${nv.gioiTinh==true}">
                                    Nam
                                </c:when>

                                <c:otherwise>
                                    Nữ
                                </c:otherwise>

                            </c:choose>

                        </td>

                        <td>${nv.diaChi}</td>

                        <td>${nv.chucVu}</td>

                        <td>

                            <img src="${pageContext.request.contextPath}/uploads/${nv.anhDaiDien}"
                                 width="70"
                                 height="70"
                                 style="border-radius:50%;object-fit:cover">

                        </td>

                        <td>

                            <c:choose>

                                <c:when test="${nv.trangThai==1}">

                                    <span class="badge bg-success">

                                        Đang làm

                                    </span>

                                </c:when>

                                <c:otherwise>

                                    <span class="badge bg-danger">

                                        Nghỉ việc

                                    </span>

                                </c:otherwise>

                            </c:choose>

                        </td>

                        <td>

                            <a href="edit?id=${nv.id}"

                               class="btn btn-warning btn-sm">

                                <i class="fa-solid fa-pen"></i>

                            </a>

                            <a href="delete?id=${nv.id}"

                               onclick="return confirm('Bạn có chắc muốn xóa?')"

                               class="btn btn-danger btn-sm">

                                <i class="fa-solid fa-trash"></i>

                            </a>

                        </td>

                    </tr>

                </c:forEach>

                </tbody>

            </table>

        </div>

    </div>

</div>

</body>
</html>