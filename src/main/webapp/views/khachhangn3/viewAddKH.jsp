<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <title>Thêm khách hàng</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.10.5/font/bootstrap-icons.css">

    <style>
        body {
            background-color: #f4f6f9;
            font-family: -apple-system, BlinkMacSystemFont, "Segoe UI", Roboto, "Helvetica Neue", Arial, sans-serif;
            font-size: 14px;
        }
        .main-card {
            border: none;
            border-radius: 12px;
            box-shadow: 0 4px 20px rgba(0,0,0,0.08);
            background: #fff;
            padding: 30px;
        }
        .avatar-section {
            display: flex;
            flex-direction: column;
            align-items: center;
            margin-bottom: 25px;
        }
        .avatar-circle {
            width: 90px;
            height: 90px;
            border-radius: 50%;
            background-color: #f1f3f9;
            display: flex;
            align-items: center;
            justify-content: center;
            font-size: 36px;
            color: #6c757d;
            border: 2px dashed #dee2e6;
            cursor: pointer;
            transition: all 0.3s ease;
        }
        .avatar-circle:hover {
            border-color: #0d6efd;
            color: #0d6efd;
        }
        .form-label {
            font-weight: 600;
            color: #495057;
        }
        .required::after {
            content: " *";
            color: red;
        }
        .address-box {
            border: 1px solid #e3e6f0;
            border-radius: 10px;
            background-color: #fafbfe;
            padding: 20px;
            margin-top: 25px;
        }
        .address-item {
            background: #fff;
            border: 1px solid #e3e6f0;
            border-radius: 8px;
            padding: 12px 16px;
            margin-bottom: 10px;
            display: flex;
            justify-content: space-between;
            align-items: center;
            transition: border-color 0.2s;
        }
        .address-item.is-default {
            border-left: 4px solid #0d6efd;
        }
        .badge-default {
            background-color: #e8f0fe;
            color: #1a73e8;
            font-size: 11px;
            padding: 2px 8px;
            border-radius: 4px;
            font-weight: 600;
        }
        .btn-add-address {
            background-color: #10b981;
            color: white;
            font-weight: 500;
        }
        .btn-add-address:hover {
            background-color: #059669;
            color: white;
        }
    </style>
</head>
<body>

