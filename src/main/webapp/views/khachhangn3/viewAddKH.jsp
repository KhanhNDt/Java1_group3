<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>

<!DOCTYPE html>
<html lang="vi">

<head>
    <meta charset="UTF-8">
    <title>Thêm khách hàng</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.css" rel="stylesheet">

    <style>
        body{
            background:#f4f6f9;
            font-size:14px;
        }
        .main-card{
            background:white;
            border-radius:15px;
            padding:30px;
            box-shadow:0 5px 25px rgba(0,0,0,.08);
        }
        .avatar{
            width:90px;
            height:90px;
            border-radius:50%;
            background:#f5f5f5;
            border:2px dashed #ddd;
            display:flex;
            justify-content:center;
            align-items:center;
            font-size:40px;
            color:#999;
            margin:auto;
        }
        .required:after{
            content:" *";
            color:red;
        }
        .address-box{
            margin-top:30px;
            border:1px solid #ddd;
            border-radius:10px;
            padding:20px;
            background:#fafafa;
        }
        .address-item{
            border:1px solid #ddd;
            border-radius:8px;
            padding:12px;
            margin-bottom:10px;
            background:white;
        }
        .default-address{
            border-left:4px solid #0d6efd;
        }
        .badge-default{
            background:#dbeafe;
            color:#2563eb;
            padding:3px 8px;
            border-radius:4px;
            font-size:11px;
        }
    </style>
</head>
<body>
<div class="container mt-5 mb-5">
    <div class="main-card">
        <div class="d-flex justify-content-between align-items-center mb-4">
            <h4>
                Quản lý khách hàng /
                <b>Thêm khách hàng</b>
            </h4>
            <a class="btn btn-outline-secondary"
               href="${pageContext.request.contextPath}/khachhang/hien-thi">
                <i class="bi bi-arrow-left"></i>
                Quay lại
            </a>
        </div>
        <div class="text-center mb-4">
            <div class="avatar">
                <i class="bi bi-person-fill"></i>
            </div>
            <small class="text-muted">
                Ảnh đại diện mặc định
            </small>
        </div>
        <form id="formAddKhachHang"
              action="${pageContext.request.contextPath}/khachhang/add"
              method="post">
            <div class="row">
                <div class="col-md-6 mb-3">
                    <label class="form-label">
                        Mã khách hàng
                    </label>
                    <input
                            class="form-control"
                            name="ma"
                            readonly
                            value="KH009">
                </div>
                <div class="col-md-6 mb-3">
                    <label class="form-label required">
                        Họ tên
                    </label>
                    <input
                            class="form-control"
                            name="hoTen"
                            required>
                </div>
                <div class="col-md-6 mb-3">
                    <label class="form-label required">
                        Số điện thoại
                    </label>
                    <input
                            class="form-control"
                            name="sdt"
                            required>
                </div>
                <div class="col-md-6 mb-3">
                    <label class="form-label required">
                        Email
                    </label>
                    <input
                            type="email"
                            class="form-control"
                            name="email"
                            required>
                </div>
                <div class="col-md-6">
                    <label class="form-label required">
                        Giới tính
                    </label>
                    <br>
                    <input type="radio"
                           name="gioiTinh"
                           value="Nam"
                           checked>
                    Nam
                    &nbsp;&nbsp;
                    <input type="radio"
                           name="gioiTinh"
                           value="Nữ">
                    Nữ
                </div>
                <div class="col-md-6">
                    <label class="form-label required">
                        Trạng thái
                    </label>
                    <br>
                    <input type="radio"
                           name="trangThai"
                           value="1"
                           checked>
                    Hoạt động
                    &nbsp;&nbsp;
                    <input type="radio"
                           name="trangThai"
                           value="0">
                    Ngừng hoạt động
                </div>
            </div>

            <div class="col-12 mt-3">
                <label class="form-label">Địa chỉ gốc (Khách hàng)</label>
                <input class="form-control" name="diaChi" placeholder="Nhập địa chỉ thường trú gốc">
            </div>

            <div class="address-box mt-4">
                <div class="d-flex justify-content-between align-items-center mb-3">
                    <div>
                        <h5 class="mb-1">
                            Quản lý địa chỉ nhận hàng
                        </h5>
                        <small class="text-muted">
                            Mỗi khách hàng thiết lập trước 1 địa chỉ nhận hàng
                        </small>
                    </div>
                    <button
                            type="button"
                            class="btn btn-success"
                            id="btnMoModalDiaChi">
                        <i class="bi bi-plus-circle"></i>
                        Thêm địa chỉ
                    </button>
                </div>
                <div id="danhSachDiaChiUI">
                    <div class="text-center text-muted py-4"
                         id="txtDiaChiTrong">
                        Chưa có địa chỉ nào.
                    </div>
                </div>
            </div>

            <input type="hidden" id="hiddenProvinceCode" name="provinceCode">
            <input type="hidden" id="hiddenDistrictCode" name="districtCode">
            <input type="hidden" id="hiddenWardCode" name="wardCode">

            <input type="hidden" id="hiddenMTinhText" name="mTinhText">
            <input type="hidden" id="hiddenMHuyenText" name="mHuyenText">
            <input type="hidden" id="hiddenMXaText" name="mXaText">
            <input type="hidden" id="hiddenMChiTiet" name="mChiTiet">
            <input type="hidden" id="hiddenMMacDinh" name="mMacDinh">

            <div class="mt-4 d-flex justify-content-end">
                <a
                        href="${pageContext.request.contextPath}/khachhang/hien-thi"
                        class="btn btn-secondary me-2">
                    Hủy
                </a>
                <button
                        class="btn btn-primary"
                        type="submit">
                    <i class="bi bi-check-circle"></i>
                    Thêm khách hàng
                </button>
            </div>
        </form>
    </div>
