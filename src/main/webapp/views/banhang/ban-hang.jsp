<%@ page contentType="text/html;charset=UTF-8" language="java" pageEncoding="UTF-8" %>
<%@ taglib uri="jakarta.tags.core" prefix="c" %>

<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <title>Bán hàng tại quầy</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.css" rel="stylesheet">

    <style>
        * { margin:0; padding:0; box-sizing:border-box; font-family:'Segoe UI',sans-serif; }
        body { background:#f5f7fb; }
        .main-content { margin-left:260px; padding:24px; }
        @media (max-width:900px){ .main-content{ margin-left:78px!important; padding:14px!important; } }

        h2 { font-weight:700; margin-bottom:20px; }

        .card-custom {
            background:#fff; border-radius:16px; padding:20px;
            box-shadow:0 2px 10px rgba(0,0,0,.05); margin-bottom:20px;
        }
        .title-box { display:flex; align-items:center; gap:8px; font-weight:700; margin-bottom:14px; }
        .title-box i { color:#6c5ce7; }

        .pos-layout { display:flex; gap:20px; align-items:flex-start; }
        .pos-left { flex:1 1 58%; min-width:0; }
        .pos-right { flex:1 1 42%; min-width:340px; position:sticky; top:20px; }
        @media (max-width:1100px){ .pos-layout{ flex-direction:column; } .pos-right{ position:static; width:100%; } }

        .product-grid {
            display:grid; grid-template-columns:repeat(auto-fill,minmax(190px,1fr));
            gap:14px; max-height:560px; overflow-y:auto; padding-right:4px;
        }
        .product-card {
            border:1px solid #eef0f5; border-radius:12px; padding:14px; cursor:pointer;
            transition:.15s; background:#fbfbfd;
        }
        .product-card:hover { border-color:#6c5ce7; box-shadow:0 4px 12px rgba(108,92,231,.15); }
        .product-card .ma { font-size:12px; color:#8a8fa3; }
        .product-card .ten { font-weight:600; margin:4px 0 6px; min-height:38px; }
        .product-card .info { font-size:13px; color:#555; display:flex; justify-content:space-between; }
        .product-card .gia { font-weight:700; color:#e14b4b; margin-top:6px; }
        .product-card .ton { font-size:12px; color:#2ecc71; }
        .product-card.disabled { opacity:.5; cursor:not-allowed; }

        .cart-table { width:100%; font-size:14px; }
        .cart-table th { font-size:12px; color:#8a8fa3; text-transform:uppercase; padding-bottom:8px; }
        .cart-table td { padding:8px 4px; border-top:1px solid #f0f1f6; vertical-align:middle; }
        .cart-qty-btn { width:26px; height:26px; border:1px solid #ddd; background:#fff; border-radius:6px; }
        .cart-empty { text-align:center; color:#aaa; padding:30px 0; }

        .summary-row { display:flex; justify-content:space-between; padding:4px 0; font-size:14px; }
        .summary-row.total { font-size:18px; font-weight:700; border-top:1px dashed #ddd; margin-top:8px; padding-top:10px; }
        .summary-row.total span:last-child { color:#e14b4b; }

        #khStatus { font-size:13px; margin-top:4px; }
        .btn-thanh-toan { padding:12px; font-size:16px; font-weight:700; border-radius:10px; }

        .orders-bar { display:flex; flex-wrap:wrap; gap:8px; align-items:center; }
        .orders-bar .btn { border-radius:20px; }
        .held-badge-close { margin-left:6px; }
    </style>
</head>
<body>

<jsp:include page="/views/layout/sidebar.jsp"/>

<div class="main-content">
    <h2><i class="bi bi-cart-check"></i> Bán hàng tại quầy</h2>

    <div id="alertBox"></div>

    <div class="card-custom">
        <div class="title-box"><i class="bi bi-hourglass-split"></i><span>Hóa đơn chờ</span></div>
        <div class="orders-bar" id="heldOrdersList"></div>
        <small class="text-muted d-block mt-2">
            Dùng khi khách muốn đi lấy thêm sản phẩm hoặc bạn cần phục vụ khách khác:
            bấm "Giữ đơn" để tạm giữ giỏ hàng hiện tại, sau đó bấm lại vào đơn chờ để tiếp tục.
            <br>
            <i class="bi bi-exclamation-circle"></i>
            Lưu ý: đơn chờ nếu để qua ngày hôm sau mà vẫn chưa hoàn tất thanh toán sẽ tự động chuyển sang "Đã hủy".
        </small>
    </div>

    <div class="pos-layout">
        <!-- CỘT TRÁI: TÌM & CHỌN SẢN PHẨM -->
        <div class="pos-left">
            <div class="card-custom">
                <div class="title-box"><i class="bi bi-search"></i><span>Tìm sản phẩm</span></div>
                <div class="input-group">
                    <input type="text" id="searchInput" class="form-control"
                           placeholder="Nhập mã hoặc tên sản phẩm...">
                    <button class="btn btn-primary" type="button" id="btnSearch">
                        <i class="bi bi-search"></i>
                    </button>
                </div>
                <div class="product-grid mt-3" id="productGrid">
                    <div class="cart-empty" style="grid-column:1/-1;">Đang tải sản phẩm...</div>
                </div>
            </div>
        </div>

        <!-- CỘT PHẢI: GIỎ HÀNG + THANH TOÁN -->
        <div class="pos-right">
            <div class="card-custom">
                <div class="title-box"><i class="bi bi-person"></i><span>Thông tin khách hàng</span></div>

                <label class="form-label">Số điện thoại <span class="text-danger">*</span></label>
                <input type="text" id="sdtInput" class="form-control" placeholder="Bắt buộc nhập số điện thoại">
                <div id="khStatus"></div>

                <div class="mt-2" id="tenKhWrap">
                    <label class="form-label">Tên khách hàng</label>
                    <input type="text" id="tenKhInput" class="form-control" placeholder="Khách lẻ">

                    <label class="form-label mt-2">Email <span class="text-danger">*</span></label>
                    <input type="email" id="emailKhInput" class="form-control" placeholder="Bắt buộc nhập email">

                    <label class="form-label mt-2">Địa chỉ <span class="text-danger">*</span></label>
                    <input type="text" id="diaChiKhInput" class="form-control" placeholder="Bắt buộc nhập địa chỉ">
                </div>

                <div class="mt-3">
                    <label class="form-label">Nhân viên phụ trách</label>
                    <input type="text" class="form-control" disabled
                           value="${sessionScope.user.nhanVien.hoTen}">
                </div>

                <div class="mt-3">
                    <label class="form-label">Phiếu giảm giá</label>
                    <select id="voucherSelect" class="form-select">
                        <option value="">-- Không dùng voucher --</option>
                    </select>
                </div>

                <div class="mt-3">
                    <label class="form-label">Ghi chú</label>
                    <textarea id="ghiChuInput" class="form-control" rows="2"></textarea>
                </div>
            </div>

            <div class="card-custom">
                <div class="title-box"><i class="bi bi-cart3"></i><span>Giỏ hàng</span></div>
                <table class="cart-table">
                    <thead>
                    <tr>
                        <th>Sản phẩm</th>
                        <th>SL</th>
                        <th>Thành tiền</th>
                        <th></th>
                    </tr>
                    </thead>
                    <tbody id="cartBody">
                    <tr><td colspan="4" class="cart-empty">Chưa có sản phẩm nào</td></tr>
                    </tbody>
                </table>

                <div class="mt-3">
                    <div class="summary-row"><span>Tiền hàng</span><span id="sumTienHang">0 đ</span></div>
                    <div class="summary-row"><span>Giảm giá</span><span id="sumGiam">0 đ</span></div>
                    <div class="summary-row total"><span>Khách trả</span><span id="sumTong">0 đ</span></div>
                </div>

                <div class="mt-3">
                    <label class="form-label d-block">Phương thức thanh toán</label>
                    <div class="btn-group w-100" role="group" aria-label="Phương thức thanh toán">
                        <input type="radio" class="btn-check" name="phuongThucThanhToan" id="pttTienMat" value="TIENMAT" checked>
                        <label class="btn btn-outline-primary" for="pttTienMat"><i class="bi bi-cash"></i> Tiền mặt</label>

                        <input type="radio" class="btn-check" name="phuongThucThanhToan" id="pttChuyenKhoan" value="CHUYENKHOAN">
                        <label class="btn btn-outline-primary" for="pttChuyenKhoan"><i class="bi bi-qr-code"></i> Chuyển khoản (QR)</label>
                    </div>

                    <div id="tienMatWrap" class="mt-3">
                        <label class="form-label">Tiền khách đưa</label>
                        <input type="number" min="0" step="1000" id="tienKhachDuaInput" class="form-control" placeholder="Nhập số tiền khách đưa">
                        <div class="summary-row total mt-2">
                            <span>Tiền thừa trả khách</span>
                            <span id="sumTienThua">0 đ</span>
                        </div>
                    </div>

                    <div id="qrWrap" class="text-center mt-3" style="display:none;">
                        <img id="qrImg" src="" alt="Mã QR thanh toán" style="width:220px;height:220px;border:1px solid #eef0f5;border-radius:12px;padding:6px;background:#fff;">
                        <div class="small text-muted mt-2">Khách quét mã để chuyển khoản đúng số tiền, sau đó bấm Thanh toán để hoàn tất đơn.</div>
                    </div>
                </div>

                <div class="d-flex gap-2 mt-3">
                    <button type="button" class="btn btn-outline-secondary btn-thanh-toan flex-shrink-0" id="btnGiuDon">
                        <i class="bi bi-hourglass-split"></i> Giữ đơn
                    </button>
                    <button type="button" class="btn btn-success w-100 btn-thanh-toan" id="btnThanhToan">
                        <i class="bi bi-cash-coin"></i> Thanh toán
                    </button>
                </div>
            </div>
        </div>
    </div>
</div>

<script>
    const ctx = "${pageContext.request.contextPath}";
    let cart = [];       // {id, ma, tenSanPham, mauSac, kichThuoc, giaBan, soLuongTon, soLuong}
    let vouchers = [];
    let productCache = {};

    // ============== CẤU HÌNH QR CHUYỂN KHOẢN (VietQR) ==============
    // TODO: đổi lại đúng thông tin tài khoản ngân hàng của cửa hàng trước khi dùng thật.
    const BANK_CONFIG = {
        bin: '970422',            // Mã ngân hàng (BIN) - vd 970422 = MB Bank
        accountNo: '0000000000',  // Số tài khoản nhận tiền của cửa hàng
        accountName: 'SCOTT FASHION' // Tên chủ tài khoản (không dấu)
    };

    function xayDungQrUrl(soTien, noiDung) {
        const bin = encodeURIComponent(BANK_CONFIG.bin);
        const stk = encodeURIComponent(BANK_CONFIG.accountNo);
        return 'https://img.vietqr.io/image/' + bin + '-' + stk + '-compact2.png' +
            '?amount=' + Math.round(soTien || 0) +
            '&addInfo=' + encodeURIComponent(noiDung || 'Thanh toan don hang') +
            '&accountName=' + encodeURIComponent(BANK_CONFIG.accountName);
    }

    function tinhTongThanhToan() {
        const tienHang = tinhTienHang();
        return tienHang - tinhTienGiam(tienHang);
    }

    function capNhatQr() {
        const isChuyenKhoan = document.getElementById('pttChuyenKhoan').checked;
        const qrWrap = document.getElementById('qrWrap');
        const tienMatWrap = document.getElementById('tienMatWrap');
        tienMatWrap.style.display = isChuyenKhoan ? 'none' : 'block';
        if (!isChuyenKhoan) {
            qrWrap.style.display = 'none';
            capNhatTienThua();
            return;
        }
        const tongTien = tinhTongThanhToan();
        const sdt = document.getElementById('sdtInput').value.trim();
        const noiDung = 'TT ' + (sdt || 'khach le');
        document.getElementById('qrImg').src = xayDungQrUrl(tongTien, noiDung);
        qrWrap.style.display = 'block';
    }
    document.getElementById('pttTienMat').addEventListener('change', capNhatQr);
    document.getElementById('pttChuyenKhoan').addEventListener('change', capNhatQr);

    function capNhatTienThua() {
        const tongTien = tinhTongThanhToan();
        const tienDua = parseFloat(document.getElementById('tienKhachDuaInput').value) || 0;
        const tienThua = tienDua - tongTien;
        const el = document.getElementById('sumTienThua');
        el.textContent = formatTien(Math.max(tienThua, 0));
        el.parentElement.querySelector('span:last-child').style.color = tienThua < 0 ? '#e14b4b' : '#2ecc71';
    }
    document.getElementById('tienKhachDuaInput').addEventListener('input', capNhatTienThua);

    function formatTien(n) {
        return Math.round(n || 0).toLocaleString('vi-VN') + ' đ';
    }

    function showAlert(type, msg) {
        document.getElementById('alertBox').innerHTML =
            '<div class="alert alert-' + type + ' alert-dismissible fade show" role="alert">' + msg +
            '<button type="button" class="btn-close" data-bs-dismiss="alert"></button></div>';
    }

    // ============== TÌM SẢN PHẨM ==============
    function timSanPham() {
        const keyword = document.getElementById('searchInput').value.trim();
        fetch(ctx + '/ban-hang-tai-quay?action=timSanPham&keyword=' + encodeURIComponent(keyword))
            .then(r => r.json())
            .then(data => renderProductGrid(data.items || []))
            .catch(() => {
                document.getElementById('productGrid').innerHTML =
                    '<div class="cart-empty" style="grid-column:1/-1;">Không tải được danh sách sản phẩm</div>';
            });
    }

    function renderProductGrid(items) {
        items.forEach(p => productCache[p.id] = p);
        const grid = document.getElementById('productGrid');
        if (!items.length) {
            grid.innerHTML = '<div class="cart-empty" style="grid-column:1/-1;">Không tìm thấy sản phẩm còn hàng</div>';
            return;
        }
        grid.innerHTML = items.map(p => {
            const soLuongDaChon = cart.filter(c => c.id === p.id).reduce((s, c) => s + c.soLuong, 0);
            const conLai = p.soLuongTon - soLuongDaChon;
            const disabled = conLai <= 0;
            return '<div class="product-card' + (disabled ? ' disabled' : '') + '" ' +
                (disabled ? '' : 'onclick="themVaoGio(' + p.id + ')"') + '>' +
                '<div class="ma">' + (p.ma || '') + '</div>' +
                '<div class="ten">' + (p.tenSanPham || '') + '</div>' +
                '<div class="info"><span>' + (p.mauSac || '') + '</span><span>' + (p.kichThuoc || '') + '</span></div>' +
                '<div class="gia">' + formatTien(p.giaBan) + '</div>' +
                '<div class="ton">Còn lại: ' + conLai + '</div>' +
                '</div>';
        }).join('');
    }

    window.themVaoGio = function (id) {
        const p = productCache[id];
        if (!p) return;
        const daCo = cart.find(c => c.id === id);
        const soLuongDaChon = cart.filter(c => c.id === id).reduce((s, c) => s + c.soLuong, 0);
        if (soLuongDaChon >= p.soLuongTon) {
            showAlert('warning', 'Sản phẩm "' + p.tenSanPham + '" chỉ còn ' + p.soLuongTon + ' trong kho.');
            return;
        }
        if (daCo) {
            daCo.soLuong += 1;
        } else {
            cart.push({
                id: p.id, ma: p.ma, tenSanPham: p.tenSanPham, mauSac: p.mauSac,
                kichThuoc: p.kichThuoc, giaBan: p.giaBan, soLuongTon: p.soLuongTon, soLuong: 1
            });
        }
        renderCart();
        renderProductGrid(Object.values(productCache));
    };

    window.doiSoLuong = function (index, delta) {
        const item = cart[index];
        if (!item) return;
        const moi = item.soLuong + delta;
        if (moi <= 0) {
            cart.splice(index, 1);
        } else if (moi > item.soLuongTon) {
            showAlert('warning', 'Sản phẩm "' + item.tenSanPham + '" chỉ còn ' + item.soLuongTon + ' trong kho.');
            return;
        } else {
            item.soLuong = moi;
        }
        renderCart();
        renderProductGrid(Object.values(productCache));
    };

    window.xoaKhoiGio = function (index) {
        cart.splice(index, 1);
        renderCart();
        renderProductGrid(Object.values(productCache));
    };

    function tinhTienHang() {
        return cart.reduce((s, c) => s + c.giaBan * c.soLuong, 0);
    }

    function tinhTienGiam(tongTienHang) {
        const id = document.getElementById('voucherSelect').value;
        if (!id) return 0;
        const v = vouchers.find(v => String(v.id) === String(id));
        if (!v) return 0;
        if (tongTienHang < (v.donToiThieu || 0)) return 0;
        let giam;
        if (v.loaiGiamGia === '%') {
            giam = tongTienHang * (v.giaTriGiamGia || 0) / 100;
            if (v.giamToiDa) giam = Math.min(giam, v.giamToiDa);
        } else {
            giam = v.giaTriGiamGia || 0;
        }
        return Math.min(giam, tongTienHang);
    }

    function renderCart() {
        const body = document.getElementById('cartBody');
        if (!cart.length) {
            body.innerHTML = '<tr><td colspan="4" class="cart-empty">Chưa có sản phẩm nào</td></tr>';
        } else {
            body.innerHTML = cart.map((c, i) => {
                return '<tr>' +
                    '<td><strong>' + c.tenSanPham + '</strong><br><small class="text-muted">' +
                    (c.mauSac || '') + (c.kichThuoc ? (' / ' + c.kichThuoc) : '') + '</small></td>' +
                    '<td><div class="d-flex align-items-center gap-1">' +
                    '<button type="button" class="cart-qty-btn" onclick="doiSoLuong(' + i + ',-1)">-</button>' +
                    '<span class="mx-1">' + c.soLuong + '</span>' +
                    '<button type="button" class="cart-qty-btn" onclick="doiSoLuong(' + i + ',1)">+</button>' +
                    '</div></td>' +
                    '<td>' + formatTien(c.giaBan * c.soLuong) + '</td>' +
                    '<td><button type="button" class="btn btn-sm btn-outline-danger" onclick="xoaKhoiGio(' + i + ')">' +
                    '<i class="bi bi-trash"></i></button></td>' +
                    '</tr>';
            }).join('');
        }
        renderVoucherOptions();
        const tienHang = tinhTienHang();
        const tienGiam = tinhTienGiam(tienHang);
        document.getElementById('sumTienHang').textContent = formatTien(tienHang);
        document.getElementById('sumGiam').textContent = '- ' + formatTien(tienGiam);
        document.getElementById('sumTong').textContent = formatTien(tienHang - tienGiam);
        capNhatQr();
    }

    // ============== KHÁCH HÀNG ==============
    let sdtTimer = null;
    document.getElementById('sdtInput').addEventListener('input', function () {
        clearTimeout(sdtTimer);
        const sdt = this.value.trim();
        capNhatQr();
        if (!/^\d{9,11}$/.test(sdt)) {
            document.getElementById('khStatus').innerHTML = sdt ? '<span class="text-danger">Số điện thoại chưa hợp lệ (9-11 số)</span>' : '';
            return;
        }
        sdtTimer = setTimeout(() => {
            fetch(ctx + '/ban-hang-tai-quay?action=timKhachHang&sdt=' + encodeURIComponent(sdt))
                .then(r => r.json())
                .then(data => {
                    if (data.found) {
                        document.getElementById('khStatus').innerHTML =
                            '<span class="text-success"><i class="bi bi-check-circle"></i> Khách quen: ' +
                            data.khachHang.hoTen + ' (' + data.khachHang.ma + ')</span>';
                        // Điền sẵn thông tin đã có, nhân viên vẫn có thể sửa/bổ sung
                        if (data.khachHang.hoTen) document.getElementById('tenKhInput').value = data.khachHang.hoTen;
                        if (data.khachHang.email) document.getElementById('emailKhInput').value = data.khachHang.email;
                        if (data.khachHang.diaChi) document.getElementById('diaChiKhInput').value = data.khachHang.diaChi;
                    } else {
                        document.getElementById('khStatus').innerHTML =
                            '<span class="text-primary"><i class="bi bi-person-plus"></i> Khách mới, sẽ tạo hồ sơ khi thanh toán</span>';
                    }
                });
        }, 400);
    });

    // ============== VOUCHER ==============
    function taiVoucher() {
        fetch(ctx + '/ban-hang-tai-quay?action=danhSachVoucher')
            .then(r => r.json())
            .then(data => {
                vouchers = data.items || [];
                renderVoucherOptions();
            });
    }

    // Liệt kê TẤT CẢ voucher còn hiệu lực; voucher nào đơn hàng hiện tại CHƯA đủ điều kiện
    // (chưa đạt giá trị tối thiểu) sẽ hiển thị mờ, không chọn được, kèm số tiền còn thiếu -
    // để nhân viên biết rõ lý do thay vì voucher "biến mất" không rõ nguyên nhân.
    // Tự động cập nhật lại mỗi khi giỏ hàng thay đổi.
    function renderVoucherOptions() {
        const select = document.getElementById('voucherSelect');
        const dangChon = select.value;
        const tienHang = tinhTienHang();

        const dsDuDieuKien = [];
        const options = ['<option value="">-- Không dùng voucher --</option>'];
        vouchers.forEach(v => {
            const donToiThieu = Number(v.donToiThieu) || 0;
            const duDieuKien = tienHang >= donToiThieu;
            const mo = v.loaiGiamGia === '%'
                ? (v.giaTriGiamGia + '%')
                : formatTien(v.giaTriGiamGia);
            let nhan = v.maVoucher + ' - ' + v.tenVoucher + ' (' + mo + ')';
            if (duDieuKien) {
                dsDuDieuKien.push(v);
            } else {
                nhan += ' — cần thêm đơn tối thiểu ' + formatTien(donToiThieu);
            }
            options.push('<option value="' + v.id + '"' + (duDieuKien ? '' : ' disabled') + '>' + nhan + '</option>');
        });
        select.innerHTML = options.join('');

        if (dangChon && dsDuDieuKien.some(v => String(v.id) === String(dangChon))) {
            select.value = dangChon;
        } else if (dangChon) {
            showAlert('warning', 'Giỏ hàng không còn đủ điều kiện áp dụng voucher đã chọn nên đã được bỏ chọn.');
        }

        let hint = document.getElementById('voucherHint');
        if (!hint) {
            hint = document.createElement('div');
            hint.id = 'voucherHint';
            hint.className = 'small text-muted mt-1';
            select.insertAdjacentElement('afterend', hint);
        }
        if (!vouchers.length) {
            hint.textContent = 'Hiện chưa có phiếu giảm giá nào còn hiệu lực trong hệ thống.';
        } else if (!dsDuDieuKien.length) {
            hint.textContent = 'Giỏ hàng hiện tại chưa đủ điều kiện áp dụng voucher nào (xem số tiền còn thiếu trong danh sách phía trên).';
        } else {
            hint.textContent = '';
        }
    }
    document.getElementById('voucherSelect').addEventListener('change', renderCart);

    // ============== THANH TOÁN ==============
    document.getElementById('btnThanhToan').addEventListener('click', function () {
        const sdt = document.getElementById('sdtInput').value.trim();
        if (!/^\d{9,11}$/.test(sdt)) {
            showAlert('danger', 'Vui lòng nhập số điện thoại khách hàng hợp lệ (9-11 số) trước khi thanh toán.');
            return;
        }
        if (!cart.length) {
            showAlert('danger', 'Giỏ hàng đang trống, vui lòng chọn sản phẩm.');
            return;
        }

        const email = document.getElementById('emailKhInput').value.trim();
        if (!email) {
            showAlert('danger', 'Vui lòng nhập email khách hàng, đây là thông tin bắt buộc.');
            return;
        }
        if (!/^[^\s@]+@[^\s@]+\.[^\s@]+$/.test(email)) {
            showAlert('danger', 'Email khách hàng không hợp lệ.');
            return;
        }

        const diaChi = document.getElementById('diaChiKhInput').value.trim();
        if (!diaChi) {
            showAlert('danger', 'Vui lòng nhập địa chỉ khách hàng, đây là thông tin bắt buộc.');
            return;
        }

        const phuongThucThanhToan = document.querySelector('input[name="phuongThucThanhToan"]:checked').value;

        let tienKhachDua = null;
        if (phuongThucThanhToan === 'TIENMAT') {
            const tongTien = tinhTongThanhToan();
            tienKhachDua = parseFloat(document.getElementById('tienKhachDuaInput').value) || 0;
            if (tienKhachDua < tongTien) {
                showAlert('danger', 'Số tiền khách đưa (' + formatTien(tienKhachDua) + ') nhỏ hơn tổng tiền cần thanh toán (' + formatTien(tongTien) + ').');
                return;
            }
        }

        const payload = {
            sdtKhachHang: sdt,
            tenKhachHang: document.getElementById('tenKhInput').value.trim(),
            emailKhachHang: email,
            diaChiKhachHang: diaChi,
            idPhieuGiamGia: document.getElementById('voucherSelect').value || null,
            ghiChu: document.getElementById('ghiChuInput').value.trim(),
            gioHang: cart.map(c => ({ idSanPhamChiTiet: c.id, soLuong: c.soLuong })),
            idHoaDonCho: currentHeldId || null,
            phuongThucThanhToan: phuongThucThanhToan,
            tienKhachDua: tienKhachDua
        };

        const btn = this;
        btn.disabled = true;
        btn.innerHTML = '<span class="spinner-border spinner-border-sm"></span> Đang xử lý...';

        fetch(ctx + '/ban-hang-tai-quay?action=thanhToan', {
            method: 'POST',
            headers: { 'Content-Type': 'application/json' },
            body: JSON.stringify(payload)
        })
            .then(r => r.json())
            .then(data => {
                if (data.success) {
                    let msg = 'Thanh toán thành công! Mã hóa đơn <strong>' + data.maHoaDon +
                        '</strong> - Tổng tiền: ' + formatTien(data.tongTienThanhToan);
                    if (phuongThucThanhToan === 'TIENMAT' && tienKhachDua !== null) {
                        msg += ' - Khách đưa: ' + formatTien(tienKhachDua) +
                            ' - Trả lại: ' + formatTien(tienKhachDua - data.tongTienThanhToan);
                    }
                    msg += ' &nbsp; <a href="' + ctx + '/quanlyhoadon?action=detail&id=' + data.idHoaDon +
                        '" class="alert-link">Xem hóa đơn</a>';
                    showAlert('success', msg);
                    resetWorkingOrder();
                    taiVoucher();
                } else {
                    showAlert('danger', data.message || 'Thanh toán thất bại.');
                }
            })
            .catch(() => showAlert('danger', 'Lỗi kết nối tới máy chủ, vui lòng thử lại.'))
            .finally(() => {
                btn.disabled = false;
                btn.innerHTML = '<i class="bi bi-cash-coin"></i> Thanh toán';
            });
    });

    document.getElementById('btnSearch').addEventListener('click', timSanPham);
    document.getElementById('searchInput').addEventListener('keyup', function (e) {
        if (e.key === 'Enter') timSanPham();
    });

    // ============== HÓA ĐƠN CHỜ (liên kết bảng hoa_don thật, trạng thái "Chờ xử lý") ==============
    let heldOrders = [];        // danh sách lấy từ server: {id, maHoaDon, tenKhachHang, sdtKhachHang, tongTienThanhToan, soLuongSanPham}
    let currentHeldId = null;   // id hóa đơn chờ đang mở để làm việc, null nếu là đơn mới chưa lưu

    function resetWorkingOrder() {
        cart = [];
        document.getElementById('sdtInput').value = '';
        document.getElementById('tenKhInput').value = '';
        document.getElementById('emailKhInput').value = '';
        document.getElementById('diaChiKhInput').value = '';
        document.getElementById('ghiChuInput').value = '';
        document.getElementById('khStatus').innerHTML = '';
        document.getElementById('voucherSelect').value = '';
        document.getElementById('pttTienMat').checked = true;
        document.getElementById('tienKhachDuaInput').value = '';
        document.getElementById('qrWrap').style.display = 'none';
        currentHeldId = null;
        renderCart();
        timSanPham();
        taiHoaDonCho();
    }

    function taiHoaDonCho() {
        fetch(ctx + '/ban-hang-tai-quay?action=hoaDonCho')
            .then(r => r.json())
            .then(data => {
                heldOrders = (data && data.success && data.items) ? data.items : [];
                renderHeldOrdersBar();
            })
            .catch(() => { heldOrders = []; renderHeldOrdersBar(); });
    }

    // Lưu đơn đang làm dở thành 1 hóa đơn "Chờ xử lý" thật trong CSDL
    function holdCurrentOrder(silent) {
        if (!cart.length) {
            if (!silent) showAlert('warning', 'Giỏ hàng đang trống, không có gì để giữ.');
            return;
        }
        const payload = {
            sdtKhachHang: document.getElementById('sdtInput').value.trim(),
            tenKhachHang: document.getElementById('tenKhInput').value.trim(),
            emailKhachHang: document.getElementById('emailKhInput').value.trim(),
            diaChiKhachHang: document.getElementById('diaChiKhInput').value.trim(),
            idPhieuGiamGia: document.getElementById('voucherSelect').value || null,
            ghiChu: document.getElementById('ghiChuInput').value.trim(),
            gioHang: cart.map(c => ({ idSanPhamChiTiet: c.id, soLuong: c.soLuong })),
            idHoaDonCho: currentHeldId || null
        };
        return fetch(ctx + '/ban-hang-tai-quay?action=giuDon', {
            method: 'POST',
            headers: { 'Content-Type': 'application/json' },
            body: JSON.stringify(payload)
        })
            .then(r => r.json())
            .then(data => {
                if (data && data.success) {
                    if (!silent) {
                        showAlert('success', 'Đã giữ đơn hàng (Mã: ' + data.maHoaDon + '). Bạn có thể tiếp tục bán cho khách khác, sau đó chọn lại đơn chờ này để tiếp tục.');
                        resetWorkingOrder();
                    } else {
                        currentHeldId = data.idHoaDonCho;
                        taiHoaDonCho();
                    }
                } else if (!silent) {
                    showAlert('danger', (data && data.message) || 'Không thể giữ đơn.');
                }
                return data;
            })
            .catch(() => {
                if (!silent) showAlert('danger', 'Lỗi kết nối tới máy chủ, vui lòng thử lại.');
            });
    }

    window.switchToHeldOrder = function (id) {
        if (id === currentHeldId) return;
        const proceed = function () {
            fetch(ctx + '/ban-hang-tai-quay?action=chiTietHoaDonCho&id=' + id)
                .then(r => r.json())
                .then(data => {
                    if (!data || !data.success) {
                        showAlert('danger', (data && data.message) || 'Không tải được hóa đơn chờ.');
                        return;
                    }
                    const hd = data.hoaDon;
                    cart = (hd.gioHang || []).map(function (it) {
                        productCache[it.id] = it;
                        return {
                            id: it.id, ma: it.ma, tenSanPham: it.tenSanPham,
                            mauSac: it.mauSac, kichThuoc: it.kichThuoc,
                            giaBan: it.giaBan, soLuongTon: it.soLuongTon, soLuong: it.soLuong
                        };
                    });
                    document.getElementById('sdtInput').value = hd.sdtKhachHang || '';
                    document.getElementById('tenKhInput').value = hd.tenKhachHang || '';
                    document.getElementById('emailKhInput').value = hd.emailKhachHang || '';
                    document.getElementById('diaChiKhInput').value = hd.diaChiKhachHang || '';
                    document.getElementById('ghiChuInput').value = hd.ghiChu || '';
                    document.getElementById('khStatus').innerHTML = '';
                    currentHeldId = hd.id;

                    renderCart();
                    timSanPham();
                    taiVoucher();
                    const voucherId = hd.idPhieuGiamGia || '';
                    if (voucherId) {
                        setTimeout(function () {
                            document.getElementById('voucherSelect').value = voucherId;
                            renderCart();
                        }, 300);
                    }
                    taiHoaDonCho();
                })
                .catch(() => showAlert('danger', 'Lỗi kết nối tới máy chủ, vui lòng thử lại.'));
        };

        if (cart.length && !currentHeldId) {
            if (confirm('Đơn đang làm dở chưa được giữ, chuyển sang đơn chờ khác sẽ mất giỏ hàng hiện tại. Tiếp tục?')) proceed();
        } else if (cart.length) {
            holdCurrentOrder(true).then(proceed);
        } else {
            proceed();
        }
    };

    window.deleteHeldOrder = function (id, ev) {
        if (ev) ev.stopPropagation();
        if (!confirm('Hủy đơn chờ này? Đơn sẽ được đánh dấu Đã hủy.')) return;
        fetch(ctx + '/ban-hang-tai-quay?action=huyHoaDonCho&id=' + id, { method: 'POST' })
            .then(r => r.json())
            .then(data => {
                if (data && data.success) {
                    if (currentHeldId === id) resetWorkingOrder();
                    taiHoaDonCho();
                } else {
                    showAlert('danger', (data && data.message) || 'Không thể hủy đơn chờ này.');
                }
            })
            .catch(() => showAlert('danger', 'Lỗi kết nối tới máy chủ, vui lòng thử lại.'));
    };

    window.newOrderTab = function () {
        if (cart.length && !currentHeldId) {
            if (!confirm('Đơn đang làm dở chưa được giữ, tạo đơn mới sẽ mất giỏ hàng hiện tại. Tiếp tục?')) return;
        }
        resetWorkingOrder();
    };

    function renderHeldOrdersBar() {
        const wrap = document.getElementById('heldOrdersList');
        let html = '<button type="button" class="btn btn-sm ' + (!currentHeldId ? 'btn-primary' : 'btn-outline-primary') +
            '" onclick="newOrderTab()"><i class="bi bi-plus-lg"></i> Đơn mới</button>';
        if (!heldOrders.length) {
            html += '<span class="text-muted small ms-1">Chưa có hóa đơn nào đang chờ xử lý</span>';
        }
        heldOrders.forEach(function (o) {
            const nhan = (o.tenKhachHang || o.sdtKhachHang || 'Khách lẻ') + ' • ' + (o.soLuongSanPham || 0) + ' SP • ' + formatTien(o.tongTienThanhToan);
            const active = (o.id === currentHeldId) ? 'btn-primary' : 'btn-outline-secondary';
            html += '<button type="button" class="btn btn-sm ' + active + '" onclick="switchToHeldOrder(' + o.id + ')">' +
                '<i class="bi bi-hourglass-split"></i> ' + nhan +
                '<span class="held-badge-close" style="color:#e14b4b;" onclick="deleteHeldOrder(' + o.id + ', event)">' +
                '<i class="bi bi-x-circle-fill"></i></span></button>';
        });
        wrap.innerHTML = html;
    }

    document.getElementById('btnGiuDon').addEventListener('click', function () {
        holdCurrentOrder(false);
    });

    // Khởi tạo
    timSanPham();
    taiVoucher();
    renderCart();
    taiHoaDonCho();
</script>

<script src="${pageContext.request.contextPath}/assets/js/main.js?v=mono3" defer></script>
</body>
</html>