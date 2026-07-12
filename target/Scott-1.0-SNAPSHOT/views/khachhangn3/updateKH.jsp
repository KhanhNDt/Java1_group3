<%@ page contentType="text/html;charset=UTF-8" language="java"%>

<!DOCTYPE html>
<html lang="vi">

<head>

    <meta charset="UTF-8">

    <title>Cập nhật khách hàng</title>

    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css"
          rel="stylesheet">

    <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.css"
          rel="stylesheet">

    <style>

        body{
            background:#f5f6fa;
        }

        .card{
            border:none;
            border-radius:18px;
        }

        .form-control,
        .form-select{
            height:45px;
            border-radius:10px;
        }

        .btn{
            border-radius:10px;
        }

    </style>

</head>

<body>

<div class="container mt-5">

    <div class="card shadow">

        <div class="card-header bg-primary text-white">

            <h4 class="mb-0">

                <i class="bi bi-pencil-square"></i>

                Cập nhật khách hàng

            </h4>

        </div>

        <div class="card-body">

            <form action="${pageContext.request.contextPath}/khachhang/update"
                  method="post">

                <!-- ID -->

                <input type="hidden"
                       name="id"
                       value="${khachHangS.id}">

                <div class="row">

                    <div class="col-md-6 mb-3">

                        <label class="form-label">

                            Mã khách hàng

                        </label>

                        <input class="form-control"
                               name="ma"
                               value="${khachHangS.ma}">

                    </div>

                    <div class="col-md-6 mb-3">

                        <label class="form-label">

                            Họ tên

                        </label>

                        <input class="form-control"
                               name="hoTen"
                               value="${khachHangS.hoTen}">

                    </div>

                    <div class="col-md-6 mb-3">

                        <label class="form-label">

                            Số điện thoại

                        </label>

                        <input class="form-control"
                               name="sdt"
                               value="${khachHangS.sdt}">

                    </div>

                    <div class="col-md-6 mb-3">

                        <label class="form-label">

                            Email

                        </label>

                        <input class="form-control"
                               name="email"
                               value="${khachHangS.email}">

                    </div>

                    <div class="col-md-6 mb-3">

                        <label class="form-label">

                            Địa chỉ

                        </label>

                        <input class="form-control"
                               name="diaChi"
                               value="${khachHangS.diaChi}">

                    </div>

                    <div class="col-md-3 mb-3">

                        <label class="form-label">

                            Giới tính

                        </label>


                            <select class="form-select" name="gioiTinh">
                                <option value="Nam" ${khachHangS.gioiTinh == 'Nam' ? 'selected' : ''}>Nam</option>
                                <option value="Nữ" ${khachHangS.gioiTinh == 'Nữ' ? 'selected' : ''}>Nữ</option>
                            </select>


                    </div>

                    <div class="col-md-3 mb-3">
                        <label class="form-label">Trạng thái</label>

                        <select class="form-select" name="trangThai">
                            <option value="1" ${khachHangS.trangThai == 1 ? 'selected' : ''}>Hoạt động</option>
                            <option value="0" ${khachHangS.trangThai == 0 ? 'selected' : ''}>Ngừng hoạt động</option>
                        </select>
                    </div>

                </div>

                <div class="text-center mt-4">

                    <button class="btn btn-success">

                        <i class="bi bi-check-circle"></i>

                        Cập nhật

                    </button>

                    <a href="${pageContext.request.contextPath}/khachhang/hien-thi"
                       class="btn btn-secondary">

                        <i class="bi bi-arrow-left"></i>

                        Quay lại

                    </a>

                </div>

            </form>

        </div>

    </div>

</div>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>

</body>

</html>