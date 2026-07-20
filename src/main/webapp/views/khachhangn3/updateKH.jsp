<%@ page contentType="text/html;charset=UTF-8" language="java"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>

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
                <b>Cập nhật khách hàng</b>
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
        <form id="formUpdateKhachHang"
              action="${pageContext.request.contextPath}/khachhang/update"
              method="post">
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
                           readonly
                           value="${khachHangS.ma}">
                </div>
                <div class="col-md-6 mb-3">
                    <label class="form-label required">
                        Họ tên
                    </label>
                    <input class="form-control"
                           name="hoTen"
                           required
                           value="${khachHangS.hoTen}">
                </div>
                <div class="col-md-6 mb-3">
                    <label class="form-label required">
                        Số điện thoại
                    </label>
                    <input class="form-control" name="sdt" required value="${khachHangS.sdt}">
                </div>
                <div class="col-md-6 mb-3">
                    <label class="form-label required">
                        Email
                    </label>
                    <input class="form-control" type="email" name="email" required value="${khachHangS.email}">
                </div>
                <div class="col-md-6 mb-3">
                    <label class="form-label">
                        Địa chỉ gốc
                    </label>
                    <input class="form-control"
                           name="diaChi"
                           value="${khachHangS.diaChi}">

                </div>
                <div class="col-md-3">
                    <label class="form-label required">
                        Giới tính
                    </label>
                    <br>
                    <input type="radio"
                           name="gioiTinh"
                           value="Nam"
                           <c:if test="${khachHangS.gioiTinh=='Nam'}">checked</c:if>>

                    Nam

                    &nbsp;&nbsp;

                    <input type="radio"
                           name="gioiTinh"
                           value="Nữ"
                           <c:if test="${khachHangS.gioiTinh=='Nữ'}">checked</c:if>>

                    Nữ

                </div>


            </div>

            <hr class="my-4">

            <div class="d-flex justify-content-between align-items-center">

                <div>

                    <h5 class="mb-1">

                        Địa chỉ nhận hàng

                    </h5>

                    <small class="text-muted">

                        Cập nhật địa chỉ nhận hàng

                    </small>

                </div>

                <button type="button"
                        class="btn btn-success"
                        id="btnMoModalDiaChi">
                    <i class="bi bi-pencil-square"></i>
                    Chỉnh sửa địa chỉ
                </button>
            </div>
            <div id="danhSachDiaChiUI"
                 class="mt-3">
            </div>
            <!-- Hidden -->
            <input type="hidden" id="hiddenProvinceCode" name="provinceCode">
            <input type="hidden" id="hiddenWardCode" name="wardCode">
            <input type="hidden" id="hiddenMTinhText" name="mTinhText">
            <input type="hidden" id="hiddenMXaText" name="mXaText">
            <input type="hidden" id="hiddenMChiTiet" name="mChiTiet">
            <input type="hidden" id="hiddenMMacDinh" name="mMacDinh">
            <div class="mt-4 text-end">
                <a href="${pageContext.request.contextPath}/khachhang/hien-thi"
                   class="btn btn-secondary">
                    Hủy
                </a>
                <button type="submit"
                        class="btn btn-primary">
                    <i class="bi bi-check-circle"></i>
                    Cập nhật khách hàng
                </button>
            </div>
        </form>
    </div>
</div>
<!-- ================= MODAL ĐỊA CHỈ ================= -->