</div>

<div class="modal fade"
     id="modalDiaChi"
     tabindex="-1">
    <div class="modal-dialog modal-lg">
        <div class="modal-content">
            <div class="modal-header">
                <h5 class="modal-title">
                    Thêm địa chỉ nhận hàng
                </h5>
                <button
                        type="button"
                        class="btn-close"
                        data-bs-dismiss="modal">
                </button>
            </div>
            <div class="modal-body">
                <div class="row">
                    <div class="col-md-4 mb-3">
                        <label class="form-label required">
                            Tỉnh / Thành phố
                        </label>
                        <select
                                id="mTinh"
                                class="form-select">
                            <option value="">
                                Đang tải...
                            </option>
                        </select>
                    </div>
                    <div class="col-md-4 mb-3">
                        <label class="form-label required">
                            Quận / Huyện
                        </label>
                        <select
                                id="mHuyen"
                                class="form-select"
                                disabled>
                            <option value="">
                                Chọn Quận/Huyện
                            </option>
                        </select>
                    </div>
                    <div class="col-md-4 mb-3">
                        <label class="form-label required">
                            Phường / Xã
                        </label>
                        <select
                                id="mXa"
                                class="form-select"
                                disabled>
                            <option value="">
                                Chọn Phường/Xã
                            </option>
                        </select>
                    </div>
                    <div class="col-12 mb-3">
                        <label class="form-label required">
                            Địa chỉ chi tiết
                        </label>
                        <input
                                id="mChiTiet"
                                class="form-control"
                                placeholder="Ví dụ: Số 10, ngõ 20, đường ABC">
                    </div>
                    <div class="col-12">
                        <div class="form-check">
                            <input
                                    class="form-check-input"
                                    type="checkbox"
                                    id="mMacDinh">
                            <label
                                    class="form-check-label"
                                    for="mMacDinh">
                                Đặt làm địa chỉ mặc định
                            </label>
                        </div>
                    </div>
                </div>
            </div>
            <div class="modal-footer">
                <button
                        type="button"
                        class="btn btn-secondary"
                        data-bs-dismiss="modal">
                    Đóng
                </button>
                <button
                        type="button"
                        class="btn btn-primary"
                        id="btnSaveDiaChi">
                    Lưu địa chỉ
                </button>
            </div>
        </div>
    </div>
