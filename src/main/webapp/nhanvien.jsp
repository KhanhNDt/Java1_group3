<%@ page contentType="text/html;charset=UTF-8" language="java"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>

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

<div class="container mt-4">

    <div class="card shadow">

        <div class="card-header bg-primary text-white">

            <h3>

                <i class="fa-solid fa-user-tie"></i>

                QUẢN LÝ NHÂN VIÊN

            </h3>

        </div>

        <div class="card-body">



            <form action="${pageContext.request.contextPath}/nhan-vien/search"
                  method="get">

                <div class="row mb-4">

                    <div class="col-md-9">

                        <input
                                class="form-control"
                                type="text"
                                name="keyword"
                                placeholder="Nhập mã hoặc tên nhân viên">

                    </div>

                    <div class="col-md-3">

                        <button class="btn btn-primary w-100">

                            <i class="fa-solid fa-magnifying-glass"></i>

                            Tìm kiếm

                        </button>

                    </div>

                </div>

            </form>



            <form action="${pageContext.request.contextPath}/nhan-vien/${nv==null?'add':'update'}"
                  method="post">

                <input type="hidden"
                       name="id"
                       value="${nv.id}">

                <div class="row">

                    <div class="col-md-6">

                        <label>Mã nhân viên</label>

                        <input
                                type="text"
                                class="form-control"
                                name="maNhanVien"
                                value="${nv.maNhanVien}">

                    </div>

                    <div class="col-md-6">

                        <label>Họ tên</label>

                        <input
                                type="text"
                                class="form-control"
                                name="hoTen"
                                value="${nv.hoTen}">

                    </div>

                </div>

                <br>

                <div class="row">

                    <div class="col-md-6">

                        <label>Email</label>

                        <input
                                type="email"
                                class="form-control"
                                name="email"
                                value="${nv.email}">

                    </div>

                    <div class="col-md-6">

                        <label>Số điện thoại</label>

                        <input
                                type="text"
                                class="form-control"
                                name="soDienThoai"
                                value="${nv.soDienThoai}">

                    </div>

                </div>

                <br>

                <div class="row">

                    <div class="col-md-6">

                        <label>Ngày sinh</label>

                        <input
                                type="date"
                                class="form-control"
                                name="ngaySinh"
                                value="${nv.ngaySinh}">

                    </div>

                    <div class="col-md-6">

                        <label>Giới tính</label>

                        <select class="form-select" name="gioiTinh">

                            <option value="true"
                                    <c:if test="${nv.gioiTinh}">selected</c:if>>
                                Nam
                            </option>

                            <option value="false"
                                    <c:if test="${!nv.gioiTinh}">selected</c:if>>
                                Nữ
                            </option>

                        </select>

                    </div>

                </div>

                <br>

                <div class="row">

                    <div class="col-md-6">

                        <label>Chức vụ</label>

                        <input
                                type="text"
                                class="form-control"
                                name="chucVu"
                                value="${nv.chucVu}">

                    </div>

                    <div class="col-md-6">

                        <label>Trạng thái</label>

                        <select class="form-select" name="trangThai">

                            <option value="1"
                                    <c:if test="${nv.trangThai==1}">selected</c:if>>
                                Đang làm
                            </option>

                            <option value="0"
                                    <c:if test="${nv.trangThai==0}">selected</c:if>>
                                Nghỉ việc
                            </option>

                        </select>

                    </div>

                </div>

                <br>

                <label>Địa chỉ</label>

                <textarea
                        class="form-control"
                        rows="3"
                        name="diaChi">${nv.diaChi}</textarea>

                <br>

                <label>Ảnh đại diện</label>

                <input
                        type="text"
                        class="form-control"
                        name="anhDaiDien"
                        value="${nv.anhDaiDien}"
                        placeholder="vd: avatar.jpg">

                <br>

                <button
                        class="btn btn-success">

                    <i class="fa-solid fa-floppy-disk"></i>

                    ${nv==null?'Thêm':'Cập nhật'}

                </button>

                <a href="${pageContext.request.contextPath}/nhan-vien/hien-thi"
                   class="btn btn-secondary">

                    Làm mới

                </a>

            </form>

            <hr>


            <h4 class="mb-3">

                <i class="fa-solid fa-table"></i>

                Danh sách nhân viên

            </h4>

            <table class="table table-bordered table-hover align-middle">

                <thead class="table-dark text-center">

                <tr>

                    <th width="60">STT</th>

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

                    <th width="150">Thao tác</th>

                </tr>

                </thead>

                <tbody>

                <c:if test="${empty listNhanVien}">

                    <tr>

                        <td colspan="12" class="text-center text-danger">

                            Không có dữ liệu.

                        </td>

                    </tr>

                </c:if>

                <c:forEach items="${listNhanVien}" var="nv" varStatus="st">

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

                                ${nv.ngaySinh}

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

                                    <img src="https://placehold.co/60x60">
                                         width="60"
                                         height="60"
                                         style="border-radius:50%;object-fit:cover">

                                </c:when>

                                <c:otherwise>

                                    Không có ảnh

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

                            <a class="btn btn-warning btn-sm"

                               href="${pageContext.request.contextPath}/nhan-vien/detail?id=${nv.id}">

                                <i class="fa-solid fa-pen"></i>

                            </a>

                            <a class="btn btn-danger btn-sm"

                               onclick="return confirm('Bạn có chắc muốn xóa nhân viên này?')"

                               href="${pageContext.request.contextPath}/nhan-vien/delete?id=${nv.id}">

                                <i class="fa-solid fa-trash"></i>

                            </a>

                        </td>

                    </tr>

                </c:forEach>

                </tbody>

            </table>