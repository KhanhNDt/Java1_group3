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
        body { background:#f5f5f5; }
        .main-content { margin-left:260px; padding:24px; }
        @media (max-width:900px){ .main-content{ margin-left:78px!important; padding:14px!important; } }

        h2 { font-weight:700; margin-bottom:20px; color:#111; }

        .card-custom {
            background:#fff; border:1px solid #ececec; border-radius:16px; padding:20px;
            box-shadow:0 2px 10px rgba(0,0,0,.04); margin-bottom:20px;
        }
        .title-box { display:flex; align-items:center; gap:8px; font-weight:700; margin-bottom:14px; color:#111; }
        .title-box i { color:#111; }
        .card-head-row { display:flex; align-items:center; justify-content:space-between; margin-bottom:14px; }
        .card-head-row .title-box { margin-bottom:0; }

        /* ===== Buttons dùng chung (đen trắng) ===== */
        .btn-black {
            background:#111; color:#fff; border:1px solid #111; border-radius:10px;
            font-weight:600; padding:9px 16px; transition:.15s;
        }
        .btn-black:hover { background:#000; color:#fff; }
        .btn-black:disabled { background:#ccc; border-color:#ccc; color:#888; cursor:not-allowed; }
        .btn-outline-black {
            background:#fff; color:#111; border:1px solid #d0d0d0; border-radius:10px;
            font-weight:600; padding:9px 16px; transition:.15s;
        }
        .btn-outline-black:hover { border-color:#111; }

        /* ===== Giỏ hàng ===== */
        .cart-table { width:100%; font-size:14px; }
        .cart-table th { font-size:12px; color:#8a8a8a; text-transform:uppercase; padding-bottom:8px; text-align:left; }
        .cart-table td { padding:10px 4px; border-top:1px solid #f0f0f0; vertical-align:middle; }
        .cart-qty-btn { width:26px; height:26px; border:1px solid #ddd; background:#fff; border-radius:6px; }
        .cart-empty { text-align:center; color:#9a9a9a; padding:36px 0; }
        .cart-empty i { font-size:34px; color:#c8c8c8; display:block; margin-bottom:8px; }

        /* ===== Đơn hàng chờ (tabs) ===== */
        .order-tabs-bar { display:flex; align-items:center; gap:8px; flex-wrap:wrap; }
        .order-tab {
            position:relative; display:flex; align-items:center; gap:8px;
            padding:8px 12px 8px 14px; border-radius:10px; border:1px solid #e2e2e2;
            background:#fbfbfb; cursor:pointer; font-size:14px; font-weight:600; color:#444;
            transition:.15s; user-select:none;
        }
        .order-tab:hover { border-color:#111; }
        .order-tab.active { background:#111; color:#fff; border-color:#111; }
        .order-tab .badge {
            background:#e14b4b; color:#fff; border-radius:999px; font-size:11px;
            padding:1px 7px; font-weight:700;
        }
        .order-tab.active .badge { background:#fff; color:#e14b4b; }
        .order-tab-close { font-size:11px; opacity:.55; padding:3px; border-radius:5px; line-height:1; }
        .order-tab-close:hover { opacity:1; background:rgba(0,0,0,.08); }
        .order-tab.active .order-tab-close:hover { background:rgba(255,255,255,.25); }
        .btn-them-don {
            width:38px; height:38px; flex:none; border-radius:10px; border:1.5px dashed #111;
            background:#fff; color:#111; font-size:18px; display:flex; align-items:center;
            justify-content:center; cursor:pointer; transition:.15s;
        }
        .btn-them-don:hover:not(:disabled) { background:#111; color:#fff; }
        .btn-them-don:disabled { border-color:#ccc; color:#bbb; cursor:not-allowed; background:#f2f2f4; }

        /* ===== Thông tin khách hàng / Thanh toán ===== */
        .info-payment-grid { display:grid; grid-template-columns:1fr 1fr; gap:20px; align-items:start; }
        @media (max-width:1100px){ .info-payment-grid{ grid-template-columns:1fr; } }

        .form-label { font-weight:600; font-size:13.5px; color:#222; margin-bottom:6px; display:block; }
        .form-control, .form-select {
            border:1px solid #dcdcdc; border-radius:10px; padding:10px 12px; font-size:14px;
        }
        .form-control:focus, .form-select:focus { border-color:#111; box-shadow:0 0 0 3px rgba(17,17,17,.08); }
        .form-control:disabled { background:#f3f3f3; color:#555; }
        #khStatus { font-size:13px; margin:6px 0 0; min-height:0; }
        #voucherHint { font-size:12.5px; color:#9a9a9a; margin-top:6px; }

        .summary-row { display:flex; justify-content:space-between; padding:5px 0; font-size:14px; color:#333; }
        .summary-row.total {
            font-size:19px; font-weight:800; border-top:1px dashed #ddd; margin-top:10px; padding-top:12px;
            color:#111;
        }
        .summary-row.total span:last-child { color:#e14b4b; }
        .change-row {
            display:flex; justify-content:space-between; align-items:center; margin-top:10px;
            font-size:16px; font-weight:800; color:#111;
        }
        .change-row span:last-child { color:#1a9e5c; }

        /* ===== Phương thức thanh toán ===== */
        .pay-method-toggle { display:flex; gap:10px; margin-top:6px; }
        .pay-method-btn {
            flex:1; padding:10px 8px; border:1px solid #dcdcdc; border-radius:10px; background:#fff;
            color:#333; font-weight:600; font-size:14px; cursor:pointer; transition:.15s;
        }
        .pay-method-btn:hover { border-color:#111; }
        .pay-method-btn.active { background:#111; color:#fff; border-color:#111; }

        .qr-box {
            display:flex; flex-direction:column; align-items:center; gap:8px;
            border:1px dashed #d6d6d6; border-radius:14px; padding:16px; margin-top:12px; background:#fafafa;
        }
        .qr-box img { width:180px; height:180px; border-radius:8px; background:#fff; border:1px solid #eee; }
        .qr-caption { font-size:13px; color:#555; text-align:center; }
        .qr-hint { font-size:12.5px; color:#9a9a9a; margin-top:8px; }

        /* ===== Modal Thêm sản phẩm ===== */
        .product-grid {
            display:grid; grid-template-columns:repeat(auto-fill,minmax(180px,1fr));
            gap:14px; max-height:52vh; overflow-y:auto; padding-right:4px;
        }
        .product-card {
            border:1px solid #ececec; border-radius:12px; padding:14px; cursor:pointer;
            transition:.15s; background:#fbfbfb;
        }
        .product-card:hover { border-color:#111; box-shadow:0 4px 12px rgba(0,0,0,.08); }
        .product-card .ma { font-size:12px; color:#8a8a8a; }
        .product-card .ten { font-weight:600; margin:4px 0 6px; min-height:38px; color:#111; }
        .product-card .info { font-size:13px; color:#555; display:flex; justify-content:space-between; }
        .product-card .gia { font-weight:700; color:#e14b4b; margin-top:6px; }
        .product-card .ton { font-size:12px; color:#1a9e5c; }
        .product-card.disabled { opacity:.5; cursor:not-allowed; }
    </style>
</head>
<body>

<jsp:include page="/views/layout/sidebar.jsp"/>

<div class="main-content">
    <h2><i class="bi bi-cart-check"></i> Bán hàng tại quầy</h2>

    <div id="alertBox"></div>

    <!-- ĐƠN HÀNG CHỜ -->
    <div class="card-custom">
        <div class="title-box">
            <i class="bi bi-receipt-cutoff"></i><span>Đơn hàng chờ</span>
            <span class="text-muted" style="font-weight:400;font-size:12px;">(tối đa 10 đơn)</span>
        </div>
        <div class="order-tabs-bar" id="orderTabsBar"></div>
    </div>

    <!-- SẢN PHẨM TRONG GIỎ -->
    <div class="card-custom">
        <div class="card-head-row">
            <div class="title-box"><i class="bi bi-cart3"></i><span>Sản phẩm trong giỏ</span>
                <span id="cartOrderLabel" style="font-weight:400;font-size:13px;color:#9a9a9a;"></span>
            </div>
            <button type="button" class="btn-black" data-bs-toggle="modal" data-bs-target="#modalThemSanPham">
                <i class="bi bi-plus-lg"></i> Thêm sản phẩm
            </button>
        </div>
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
            <tr><td colspan="4" class="cart-empty"><i class="bi bi-bag"></i>Chưa có sản phẩm nào trong giỏ hàng</td></tr>
            </tbody>
        </table>
    </div>

    <!-- THÔNG TIN KHÁCH HÀNG + THANH TOÁN -->
    <div class="info-payment-grid">
        <div class="card-custom">
            <div class="title-box"><i class="bi bi-person"></i><span>Thông tin khách hàng</span></div>

            <label class="form-label">Số điện thoại <span class="text-danger">*</span></label>
            <input type="text" id="sdtInput" class="form-control" placeholder="Bắt buộc nhập số điện thoại">
            <div id="khStatus"></div>

            <label class="form-label mt-3">Tên khách hàng</label>
            <input type="text" id="tenKhInput" class="form-control" placeholder="Khách lẻ">

            <label class="form-label mt-3">Email <span class="text-danger">*</span></label>
            <input type="email" id="emailKhInput" class="form-control" placeholder="Bắt buộc nhập email">

            <label class="form-label mt-3">Địa chỉ <span class="text-danger">*</span></label>
            <input type="text" id="diaChiKhInput" class="form-control" placeholder="Bắt buộc nhập địa chỉ">

            <label class="form-label mt-3">Nhân viên phụ trách</label>
            <input type="text" class="form-control" disabled value="${sessionScope.user.nhanVien.hoTen}">

            <label class="form-label mt-3">Ghi chú</label>
            <textarea id="ghiChuInput" class="form-control" rows="2"></textarea>
        </div>

        <div class="card-custom">
            <div class="title-box"><i class="bi bi-credit-card"></i><span>Thanh toán</span></div>

            <label class="form-label">Phiếu giảm giá</label>
            <select id="voucherSelect" class="form-select">
                <option value="">-- Không dùng voucher --</option>
            </select>
            <div id="voucherHint"></div>

            <div class="mt-3">
                <div class="summary-row"><span>Tiền hàng</span><span id="sumTienHang">0 đ</span></div>
                <div class="summary-row"><span>Giảm giá</span><span id="sumGiam">- 0 đ</span></div>
                <div class="summary-row total"><span>Khách trả</span><span id="sumTong">0 đ</span></div>
            </div>

            <label class="form-label mt-3">Phương thức thanh toán</label>
            <div class="pay-method-toggle">
                <button type="button" class="pay-method-btn active" id="btnPtTienMat" onclick="chonPhuongThuc('tien_mat')">
                    <i class="bi bi-cash-coin"></i> Tiền mặt
                </button>
                <button type="button" class="pay-method-btn" id="btnPtQR" onclick="chonPhuongThuc('qr')">
                    <i class="bi bi-qr-code"></i> Chuyển khoản (QR)
                </button>
            </div>

            <div id="tienMatBox">
                <label class="form-label mt-3">Tiền khách đưa</label>
                <input type="number" min="0" step="1000" id="tienKhachDuaInput" class="form-control" placeholder="Nhập số tiền khách đưa">
                <div class="change-row"><span>Tiền thừa trả khách</span><span id="sumThua">0 đ</span></div>
            </div>

            <div id="qrBox" style="display:none;">
                <div class="qr-box">
                    <img id="qrImage" src="" alt="Mã QR chuyển khoản">
                    <div class="qr-caption">Quét mã để chuyển khoản<br>Số tiền: <strong id="qrAmount">0 đ</strong></div>
                </div>
                <div class="qr-hint">Sau khi nhận được tiền chuyển khoản, vui lòng bấm <strong>Thanh toán</strong> để hoàn tất đơn.</div>
            </div>

            <div class="d-flex gap-2 mt-4">
                <button type="button" class="btn-outline-black" id="btnGiuDon"><i class="bi bi-archive"></i> Giữ đơn</button>
                <button type="button" class="btn-black flex-grow-1" id="btnThanhToan">
                    <i class="bi bi-cash-coin"></i> Thanh toán
                </button>
            </div>
        </div>
    </div>
</div>

<!-- MODAL: THÊM SẢN PHẨM -->
<div class="modal fade" id="modalThemSanPham" tabindex="-1" aria-hidden="true">
    <div class="modal-dialog modal-lg modal-dialog-scrollable">
        <div class="modal-content" style="border-radius:16px;">
            <div class="modal-header">
                <h5 class="modal-title"><i class="bi bi-plus-lg"></i> Thêm sản phẩm vào giỏ</h5>
                <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
            </div>
            <div class="modal-body">
                <div class="input-group mb-3">
                    <input type="text" id="searchInput" class="form-control"
                           placeholder="Nhập mã hoặc tên sản phẩm...">
                    <button class="btn btn-black" type="button" id="btnSearch">
                        <i class="bi bi-search"></i>
                    </button>
                </div>
                <div class="product-grid" id="productGrid">
                    <div class="cart-empty" style="grid-column:1/-1;">Đang tải sản phẩm...</div>
                </div>
            </div>
            <div class="modal-footer">
                <span class="text-muted small me-auto">Bấm vào sản phẩm để thêm vào giỏ, có thể thêm nhiều sản phẩm liên tiếp.</span>
                <button type="button" class="btn-outline-black" data-bs-dismiss="modal">Xong</button>
            </div>
        </div>
    </div>
</div>

<script>
    const ctx = "${pageContext.request.contextPath}";
    const MAX_ORDERS = 10; // tối đa 10 đơn chờ

    // TODO: thay bằng thông tin ngân hàng thật của cửa hàng để mã QR nhận đúng tiền
    const QR_BANK_BIN = '970407';               // Techcombank (Ngân hàng TMCP Kỹ thương Việt Nam)
    const QR_ACCOUNT_NO = '88888888881157';     // Số tài khoản nhận tiền
    const QR_ACCOUNT_NAME = 'NGUYEN DINH KHANH'; // Tên chủ tài khoản (không dấu)

    // Mỗi đơn chờ: {id, sdt, tenKh, email, diaChi, ghiChu, voucherId, khStatusHtml, phuongThucThanhToan, tienKhachDua, cart:[]}
    let orders = [];
    let activeOrderId = null;

    let cart = [];       // tham chiếu tới cart của đơn đang chọn: {id, ma, tenSanPham, mauSac, kichThuoc, giaBan, soLuongTon, soLuong}
    let vouchers = [];
    let productCache = {};

    // ============== QUẢN LÝ ĐƠN HÀNG CHỜ ==============
    function taoDonRong() {
        return {
            id: 'don_' + Date.now() + '_' + Math.random().toString(36).slice(2, 7),
            sdt: '', tenKh: '', email: '', diaChi: '', ghiChu: '', voucherId: '',
            khStatusHtml: '',
            phuongThucThanhToan: 'tien_mat',
            tienKhachDua: '',
            cart: []
        };
    }

    function donHienTai() {
        return orders.find(o => o.id === activeOrderId);
    }

    // Lưu dữ liệu đang hiển thị trên form vào đơn đang chọn (trước khi chuyển/xóa đơn)
    function luuDonHienTai() {
        const don = donHienTai();
        if (!don) return;
        don.sdt = document.getElementById('sdtInput').value.trim();
        don.tenKh = document.getElementById('tenKhInput').value.trim();
        don.email = document.getElementById('emailKhInput').value.trim();
        don.diaChi = document.getElementById('diaChiKhInput').value.trim();
        don.ghiChu = document.getElementById('ghiChuInput').value.trim();
        don.voucherId = document.getElementById('voucherSelect').value;
        don.khStatusHtml = document.getElementById('khStatus').innerHTML;
        don.tienKhachDua = document.getElementById('tienKhachDuaInput').value;
    }

    // Nạp dữ liệu của đơn đang chọn lên form
    function napDonVaoForm() {
        const don = donHienTai();
        if (!don) return;
        document.getElementById('sdtInput').value = don.sdt || '';
        document.getElementById('tenKhInput').value = don.tenKh || '';
        document.getElementById('emailKhInput').value = don.email || '';
        document.getElementById('diaChiKhInput').value = don.diaChi || '';
        document.getElementById('ghiChuInput').value = don.ghiChu || '';
        document.getElementById('voucherSelect').value = don.voucherId || '';
        document.getElementById('khStatus').innerHTML = don.khStatusHtml || '';
        document.getElementById('tienKhachDuaInput').value = don.tienKhachDua || '';
        cart = don.cart;
        chonPhuongThuc(don.phuongThucThanhToan || 'tien_mat');
    }

    window.taoDonMoi = function () {
        if (orders.length >= MAX_ORDERS) {
            showAlert('warning', 'Đã đạt tối đa ' + MAX_ORDERS + ' đơn chờ. Vui lòng thanh toán hoặc xóa bớt đơn trước khi thêm mới.');
            return;
        }
        luuDonHienTai();
        const don = taoDonRong();
        orders.push(don);
        activeOrderId = don.id;
        napDonVaoForm();
        renderOrderTabs();
        renderCart();
        renderProductGrid(Object.values(productCache));
    };

    window.chonDon = function (id) {
        if (id === activeOrderId) return;
        luuDonHienTai();
        activeOrderId = id;
        napDonVaoForm();
        renderOrderTabs();
        renderCart();
        renderProductGrid(Object.values(productCache));
    };

    window.xoaDon = function (id) {
        const don = orders.find(o => o.id === id);
        if (!don) return;
        if (don.cart.length && !confirm('Đơn này đang có sản phẩm, bạn có chắc muốn xóa?')) return;

        const idx = orders.findIndex(o => o.id === id);
        orders.splice(idx, 1);

        if (!orders.length) {
            const donMoi = taoDonRong();
            orders.push(donMoi);
            activeOrderId = donMoi.id;
        } else if (id === activeOrderId) {
            const ke = orders[idx] || orders[idx - 1];
            activeOrderId = ke.id;
        }
        napDonVaoForm();
        renderOrderTabs();
        renderCart();
        renderProductGrid(Object.values(productCache));
    };

    // Gọi khi 1 đơn thanh toán thành công: đóng đơn đó, chuyển sang đơn kế / tạo đơn mới nếu hết
    function hoanTatDonHienTai() {
        const idx = orders.findIndex(o => o.id === activeOrderId);
        if (idx === -1) return;
        orders.splice(idx, 1);

        if (!orders.length) {
            const donMoi = taoDonRong();
            orders.push(donMoi);
            activeOrderId = donMoi.id;
        } else {
            const ke = orders[idx] || orders[idx - 1];
            activeOrderId = ke.id;
        }
        napDonVaoForm();
        renderOrderTabs();
        renderCart();
    }

    function renderOrderTabs() {
        const bar = document.getElementById('orderTabsBar');
        let html = orders.map((o, idx) => {
            const active = o.id === activeOrderId;
            const total = o.cart.reduce((s, c) => s + c.soLuong, 0);
            return '<div class="order-tab' + (active ? ' active' : '') + '" onclick="chonDon(\'' + o.id + '\')">' +
                '<span>Đơn ' + (idx + 1) + '</span>' +
                (total ? '<span class="badge">' + total + '</span>' : '') +
                '<i class="bi bi-x-lg order-tab-close" title="Xóa đơn" onclick="event.stopPropagation(); xoaDon(\'' + o.id + '\')"></i>' +
                '</div>';
        }).join('');

        const dayRoi = orders.length >= MAX_ORDERS;
        html += '<button type="button" class="btn-them-don" id="btnThemDon" ' +
            (dayRoi ? 'disabled title="Đã đạt tối đa ' + MAX_ORDERS + ' đơn chờ"' : 'title="Thêm đơn mới"') +
            ' onclick="taoDonMoi()"><i class="bi bi-plus-lg"></i></button>';

        bar.innerHTML = html;
    }

    // Tổng số lượng 1 sản phẩm đã được chọn trên TẤT CẢ đơn chờ (để tránh bán vượt tồn kho)
    function tongDaChonTatCaDon(productId) {
        let tong = 0;
        orders.forEach(o => {
            o.cart.forEach(c => { if (c.id === productId) tong += c.soLuong; });
        });
        return tong;
    }

    function formatTien(n) {
        return Math.round(n || 0).toLocaleString('vi-VN') + ' đ';
    }

    function showAlert(type, msg) {
        document.getElementById('alertBox').innerHTML =
            '<div class="alert alert-' + type + ' alert-dismissible fade show" role="alert">' + msg +
            '<button type="button" class="btn-close" data-bs-dismiss="alert"></button></div>';
    }

    // ============== TÌM SẢN PHẨM (trong modal) ==============
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
            const soLuongDaChon = tongDaChonTatCaDon(p.id);
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
        const daChonTatCaDon = tongDaChonTatCaDon(id);
        if (daChonTatCaDon >= p.soLuongTon) {
            showAlert('warning', 'Sản phẩm "' + p.tenSanPham + '" chỉ còn ' + p.soLuongTon + ' trong kho (đã được giữ ở các đơn chờ khác).');
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
        renderOrderTabs();
        renderProductGrid(Object.values(productCache));
    };

    window.doiSoLuong = function (index, delta) {
        const item = cart[index];
        if (!item) return;
        const moi = item.soLuong + delta;
        if (moi <= 0) {
            cart.splice(index, 1);
        } else {
            const daChonDonKhac = tongDaChonTatCaDon(item.id) - item.soLuong;
            if (daChonDonKhac + moi > item.soLuongTon) {
                showAlert('warning', 'Sản phẩm "' + item.tenSanPham + '" chỉ còn ' + item.soLuongTon + ' trong kho (đã được giữ ở các đơn chờ khác).');
                return;
            }
            item.soLuong = moi;
        }
        renderCart();
        renderOrderTabs();
        renderProductGrid(Object.values(productCache));
    };

    window.xoaKhoiGio = function (index) {
        cart.splice(index, 1);
        renderCart();
        renderOrderTabs();
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

    function tongPhaiTra() {
        const tienHang = tinhTienHang();
        return Math.max(0, tienHang - tinhTienGiam(tienHang));
    }

    function renderCart() {
        const nhanDon = document.getElementById('cartOrderLabel');
        if (nhanDon) {
            const idx = orders.findIndex(o => o.id === activeOrderId);
            nhanDon.textContent = idx >= 0 ? ('— Đơn ' + (idx + 1)) : '';
        }

        const body = document.getElementById('cartBody');
        if (!cart.length) {
            body.innerHTML = '<tr><td colspan="4" class="cart-empty"><i class="bi bi-bag"></i>Chưa có sản phẩm nào trong giỏ hàng</td></tr>';
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
        const tienHang = tinhTienHang();
        const tienGiam = tinhTienGiam(tienHang);
        document.getElementById('sumTienHang').textContent = formatTien(tienHang);
        document.getElementById('sumGiam').textContent = '- ' + formatTien(tienGiam);
        document.getElementById('sumTong').textContent = formatTien(tienHang - tienGiam);

        capNhatTienThua();
        const don = donHienTai();
        if (don && don.phuongThucThanhToan === 'qr') capNhatQR();
    }

    // ============== KHÁCH HÀNG ==============
    let sdtTimer = null;
    document.getElementById('sdtInput').addEventListener('input', function () {
        clearTimeout(sdtTimer);
        const sdt = this.value.trim();
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
                        if (!document.getElementById('tenKhInput').value.trim()) {
                            document.getElementById('tenKhInput').value = data.khachHang.hoTen || '';
                        }
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
                const select = document.getElementById('voucherSelect');
                const daChon = select.value;
                select.innerHTML = '<option value="">-- Không dùng voucher --</option>' +
                    vouchers.map(v => {
                        const mo = v.loaiGiamGia === '%'
                            ? (v.giaTriGiamGia + '%')
                            : formatTien(v.giaTriGiamGia);
                        return '<option value="' + v.id + '">' + v.maVoucher + ' - ' + v.tenVoucher + ' (' + mo + ')</option>';
                    }).join('');
                select.value = daChon;
                document.getElementById('voucherHint').textContent = vouchers.length
                    ? ''
                    : 'Hiện chưa có phiếu giảm giá nào còn hiệu lực trong hệ thống.';
                renderCart();
            });
    }
    document.getElementById('voucherSelect').addEventListener('change', renderCart);

    // ============== PHƯƠNG THỨC THANH TOÁN ==============
    window.chonPhuongThuc = function (pt) {
        const don = donHienTai();
        if (don) don.phuongThucThanhToan = pt;
        document.getElementById('btnPtTienMat').classList.toggle('active', pt === 'tien_mat');
        document.getElementById('btnPtQR').classList.toggle('active', pt === 'qr');
        document.getElementById('tienMatBox').style.display = pt === 'tien_mat' ? 'block' : 'none';
        document.getElementById('qrBox').style.display = pt === 'qr' ? 'block' : 'none';
        if (pt === 'qr') capNhatQR();
    };

    function capNhatTienThua() {
        const tong = tongPhaiTra();
        const dua = parseFloat(document.getElementById('tienKhachDuaInput').value) || 0;
        const thua = Math.max(0, dua - tong);
        document.getElementById('sumThua').textContent = formatTien(thua);
    }
    document.getElementById('tienKhachDuaInput').addEventListener('input', capNhatTienThua);

    function capNhatQR() {
        const tong = tongPhaiTra();
        const don = donHienTai();
        const noiDung = 'Thanh toan don hang' + (don ? (' ' + don.id.slice(-6)) : '');
        const url = 'https://img.vietqr.io/image/' + QR_BANK_BIN + '-' + QR_ACCOUNT_NO + '-compact2.png' +
            '?amount=' + Math.round(tong) +
            '&addInfo=' + encodeURIComponent(noiDung) +
            '&accountName=' + encodeURIComponent(QR_ACCOUNT_NAME);
        document.getElementById('qrImage').src = url;
        document.getElementById('qrAmount').textContent = formatTien(tong);
    }

    // ============== GIỮ ĐƠN ==============
    document.getElementById('btnGiuDon').addEventListener('click', function () {
        if (!cart.length) {
            showAlert('warning', 'Giỏ hàng đang trống, không có gì để giữ.');
            return;
        }
        luuDonHienTai();
        renderOrderTabs();
        showAlert('success', 'Đã giữ đơn hiện tại. Bạn có thể chọn lại đơn này bất cứ lúc nào ở danh sách "Đơn hàng chờ".');
        if (orders.length < MAX_ORDERS) {
            taoDonMoi();
        }
    });

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
            showAlert('danger', 'Vui lòng nhập email khách hàng.');
            return;
        }
        if (!/^[^\s@]+@[^\s@]+\.[^\s@]+$/.test(email)) {
            showAlert('danger', 'Email khách hàng không hợp lệ.');
            return;
        }

        const diaChi = document.getElementById('diaChiKhInput').value.trim();
        if (!diaChi) {
            showAlert('danger', 'Vui lòng nhập địa chỉ khách hàng.');
            return;
        }

        const pt = donHienTai() ? donHienTai().phuongThucThanhToan : 'tien_mat';
        let ghiChu = document.getElementById('ghiChuInput').value.trim();
        if (pt === 'tien_mat') {
            const tong = tongPhaiTra();
            const dua = parseFloat(document.getElementById('tienKhachDuaInput').value) || 0;
            if (dua < tong) {
                showAlert('danger', 'Số tiền khách đưa chưa đủ để thanh toán.');
                return;
            }
            ghiChu = ('[Tiền mặt] ' + ghiChu).trim();
        } else {
            ghiChu = ('[Chuyển khoản QR] ' + ghiChu).trim();
        }

        const payload = {
            sdtKhachHang: sdt,
            tenKhachHang: document.getElementById('tenKhInput').value.trim(),
            emailKhachHang: email,
            diaChiKhachHang: diaChi,
            idPhieuGiamGia: document.getElementById('voucherSelect').value || null,
            ghiChu: ghiChu,
            gioHang: cart.map(c => ({ idSanPhamChiTiet: c.id, soLuong: c.soLuong }))
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
                    showAlert('success', 'Thanh toán thành công! Mã hóa đơn <strong>' + data.maHoaDon +
                        '</strong> - Tổng tiền: ' + formatTien(data.tongTienThanhToan) +
                        ' &nbsp; <a href="' + ctx + '/quanlyhoadon?action=detail&id=' + data.idHoaDon +
                        '" class="alert-link">Xem hóa đơn</a>');
                    hoanTatDonHienTai();
                    timSanPham();
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

    // Khởi tạo: tạo sẵn 1 đơn chờ đầu tiên
    taoDonMoi();
    timSanPham();
    taiVoucher();
</script>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
<script src="${pageContext.request.contextPath}/assets/js/main.js?v=mono3" defer></script>
</body>
</html>