<div class="container my-5" style="max-width: 1000px;">
    <div class="main-card">

        <div class="d-flex justify-content-between align-items-center mb-4 pb-3 border-bottom">
            <h4 class="fw-bold mb-0 text-dark">Quản lý khách hàng / Thêm mới</h4>
            <a href="${pageContext.request.contextPath}/khachhang/hien-thi" class="btn btn-sm btn-outline-secondary">
                <i class="bi bi-arrow-left"></i> Quay lại danh sách
            </a>
        </div>

        <div class="avatar-section">
            <div class="avatar-circle">
                <i class="bi bi-person-fill"></i>
            </div>
            <span class="text-muted mt-2" style="font-size: 12px;">Bấm vào ảnh để chọn (png/jpg/webp). Ảnh sẽ upload lên server.</span>
        </div>

        <form id="formAddKhachHang" action="${pageContext.request.contextPath}/khachhang/add" method="POST">

            <div class="row g-3">
                <div class="col-md-6">
                    <label class="form-label">Mã khách hàng</label>
                    <input type="text" class="form-control" name="ma" value="KH009" readonly style="background-color: #e9ecef;">
                </div>

                <div class="col-md-6">
                    <label class="form-label required">Tên khách hàng</label>
                    <input type="text" class="form-control" name="hoTen" placeholder="Nhập họ tên" required>
                </div>

                <div class="col-md-6">
                    <label class="form-label required">Số điện thoại</label>
                    <input type="text" class="form-control" name="sdt" placeholder="Nhập số điện thoại" required>
                </div>

                <div class="col-md-6">
                    <label class="form-label required">Email</label>
                    <input type="email" class="form-control" name="email" placeholder="Nhập email" required>
                </div>

                <div class="col-md-6">
                    <label class="form-label required">Giới tính</label>
                    <div class="mt-2">
                        <div class="form-check form-check-inline">
                            <input class="form-check-input" type="radio" name="gioiTinh" id="gtNam" value="Nam" checked>
                            <label class="form-check-label" for="gtNam">Nam</label>
                        </div>
                        <div class="form-check form-check-inline">
                            <input class="form-check-input" type="radio" name="gioiTinh" id="gtNu" value="Nữ">
                            <label class="form-check-label" for="gtNu">Nữ</label>
                        </div>
                    </div>
                </div>

                <div class="col-md-6">
                    <label class="form-label required">Trạng thái</label>
                    <div class="mt-2">
                        <div class="form-check form-check-inline">
                            <input class="form-check-input" type="radio" name="trangThai" id="ttHoatDong" value="1" checked>
                            <label class="form-check-label" for="ttHoatDong">Hoạt động</label>
                        </div>
                        <div class="form-check form-check-inline">
                            <input class="form-check-input" type="radio" name="trangThai" id="ttNgungHoatDong" value="0">
                            <label class="form-check-label" for="ttNgungHoatDong">Ngừng hoạt động</label>
                        </div>
                    </div>
                </div>
            </div>

            <div class="address-box">
                <div class="d-flex justify-content-between align-items-center mb-3">
                    <div>
                        <h6 class="fw-bold mb-0">Quản lý địa chỉ</h6>
                        <small class="text-muted">Danh sách địa chỉ của khách hàng (Tối đa 5 địa chỉ)</small>
                    </div>
                    <button type="button" class="btn btn-add-address btn-sm px-3" id="btnMoModalDiaChi">
                        Thêm địa chỉ
                    </button>
                </div>

                <div id="danhSachDiaChiUI">
                    <p class="text-center text-muted py-4 mb-0" id="txtDiaChiTrong">
                        Chưa có địa chỉ nào được thêm. Vui lòng thêm địa chỉ!
                    </p>
                </div>
            </div>

            <input type="hidden" id="hiddenDiaChiInput" name="diaChi">

            <div class="d-flex justify-content-between align-items-center mt-4 pt-3 border-top">
                <span class="text-muted" id="txtCheckForm">Vui lòng điền đầy đủ các thông tin bắt buộc.</span>
                <div>
                    <a href="${pageContext.request.contextPath}/khachhang/hien-thi" class="btn btn-light me-2 px-4">Hủy</a>
                    <button type="submit" class="btn btn-primary px-4">Thêm mới</button>
                </div>
            </div>

        </form>
    </div>
</div>

<div class="modal fade" id="modalDiaChi" data-bs-backdrop="static" tabindex="-1" aria-hidden="true">
    <div class="modal-dialog modal-dialog-centered modal-lg">
        <div class="modal-content">
            <div class="modal-header border-0 pb-0">
                <div>
                    <h5 class="modal-title fw-bold">Thêm địa chỉ mới</h5>
                    <small class="text-muted">Nhập đầy đủ thông tin địa chỉ.</small>
                </div>
                <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
            </div>

            <div class="modal-body pt-3">
                <form id="formModalDiaChi">
                    <div class="row g-3">
                        <div class="col-md-6">
                            <label class="form-label required">Người nhận</label>
                            <input type="text" class="form-control" id="mNguoiNhan" placeholder="Tên người nhận" required>
                        </div>

                        <div class="col-md-6">
                            <label class="form-label required">SĐT người nhận</label>
                            <input type="text" class="form-control" id="mSdtNhan" placeholder="SĐT người nhận" required>
                        </div>

                        <div class="col-md-4">
                            <label class="form-label required">Tỉnh / Thành phố</label>
                            <select class="form-select" id="mTinh" required>
                                <option value="" selected disabled>Chọn Tỉnh/Thành phố</option>
                            </select>
                        </div>

                        <div class="col-md-4">
                            <label class="form-label required">Quận / Huyện</label>
                            <select class="form-select" id="mHuyen" required disabled>
                                <option value="" selected disabled>Chọn Quận/Huyện</option>
                            </select>
                        </div>

                        <div class="col-md-4">
                            <label class="form-label required">Phường / Xã</label>
                            <select class="form-select" id="mXa" required disabled>
                                <option value="" selected disabled>Chọn Phường/Xã</option>
                            </select>
                        </div>

                        <div class="col-12">
                            <label class="form-label required">Địa chỉ chi tiết</label>
                            <input type="text" class="form-control" id="mChiTiet" placeholder="Số nhà, ngõ, đường..." required>
                        </div>

                        <div class="col-12">
                            <div class="form-check">
                                <input class="form-check-input" type="checkbox" id="mMacDinh">
                                <label class="form-check-label" for="mMacDinh">
                                    Đặt làm địa chỉ mặc định
                                </label>
                            </div>
                        </div>
                    </div>
                </form>
            </div>

            <div class="modal-footer border-0">
                <button type="button" class="btn btn-light" data-bs-dismiss="modal">Hủy</button>
                <button type="button" class="btn btn-primary" id="btnSaveDiaChi" style="background-color: #2563eb;">Lưu địa chỉ</button>
            </div>
        </div>
    </div>