<div class="modal fade"
     id="modalDiaChi"
     tabindex="-1">

    <div class="modal-dialog modal-lg">

        <div class="modal-content">

            <div class="modal-header">

                <h5 class="modal-title">

                    Cập nhật địa chỉ nhận hàng

                </h5>

                <button type="button"
                        class="btn-close"
                        data-bs-dismiss="modal">

                </button>

            </div>

            <div class="modal-body">

                <div class="row">

                    <div class="col-md-6 mb-3">

                        <label class="form-label required">

                            Tỉnh / Thành phố

                        </label>

                        <select id="mTinh"
                                class="form-select">

                            <option value="">-- Chọn tỉnh --</option>

                            <c:forEach items="${listTinh}" var="t">

                                <option value="${t.id}">

                                        ${t.ten}

                                </option>

                            </c:forEach>

                        </select>

                    </div>

                    <div class="col-md-6 mb-3">

                        <label class="form-label required">

                            Phường / Xã

                        </label>

                        <select id="mXa"
                                class="form-select">

                            <option value="">-- Chọn phường/xã --</option>

                        </select>

                    </div>

                    <div class="col-12 mb-3">

                        <label class="form-label required">

                            Địa chỉ chi tiết

                        </label>

                        <input id="mChiTiet"
                               class="form-control"
                               value="${diaChiKH.diaChiCuThe}">

                    </div>

                    <div class="col-12">

                        <div class="form-check">

                            <input id="mMacDinh"
                                   class="form-check-input"
                                   type="checkbox"

                            <c:if test="${diaChiKH.isMacDinh}">

                                   checked

                            </c:if>

                            >

                            <label class="form-check-label">

                                Địa chỉ mặc định

                            </label>

                        </div>

                    </div>

                </div>
            </div>
            <div class="modal-footer">
                <button type="button"
                        class="btn btn-secondary"
                        data-bs-dismiss="modal">
                    Đóng
                </button>
                <button type="button"
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

    const modal =
        new bootstrap.Modal(document.getElementById("modalDiaChi"));

    const btnMoModal =
        document.getElementById("btnMoModalDiaChi");

    const btnSaveDiaChi =
        document.getElementById("btnSaveDiaChi");

    const mTinh =
        document.getElementById("mTinh");

    const mXa =
        document.getElementById("mXa");

    const mChiTiet =
        document.getElementById("mChiTiet");

    const mMacDinh =
        document.getElementById("mMacDinh");

    // ===============================
    // Danh sách toàn bộ phường/xã
    // ===============================

    const allPhuong = [

        <c:forEach items="${listPhuong}" var="p" varStatus="st">

        {
            id:${p.id},
            provinceId:${p.provinceId},
            ten:"${p.ten}"
        }

        <c:if test="${!st.last}">,</c:if>

        </c:forEach>

    ];

    // ===============================
    // Địa chỉ hiện tại
    // ===============================

    let listDiaChiTam = [

        {

            provinceCode:null,

            wardCode:null,

            tinhThanh:"${diaChiKH.tinhThanh}",

            phuongXa:"${diaChiKH.phuongXa}",

            diaChiCuThe:"${diaChiKH.diaChiCuThe}",

            isMacDinh:${diaChiKH.isMacDinh}

        }

    ];

    btnMoModal.onclick=function(){

        modal.show();

    };

    // ===============================
    // Lọc phường theo tỉnh
    // ===============================

    mTinh.onchange=function(){

        mXa.innerHTML=
            "<option value=''>-- Chọn phường/xã --</option>";

        if(mTinh.value==""){

            mXa.disabled=true;

            return;

        }

        const provinceId=parseInt(mTinh.value);

        const ds=allPhuong.filter(function(p){

            return p.provinceId===provinceId;

        });

        ds.forEach(function(p){

            mXa.innerHTML+=
                "<option value='"+p.id+"'>"+
                p.ten+
                "</option>";

        });

        mXa.disabled=false;

    };

    // ===============================
    // Hiển thị địa chỉ
    // ===============================

    function renderDiaChi(){

        const box=document.getElementById("danhSachDiaChiUI");

        const item=listDiaChiTam[0];

        box.innerHTML=

            '<div class="address-item default-address">'+

            '<div class="d-flex justify-content-between">'+

            '<div>'+

            '<div class="fw-bold">'+

            'Nhà riêng'+

            (item.isMacDinh
                ?'<span class="badge-default ms-2">Mặc định</span>'
                :'')+

            '</div>'+

            '<div class="mt-2">'+

            item.diaChiCuThe+

            ", "+

            item.phuongXa+

            ", "+

            item.tinhThanh+

            '</div>'+

            '</div>'+

            '</div>'+

            '</div>';

    }

    renderDiaChi();
    // ==========================================
    // Lưu địa chỉ
    // ==========================================

    btnSaveDiaChi.onclick = function () {

        if (mTinh.value == "" ||
            mXa.value == "" ||
            mChiTiet.value.trim() == "") {

            alert("Vui lòng nhập đầy đủ địa chỉ.");

            return;
        }

        const diaChi = {

            provinceCode: parseInt(mTinh.value),

            wardCode: parseInt(mXa.value),

            tinhThanh:
            mTinh.options[mTinh.selectedIndex].text,

            phuongXa:
            mXa.options[mXa.selectedIndex].text,

            diaChiCuThe:
                mChiTiet.value.trim(),

            isMacDinh:
            mMacDinh.checked

        };

        listDiaChiTam = [diaChi];

        renderDiaChi();

        modal.hide();

    };

    // ==========================================
    // Đổ dữ liệu vào hidden input
    // ==========================================

    function syncHidden() {

        if (listDiaChiTam.length == 0) {
            return;
        }

        const item = listDiaChiTam[0];

        document.getElementById("hiddenProvinceCode").value =
            item.provinceCode;

        document.getElementById("hiddenWardCode").value =
            item.wardCode;

        document.getElementById("hiddenMTinhText").value =
            item.tinhThanh;

        document.getElementById("hiddenMXaText").value =
            item.phuongXa;

        document.getElementById("hiddenMChiTiet").value =
            item.diaChiCuThe;

        document.getElementById("hiddenMMacDinh").value =
            item.isMacDinh;

    }

    // ==========================================
    // Submit Form
    // ==========================================

    document.getElementById("formUpdateKhachHang")
        .addEventListener("submit", function (e) {

            syncHidden();

            if (listDiaChiTam.length == 0) {

                e.preventDefault();

                alert("Vui lòng cập nhật địa chỉ.");

                return;
            }

            if (!confirm("Bạn có chắc muốn cập nhật khách hàng này không?")) {

                e.preventDefault();

                return;
            }

        });
    // ==========================================
    // Khởi tạo hidden input lần đầu
    // ==========================================

    syncHidden();

</script>

</body>

</html>