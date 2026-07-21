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
        body{ background:#f4f6f9; font-size:14px; }
        .main-card{ background:white; border-radius:15px; padding:30px; box-shadow:0 5px 25px rgba(0,0,0,.08); }
        .avatar{ width:90px; height:90px; border-radius:50%; background:#f5f5f5; border:2px dashed #ddd; display:flex; justify-content:center; align-items:center; font-size:40px; color:#999; margin:auto; }
        .required:after{ content:" *"; color:red; }
        .address-box{ margin-top:30px; border:1px solid #ddd; border-radius:10px; padding:20px; background:#fafafa; }
        .address-item{ border:1px solid #ddd; border-radius:8px; padding:12px; margin-bottom:10px; background:white; }
        .default-address{ border-left:4px solid #0d6efd; }
        .badge-default{ background:#dbeafe; color:#2563eb; padding:3px 8px; border-radius:4px; font-size:11px; }
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
    <div class="container mt-5 mb-5">
        <div class="main-card">
            <div class="d-flex justify-content-between align-items-center mb-4">
                <h4>Quản lý khách hàng / <b>Thêm khách hàng</b></h4>
                <a class="btn btn-outline-secondary" href="${pageContext.request.contextPath}/khachhang/hien-thi">
                    <i class="bi bi-arrow-left"></i> Quay lại
                </a>
            </div>

            <div class="text-center mb-4">
                <div class="avatar"><i class="bi bi-person-fill"></i></div>
                <small class="text-muted">Ảnh đại diện mặc định</small>
            </div>

            <form id="formAddKhachHang" action="${pageContext.request.contextPath}/khachhang/add" method="post">
                <div class="row">
                    <div class="col-md-6 mb-3">
                        <label class="form-label">Mã khách hàng</label>
                        <input class="form-control" name="ma">
                    </div>
                    <div class="col-md-6 mb-3">
                        <label class="form-label required">Họ tên</label>
                        <input class="form-control" name="hoTen" required>
                    </div>
                    <div class="col-md-6 mb-3">
                        <label class="form-label required">Số điện thoại</label>
                        <input class="form-control" name="sdt" required>
                    </div>
                    <div class="col-md-6 mb-3">
                        <label class="form-label required">Email</label>
                        <input type="email" class="form-control" name="email" required>
                    </div>
                    <div class="col-md-6">
                        <label class="form-label required">Giới tính</label><br>
                        <input type="radio" name="gioiTinh" value="Nam" checked> Nam &nbsp;&nbsp;
                        <input type="radio" name="gioiTinh" value="Nữ"> Nữ
                    </div>

                </div>

                <div class="mt-3">
                    <label class="form-label">Địa chỉ gốc</label>
                    <input class="form-control" name="diaChi" placeholder="Nhập địa chỉ thường trú">
                </div>

                <hr class="my-4">

                <div class="d-flex justify-content-between align-items-center">
                    <div>
                        <h5 class="mb-1">Địa chỉ nhận hàng</h5>
                        <small class="text-muted">Thiết lập trước 1 địa chỉ nhận hàng</small>
                    </div>
                    <button type="button" class="btn btn-success" id="btnMoModalDiaChi">
                        <i class="bi bi-plus-circle"></i> Thêm địa chỉ
                    </button>
                </div>

                <div id="danhSachDiaChiUI" class="mt-3">
                    <div class="text-center text-muted py-4">Chưa có địa chỉ nào.</div>
                </div>

                <!-- Hidden inputs -->
                <input type="hidden" id="hiddenProvinceCode" name="provinceCode">
                <input type="hidden" id="hiddenWardCode" name="wardCode">
                <input type="hidden" id="hiddenMTinhText" name="mTinhText">
                <input type="hidden" id="hiddenMXaText" name="mXaText">
                <input type="hidden" id="hiddenMChiTiet" name="mChiTiet">
                <input type="hidden" id="hiddenMMacDinh" name="mMacDinh">

                <div class="mt-4 text-end">
                    <a href="${pageContext.request.contextPath}/khachhang/hien-thi" class="btn btn-secondary">Hủy</a>
                    <button type="submit" class="btn btn-primary">
                        <i class="bi bi-check-circle"></i> Thêm khách hàng
                    </button>
                </div>
            </form>
        </div>
    </div>

    <!-- ================= MODAL ĐỊA CHỈ ================= -->
    <div class="modal fade" id="modalDiaChi" tabindex="-1">
        <div class="modal-dialog modal-lg">
            <div class="modal-content">
                <div class="modal-header">
                    <h5 class="modal-title">Thêm địa chỉ nhận hàng</h5>
                    <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
                </div>
                <div class="modal-body">
                    <div class="row">
                        <div class="col-md-6 mb-3">
                            <label class="form-label required">Tỉnh / Thành phố</label>
                            <select id="mTinh" class="form-select">
                                <option value="">-- Chọn tỉnh --</option>
                                <c:forEach items="${listTinh}" var="t">
                                    <option value="${t.id}">${t.ten}</option>
                                </c:forEach>
                            </select>
                        </div>
                        <div class="col-md-6 mb-3">
                            <label class="form-label required">Phường / Xã</label>
                            <select id="mXa" class="form-select" disabled>
                                <option value="">-- Chọn phường/xã --</option>
                            </select>
                        </div>
                        <div class="col-12 mb-3">
                            <label class="form-label required">Địa chỉ chi tiết</label>
                            <input id="mChiTiet" class="form-control" placeholder="Ví dụ: Số nhà 12, đường ABC">
                        </div>
                        <div class="col-12">
                            <div class="form-check">
                                <input id="mMacDinh" class="form-check-input" type="checkbox" checked>
                                <label class="form-check-label" for="mMacDinh">Đặt làm địa chỉ mặc định</label>
                            </div>
                        </div>
                    </div>
                </div>
                <div class="modal-footer">
                    <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Đóng</button>
                    <button type="button" class="btn btn-primary" id="btnSaveDiaChi">Lưu địa chỉ</button>
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
        const mXa = document.getElementById("mXa");
        const mChiTiet = document.getElementById("mChiTiet");
        const mMacDinh = document.getElementById("mMacDinh");

        let listDiaChiTam = [];

        btnMoModal.onclick = function() {
            if(listDiaChiTam.length >= 1){
                alert("Chỉ hỗ trợ 1 địa chỉ.");
                return;
            }
            modal.show();
        };

        const allPhuong = [

            <c:forEach items="${listPhuong}" var="p" varStatus="st">
            {
                id: ${p.id},
                provinceId: ${p.provinceId},
                ten: "${p.ten}"
            }<c:if test="${!st.last}">,</c:if>
            </c:forEach>

        ];
        console.log("allPhuong =", allPhuong);
        console.log("Số lượng =", allPhuong.length);
        mTinh.onchange = function () {

            mXa.innerHTML = "<option value=''>-- Chọn phường/xã --</option>";
            mXa.disabled = true;

            if (mTinh.value === "") {
                return;
            }

            const provinceId = parseInt(mTinh.value);

            const ds = allPhuong.filter(function (p) {
                return p.provinceId === provinceId;
            });

            ds.forEach(function (p) {
                mXa.innerHTML +=
                    "<option value='" + p.id + "'>" + p.ten + "</option>";
            });

            mXa.disabled = false;
        };
        btnSaveDiaChi.onclick = function() {
            if(mTinh.value == "" || mXa.value == "" || mChiTiet.value.trim() == ""){
                alert("Vui lòng nhập đầy đủ.");
                return;
            }

            const diaChi = {
                provinceCode: parseInt(mTinh.value),
                wardCode: parseInt(mXa.value),
                tinhThanh: mTinh.options[mTinh.selectedIndex].text,
                phuongXa: mXa.options[mXa.selectedIndex].text,
                diaChiCuThe: mChiTiet.value.trim(),
                isMacDinh: mMacDinh.checked
            };

            listDiaChiTam = [diaChi];
            renderDiaChi();
            modal.hide();
        };

        function renderDiaChi() {
            const box = document.getElementById("danhSachDiaChiUI");
            box.innerHTML = "";
            const item = listDiaChiTam[0];

            box.innerHTML =

                '<div class="address-item default-address">' +

                '<div class="d-flex justify-content-between align-items-start">' +

                '<div>' +

                '<div class="fw-bold">' +

                'Nhà riêng ' +

                (item.isMacDinh
                    ? '<span class="badge-default ms-2">Mặc định</span>'
                    : '') +

                '</div>' +

                '<div class="mt-2">' +

                item.diaChiCuThe +
                ', ' +
                item.phuongXa +
                ', ' +
                item.tinhThanh +

                '</div>' +

                '</div>' +

                '<button class="btn btn-outline-danger btn-sm" onclick="xoaDiaChi()">' +

                'Xóa'

                +

                '</button>' +

                '</div>' +

                '</div>';
            document.getElementById("hiddenProvinceCode").value = item.provinceCode;
            document.getElementById("hiddenWardCode").value = item.wardCode;
            document.getElementById("hiddenMTinhText").value = item.tinhThanh;
            document.getElementById("hiddenMXaText").value = item.phuongXa;
            document.getElementById("hiddenMChiTiet").value = item.diaChiCuThe;
            document.getElementById("hiddenMMacDinh").value = item.isMacDinh;
        }

        window.xoaDiaChi = function () {

            if (!confirm("Bạn có chắc muốn xóa địa chỉ này?")) {
                return;
            }

            listDiaChiTam = [];

            document.getElementById("danhSachDiaChiUI").innerHTML =
                '<div class="text-center text-muted py-4">' +
                'Chưa có địa chỉ nào.' +
                '</div>';

            document.getElementById("hiddenProvinceCode").value = "";
            document.getElementById("hiddenWardCode").value = "";

            document.getElementById("hiddenMTinhText").value = "";
            document.getElementById("hiddenMXaText").value = "";
            document.getElementById("hiddenMChiTiet").value = "";
            document.getElementById("hiddenMMacDinh").value = "";

        };


        document.getElementById("modalDiaChi")
            .addEventListener("hidden.bs.modal", function () {

                mTinh.selectedIndex = 0;

                mXa.innerHTML =
                    "<option value=''>-- Chọn Phường/Xã --</option>";

                mChiTiet.value = "";

                mMacDinh.checked = true;

            });


        document.getElementById("formAddKhachHang")
            .addEventListener("submit", function (e) {

                // Kiểm tra đã thêm địa chỉ chưa
                if (listDiaChiTam.length === 0) {

                    e.preventDefault();
                    alert("Vui lòng thêm địa chỉ nhận hàng.");
                    return;
                }

                // Xác nhận thêm khách hàng
                if (!confirm("Bạn có chắc muốn thêm khách hàng này không?")) {

                    e.preventDefault();
                    return;

                }

            });
    </script>
</div>
</body>
</html>