</div>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
<script src="https://cdn.jsdelivr.net/gh/ux-team/vietnam-provinces-json@main/vietnam-provinces.js"></script>

<script>
    // DOM Elements
    const modalEl = document.getElementById('modalDiaChi');
    const modalInstance = new bootstrap.Modal(modalEl);
    const btnMoModal = document.getElementById('btnMoModalDiaChi');

    const mTinh = document.getElementById('mTinh');
    const mHuyen = document.getElementById('mHuyen');
    const mXa = document.getElementById('mXa');

    let listDiaChiTam = [];
    let duLieuHanhChinh = [];

    btnMoModal.addEventListener('click', () => {
        if(listDiaChiTam.length >= 5) {
            alert("Bạn chỉ được thêm tối đa 5 địa chỉ!");
            return;
        }
        document.getElementById('formModalDiaChi').reset();
        mHuyen.innerHTML = '<option value="" selected disabled>Chọn Quận/Huyện</option>';
        mHuyen.disabled = true;
        mXa.innerHTML = '<option value="" selected disabled>Chọn Phường/Xã</option>';
        mXa.disabled = true;
        modalInstance.show();
    });

    // 1. Tự động nạp dữ liệu từ thư viện CDN khi trang tải xong
    function loadProvincesData() {
        // Biến window.__vietnamProvinces__ tự động sinh ra khi nhúng script CDN ở trên
        if (typeof window.__vietnamProvinces__ !== 'undefined') {
            duLieuHanhChinh = window.__vietnamProvinces__;
        } else {
            // Backup dữ liệu mẫu đề phòng CDN lỗi ngầm
            duLieuHanhChinh = [];
        }

        mTinh.innerHTML = '<option value="" selected disabled>Chọn Tỉnh/Thành phố</option>';
        duLieuHanhChinh.forEach(p => {
            let opt = document.createElement('option');
            opt.value = p.code;
            opt.textContent = p.name;
            mTinh.appendChild(opt);
        });
    }

    // 2. Chọn Tỉnh/Thành phố -> Hiện Quận/Huyện
    mTinh.addEventListener('change', () => {
        const provinceCode = parseInt(mTinh.value);
        mHuyen.innerHTML = '<option value="" selected disabled>Chọn Quận/Huyện</option>';
        mXa.innerHTML = '<option value="" selected disabled>Chọn Phường/Xã</option>';
        mXa.disabled = true;

        const targetProvince = duLieuHanhChinh.find(p => p.code === provinceCode);

        if (targetProvince && targetProvince.districts) {
            targetProvince.districts.forEach(d => {
                let opt = document.createElement('option');
                opt.value = d.code;
                opt.textContent = d.name;
                mHuyen.appendChild(opt);
            });
            mHuyen.disabled = false;
        }
    });

    // 3. Chọn Quận/Huyện -> Hiện Phường/Xã
    mHuyen.addEventListener('change', () => {
        const provinceCode = parseInt(mTinh.value);
        const districtCode = parseInt(mHuyen.value);
        mXa.innerHTML = '<option value="" selected disabled>Chọn Phường/Xã</option>';

        const targetProvince = duLieuHanhChinh.find(p => p.code === provinceCode);
        if (targetProvince && targetProvince.districts) {
            const targetDistrict = targetProvince.districts.find(d => d.code === districtCode);
            if (targetDistrict && targetDistrict.wards) {
                targetDistrict.wards.forEach(w => {
                    let opt = document.createElement('option');
                    opt.value = w.code;
                    opt.textContent = w.name;
                    mXa.appendChild(opt);
                });
                mXa.disabled = false;
            }
        }
    });

    // Chạy kích hoạt load dữ liệu
    loadProvincesData();

    // 4. Lưu địa chỉ tạm thời (Giữ nguyên logic của bạn)
    document.getElementById('btnSaveDiaChi').addEventListener('click', () => {
        const tenNguoiNhan = document.getElementById('mNguoiNhan').value.trim();
        const sdtNguoiNhan = document.getElementById('mSdtNhan').value.trim();
        const diaChiCuThe = document.getElementById('mChiTiet').value.trim();
        const isMacDinh = document.getElementById('mMacDinh').checked;

        const tinhThanh = mTinh.options[mTinh.selectedIndex]?.text || '';
        const quanHuyen = mHuyen.options[mHuyen.selectedIndex]?.text || '';
        const phuongXa = mXa.options[mXa.selectedIndex]?.text || '';

        if (!tenNguoiNhan || !sdtNguoiNhan || !mTinh.value || !mHuyen.value || !mXa.value || !diaChiCuThe) {
            alert("Vui lòng nhập đầy đủ các trường thông tin!");
            return;
        }

        const itemDiaChi = {
            idTemp: Date.now(),
            tenNguoiNhan: tenNguoiNhan,
            sdtNguoiNhan: sdtNguoiNhan,
            tinhThanh: tinhThanh,
            quanHuyen: quanHuyen,
            phuongXa: phuongXa,
            diaChiCuThe: diaChiCuThe,
            loaiDiaChi: "Nhà riêng",
            isMacDinh: isMacDinh
        };

        if (isMacDinh) {
            listDiaChiTam.forEach(item => item.isMacDinh = false);
        } else if (listDiaChiTam.length === 0) {
            itemDiaChi.isMacDinh = true;
        }

        listDiaChiTam.push(itemDiaChi);
        renderDanhSachDiaChi();
        modalInstance.hide();
    });

    // 5. Render danh sách địa chỉ ra UI
    function renderDanhSachDiaChi() {
        const container = document.getElementById('danhSachDiaChiUI');
        const txtTrong = document.getElementById('txtDiaChiTrong');

        if (listDiaChiTam.length === 0) {
            txtTrong.style.display = 'block';
            const cards = container.querySelectorAll('.address-item');
            cards.forEach(c => c.remove());
            document.getElementById('hiddenDiaChiInput').value = "";
            return;
        }

        txtTrong.style.display = 'none';
        const cards = container.querySelectorAll('.address-item');
        cards.forEach(c => c.remove());

        listDiaChiTam.forEach(item => {
            const div = document.createElement('div');
            div.className = `address-item ${item.isMacDinh ? 'is-default' : ''}`;
            div.innerHTML = `
                <div class="d-flex align-items-center">
                    <div class="form-check me-3">
                        <input class="form-check-input" type="radio" name="selectDefault" id="rad_${item.idTemp}" ${item.isMacDinh ? 'checked' : ''} onchange="setMacDinh(${item.idTemp})">
                    </div>
                    <div>
                        <div class="fw-bold text-dark">
                            ${item.tenNguoiNhan} <span class="text-muted fw-normal" style="font-size: 13px;">| ${item.sdtNguoiNhan}</span>
                            ${item.isMacDinh ? '<span class="badge-default ms-2">Mặc định</span>' : ''}
                        </div>
                        <div class="text-muted mt-1" style="font-size: 13px;">
                            ${item.diaChiCuThe}, ${item.phuongXa}, ${item.quanHuyen}, ${item.tinhThanh}
                        </div>
                    </div>
                </div>
                <div>
                    <button type="button" class="btn btn-sm btn-outline-danger border-0" onclick="deleteDiaChi(${item.idTemp})">
                        <i class="bi bi-trash-fill"></i>
                    </button>
                </div>
            `;
            container.appendChild(div);
        });

        document.getElementById('hiddenDiaChiInput').value = JSON.stringify(listDiaChiTam);
    }

    window.setMacDinh = function(idTemp) {
        listDiaChiTam.forEach(item => {
            item.isMacDinh = (item.idTemp === idTemp);
        });
        renderDanhSachDiaChi();
    };

    window.deleteDiaChi = function(idTemp) {
        listDiaChiTam = listDiaChiTam.filter(item => item.idTemp !== idTemp);
        if (listDiaChiTam.length > 0 && !listDiaChiTam.some(item => item.isMacDinh)) {
            listDiaChiTam[0].isMacDinh = true;
        }
        renderDanhSachDiaChi();
    };

    document.getElementById('formAddKhachHang').addEventListener('submit', (e) => {
        if(listDiaChiTam.length === 0) {
            e.preventDefault();
            alert("Vui lòng thêm ít nhất một địa chỉ trước khi lưu!");
        }
    });
</script>
</body>
</html>