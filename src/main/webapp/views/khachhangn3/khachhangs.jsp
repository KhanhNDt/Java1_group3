<%@ page contentType="text/html;charset=UTF-8" language="java"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>

<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <title>Quản lý khách hàng</title>

    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.css" rel="stylesheet">
    <style>

        .form-check.form-switch{
            display: inline-flex;
            align-items: center;
            margin: 0 6px;
        }

        .form-check-input{
            margin-top: 0;
            cursor: pointer;
        }
        .form-check-input:checked {
            background-color: #111 !important;
            border-color: #111 !important;
        }
    </style>

    <style>
        :root{--sc-black:#111827;--sc-gray:#6b7280;--sc-line:#e5e7eb;--sc-bg:#f8fafc;}
        body{background:var(--sc-bg)!important;color:#111!important;}
        .main-content{margin-left:260px;padding:28px;}
        .card,.main-card,.modal-content{border:1px solid var(--sc-line)!important;box-shadow:0 8px 24px rgba(0,0,0,.05)!important;}
        .bg-primary,.bg-success,.bg-danger,.bg-warning{background:#111827!important;color:#fff!important;}
        .text-primary,.text-success,.text-danger,.text-warning{color:#111827!important;}
        .btn-primary,.btn-success,.btn-danger,.btn-warning{background:#111827!important;border-color:#111827!important;color:#fff!important;}
        .btn-primary:hover,.btn-success:hover,.btn-danger:hover,.btn-warning:hover{background:#000!important;border-color:#000!important;}
        .btn-outline-primary,.btn-outline-success,.btn-outline-danger,.btn-outline-warning{color:#111827!important;border-color:#9ca3af!important;}
        .btn-outline-primary:hover,.btn-outline-success:hover,.btn-outline-danger:hover,.btn-outline-warning:hover{background:#111827!important;color:#fff!important;}
        .badge{background:#f3f4f6!important;color:#111827!important;border:1px solid #d1d5db;}
        .form-control:focus,.form-select:focus{border-color:#111827!important;box-shadow:0 0 0 .2rem rgba(17,24,39,.12)!important;}
        .table thead th{background:#f3f4f6!important;color:#374151!important;}
        .required:after{color:#111!important;}
    </style>
</head>

<body>

<%@ include file="/views/layout/sidebar.jsp"%>
<div class="main-content">

    <div class="container-fluid mt-4">

        <div class="card shadow">

            <div class="card-header bg-light text-dark">
                <h4 class="mb-0 fw-bold" >Quản lý khách hàng</h4>
            </div>

            <div class="card shadow-sm mb-4">

                <div class="card-body">

                    <form id="customerFilterForm" action="${pageContext.request.contextPath}/khachhang/search" method="get">

                        <div class="row align-items-center">

                            <!-- Tìm kiếm -->
                            <div class="col-md-3">
                                <input type="text"
                                       class="form-control"
                                       name="keyword" id="customerKeyword" autocomplete="off"
                                       placeholder="Tìm mã, tên, SĐT..."
                                       value="${param.keyword}">
                            </div>

                            <!-- Giới tính -->
                            <div class="col-md-2">
                                <select class="form-select" name="gioiTinh" id="gioiTinhFilter">
                                    <option value="">-- Giới tính --</option>
                                    <option value="Nam" ${param.gioiTinh == 'Nam' ? 'selected' : ''}>Nam</option>
                                    <option value="Nữ" ${param.gioiTinh == 'Nữ' ? 'selected' : ''}>Nữ</option>
                                </select>
                            </div>

                            <!-- Trạng thái -->
                            <div class="col-md-2">
                                <select class="form-select" name="trangThai" id="trangThaiFilter">
                                    <option value="">-- Trạng thái --</option>
                                    <option value="1" ${param.trangThai == '1' ? 'selected' : ''}>Hoạt động</option>
                                    <option value="0" ${param.trangThai == '0' ? 'selected' : ''}>Ngừng hoạt động</option>
                                </select>
                            </div>

                            <!-- Nút -->
                            <div class="col-md-5 text-end">

                                <a href="${pageContext.request.contextPath}/khachhang/view-add"
                                   class="btn btn-light text-dark fw-bold">
                                    <i class="bi bi-plus-circle"></i>
                                    Thêm mới
                                </a>

                                <a href="${pageContext.request.contextPath}/khachhang/hien-thi"
                                   class="btn btn-light text-dark fw-bold">
                                    <i class="bi bi-arrow-repeat"></i> Đặt lại
                                </a>


                            </div>

                        </div>

                    </form>

                </div>

            </div>

        </div>

        <div class="card shadow mt-4">

            <div class="card-header bg-light text-dark">
                <h5 class="mb-0 fw-bold">Danh sách khách hàng</h5>
            </div>

            <div class="card-body">

                <table class="table table-bordered table-hover text-center align-middle">

                    <thead class="table-light">

                    <tr>
                        <th>STT</th>
                        <th>Mã KH</th>
                        <th>Họ tên</th>
                        <th>SĐT</th>
                        <th>Email</th>
                        <th>Địa chỉ</th>
                        <th>Giới tính</th>
                        <th>Trạng thái</th>
                        <th>Chức năng</th>
                    </tr>

                    </thead>

                    <tbody>

                    <c:if test="${empty listKhachHang}">
                        <tr><td colspan="9" class="py-5 text-muted">Không tìm thấy khách hàng phù hợp.</td></tr>
                    </c:if>
                    <c:forEach items="${listKhachHang}" var="KH" varStatus="st">

                        <tr>

                            <td>${st.count}</td>
                            <td>${KH.ma}</td>
                            <td>${KH.hoTen}</td>
                            <td>${KH.sdt}</td>
                            <td>${KH.email}</td>
                            <td>${KH.diaChi}</td>
                            <td>
                                <c:choose>
                                    <c:when test="${KH.gioiTinh == 'Nam'}">Nam</c:when>
                                    <c:when test="${KH.gioiTinh == 'Nữ'}">Nữ</c:when>
                                    <c:otherwise><span class="text-muted">Chưa cập nhật</span></c:otherwise>
                                </c:choose>
                            </td>

                            <td>
                                <c:choose>
                                    <c:when test="${KH.trangThai == 1}">
                                        <span class="badge bg-success">Hoạt động</span>
                                    </c:when>
                                    <c:otherwise>
                                        <span class="badge bg-secondary">Ngừng hoạt động</span>
                                    </c:otherwise>
                                </c:choose>
                            </td>
                            <td>

                                <a href="${pageContext.request.contextPath}/khachhang/view-update?id=${KH.id}"
                                   class="btn btn-light btn-sm">
                                    <i class="bi bi-pencil-square"></i>
                                </a>

                                <a href="${pageContext.request.contextPath}/khachhang/detail?id=${KH.id}"
                                   class="btn btn-light btn-sm">
                                    <i class="bi bi-eye"></i>
                                </a>

                                <div class="form-check form-switch d-inline-block mx-2">

                                    <input
                                            class="form-check-input"
                                            type="checkbox"
                                            <c:if test="${KH.trangThai == 1}">checked</c:if>
                                            onchange="doiTrangThai(${KH.id})">

                                </div>

                            </td>

                        </tr>

                    </c:forEach>

                    </tbody>

                </table>

            </div>

        </div>

    </div>
</div>
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>

<script>

    function doiTrangThai(id){

        if(confirm("Bạn có muốn đổi trạng thái khách hàng không?")){

            window.location =
                "${pageContext.request.contextPath}/khachhang/doi-trang-thai?id=" + id;

        }else{
            location.reload();
        }

    }


    const filterForm = document.getElementById('customerFilterForm');
    const keywordInput = document.getElementById('customerKeyword');
    let filterTimer;
    function autoFilterCustomers() {
        clearTimeout(filterTimer);
        filterTimer = setTimeout(() => filterForm.submit(), 300);
    }
    keywordInput.addEventListener('input', autoFilterCustomers);
    document.getElementById('gioiTinhFilter').addEventListener('change', () => filterForm.submit());
    document.getElementById('trangThaiFilter').addEventListener('change', () => filterForm.submit());
</script>
</body>
</html>