</div>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
<script>
    const modal = new bootstrap.Modal(document.getElementById("modalDiaChi"));
    const btnMoModal = document.getElementById("btnMoModalDiaChi");
    const btnSaveDiaChi = document.getElementById("btnSaveDiaChi");

    const mTinh = document.getElementById("mTinh");
    const mHuyen = document.getElementById("mHuyen");
    const mXa = document.getElementById("mXa");
    const mChiTiet = document.getElementById("mChiTiet");
    const mMacDinh = document.getElementById("mMacDinh");

    let listDiaChiTam = [];

    btnMoModal.onclick = function () {
        if(listDiaChiTam.length >= 1){
            alert("Luồng tạo mới tạm thời chỉ hỗ trợ thiết lập trước 1 địa chỉ nhận hàng.");
            return;
        }
        mChiTiet.value = "";
        mMacDinh.checked = true;
        modal.show();
    };

    // 1. Tải danh sách Tỉnh/Thành phố từ API Esgoo siêu tốc và ổn định
    function loadTinh() {
        fetch("https://esgoo.net/api-tinhthanh/1/0.htm")
            .then(function(response) {
                return response.json();
            })
            .then(function(data) {
                if (data.error === 0) {
                    mTinh.innerHTML = "<option value=''>Chọn Tỉnh / Thành phố</option>";
                    data.data.forEach(function(item) {
                        mTinh.innerHTML += '<option value="' + item.id + '">' + item.name + '</option>';
                    });
                }
            })
            .catch(function(error) {
                console.error("Lỗi load Tỉnh:", error);
            });
    }
    loadTinh();

    // 2. Khi chọn Tỉnh -> Load Quận/Huyện dựa trên ID Tỉnh
    mTinh.onchange = function() {
        mHuyen.disabled = true;
        mXa.disabled = true;
        mHuyen.innerHTML = "<option>Đang tải...</option>";
        mXa.innerHTML = "<option value=''>Chọn Phường/Xã</option>";

        const idTinh = this.value;
        if(idTinh) {
            fetch("https://esgoo.net/api-tinhthanh/2/" + idTinh + ".htm")
                .then(function(response) {
                    return response.json();
                })
                .then(function(data) {
                    mHuyen.innerHTML = "<option value=''>Chọn Quận/Huyện</option>";
                    if(data.error === 0 && data.data) {
                        data.data.forEach(function(item) {
                            mHuyen.innerHTML += '<option value="' + item.id + '">' + item.name + '</option>';
                        });
                        mHuyen.disabled = false;
                    }
                })
                .catch(function(error) {
                    console.error("Lỗi load Quận:", error);
                });
        } else {
            mHuyen.innerHTML = "<option value=''>Chọn Quận/Huyện</option>";
        }
    };

    // 3. Khi chọn Quận/Huyện -> Load Phường/Xã dựa trên ID Huyện
    mHuyen.onchange = function() {
        mXa.disabled = true;
        mXa.innerHTML = "<option>Đang tải...</option>";

        const idHuyen = this.value;
        if(idHuyen) {
            fetch("https://esgoo.net/api-tinhthanh/3/" + idHuyen + ".htm")
                .then(function(response) {
                    return response.json();
                })
                .then(function(data) {
                    mXa.innerHTML = "<option value=''>Chọn Phường/Xã</option>";
                    if(data.error === 0 && data.data) {
                        data.data.forEach(function(item) {
                            mXa.innerHTML += '<option value="' + item.id + '">' + item.name + '</option>';
                        });
                        mXa.disabled = false;
                    }
                })
                .catch(function(error) {
                    console.error("Lỗi load Xã:", error);
                });
        } else {
            mXa.innerHTML = "<option value=''>Chọn Phường/Xã</option>";
        }
    };

    // 4. Lưu địa chỉ tạm từ Modal vào UI danh sách nhận hàng
    btnSaveDiaChi.onclick = function () {
        if (
            mTinh.value === "" ||
            mHuyen.value === "" ||
            mXa.value === "" ||
            mChiTiet.value.trim() === ""
        ) {
            alert("Vui lòng nhập đầy đủ thông tin địa chỉ.");
            return;
        }

        const tinhThanh = mTinh.options[mTinh.selectedIndex].text;
        const quanHuyen = mHuyen.options[mHuyen.selectedIndex].text;
        const phuongXa = mXa.options[mXa.selectedIndex].text;

        const diaChi = {
            idTemp: Date.now(),
            provinceCode: parseInt(mTinh.value),
            districtCode: parseInt(mHuyen.value),
            wardCode: parseInt(mXa.value),
            tinhThanh: tinhThanh,
            quanHuyen: quanHuyen,
            phuongXa: phuongXa,
            diaChiCuThe: mChiTiet.value.trim(),
            loaiDiaChi: "Nhà riêng",
            isMacDinh: mMacDinh.checked
        };

        listDiaChiTam.push(diaChi);
        renderDanhSachDiaChi();
        modal.hide();
    };

    // 5. Render danh sách địa chỉ nhận hàng tạm thời ra ngoài
    function renderDanhSachDiaChi() {
        const container = document.getElementById("danhSachDiaChiUI");
        container.innerHTML = "";

        if (listDiaChiTam.length === 0) {
            container.innerHTML =
                '<div class="text-center text-muted py-4" id="txtDiaChiTrong">' +
                'Chưa có địa chỉ nào.' +
                '</div>';

            document.getElementById("hiddenProvinceCode").value = "";
            document.getElementById("hiddenDistrictCode").value = "";
            document.getElementById("hiddenWardCode").value = "";
            document.getElementById("hiddenMTinhText").value = "";
            document.getElementById("hiddenMHuyenText").value = "";
            document.getElementById("hiddenMXaText").value = "";
            document.getElementById("hiddenMChiTiet").value = "";
            document.getElementById("hiddenMMacDinh").value = "";
            return;
        }

        const item = listDiaChiTam[0];
        const badge = item.isMacDinh ? '<span class="badge-default ms-2">Mặc định</span>' : '';

        container.innerHTML =
            '<div class="address-item ' + (item.isMacDinh ? 'default-address' : '') + '">' +
            '<div>' +
            '<div class="fw-bold">' +
            item.loaiDiaChi + badge +
            '</div>' +
            '<div class="text-muted mt-2">' +
            item.diaChiCuThe + ', ' + item.phuongXa + ', ' + item.quanHuyen + ', ' + item.tinhThanh +
            '</div>' +
            '</div>' +
            '<div class="mt-2">' +
            '<button type="button" class="btn btn-outline-danger btn-sm" onclick="xoaDiaChi(' + item.idTemp + ')">' +
            'Xóa địa chỉ' +
            '</button>' +
            '</div>' +
            '</div>';

        document.getElementById("hiddenProvinceCode").value = item.provinceCode;
        document.getElementById("hiddenDistrictCode").value = item.districtCode;
        document.getElementById("hiddenWardCode").value = item.wardCode;

        document.getElementById("hiddenMTinhText").value = item.tinhThanh;
        document.getElementById("hiddenMHuyenText").value = item.quanHuyen;
        document.getElementById("hiddenMXaText").value = item.phuongXa;
        document.getElementById("hiddenMChiTiet").value = item.diaChiCuThe;
        document.getElementById("hiddenMMacDinh").value = item.isMacDinh ? "true" : "false";
    }

    // 6. Xóa địa chỉ tạm
    window.xoaDiaChi = function (idTemp) {
        if (!confirm("Bạn có chắc muốn xóa địa chỉ này?")) {
            return;
        }
        listDiaChiTam = [];
        renderDanhSachDiaChi();
    };

    // Reset sạch modal sau khi đóng
    document.getElementById("modalDiaChi").addEventListener("hidden.bs.modal", function () {
        mTinh.selectedIndex = 0;
        mHuyen.innerHTML = "<option value=''>Chọn Quận/Huyện</option>";
        mXa.innerHTML = "<option value=''>Chọn Phường/Xã</option>";
        mHuyen.disabled = true;
        mXa.disabled = true;
        mChiTiet.value = "";
        mMacDinh.checked = false;
    });

    // Ràng buộc trước khi submit form
    document.getElementById("formAddKhachHang").addEventListener("submit", function (e) {
        if (listDiaChiTam.length === 0) {
            e.preventDefault();
            alert("Vui lòng thêm địa chỉ nhận hàng.");
        }
    });
</script>
</body>
</html>