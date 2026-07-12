<%@ page contentType="text/html;charset=UTF-8" language="java"%>
<%@ taglib prefix="c" uri="jakarta.tags.core"%>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt"%>

<!DOCTYPE html>
<html lang="vi">

<head>

    <meta charset="UTF-8">

    <title>Quản lý nhân viên</title>

    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css"
          rel="stylesheet">

    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.2/css/all.min.css"
          rel="stylesheet">

</head>

<body class="bg-light">

<div class="container mt-4 mb-5">

    <div class="card shadow">

        <div class="card-header bg-primary text-white">

            <h3 class="mb-0">

                <i class="fa-solid fa-users"></i>

                QUẢN LÝ NHÂN VIÊN

            </h3>

        </div>

        <div class="card-body">

            <!-- ================= TÌM KIẾM ================= -->

            <form action="${pageContext.request.contextPath}/nhan-vien/search"
                  method="get">

                <div class="row mb-4">

                    <div class="col-md-10">

                        <input
                                type="text"
                                class="form-control"
                                name="keyword"
                                placeholder="Nhập mã hoặc tên nhân viên">

                    </div>

                    <div class="col-md-2">

                        <button class="btn btn-primary w-100">

                            <i class="fa-solid fa-magnifying-glass"></i>

                            Tìm

                        </button>

                    </div>

                </div>

            </form>

            <!-- ================= FORM ================= -->

            <form
                    action="${pageContext.request.contextPath}/nhan-vien/${empty nv ? 'add' : 'update'}"
                    method="post">

                <input
                        type="hidden"
                        name="id"
                        value="${nv.id}">

                <div class="row">

                    <div class="col-md-6 mb-3">

                        <label class="form-label">

                            Mã nhân viên

                        </label>

                        <input
                                type="text"
                                class="form-control"
                                name="maNhanVien"
                                value="${nv.maNhanVien}"
                                required>

                    </div>

                    <div class="col-md-6 mb-3">

                        <label class="form-label">

                            Họ tên

                        </label>

                        <input
                                type="text"
                                class="form-control"
                                name="hoTen"
                                value="${nv.hoTen}"
                                required>

                    </div>

                </div>

                <div class="row">

                    <div class="col-md-6 mb-3">

                        <label class="form-label">

                            Email

                        </label>

                        <input
                                type="email"
                                class="form-control"
                                name="email"
                                value="${nv.email}">

                    </div>

                    <div class="col-md-6 mb-3">

                        <label class="form-label">

                            Số điện thoại

                        </label>

                        <input
                                type="text"
                                class="form-control"
                                name="soDienThoai"
                                value="${nv.soDienThoai}">

                    </div>

                </div>

                <div class="row">

                    <div class="col-md-6 mb-3">

                        <label class="form-label">

                            Ngày sinh

                        </label>

                        <input
                                type="date"
                                class="form-control"
                                name="ngaySinh"
                                value="<fmt:formatDate value='${nv.ngaySinh}' pattern='yyyy-MM-dd'/>">

                    </div>

                    <div class="col-md-6 mb-3">

                        <label class="form-label">

                            Giới tính

                        </label>

                        <select
                                class="form-select"
                                name="gioiTinh">

                            <option value="true"
                                    <c:if test="${nv.gioiTinh}">
                                        selected
                                    </c:if>>

                                Nam

                            </option>

                            <option value="false"
                                    <c:if test="${!nv.gioiTinh}">
                                        selected
                                    </c:if>>

                                Nữ

                            </option>

                        </select>

                    </div>

                </div>

                <div class="row">

                    <div class="col-md-6 mb-3">

                        <label class="form-label">

                            Chức vụ

                        </label>

                        <input
                                type="text"
                                class="form-control"
                                name="chucVu"
                                value="${nv.chucVu}">

                    </div>

                    <div class="col-md-6 mb-3">

                        <label class="form-label">

                            Trạng thái

                        </label>

                        <select
                                class="form-select"
                                name="trangThai">

                            <option value="1"
                                    <c:if test="${nv.trangThai==1}">
                                        selected
                                    </c:if>>

                                Đang làm

                            </option>

                            <option value="0"
                                    <c:if test="${nv.trangThai==0}">
                                        selected
                                    </c:if>>

                                Nghỉ việc

                            </option>

                        </select>

                    </div>

                </div>

                <div class="mb-3">

                    <label class="form-label">

                        Địa chỉ

                    </label>

                    <textarea
                            class="form-control"
                            rows="3"
                            name="diaChi">${nv.diaChi}</textarea>

                </div>

                <div class="mb-3">

                    <label class="form-label">

                        Ảnh đại diện

                    </label>

                    <input
                            type="text"
                            class="form-control"
                            name="anhDaiDien"
                            value="${nv.anhDaiDien}"
                            placeholder="Ví dụ: avatar.jpg">

                </div>

                <button
                        type="submit"
                        class="btn btn-success">

                    <i class="fa-solid fa-floppy-disk"></i>

                    ${empty nv ? 'Thêm' : 'Cập nhật'}

                </button>

                <a href="${pageContext.request.contextPath}/nhan-vien/hien-thi"
                   class="btn btn-secondary">

                    <i class="fa-solid fa-rotate"></i>

                    Làm mới

                </a>

            </form>

            <hr>

            <h4>

                <i class="fa-solid fa-table"></i>

                Danh sách nhân viên

            </h4>

            <table class="table table-bordered table-hover align-middle">

                <thead class="table-dark text-center">

                <tr>

                    <th>STT</th>

                    <th>Mã NV</th>

                    <th>Họ tên</th>

                    <th>Email</th>

                    <th>SĐT</th>

                    <th>Ngày sinh</th>

                    <th>Giới tính</th>

                    <th>Chức vụ</th>

                    <th>Địa chỉ</th>

                    <th>Ảnh</th>

                    <th>Trạng thái</th>

                    <th width="150">

                        Thao tác

                    </th>

                </tr>

                </thead>

                <tbody>
                <c:if test="${empty list}">

                    <tr>

                        <td colspan="12" class="text-center text-danger">

                            Không có dữ liệu.

                        </td>

                    </tr>

                </c:if>

                <c:forEach items="${list}" var="nv" varStatus="st">

                    <tr>

                        <td class="text-center">

                                ${st.count}

                        </td>

                        <td>

                                ${nv.maNhanVien}

                        </td>

                        <td>

                                ${nv.hoTen}

                        </td>

                        <td>

                                ${nv.email}

                        </td>

                        <td>

                                ${nv.soDienThoai}

                        </td>

                        <td>

                            <fmt:formatDate
                                    value="${nv.ngaySinh}"
                                    pattern="dd/MM/yyyy"/>

                        </td>

                        <td class="text-center">

                            <c:choose>

                                <c:when test="${nv.gioiTinh}">

                                    Nam

                                </c:when>

                                <c:otherwise>

                                    Nữ

                                </c:otherwise>

                            </c:choose>

                        </td>

                        <td>

                                ${nv.chucVu}

                        </td>

                        <td>

                                ${nv.diaChi}

                        </td>

                        <td class="text-center">

                            <c:choose>

                                <c:when test="${not empty nv.anhDaiDien}">

                                    <img
                                            src="${pageContext.request.contextPath}/images/${nv.anhDaiDien}"
                                            width="60"
                                            height="60"
                                            style="border-radius:50%;object-fit:cover">

                                </c:when>

                                <c:otherwise>

                                    <img
                                            src="https://placehold.co/60x60"
                                            width="60"
                                            height="60"
                                            style="border-radius:50%;object-fit:cover">

                                </c:otherwise>

                            </c:choose>

                        </td>

                        <td class="text-center">

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

                        <td class="text-center">

                            <a
                                    class="btn btn-warning btn-sm"

                                    href="${pageContext.request.contextPath}/nhan-vien/detail?id=${nv.id}">

                                <i class="fa-solid fa-pen"></i>

                            </a>

                            <a
                                    class="btn btn-danger btn-sm"

                                    onclick="return confirm('Bạn có chắc muốn xóa nhân viên này?')"

                                    href="${pageContext.request.contextPath}/nhan-vien/delete?id=${nv.id}">

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

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>

</body>

</html>