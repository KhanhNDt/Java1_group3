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
        #salesEmptyState { position:relative; padding:70px 0; }
        #salesEmptyState i.bi-lock { font-size:38px; color:#c8c8c8; }

        /* ===== Đơn hàng chờ (tabs) ===== */
        .order-tabs-bar { display:flex; align-items:center; gap:8px; justify-content:space-between; }
        .order-tabs-list { display:flex; align-items:center; gap:8px; flex-wrap:wrap; }
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

        .voucher-tabs { display:flex; gap:8px; margin-bottom:10px; }
        .voucher-tab-btn {
            flex:1; border:1px solid #dcdcdc; background:#fff; border-radius:10px; padding:8px 10px;
            font-size:13.5px; font-weight:600; color:#555; cursor:pointer; transition:.15s;
        }
        .voucher-tab-btn:hover { border-color:#111; color:#111; }
        .voucher-tab-btn.active { background:#111; border-color:#111; color:#fff; }

        .voucher-card {
            border:1px dashed #cfcfcf; border-radius:12px; padding:12px 14px; background:#fafafa; position:relative;
        }
        .voucher-card-active { border:1.5px solid #16a34a; background:#f0fdf4; }
        .voucher-card-top { display:flex; align-items:center; justify-content:space-between; margin-bottom:4px; }
        .voucher-badge {
            display:inline-block; font-size:11.5px; font-weight:700; color:#a15c00; background:#fff3d6;
            border-radius:999px; padding:2px 9px;
        }
        .voucher-applied { font-size:12px; font-weight:600; color:#16a34a; }
        .voucher-code { font-size:16px; font-weight:800; letter-spacing:.3px; color:#111; }
        .voucher-name { font-size:13px; color:#555; margin-top:1px; }
        .voucher-desc { font-size:13px; color:#333; margin-top:6px; }
        .voucher-empty { font-size:13px; color:#9a9a9a; padding:10px 2px; }
        .voucher-suggest {
            margin-top:8px; font-size:12.5px; color:#7a4b00; background:#fff8ec; border:1px solid #ffe4ad;
            border-radius:8px; padding:8px 10px;
        }

        #voucherAltPane { max-height:220px; overflow-y:auto; border:1px solid #eee; border-radius:10px; }
        .voucher-alt-item {
            display:flex; align-items:center; gap:8px; padding:9px 12px; font-size:12.5px; cursor:pointer;
            border-bottom:1px solid #f0f0f0; transition:.1s;
        }
        .voucher-alt-item:last-child { border-bottom:none; }
        .voucher-alt-item:hover { background:#f7f7f7; }
        .voucher-alt-item.active { background:#f0fdf4; }
        .voucher-alt-item.locked { cursor:default; color:#9a9a9a; }
        .voucher-alt-item.locked:hover { background:none; }
        .voucher-alt-code { font-weight:700; color:#111; min-width:80px; }
        .voucher-alt-item.locked .voucher-alt-code { color:#9a9a9a; }
        .voucher-alt-desc { flex:1; color:#555; }
        .voucher-alt-amt { font-weight:700; color:#16a34a; white-space:nowrap; }

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

        /* ===== Modal QR thanh toán (hiện giữa màn hình) ===== */
        #modalQRPayment .modal-content { border-radius:22px; overflow:hidden; border:none; box-shadow:0 24px 60px rgba(0,0,0,.25); }
        #modalQRPayment .modal-header { border-bottom:1px solid #f0f0f0; padding:18px 24px; }
        #modalQRPayment .modal-footer { border-top:1px solid #f0f0f0; padding:16px 24px; }
        #qrImageBig { width:260px; height:260px; border-radius:16px; background:#fff; border:1px solid #eee; box-shadow:0 6px 20px rgba(0,0,0,.06); }
        #qrAmountBig { font-size:34px; font-weight:800; color:#111; letter-spacing:.2px; }
        .qr-waiting-pulse { display:inline-flex; align-items:center; gap:8px; font-size:13.5px; color:#9a9a9a; }
        .qr-success-state { display:none; font-size:16px; font-weight:700; color:#15803d; }

        /* ===== Modal Thêm sản phẩm ===== */
        .product-search-status { font-size:12px; color:#9a9a9a; min-height:16px; margin:-6px 0 10px 2px; display:flex; align-items:center; gap:6px; }
        .product-search-status .spinner-border { width:12px; height:12px; border-width:2px; }
        .product-grid {
            display:grid; grid-template-columns:repeat(auto-fill,minmax(190px,1fr));
            gap:14px; max-height:56vh; overflow-y:auto; padding-right:4px;
        }
        .product-card {
            display:flex; flex-direction:column; overflow:hidden;
            border:1px solid #ececec; border-radius:12px; cursor:pointer;
            transition:.15s; background:#fff;
        }
        .product-card:hover { border-color:#111; box-shadow:0 4px 12px rgba(0,0,0,.08); transform:translateY(-1px); }
        .product-card .thumb {
            width:100%; aspect-ratio:1/1; background:#f2f2f2; overflow:hidden;
            display:flex; align-items:center; justify-content:center; color:#c2c2c2; font-size:26px;
        }
        .product-card .thumb img { width:100%; height:100%; object-fit:cover; display:block; }
        .product-card .body { padding:10px 12px 12px; }
        .product-card .ma { font-size:11px; color:#8a8a8a; }
        .product-card .ten { font-weight:600; margin:2px 0 6px; min-height:38px; color:#111; line-height:1.25; font-size:13.5px; }
        .product-card .info { font-size:12px; color:#555; display:flex; justify-content:space-between; gap:6px; }
        .product-card .info span { border:1px solid #e2e2e2; border-radius:999px; padding:2px 8px; background:#fafafa; }
        .product-card .foot { display:flex; align-items:center; justify-content:space-between; margin-top:8px; }
        .product-card .gia { font-weight:700; color:#e14b4b; }
        .product-card .ton { font-size:11px; color:#1a9e5c; font-weight:600; }
        .product-card.disabled { opacity:.5; cursor:not-allowed; }
        .product-card.disabled:hover { transform:none; box-shadow:none; border-color:#ececec; }

        /* ===== Modal Thêm sản phẩm: bảng + bộ lọc ===== */
        .price-range-values { display:flex; justify-content:space-between; font-size:12.5px; color:#1a9e5c; font-weight:700; margin-bottom:4px; }
        .price-range-wrap { position:relative; height:28px; }
        .price-range-track { position:absolute; top:12px; left:0; right:0; height:4px; background:#e2e2e2; border-radius:4px; }
        .price-range-input {
            position:absolute; top:8px; left:0; width:100%; margin:0; -webkit-appearance:none; appearance:none;
            background:transparent; pointer-events:none; height:12px;
        }
        .price-range-input::-webkit-slider-thumb {
            -webkit-appearance:none; pointer-events:auto; width:16px; height:16px; border-radius:50%;
            background:#111; cursor:pointer; border:2px solid #fff; box-shadow:0 0 0 1px #111;
        }
        .price-range-input::-moz-range-thumb {
            pointer-events:auto; width:16px; height:16px; border-radius:50%;
            background:#111; cursor:pointer; border:2px solid #fff; box-shadow:0 0 0 1px #111;
        }
        .price-range-input::-webkit-slider-runnable-track { background:transparent; }
        .price-range-input::-moz-range-track { background:transparent; }

        .product-select-table { font-size:13.5px; }
        .product-select-table th { font-size:11.5px; text-transform:uppercase; color:#8a8a8a; white-space:nowrap; }
        .product-select-table td { vertical-align:middle; }
        .product-select-table .thumb-sm {
            width:42px; height:42px; border-radius:8px; object-fit:cover; background:#f2f2f2;
            display:inline-flex; align-items:center; justify-content:center; color:#c2c2c2;
        }
        .product-select-table tr.row-disabled { opacity:.45; }
        .product-select-table .gia-cell { font-weight:700; color:#e14b4b; white-space:nowrap; }
    </style>
</head>
<body>

<jsp:include page="/views/layout/sidebar.jsp"/>

<div class="main-content">
    <div class="d-flex align-items-center justify-content-between" style="margin-bottom:24px;">
        <div class="d-flex align-items-center" style="gap:14px;">
            <div style="width:46px;height:46px;border-radius:14px;background:linear-gradient(135deg,#171717,#3a3a3a);display:flex;align-items:center;justify-content:center;color:#fff;font-size:20px;box-shadow:0 6px 16px rgba(0,0,0,.18);">
                <i class="bi bi-cart-check"></i>
            </div>
            <div>
                <h2 style="margin-bottom:2px;">Bán hàng tại quầy</h2>
                <div style="font-size:13px;color:#9a9a9a;">Tạo đơn, chọn sản phẩm và thanh toán ngay tại quầy</div>
            </div>
        </div>
        <button type="button" class="btn-black" id="btnTaoDonHang" onclick="taoDonMoi()">
            <i class="bi bi-plus-lg"></i> Tạo đơn hàng
        </button>
    </div>

    <div id="alertBox"></div>

    <!-- ĐƠN HÀNG CHỜ -->
    <div class="card-custom">
        <div class="card-head-row" id="orderTabsHeadRow" style="display:none;">
            <div class="title-box"><i class="bi bi-receipt-cutoff"></i><span>Đơn hàng chờ</span></div>
            <span class="text-muted" id="orderCountLabel" style="font-weight:400;font-size:13px;">0/10 đơn</span>
        </div>
        <div class="order-tabs-bar" id="orderTabsBar" style="display:none;"></div>
        <div class="cart-empty" id="salesEmptyState">
            <span style="position:absolute;right:20px;top:16px;font-size:12px;color:#9a9a9a;font-weight:600;" id="orderCountLabelEmpty">0/10 đơn</span>
            <i class="bi bi-lock"></i>
            Chưa có đơn hàng nào
        </div>
    </div>

    <!-- SẢN PHẨM TRONG GIỎ + THÔNG TIN + THANH TOÁN -->
    <div id="salesWorkArea" style="display:none;">
        <div class="card-custom">
            <div class="card-head-row">
                <div class="title-box"><i class="bi bi-cart3"></i><span>Sản phẩm trong giỏ</span>
                    <span id="cartOrderLabel" style="font-weight:400;font-size:13px;color:#9a9a9a;"></span>
                </div>
                <div class="d-flex gap-2">
                    <button type="button" class="btn-outline-black" data-bs-toggle="modal" data-bs-target="#modalQuetQR">
                        <i class="bi bi-qr-code-scan"></i> Quét mã QR
                    </button>
                    <button type="button" class="btn-black" data-bs-toggle="modal" data-bs-target="#modalThemSanPham">
                        <i class="bi bi-plus-lg"></i> Thêm sản phẩm
                    </button>
                </div>
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

                <label class="form-label">Số điện thoại</label>
                <input type="text" id="sdtInput" class="form-control" placeholder="Số điện thoại (không bắt buộc)">
                <div id="khStatus"></div>

                <label class="form-label mt-3">Tên khách hàng</label>
                <input type="text" id="tenKhInput" class="form-control" placeholder="Khách lẻ">

                <label class="form-label mt-3">Email</label>
                <input type="email" id="emailKhInput" class="form-control" placeholder="Email (không bắt buộc)">

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
                <div class="voucher-tabs">
                    <button type="button" class="voucher-tab-btn active" id="tabVoucherBest" onclick="chonTabVoucher('best')">
                        <i class="bi bi-award"></i> Mã tốt nhất
                    </button>
                    <button type="button" class="voucher-tab-btn" id="tabVoucherAlt" onclick="chonTabVoucher('alt')">
                        <i class="bi bi-tags"></i> Mã thay thế
                    </button>
                </div>
                <div id="voucherBestPane"></div>
                <div id="voucherAltPane" style="display:none;"></div>
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
                    <div class="d-flex justify-content-between align-items-center mt-3">
                        <label class="form-label mb-0">Tiền khách đưa</label>
                        <a href="javascript:void(0)" id="tienKhachDuaAutoReset" style="display:none;font-size:12px;">Dùng đúng số tiền</a>
                    </div>
                    <input type="number" min="0" step="1000" id="tienKhachDuaInput" class="form-control quick-cash-input" placeholder="Nhập số tiền khách đưa" autocomplete="off">
                    <div class="change-row"><span>Tiền thừa trả khách</span><span id="sumThua">0 đ</span></div>
                </div>

                <div id="qrBox" style="display:none;">
                    <div class="qr-box">
                        <img id="qrImage" src="" alt="Mã QR chuyển khoản">
                        <div class="qr-caption">Quét mã để chuyển khoản<br>Số tiền: <strong id="qrAmount">0 đ</strong></div>
                    </div>
                    <div class="qr-hint">Bấm <strong>Thanh toán</strong> để hiển thị mã QR lớn giữa màn hình cho khách quét. Hệ thống sẽ tự nhận diện khi khách chuyển khoản xong và tự in hóa đơn.</div>
                </div>

                <div class="d-flex gap-2 mt-4">
                    <button type="button" class="btn-outline-black" id="btnGiuDon"><i class="bi bi-archive"></i> Giữ đơn</button>
                    <button type="button" class="btn-black flex-grow-1" id="btnThanhToan">
                        <i class="bi bi-cash-coin"></i> Thanh toán
                    </button>
                </div>
            </div>
        </div>
    </div><!-- /salesWorkArea -->
</div>

<!-- Popup chọn nhanh mệnh giá tiền khách đưa -->
<div id="quickCashPicker" style="position:fixed;z-index:1080;width:260px;padding:12px;border:1px solid #dedede;border-radius:12px;background:#fff;box-shadow:0 12px 32px rgba(15,23,42,.16);display:none">
    <div style="font-size:11.5px;font-weight:800;color:#686868;text-transform:uppercase;letter-spacing:.03em;margin-bottom:8px">Chọn nhanh mệnh giá</div>
    <div style="display:grid;grid-template-columns:1fr 1fr;gap:6px" id="quickCashGrid"></div>
    <div style="display:flex;align-items:center;justify-content:space-between;gap:8px;margin-top:10px;padding-top:10px;border-top:1px solid #eee">
        <span style="font-size:11px;color:#9a9a9a">Hoặc tự nhập số tiền khác vào ô</span>
        <button type="button" id="quickCashClose" style="border:0;background:transparent;font-size:12px;font-weight:700;color:#686868;cursor:pointer;padding:2px 6px">Đóng</button>
    </div>
</div>
<style>.quick-cash__btn{border:1px solid #dedede;border-radius:9px;background:#f8f8f8;padding:8px 6px;font-size:12.5px;font-weight:700;color:#111111;cursor:pointer;text-align:center;transition:.15s}.quick-cash__btn:hover{background:#111111;color:#fff;border-color:#111111}</style>

<!-- MODAL: THÊM SẢN PHẨM (chọn biến thể để thêm vào đơn) -->
<div class="modal fade" id="modalThemSanPham" tabindex="-1" aria-hidden="true">
    <div class="modal-dialog modal-xl modal-dialog-scrollable">
        <div class="modal-content" style="border-radius:16px;">
            <div class="modal-header">
                <h5 class="modal-title"><i class="bi bi-plus-lg"></i> Chọn biến thể để thêm vào đơn</h5>
                <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
            </div>
            <div class="modal-body">
                <div class="row g-2 mb-2">
                    <div class="col-md-6">
                        <label class="form-label">Tìm kiếm</label>
                        <input type="text" id="searchInput" class="form-control"
                               placeholder="Tìm theo mã / tên sản phẩm..." autocomplete="off">
                    </div>
                    <div class="col-md-3">
                        <label class="form-label">Màu sắc</label>
                        <select id="filterMauSac" class="form-select">
                            <option value="">-- Chọn màu sắc --</option>
                        </select>
                    </div>
                    <div class="col-md-3">
                        <label class="form-label">Size</label>
                        <select id="filterSize" class="form-select">
                            <option value="">-- Chọn size --</option>
                        </select>
                    </div>
                </div>

                <div class="row g-2 align-items-end mb-2">
                    <div class="col-md-6">
                        <label class="form-label">Khoảng giá</label>
                        <div class="price-range-values">
                            <span id="priceRangeMinLabel">0</span>
                            <span id="priceRangeMaxLabel">0</span>
                        </div>
                        <div class="price-range-wrap">
                            <input type="range" id="filterGiaMin" class="price-range-input price-range-min">
                            <input type="range" id="filterGiaMax" class="price-range-input price-range-max">
                            <div class="price-range-track"></div>
                        </div>
                    </div>
                    <div class="col-md-3">
                        <label class="form-label">Trạng thái</label>
                        <div class="d-flex gap-3" style="padding-top:6px;">
                            <label class="form-check-label" style="font-size:13.5px;">
                                <input type="radio" name="filterTonKho" value="tat-ca" checked> Tất cả</label>
                            <label class="form-check-label" style="font-size:13.5px;">
                                <input type="radio" name="filterTonKho" value="con-hang"> Còn hàng</label>
                            <label class="form-check-label" style="font-size:13.5px;">
                                <input type="radio" name="filterTonKho" value="het-hang"> Hết hàng</label>
                        </div>
                    </div>
                    <div class="col-md-3 text-md-end">
                        <button type="button" class="btn-outline-black btn-sm" id="btnDatLaiLoc">Đặt lại</button>
                        <button type="button" class="btn-outline-black btn-sm" id="btnTaiLaiLoc">Tải lại</button>
                    </div>
                </div>

                <div class="d-flex justify-content-between align-items-center mb-1">
                    <span class="product-search-status" id="productSearchStatus">&nbsp;</span>
                    <span class="text-muted small" id="ketQuaLocLabel">Hiển thị 0 &nbsp;·&nbsp; Tổng sau lọc 0</span>
                </div>

                <div class="table-responsive" style="max-height:52vh; overflow-y:auto;">
                    <table class="table align-middle product-select-table" id="productTable">
                        <thead>
                        <tr>
                            <th>STT</th><th>Mã</th><th>Ảnh</th><th>Tên sản phẩm</th>
                            <th>Màu</th><th>Size</th><th>Tồn</th><th>Giá</th><th>Chọn</th>
                        </tr>
                        </thead>
                        <tbody id="productTableBody">
                        <tr><td colspan="9" class="cart-empty">Đang tải sản phẩm...</td></tr>
                        </tbody>
                    </table>
                </div>

                <div class="d-flex justify-content-between align-items-center mt-2">
                    <span class="text-muted small">Trang <span id="pageInfoLabel">1/1</span></span>
                    <div class="d-flex align-items-center gap-2">
                        <button type="button" class="btn-outline-black btn-sm" id="btnTrangTruoc"><i class="bi bi-chevron-left"></i></button>
                        <button type="button" class="btn-outline-black btn-sm" id="btnTrangSau"><i class="bi bi-chevron-right"></i></button>
                        <select id="pageSizeSelect" class="form-select form-select-sm" style="width:auto;">
                            <option value="10">10 bản ghi/trang</option>
                            <option value="20">20 bản ghi/trang</option>
                            <option value="30">30 bản ghi/trang</option>
                        </select>
                    </div>
                </div>
            </div>
            <div class="modal-footer">
                <span class="text-muted small me-auto">Bấm "Chọn" ở dòng sản phẩm để thêm vào giỏ, có thể thêm nhiều sản phẩm liên tiếp.</span>
                <button type="button" class="btn-outline-black" data-bs-dismiss="modal">Xong</button>
            </div>
        </div>
    </div>
</div>

<!-- MODAL: QUÉT MÃ QR BIẾN THỂ (camera hoặc tải ảnh lên) để thêm nhanh vào giỏ hàng -->
<div class="modal fade" id="modalQuetQR" tabindex="-1" aria-hidden="true">
    <div class="modal-dialog modal-dialog-centered">
        <div class="modal-content" style="border-radius:16px;">
            <div class="modal-header">
                <h5 class="modal-title"><i class="bi bi-qr-code-scan"></i> Quét mã QR sản phẩm</h5>
                <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
            </div>
            <div class="modal-body">
                <ul class="nav nav-tabs mb-3" id="qrScanTabs">
                    <li class="nav-item"><button type="button" class="nav-link active" id="qrTabCameraBtn" data-qr-tab="camera">
                        <i class="bi bi-camera-fill me-1"></i>Quét bằng camera</button></li>
                    <li class="nav-item"><button type="button" class="nav-link" id="qrTabUploadBtn" data-qr-tab="upload">
                        <i class="bi bi-upload me-1"></i>Tải ảnh QR lên</button></li>
                </ul>

                <div id="qrPaneCamera">
                    <div style="position:relative; border-radius:12px; overflow:hidden; background:#111; aspect-ratio:1/1; max-width:340px; margin:0 auto;">
                        <video id="qrVideo" autoplay playsinline muted style="width:100%; height:100%; object-fit:cover;"></video>
                        <div style="position:absolute; inset:14%; border:2px solid rgba(255,255,255,.75); border-radius:12px; pointer-events:none;"></div>
                    </div>
                    <div class="text-center text-muted small mt-2" id="qrCameraHint">Đưa mã QR của biến thể vào giữa khung hình.</div>
                    <div class="text-center text-danger small mt-1 d-none" id="qrCameraError"></div>
                </div>

                <div id="qrPaneUpload" class="d-none">
                    <div class="border rounded-3 p-4 text-center" style="border-style:dashed !important;">
                        <i class="bi bi-image display-6 text-muted"></i>
                        <p class="text-muted small mb-2">Chọn ảnh chụp/màn hình chứa mã QR của biến thể</p>
                        <input type="file" id="qrUploadInput" class="form-control" accept="image/*">
                    </div>
                    <canvas id="qrUploadCanvas" class="d-none"></canvas>
                </div>

                <div id="qrScanResult" class="mt-3"></div>
            </div>
            <div class="modal-footer">
                <span class="text-muted small me-auto">Quét xong sẽ hiện thông tin sản phẩm để xác nhận Thêm vào giỏ hoặc Hủy.</span>
                <button type="button" class="btn-outline-black" data-bs-dismiss="modal">Đóng</button>
            </div>
        </div>
    </div>
</div>

<!-- MODAL: THANH TOÁN QR (hiện lớn giữa màn hình kèm số tiền khi chọn phương thức Chuyển khoản QR) -->
<div class="modal fade" id="modalQRPayment" tabindex="-1" aria-hidden="true" data-bs-backdrop="static" data-bs-keyboard="false">
    <div class="modal-dialog modal-dialog-centered">
        <div class="modal-content">
            <div class="modal-header">
                <h5 class="modal-title"><i class="bi bi-qr-code-scan"></i> Quét mã để thanh toán</h5>
                <button type="button" class="btn-close" id="btnCloseQrModal" data-bs-dismiss="modal"></button>
            </div>
            <div class="modal-body text-center py-4">
                <img id="qrImageBig" src="" alt="Mã QR chuyển khoản">
                <div class="mt-3" style="font-size:13.5px;color:#9a9a9a;">Số tiền cần thanh toán</div>
                <div id="qrAmountBig">0 đ</div>

                <div id="qrWaitingState" class="qr-waiting-pulse mt-3">
                    <span class="spinner-border spinner-border-sm"></span> Đang chờ khách quét mã và chuyển khoản...
                </div>
                <div id="qrSuccessState" class="qr-success-state mt-2">
                    <i class="bi bi-check-circle-fill"></i> Thanh toán thành công! Đang chuyển sang in hóa đơn...
                </div>
                <div id="qrErrorState" class="mt-2 text-danger fw-semibold" style="display:none;font-size:14px;"></div>
            </div>
            <div class="modal-footer justify-content-between">
                <button type="button" class="btn-outline-black" data-bs-dismiss="modal" id="btnHuyQrModal">
                    <i class="bi bi-x-lg"></i> Hủy
                </button>
                <button type="button" class="btn-black" id="btnXacNhanDaThanhToanQR">
                    <i class="bi bi-check2-circle"></i> Khách đã chuyển khoản xong
                </button>
            </div>
        </div>
    </div>
</div>

<script src="${pageContext.request.contextPath}/assets/js/vendor/jsQR.js"></script>
<script>
    const ctx = "${pageContext.request.contextPath}";
    const MAX_ORDERS = 10; // tối đa 10 đơn chờ

    // TODO: thay bằng thông tin ngân hàng thật của cửa hàng để mã QR nhận đúng tiền
    const QR_BANK_BIN = '970422';                // MB Bank (Ngân hàng TMCP Quân đội)
    const QR_ACCOUNT_NO = '0356029335';          // Số tài khoản nhận tiền
    const QR_ACCOUNT_NAME = 'NGUYEN THE GIANG';  // Tên chủ tài khoản (không dấu)

    // Mỗi đơn chờ: {id, sdt, tenKh, email, diaChi, ghiChu, voucherId, khStatusHtml, phuongThucThanhToan, tienKhachDua, cart:[]}
    let orders = [];
    let activeOrderId = null;

    let cart = [];       // tham chiếu tới cart của đơn đang chọn: {id, ma, tenSanPham, mauSac, kichThuoc, giaBan, soLuongTon, soLuong}
    let vouchers = [];
    let productCache = {};   // cache toàn bộ item đã từng tải, theo id (để tra cứu khi thêm vào giỏ)
    let currentPageItems = []; // các item đang hiển thị ở trang hiện tại trong modal
    let boLoc = { mauSac: [], size: [], giaMin: 0, giaMax: 0 };
    let pageState = { page: 1, pageSize: 10, totalPages: 1, totalItems: 0 };

    // ============== QUẢN LÝ ĐƠN HÀNG CHỜ ==============
    function taoDonRong() {
        return {
            id: 'don_' + Date.now() + '_' + Math.random().toString(36).slice(2, 7),
            sdt: '', tenKh: '', email: '', diaChi: '', ghiChu: '', voucherId: '',
            voucherAuto: true, // true = hệ thống tự chọn phiếu giảm giá tốt nhất; false = khách hàng/thu ngân đã tự chọn tay
            khStatusHtml: '',
            phuongThucThanhToan: 'tien_mat',
            tienKhachDua: '',
            tienKhachDuaAuto: true, // true = tự điền đúng số tiền phải trả; false = thu ngân/khách đã tự sửa tay (đưa nhiều hơn...)
            cart: [],
            idHoaDonCho: null, // != null nếu đơn này đã được "Giữ đơn" và lưu vào CSDL (hóa đơn trạng thái 0)
            ngayTao: null,     // epoch millis lúc giữ đơn trên server, dùng để đếm ngược 24h trước khi tự hủy
            daTaiChiTiet: true // false = đơn được nạp từ server nhưng chưa tải chi tiết giỏ hàng (tải "lười" khi bấm vào tab)
        };
    }

    // Thời hạn tối đa một hóa đơn chờ được giữ trước khi hệ thống tự động hủy (phải khớp với
    // HoaDonRepo#huyCacHoaDonChoQuaHan ở backend: DATEADD(HOUR, -24, GETDATE())).
    const HAN_GIU_DON_GIO = 24;

    // Số mili-giây còn lại trước khi 1 đơn chờ (đã lưu server) tự động bị hủy. null nếu chưa xác định.
    function thoiGianConLai(don) {
        if (!don || !don.ngayTao) return null;
        const hetHan = don.ngayTao + HAN_GIU_DON_GIO * 3600 * 1000;
        return hetHan - Date.now();
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
        chonTabVoucher('best');
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
        renderProductTable(currentPageItems);
    };

    // Tải chi tiết giỏ hàng của 1 đơn chờ ĐÃ LƯU TRÊN SERVER (nạp "lười", chỉ gọi khi cần).
    function taiChiTietHoaDonChoNeuCan(don) {
        if (!don || don.daTaiChiTiet || !don.idHoaDonCho) return Promise.resolve(don);
        return fetch(ctx + '/ban-hang-tai-quay?action=chiTietHoaDonCho&id=' + don.idHoaDonCho)
            .then(r => r.json())
            .then(data => {
                if (data.success) {
                    const hd = data.hoaDon;
                    don.sdt = hd.sdtKhachHang || '';
                    don.tenKh = hd.tenKhachHang || '';
                    don.diaChi = hd.diaChiKhachHang || '';
                    don.ghiChu = hd.ghiChu || '';
                    don.voucherId = hd.idPhieuGiamGia || '';
                    don.voucherAuto = !hd.idPhieuGiamGia;
                    don.cart = (hd.gioHang || []).map(it => ({
                        id: it.id, ma: it.ma, tenSanPham: it.tenSanPham, mauSac: it.mauSac,
                        kichThuoc: it.kichThuoc, giaBan: it.giaBan, soLuongTon: it.soLuongTon, soLuong: it.soLuong
                    }));
                } else {
                    // Hóa đơn đã bị hủy/xử lý ở nơi khác (ví dụ vừa tự động hủy quá 24h) -> loại khỏi danh sách cục bộ
                    showAlert('warning', data.message || 'Đơn chờ này không còn tồn tại (có thể đã quá hạn 24h và bị tự động hủy).');
                    orders = orders.filter(o => o.id !== don.id);
                }
                don.daTaiChiTiet = true;
                return don;
            })
            .catch(() => { don.daTaiChiTiet = true; return don; });
    }

    window.chonDon = function (id) {
        if (id === activeOrderId) return;
        luuDonHienTai();
        const don = orders.find(o => o.id === id);
        activeOrderId = id;
        taiChiTietHoaDonChoNeuCan(don).then(() => {
            napDonVaoForm();
            renderOrderTabs();
            renderCart();
            renderProductTable(currentPageItems);
        });
    };

    window.xoaDon = function (id) {
        const don = orders.find(o => o.id === id);
        if (!don) return;
        if (don.cart.length && !confirm('Đơn này đang có sản phẩm, bạn có chắc muốn xóa?')) return;

        const xoaCucBo = function () {
            const idx = orders.findIndex(o => o.id === id);
            if (idx === -1) return;
            orders.splice(idx, 1);

            if (!orders.length) {
                // Không tự tạo đơn mới nữa: quay về màn hình danh (chưa có đơn hàng nào)
                activeOrderId = null;
            } else if (id === activeOrderId) {
                const ke = orders[idx] || orders[idx - 1];
                activeOrderId = ke.id;
                napDonVaoForm();
            }
            renderOrderTabs();
            renderCart();
            renderProductTable(currentPageItems);
        };

        // Nếu đơn đã được lưu trên server (đã "Giữ đơn"), phải hủy trên server trước để tránh
        // vẫn còn trong danh sách "Đơn hàng chờ" của nhân viên khác / sau khi tải lại trang.
        if (don.idHoaDonCho) {
            fetch(ctx + '/ban-hang-tai-quay?action=huyHoaDonCho&id=' + don.idHoaDonCho, { method: 'POST' })
                .then(r => r.json())
                .then(data => {
                    if (!data.success) {
                        showAlert('danger', data.message || 'Không thể hủy hóa đơn chờ trên hệ thống.');
                        return;
                    }
                    xoaCucBo();
                })
                .catch(() => showAlert('danger', 'Lỗi kết nối tới máy chủ, vui lòng thử lại.'));
        } else {
            xoaCucBo();
        }
    };

    // Gọi khi 1 đơn thanh toán thành công: đóng đơn đó, chuyển sang đơn kế nếu còn / về màn hình danh nếu hết
    function hoanTatDonHienTai() {
        const idx = orders.findIndex(o => o.id === activeOrderId);
        if (idx === -1) return;
        orders.splice(idx, 1);

        if (!orders.length) {
            activeOrderId = null;
        } else {
            const ke = orders[idx] || orders[idx - 1];
            activeOrderId = ke.id;
            napDonVaoForm();
        }
        renderOrderTabs();
        renderCart();
    }

    function renderOrderTabs() {
        const bar = document.getElementById('orderTabsBar');
        const headRow = document.getElementById('orderTabsHeadRow');
        const emptyState = document.getElementById('salesEmptyState');
        const workArea = document.getElementById('salesWorkArea');
        const countLabel = document.getElementById('orderCountLabel');
        const countLabelEmpty = document.getElementById('orderCountLabelEmpty');
        const soDem = orders.length + '/' + MAX_ORDERS + ' đơn';
        if (countLabel) countLabel.textContent = soDem;
        if (countLabelEmpty) countLabelEmpty.textContent = soDem;

        const btnTaoDonHang = document.getElementById('btnTaoDonHang');
        const dayRoi = orders.length >= MAX_ORDERS;
        if (btnTaoDonHang) btnTaoDonHang.disabled = dayRoi;

        if (!orders.length) {
            // Chưa có đơn hàng nào: chỉ hiện danh, ẩn hết khu vực làm việc
            bar.style.display = 'none';
            headRow.style.display = 'none';
            emptyState.style.display = 'block';
            workArea.style.display = 'none';
            bar.innerHTML = '';
            return;
        }

        headRow.style.display = 'flex';
        bar.style.display = 'flex';
        emptyState.style.display = 'none';
        workArea.style.display = 'block';

        let html = orders.map((o, idx) => {
            const active = o.id === activeOrderId;
            const total = o.cart.reduce((s, c) => s + c.soLuong, 0);
            return '<div class="order-tab' + (active ? ' active' : '') + '" onclick="chonDon(\'' + o.id + '\')">' +
                '<span>Đơn ' + (idx + 1) + '</span>' +
                (total ? '<span class="badge">' + total + '</span>' : '') +
                htmlHetHan(o) +
                '<i class="bi bi-x-lg order-tab-close" title="Xóa đơn" onclick="event.stopPropagation(); xoaDon(\'' + o.id + '\')"></i>' +
                '</div>';
        }).join('');

        const btnHtml = '<button type="button" class="btn-them-don" id="btnThemDon" ' +
            (dayRoi ? 'disabled title="Đã đạt tối đa ' + MAX_ORDERS + ' đơn chờ"' : 'title="Thêm đơn mới"') +
            ' onclick="taoDonMoi()"><i class="bi bi-plus-lg"></i></button>';

        bar.innerHTML = '<div class="order-tabs-list" id="orderTabsList">' + html + '</div>' + btnHtml;
    }

    // Huy hiệu đếm ngược thời gian còn lại trước khi 1 đơn chờ (đã lưu server) tự động bị hủy.
    // Chỉ hiện với đơn đã "Giữ đơn" (có ngayTao); đơn đang soạn dở cục bộ chưa lưu thì không có hạn.
    function htmlHetHan(don) {
        const conLai = thoiGianConLai(don);
        if (conLai === null) return '';
        if (conLai <= 0) return '<span class="badge" style="background:#dc3545;" title="Sắp bị hệ thống tự động hủy">Quá hạn</span>';
        const gioConLai = conLai / 3600000;
        const sapHetHan = gioConLai <= 2; // còn dưới 2 giờ -> cảnh báo màu đỏ
        const nhan = gioConLai >= 1 ? Math.ceil(gioConLai) + 'h' : Math.ceil(conLai / 60000) + 'p';
        return '<span class="badge" style="background:' + (sapHetHan ? '#dc3545' : '#6c757d') + ';" ' +
            'title="Tự động hủy sau ' + nhan + ' nếu chưa thanh toán/hủy (hạn giữ đơn ' + HAN_GIU_DON_GIO + 'h)">' +
            '<i class="bi bi-clock-history"></i> ' + nhan + '</span>';
    }

    // ============== ĐỒNG BỘ "ĐƠN HÀNG CHỜ" ĐÃ LƯU TRÊN SERVER ==============
    // Nạp danh sách hóa đơn chờ (trạng thái 0) đã được lưu vào CSDL qua "Giữ đơn", để nhân viên
    // xem lại được cả sau khi tải lại trang / đổi máy. Đơn nào đã quá 24h sẽ được backend tự động
    // hủy trước khi trả về danh sách, nên tự "biến mất" khỏi các tab mà không cần thao tác gì thêm.
    function taiDanhSachHoaDonChoTuServer() {
        return fetch(ctx + '/ban-hang-tai-quay?action=hoaDonCho')
            .then(r => r.json())
            .then(data => {
                if (!data.success) return;
                const idConLai = new Set(data.items.map(it => it.id));

                // Bỏ khỏi bộ nhớ những đơn đã lưu server nhưng nay không còn (đã bị tự động hủy quá 24h,
                // hoặc bị hủy/xử lý từ máy khác) - trừ đơn đang mở dở (activeOrderId) sẽ được cảnh báo riêng.
                orders = orders.filter(o => !o.idHoaDonCho || idConLai.has(o.idHoaDonCho));
                if (activeOrderId && !orders.find(o => o.id === activeOrderId)) {
                    activeOrderId = orders.length ? orders[0].id : null;
                    napDonVaoForm();
                }

                data.items.forEach(item => {
                    const existed = orders.find(o => o.idHoaDonCho === item.id);
                    if (existed) {
                        existed.ngayTao = item.ngayTao; // cập nhật lại hạn cho đúng
                        return;
                    }
                    orders.push({
                        id: 'srv_' + item.id,
                        sdt: item.sdtKhachHang || '', tenKh: item.tenKhachHang || '',
                        email: '', diaChi: '', ghiChu: '', voucherId: '', voucherAuto: true,
                        khStatusHtml: '', phuongThucThanhToan: 'tien_mat', tienKhachDua: '', tienKhachDuaAuto: true,
                        cart: [], idHoaDonCho: item.id, ngayTao: item.ngayTao, daTaiChiTiet: false
                    });
                });

                if (!activeOrderId && orders.length) {
                    activeOrderId = orders[0].id;
                    taiChiTietHoaDonChoNeuCan(orders[0]).then(() => {
                        napDonVaoForm();
                        renderCart();
                        renderProductTable(currentPageItems);
                    });
                }
                renderOrderTabs();
            })
            .catch(() => { /* im lặng bỏ qua lỗi mạng khi đồng bộ nền, tránh làm phiền thu ngân */ });
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

    // ============== POPUP CHỌN NHANH MỆNH GIÁ TIỀN KHÁCH ĐƯA ==============
    (function initQuickCashPicker() {
        var CASH_PRESETS = [50000, 100000, 200000, 500000, 1000000];
        var picker = document.getElementById('quickCashPicker');
        var grid = document.getElementById('quickCashGrid');
        var closeBtn = document.getElementById('quickCashClose');
        var input = document.getElementById('tienKhachDuaInput');
        var active = null;

        if (!picker || !grid || !input) { return; }

        CASH_PRESETS.forEach(function (value) {
            var btn = document.createElement('button');
            btn.type = 'button';
            btn.className = 'quick-cash__btn';
            btn.textContent = formatTien(value);
            btn.setAttribute('data-value', String(value));
            grid.appendChild(btn);
        });

        function close() {
            picker.style.display = 'none';
            active = null;
        }

        function open(target) {
            active = target;
            var rect = target.getBoundingClientRect();
            picker.style.left = Math.max(12, rect.left) + 'px';
            picker.style.top = (rect.bottom + 6) + 'px';
            picker.style.display = 'block';
        }

        document.addEventListener('focusin', function (event) {
            if (event.target === input) {
                open(input);
            } else if (!picker.contains(event.target)) {
                close();
            }
        });

        grid.addEventListener('mousedown', function (event) {
            var btn = event.target.closest('.quick-cash__btn');
            if (!btn || !active) { return; }
            event.preventDefault();
            active.value = btn.getAttribute('data-value');
            active.dispatchEvent(new Event('input', { bubbles: true }));
            close();
        });

        if (closeBtn) {
            closeBtn.addEventListener('mousedown', function (event) { event.preventDefault(); close(); });
        }

        document.addEventListener('mousedown', function (event) {
            if (picker.style.display === 'block' && !picker.contains(event.target) && event.target !== active) {
                close();
            }
        });

        document.addEventListener('keydown', function (event) {
            if (event.key === 'Escape') { close(); }
        });
    }());

    function showAlert(type, msg) {
        document.getElementById('alertBox').innerHTML =
            '<div class="alert alert-' + type + ' alert-dismissible fade show" role="alert">' + msg +
            '<button type="button" class="btn-close" data-bs-dismiss="alert"></button></div>';
    }

    // ============== BỘ LỌC + TÌM SẢN PHẨM (trong modal) ==============
    // Hỗ trợ cả 2 cách: bấm Enter/gõ tìm ngay (live search có debounce), VÀ đổi bộ lọc/trang.
    let timSanPhamController = null;
    let timSanPhamDebounce = null;

    // Tải danh sách màu / size / khoảng giá đang bán, dùng để dựng bộ lọc (gọi 1 lần khi trang tải xong)
    function taiBoLocSanPham() {
        fetch(ctx + '/ban-hang-tai-quay?action=boLocSanPham')
            .then(r => r.json())
            .then(data => {
                if (!data.success) return;
                boLoc.mauSac = data.mauSac || [];
                boLoc.size = data.size || [];
                boLoc.giaMin = Math.floor(Number(data.giaMin) || 0);
                boLoc.giaMax = Math.ceil(Number(data.giaMax) || 0);
                if (boLoc.giaMax <= boLoc.giaMin) boLoc.giaMax = boLoc.giaMin + 1000;

                const selMau = document.getElementById('filterMauSac');
                selMau.innerHTML = '<option value="">-- Chọn màu sắc --</option>' +
                    boLoc.mauSac.map(m => '<option value="' + m.id + '">' + m.ten + '</option>').join('');

                const selSize = document.getElementById('filterSize');
                selSize.innerHTML = '<option value="">-- Chọn size --</option>' +
                    boLoc.size.map(s => '<option value="' + s.id + '">' + s.ten + '</option>').join('');

                const giaMinInput = document.getElementById('filterGiaMin');
                const giaMaxInput = document.getElementById('filterGiaMax');
                [giaMinInput, giaMaxInput].forEach(el => {
                    el.min = boLoc.giaMin; el.max = boLoc.giaMax;
                    el.step = Math.max(1000, Math.round((boLoc.giaMax - boLoc.giaMin) / 100));
                });
                giaMinInput.value = boLoc.giaMin;
                giaMaxInput.value = boLoc.giaMax;
                capNhatPriceRangeUI();
            })
            .catch(() => {});
    }

    // ============== Thanh trượt khoảng giá (2 đầu kéo) ==============
    function capNhatPriceRangeUI() {
        const minInput = document.getElementById('filterGiaMin');
        const maxInput = document.getElementById('filterGiaMax');
        let vMin = parseFloat(minInput.value), vMax = parseFloat(maxInput.value);
        if (vMin > vMax) { const t = vMin; vMin = vMax; vMax = t; }
        document.getElementById('priceRangeMinLabel').textContent = formatTien(vMin);
        document.getElementById('priceRangeMaxLabel').textContent = formatTien(vMax);
    }

    (function initPriceRange() {
        const minInput = document.getElementById('filterGiaMin');
        const maxInput = document.getElementById('filterGiaMax');
        if (!minInput || !maxInput) return;
        minInput.addEventListener('input', function () {
            if (parseFloat(minInput.value) > parseFloat(maxInput.value)) minInput.value = maxInput.value;
            capNhatPriceRangeUI();
        });
        maxInput.addEventListener('input', function () {
            if (parseFloat(maxInput.value) < parseFloat(minInput.value)) maxInput.value = minInput.value;
            capNhatPriceRangeUI();
        });
        minInput.addEventListener('change', () => timSanPhamLive());
        maxInput.addEventListener('change', () => timSanPhamLive());
    }());

    function timSanPham() {
        clearTimeout(timSanPhamDebounce);
        const keyword = document.getElementById('searchInput').value.trim();
        const mauSac = document.getElementById('filterMauSac').value;
        const size = document.getElementById('filterSize').value;
        const giaMin = document.getElementById('filterGiaMin').value;
        const giaMax = document.getElementById('filterGiaMax').value;
        const tonKho = (document.querySelector('input[name="filterTonKho"]:checked') || {}).value || 'tat-ca';
        const status = document.getElementById('productSearchStatus');
        const tbody = document.getElementById('productTableBody');

        if (timSanPhamController) timSanPhamController.abort();
        timSanPhamController = new AbortController();

        if (status) status.innerHTML = '<span class="spinner-border spinner-border-sm"></span> Đang tìm sản phẩm...';

        const params = new URLSearchParams({
            action: 'timSanPham', keyword: keyword,
            mauSac: mauSac, size: size, giaMin: giaMin, giaMax: giaMax, tonKho: tonKho,
            page: pageState.page, pageSize: pageState.pageSize
        });

        fetch(ctx + '/ban-hang-tai-quay?' + params.toString(), { signal: timSanPhamController.signal })
            .then(r => r.json())
            .then(data => {
                currentPageItems = data.items || [];
                if (data.pagination) {
                    pageState.page = data.pagination.page;
                    pageState.pageSize = data.pagination.pageSize;
                    pageState.totalItems = data.pagination.totalItems;
                    pageState.totalPages = data.pagination.totalPages;
                }
                renderProductTable(currentPageItems);
                capNhatPhanTrangUI();
                if (status) status.textContent = '';
            })
            .catch(err => {
                if (err && err.name === 'AbortError') return;
                tbody.innerHTML = '<tr><td colspan="9" class="cart-empty">Không tải được danh sách sản phẩm</td></tr>';
                if (status) status.textContent = '';
            });
    }

    function timSanPhamLive() {
        clearTimeout(timSanPhamDebounce);
        pageState.page = 1;
        timSanPhamDebounce = setTimeout(timSanPham, 350);
    }

    function capNhatPhanTrangUI() {
        document.getElementById('pageInfoLabel').textContent = pageState.page + '/' + pageState.totalPages;
        document.getElementById('ketQuaLocLabel').textContent =
            'Hiển thị ' + currentPageItems.length + ' \u00b7 Tổng sau lọc ' + pageState.totalItems;
        document.getElementById('btnTrangTruoc').disabled = pageState.page <= 1;
        document.getElementById('btnTrangSau').disabled = pageState.page >= pageState.totalPages;
    }

    function renderProductTable(items) {
        items.forEach(p => productCache[p.id] = p);
        const tbody = document.getElementById('productTableBody');
        if (!items.length) {
            tbody.innerHTML = '<tr><td colspan="9" class="cart-empty">Không tìm thấy sản phẩm phù hợp</td></tr>';
            return;
        }
        tbody.innerHTML = items.map((p, idx) => {
            const soLuongDaChon = tongDaChonTatCaDon(p.id);
            const conLai = p.soLuongTon - soLuongDaChon;
            const hetHang = conLai <= 0;
            const anhHtml = p.hinhAnh
                ? '<img class="thumb-sm" src="' + ctx + '/' + p.hinhAnh + '" alt="" loading="lazy">'
                : '<span class="thumb-sm"><i class="bi bi-image"></i></span>';
            return '<tr class="' + (hetHang ? 'row-disabled' : '') + '">' +
                '<td>' + ((pageState.page - 1) * pageState.pageSize + idx + 1) + '</td>' +
                '<td>' + (p.ma || '') + '</td>' +
                '<td>' + anhHtml + '</td>' +
                '<td>' + (p.tenSanPham || '') + '</td>' +
                '<td>' + (p.mauSac || '') + '</td>' +
                '<td>' + (p.kichThuoc || '') + '</td>' +
                '<td>' + conLai + '</td>' +
                '<td class="gia-cell">' + formatTien(p.giaBan) + '</td>' +
                '<td><button type="button" class="btn-outline-black btn-sm" ' +
                (hetHang ? 'disabled' : 'onclick="themVaoGio(' + p.id + ')"') + '>Chọn</button></td>' +
                '</tr>';
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
        renderProductTable(currentPageItems);
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
        renderProductTable(currentPageItems);
    };

    window.xoaKhoiGio = function (index) {
        cart.splice(index, 1);
        renderCart();
        renderOrderTabs();
        renderProductTable(currentPageItems);
    };

    function tinhTienHang() {
        return cart.reduce((s, c) => s + c.giaBan * c.soLuong, 0);
    }

    function tinhTienGiam(tongTienHang) {
        const don = donHienTai();
        const id = don ? don.voucherId : '';
        if (!id) return 0;
        const v = vouchers.find(v => String(v.id) === String(id));
        if (!v) return 0;
        return tinhGiamTheoVoucher(v, tongTienHang);
    }

    // Số tiền một voucher cụ thể sẽ giảm được cho tổng tiền hàng hiện tại (0 nếu chưa đủ điều kiện)
    function tinhGiamTheoVoucher(v, tongTienHang) {
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

    // Xếp hạng toàn bộ voucher theo số tiền giảm được cho tổng tiền hàng hiện tại, cao xuống thấp
    function xepHangVoucher(tongTienHang) {
        return vouchers
            .map(v => ({ v: v, giam: tinhGiamTheoVoucher(v, tongTienHang) }))
            .sort((a, b) => b.giam - a.giam);
    }

    const RANK_LABELS = ['🥇', '🥈', '🥉'];
    let voucherTabActive = 'best';

    function moTaVoucher(v) {
        return v.loaiGiamGia === '%' ? (v.giaTriGiamGia + '%') : formatTien(v.giaTriGiamGia);
    }

    // Chuyển tab "Mã tốt nhất" / "Mã thay thế"
    window.chonTabVoucher = function (tab) {
        voucherTabActive = tab;
        document.getElementById('tabVoucherBest').classList.toggle('active', tab === 'best');
        document.getElementById('tabVoucherAlt').classList.toggle('active', tab === 'alt');
        document.getElementById('voucherBestPane').style.display = tab === 'best' ? 'block' : 'none';
        document.getElementById('voucherAltPane').style.display = tab === 'alt' ? 'block' : 'none';
    };

    // Chọn 1 mã (id rỗng = không dùng voucher). auto=true khi bấm "Dùng mã này" ở tab tốt nhất
    // (đơn sẽ tự cập nhật theo mã tốt nhất mỗi khi giỏ hàng thay đổi); auto=false khi chọn tay ở tab thay thế.
    window.chonVoucher = function (id, auto) {
        const don = donHienTai();
        if (!don) return;
        don.voucherId = id || '';
        don.voucherAuto = !!auto;
        renderCart();
    };

    // Dựng lại 2 tab "Mã tốt nhất" / "Mã thay thế" theo thứ tự số tiền giảm được, cao xuống thấp.
    // Nếu đơn đang ở chế độ tự động (voucherAuto), sẽ tự áp dụng mã giảm nhiều nhất còn đủ điều kiện.
    function capNhatVoucherUI() {
        const don = donHienTai();
        const bestPane = document.getElementById('voucherBestPane');
        const altPane = document.getElementById('voucherAltPane');
        const hint = document.getElementById('voucherHint');
        if (!bestPane || !altPane) return;

        if (!vouchers.length) {
            bestPane.innerHTML = '<div class="voucher-empty"><i class="bi bi-slash-circle"></i> Hiện chưa có phiếu giảm giá nào còn hiệu lực trong hệ thống.</div>';
            altPane.innerHTML = '';
            if (hint) hint.textContent = '';
            if (don) { don.voucherId = ''; don.voucherAuto = true; }
            return;
        }
        if (hint) hint.textContent = '';

        const tongTienHang = tinhTienHang();
        const xepHang = xepHangVoucher(tongTienHang);
        const eligible = xepHang.filter(it => it.giam > 0);
        const locked = xepHang.filter(it => it.giam === 0)
            .sort((a, b) => (a.v.donToiThieu || 0) - (b.v.donToiThieu || 0));
        const best = eligible[0] || null;

        if (don) {
            if (don.voucherAuto) {
                don.voucherId = best ? String(best.v.id) : '';
            } else if (don.voucherId && !vouchers.find(v => String(v.id) === String(don.voucherId))) {
                // mã đã chọn không còn tồn tại/hết hiệu lực -> quay lại không dùng voucher
                don.voucherId = '';
                don.voucherAuto = true;
            }
        }
        const currentId = don ? (don.voucherId || '') : '';

        // ----- Tab "Mã tốt nhất" -----
        if (best) {
            const dangDung = currentId && String(currentId) === String(best.v.id);
            bestPane.innerHTML =
                '<div class="voucher-card ' + (dangDung ? 'voucher-card-active' : '') + '">' +
                '<div class="voucher-card-top"><span class="voucher-badge">🥇 Tốt nhất</span>' +
                (dangDung ? '<span class="voucher-applied"><i class="bi bi-check-circle-fill"></i> Đang áp dụng</span>' : '') +
                '</div>' +
                '<div class="voucher-code">' + best.v.maVoucher + '</div>' +
                '<div class="voucher-name">' + best.v.tenVoucher + '</div>' +
                '<div class="voucher-desc">Giảm ' + moTaVoucher(best.v) + ' &middot; Tiết kiệm <strong>' + formatTien(best.giam) + '</strong></div>' +
                (dangDung
                    ? '<button type="button" class="btn btn-sm btn-outline-secondary mt-2" onclick="chonVoucher(\'\', false)">Không dùng voucher</button>'
                    : '<button type="button" class="btn btn-sm btn-dark mt-2" onclick="chonVoucher(\'' + best.v.id + '\', true)">Dùng mã này</button>') +
                '</div>';
        } else {
            let goiY = '';
            if (locked.length) {
                const gan = locked[0];
                const conThieu = (gan.v.donToiThieu || 0) - tongTienHang;
                goiY = '<div class="voucher-suggest"><i class="bi bi-lightbulb"></i> Mua thêm <strong>' +
                    formatTien(conThieu > 0 ? conThieu : 0) + '</strong> để dùng mã <strong>' + gan.v.maVoucher +
                    '</strong> (giảm ' + moTaVoucher(gan.v) + ')</div>';
            }
            bestPane.innerHTML = '<div class="voucher-empty"><i class="bi bi-slash-circle"></i> Chưa có mã nào áp dụng được cho đơn này.</div>' + goiY;
        }

        // ----- Tab "Mã thay thế" (các mã còn lại, giảm dần; mã chưa đủ điều kiện xếp cuối) -----
        const others = eligible.slice(best ? 1 : 0).concat(locked);
        let altHtml = '<div class="voucher-alt-item ' + (!currentId ? 'active' : '') + '" onclick="chonVoucher(\'\', false)">' +
            '<span class="voucher-alt-code">—</span><span class="voucher-alt-desc">Không dùng voucher</span></div>';
        if (!others.length) {
            altHtml += '<div class="voucher-empty">Không còn mã thay thế nào khác.</div>';
        } else {
            altHtml += others.map(item => {
                const v = item.v;
                const active = currentId && String(currentId) === String(v.id);
                if (item.giam > 0) {
                    return '<div class="voucher-alt-item ' + (active ? 'active' : '') + '" onclick="chonVoucher(\'' + v.id + '\', false)">' +
                        '<span class="voucher-alt-code">' + v.maVoucher + '</span>' +
                        '<span class="voucher-alt-desc">' + v.tenVoucher + ' &middot; Giảm ' + moTaVoucher(v) + '</span>' +
                        '<span class="voucher-alt-amt">-' + formatTien(item.giam) + '</span>' +
                        '</div>';
                }
                const conThieu = (v.donToiThieu || 0) - tongTienHang;
                return '<div class="voucher-alt-item locked">' +
                    '<span class="voucher-alt-code">🔒 ' + v.maVoucher + '</span>' +
                    '<span class="voucher-alt-desc">' + v.tenVoucher + ' &middot; Giảm ' + moTaVoucher(v) + '</span>' +
                    '<span class="voucher-alt-amt text-muted">Thiếu ' + formatTien(conThieu > 0 ? conThieu : 0) + '</span>' +
                    '</div>';
            }).join('');
        }
        altPane.innerHTML = altHtml;
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
        capNhatVoucherUI();
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
                capNhatVoucherUI();
                renderCart();
            });
    }

    // ============== PHƯƠNG THỨC THANH TOÁN ==============
    window.chonPhuongThuc = function (pt) {
        const don = donHienTai();
        if (don) don.phuongThucThanhToan = pt;
        document.getElementById('btnPtTienMat').classList.toggle('active', pt === 'tien_mat');
        document.getElementById('btnPtQR').classList.toggle('active', pt === 'qr');
        document.getElementById('tienMatBox').style.display = pt === 'tien_mat' ? 'block' : 'none';
        document.getElementById('qrBox').style.display = pt === 'qr' ? 'block' : 'none';
        if (pt === 'qr') capNhatQR();
        if (pt === 'tien_mat') capNhatTienThua();
    };

    // Tự điền "Tiền khách đưa" = đúng số tiền phải trả của đơn (chỉ khi đang ở chế độ tự động).
    // Khách đưa nhiều hơn -> thu ngân tự sửa lại ô này, hệ thống sẽ không ghi đè nữa cho tới khi
    // bấm "Dùng số tiền vừa đủ" hoặc chuyển sang đơn khác.
    function capNhatTienThua() {
        const don = donHienTai();
        const tong = tongPhaiTra();
        const input = document.getElementById('tienKhachDuaInput');
        const resetLink = document.getElementById('tienKhachDuaAutoReset');
        if (don && don.tienKhachDuaAuto && don.phuongThucThanhToan !== 'qr') {
            const tongLamTron = Math.round(tong);
            input.value = tongLamTron > 0 ? tongLamTron : '';
            don.tienKhachDua = input.value;
        }
        if (resetLink) resetLink.style.display = (don && !don.tienKhachDuaAuto) ? 'inline' : 'none';
        const dua = parseFloat(input.value) || 0;
        const thua = Math.max(0, dua - tong);
        document.getElementById('sumThua').textContent = formatTien(thua);
    }
    document.getElementById('tienKhachDuaInput').addEventListener('input', function () {
        // Người dùng vừa tự tay sửa số tiền khách đưa (ví dụ khách đưa nhiều hơn) -> tắt tự động
        const don = donHienTai();
        if (don) {
            don.tienKhachDuaAuto = false;
            don.tienKhachDua = this.value;
        }
        capNhatTienThua();
    });
    document.getElementById('tienKhachDuaAutoReset') && document.getElementById('tienKhachDuaAutoReset').addEventListener('click', function () {
        const don = donHienTai();
        if (!don) return;
        don.tienKhachDuaAuto = true;
        capNhatTienThua();
    });

    // maThamChieu do server sinh ra cho phiên QR đang chờ (dùng để poll trạng thái + nhúng vào nội dung CK).
    // qrPollTimer: id của setInterval đang chạy polling, để có thể clearInterval khi đóng modal.
    let qrPhienHienTai = null;
    let qrPollTimer = null;

    // Hiển thị QR dùng mã tham chiếu đã có sẵn (do server cấp trong taoPhienQR). Chỉ vẽ lại ảnh QR,
    // KHÔNG gọi server (dùng khi chỉ cần re-render, ví dụ khi đổi phương thức thanh toán trước khi bấm Thanh toán).
    function capNhatQR() {
        const tong = tongPhaiTra();
        const maThamChieu = qrPhienHienTai ? qrPhienHienTai.maThamChieu : '';
        const noiDung = maThamChieu ? ('Thanh toan don hang ' + maThamChieu) : 'Thanh toan don hang';
        const url = 'https://img.vietqr.io/image/' + QR_BANK_BIN + '-' + QR_ACCOUNT_NO + '-compact2.png' +
            '?amount=' + Math.round(tong) +
            '&addInfo=' + encodeURIComponent(noiDung) +
            '&accountName=' + encodeURIComponent(QR_ACCOUNT_NAME);
        document.getElementById('qrImage').src = url;
        document.getElementById('qrAmount').textContent = formatTien(tong);
        // Ảnh + số tiền hiển thị trong modal QR lớn giữa màn hình dùng chung 1 URL với ô QR nhỏ.
        const qrImgBig = document.getElementById('qrImageBig');
        const qrAmtBig = document.getElementById('qrAmountBig');
        if (qrImgBig) qrImgBig.src = url;
        if (qrAmtBig) qrAmtBig.textContent = formatTien(tong);
    }

    // Gọi server mở 1 phiên QR mới (chưa tạo hóa đơn) -> nhận về mã tham chiếu duy nhất để nhúng vào QR.
    function moPhienQR(payload) {
        payload.soTienDuKien = tongPhaiTra();
        return fetch(ctx + '/ban-hang-tai-quay?action=taoPhienQR', {
            method: 'POST',
            headers: { 'Content-Type': 'application/json' },
            body: JSON.stringify(payload)
        }).then(r => r.json());
    }

    // Bắt đầu polling trạng thái phiên QR mỗi 3 giây, tự dừng khi thành công/lỗi/đóng modal.
    function batDauPollQR() {
        dungPollQR();
        qrPollTimer = setInterval(function () {
            if (!qrPhienHienTai) { dungPollQR(); return; }
            fetch(ctx + '/ban-hang-tai-quay?action=kiemTraQR&ma=' + encodeURIComponent(qrPhienHienTai.maThamChieu))
                .then(r => r.json())
                .then(data => {
                    if (!data.success) return;
                    if (data.trangThai === 'paid') {
                        dungPollQR();
                        document.getElementById('qrWaitingState').style.display = 'none';
                        document.getElementById('qrSuccessState').style.display = 'block';
                        hoanTatDonHienTai();
                        timSanPham();
                        taiVoucher();
                        setTimeout(function () {
                            window.location.href = ctx + '/quanlyhoadon?action=detail&id=' + data.idHoaDon + '&autoprint=1';
                        }, 1200);
                    } else if (data.trangThai === 'loi') {
                        const errBox = document.getElementById('qrErrorState');
                        errBox.textContent = data.message || 'Số tiền chuyển khoản không khớp, vui lòng kiểm tra lại hoặc xác nhận thủ công.';
                        errBox.style.display = 'block';
                    }
                    // trangThai === 'cho': tiếp tục chờ, không làm gì.
                })
                .catch(() => { /* lỗi mạng tạm thời khi poll -> bỏ qua, thử lại lượt sau */ });
        }, 3000);
    }

    function dungPollQR() {
        if (qrPollTimer) { clearInterval(qrPollTimer); qrPollTimer = null; }
    }

    // ============== GIỮ ĐƠN ==============
    // Lưu đơn đang soạn dở xuống CSDL (hóa đơn trạng thái "Chờ xử lý") để không bị mất khi tải lại
    // trang / đổi máy, và để hệ thống áp dụng đúng hạn tự động hủy sau 24h.
    document.getElementById('btnGiuDon').addEventListener('click', function () {
        if (!cart.length) {
            showAlert('warning', 'Giỏ hàng đang trống, không có gì để giữ.');
            return;
        }
        luuDonHienTai();
        const don = donHienTai();
        if (!don) return;

        const payload = {
            sdtKhachHang: don.sdt || '',
            tenKhachHang: don.tenKh || '',
            emailKhachHang: don.email || '',
            diaChiKhachHang: don.diaChi || '',
            idPhieuGiamGia: don.voucherId || null,
            ghiChu: don.ghiChu || '',
            gioHang: don.cart.map(c => ({ idSanPhamChiTiet: c.id, soLuong: c.soLuong })),
            idHoaDonCho: don.idHoaDonCho || null // != null nếu đang cập nhật lại 1 đơn đã giữ trước đó
        };

        const btn = this;
        btn.disabled = true;
        const noiDungCuBtn = btn.innerHTML;
        btn.innerHTML = '<span class="spinner-border spinner-border-sm"></span> Đang giữ đơn...';

        fetch(ctx + '/ban-hang-tai-quay?action=giuDon', {
            method: 'POST',
            headers: { 'Content-Type': 'application/json' },
            body: JSON.stringify(payload)
        })
            .then(r => r.json())
            .then(data => {
                if (!data.success) {
                    showAlert('danger', data.message || 'Không thể giữ đơn, vui lòng thử lại.');
                    return;
                }
                don.idHoaDonCho = data.idHoaDonCho;
                don.ngayTao = don.ngayTao || Date.now();
                don.daTaiChiTiet = true;
                renderOrderTabs();
                showAlert('success', 'Đã giữ đơn ' + data.maHoaDon + '. Đơn sẽ tự động hủy nếu chưa xử lý sau ' +
                    HAN_GIU_DON_GIO + ' giờ. Bạn có thể chọn lại đơn này bất cứ lúc nào ở "Đơn hàng chờ".');
                if (orders.length < MAX_ORDERS) {
                    taoDonMoi();
                }
            })
            .catch(() => showAlert('danger', 'Lỗi kết nối tới máy chủ, vui lòng thử lại.'))
            .finally(() => {
                btn.disabled = false;
                btn.innerHTML = noiDungCuBtn;
            });
    });

    // ============== THANH TOÁN ==============

    // Kiểm tra dữ liệu + dựng payload thanh toán dùng chung cho cả 2 phương thức (tiền mặt / QR).
    // Trả về payload hợp lệ, hoặc null nếu có lỗi (đã tự hiển thị thông báo lỗi).
    function chuanBiPayloadThanhToan() {
        const sdt = document.getElementById('sdtInput').value.trim();
        if (sdt && !/^\d{9,11}$/.test(sdt)) {
            showAlert('danger', 'Số điện thoại khách hàng chưa hợp lệ (9-11 số).');
            return null;
        }
        if (!cart.length) {
            showAlert('danger', 'Giỏ hàng đang trống, vui lòng chọn sản phẩm.');
            return null;
        }

        const email = document.getElementById('emailKhInput').value.trim();
        if (email && !/^[^\s@]+@[^\s@]+\.[^\s@]+$/.test(email)) {
            showAlert('danger', 'Email khách hàng không hợp lệ.');
            return null;
        }

        const diaChi = document.getElementById('diaChiKhInput').value.trim();
        if (!diaChi) {
            showAlert('danger', 'Vui lòng nhập địa chỉ khách hàng.');
            return null;
        }

        const pt = donHienTai() ? donHienTai().phuongThucThanhToan : 'tien_mat';
        let ghiChu = document.getElementById('ghiChuInput').value.trim();
        if (pt === 'tien_mat') {
            const tong = tongPhaiTra();
            const dua = parseFloat(document.getElementById('tienKhachDuaInput').value) || 0;
            if (dua < tong) {
                showAlert('danger', 'Số tiền khách đưa chưa đủ để thanh toán.');
                return null;
            }
            ghiChu = ('[Tiền mặt] ' + ghiChu).trim();
        } else {
            ghiChu = ('[Chuyển khoản QR] ' + ghiChu).trim();
        }

        return {
            sdtKhachHang: sdt,
            tenKhachHang: document.getElementById('tenKhInput').value.trim(),
            emailKhachHang: email,
            diaChiKhachHang: diaChi,
            idPhieuGiamGia: (donHienTai() && donHienTai().voucherId) || null,
            ghiChu: ghiChu,
            gioHang: cart.map(c => ({ idSanPhamChiTiet: c.id, soLuong: c.soLuong })),
            // Nếu đơn đang thanh toán là 1 đơn đã "Giữ đơn" trước đó (đã lưu server), truyền kèm id để
            // backend CẬP NHẬT chính hóa đơn chờ đó thành "Đã thanh toán" thay vì tạo hóa đơn mới.
            idHoaDonCho: (donHienTai() && donHienTai().idHoaDonCho) || null
        };
    }

    // Gọi API tạo hóa đơn/thanh toán, trả về Promise<data trả về từ server>.
    function guiYeuCauThanhToan(payload) {
        return fetch(ctx + '/ban-hang-tai-quay?action=thanhToan', {
            method: 'POST',
            headers: { 'Content-Type': 'application/json' },
            body: JSON.stringify(payload)
        }).then(r => r.json());
    }

    document.getElementById('btnThanhToan').addEventListener('click', function () {
        const pt = donHienTai() ? donHienTai().phuongThucThanhToan : 'tien_mat';

        // Phương thức QR: mở modal QR lớn giữa màn hình, chờ thu ngân xác nhận khách đã chuyển khoản
        // rồi mới thực sự tạo hóa đơn (không gọi API thanh toán ngay khi bấm nút này).
        if (pt === 'qr') {
            const payload = chuanBiPayloadThanhToan();
            if (!payload) return; // báo lỗi thiếu dữ liệu ngay tại đây nếu có

            const btnTT = this;
            btnTT.disabled = true;
            const noiDungCuBtn = btnTT.innerHTML;
            btnTT.innerHTML = '<span class="spinner-border spinner-border-sm"></span> Đang tạo mã QR...';

            moPhienQR(payload)
                .then(data => {
                    if (!data.success) {
                        showAlert('danger', data.message || 'Không tạo được mã QR thanh toán, vui lòng thử lại.');
                        return;
                    }
                    qrPhienHienTai = { maThamChieu: data.maThamChieu };
                    capNhatQR();
                    document.getElementById('qrWaitingState').style.display = 'inline-flex';
                    document.getElementById('qrSuccessState').style.display = 'none';
                    document.getElementById('qrErrorState').style.display = 'none';
                    const btnXacNhan = document.getElementById('btnXacNhanDaThanhToanQR');
                    btnXacNhan.disabled = false;
                    btnXacNhan.innerHTML = '<i class="bi bi-check2-circle"></i> Khách đã chuyển khoản xong';
                    new bootstrap.Modal(document.getElementById('modalQRPayment')).show();
                    // Hệ thống sẽ tự động phát hiện khi tiền về (qua webhook ngân hàng) và tự chuyển
                    // sang in hóa đơn. Nút "Khách đã chuyển khoản xong" chỉ dùng khi cần xác nhận tay.
                    batDauPollQR();
                })
                .catch(() => showAlert('danger', 'Lỗi kết nối tới máy chủ, vui lòng thử lại.'))
                .finally(() => {
                    btnTT.disabled = false;
                    btnTT.innerHTML = noiDungCuBtn;
                });
            return;
        }

        // Phương thức tiền mặt: giữ nguyên luồng cũ, thanh toán ngay khi bấm.
        const payload = chuanBiPayloadThanhToan();
        if (!payload) return;

        const btn = this;
        btn.disabled = true;
        btn.innerHTML = '<span class="spinner-border spinner-border-sm"></span> Đang xử lý...';

        guiYeuCauThanhToan(payload)
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

    // Nút dự phòng: thu ngân bấm xác nhận thủ công nếu đã kiểm tra thấy tiền về nhưng hệ thống
    // (webhook ngân hàng) chưa kịp tự phát hiện. Bình thường sẽ tự chuyển màn hình nhờ batDauPollQR().
    document.getElementById('btnXacNhanDaThanhToanQR').addEventListener('click', function () {
        const errBox = document.getElementById('qrErrorState');
        if (!qrPhienHienTai) {
            bootstrap.Modal.getInstance(document.getElementById('modalQRPayment'))?.hide();
            return;
        }

        const btn = this;
        btn.disabled = true;
        btn.innerHTML = '<span class="spinner-border spinner-border-sm"></span> Đang xác nhận...';
        errBox.style.display = 'none';

        fetch(ctx + '/ban-hang-tai-quay?action=xacNhanQR&ma=' + encodeURIComponent(qrPhienHienTai.maThamChieu), {
            method: 'POST'
        })
            .then(r => r.json())
            .then(data => {
                if (data.success) {
                    dungPollQR();
                    document.getElementById('qrWaitingState').style.display = 'none';
                    document.getElementById('qrSuccessState').style.display = 'block';
                    hoanTatDonHienTai();
                    timSanPham();
                    taiVoucher();
                    // Thông báo thành công + tự động chuyển sang màn in hóa đơn sau ít giây.
                    setTimeout(function () {
                        window.location.href = ctx + '/quanlyhoadon?action=detail&id=' + data.idHoaDon + '&autoprint=1';
                    }, 1200);
                } else {
                    errBox.textContent = data.message || 'Thanh toán thất bại, vui lòng thử lại.';
                    errBox.style.display = 'block';
                    btn.disabled = false;
                    btn.innerHTML = '<i class="bi bi-check2-circle"></i> Khách đã chuyển khoản xong';
                }
            })
            .catch(() => {
                errBox.textContent = 'Lỗi kết nối tới máy chủ, vui lòng thử lại.';
                errBox.style.display = 'block';
                btn.disabled = false;
                btn.innerHTML = '<i class="bi bi-check2-circle"></i> Khách đã chuyển khoản xong';
            });
    });

    // Đóng modal QR (hủy) -> dừng polling để khỏi tốn request vô ích, và xóa phiên đang theo dõi.
    document.getElementById('modalQRPayment').addEventListener('hidden.bs.modal', function () {
        dungPollQR();
        qrPhienHienTai = null;
    });

    document.getElementById('searchInput').addEventListener('keyup', function (e) {
        if (e.key === 'Enter') { pageState.page = 1; timSanPham(); }
    });
    // Live search: tự tìm khi người dùng đang gõ, không cần bấm nút hay Enter.
    document.getElementById('searchInput').addEventListener('input', timSanPhamLive);
    document.getElementById('filterMauSac').addEventListener('change', timSanPhamLive);
    document.getElementById('filterSize').addEventListener('change', timSanPhamLive);
    document.querySelectorAll('input[name="filterTonKho"]').forEach(function (r) {
        r.addEventListener('change', timSanPhamLive);
    });

    document.getElementById('btnDatLaiLoc').addEventListener('click', function () {
        document.getElementById('searchInput').value = '';
        document.getElementById('filterMauSac').value = '';
        document.getElementById('filterSize').value = '';
        document.getElementById('filterGiaMin').value = boLoc.giaMin;
        document.getElementById('filterGiaMax').value = boLoc.giaMax;
        capNhatPriceRangeUI();
        const rTatCa = document.querySelector('input[name="filterTonKho"][value="tat-ca"]');
        if (rTatCa) rTatCa.checked = true;
        pageState.page = 1;
        timSanPham();
    });
    document.getElementById('btnTaiLaiLoc').addEventListener('click', function () {
        timSanPham();
    });

    document.getElementById('btnTrangTruoc').addEventListener('click', function () {
        if (pageState.page > 1) { pageState.page--; timSanPham(); }
    });
    document.getElementById('btnTrangSau').addEventListener('click', function () {
        if (pageState.page < pageState.totalPages) { pageState.page++; timSanPham(); }
    });
    document.getElementById('pageSizeSelect').addEventListener('change', function () {
        pageState.pageSize = parseInt(this.value, 10) || 10;
        pageState.page = 1;
        timSanPham();
    });

    // Mỗi lần mở lại modal thêm sản phẩm, tải lại danh sách mới nhất (kể cả khi
    // ô tìm kiếm/bộ lọc đang có sẵn giá trị từ lần trước).
    document.getElementById('modalThemSanPham').addEventListener('shown.bs.modal', function () {
        document.getElementById('searchInput').focus();
        timSanPham();
    });

    // Khởi tạo: hiện danh sách rỗng cho tới khi bấm "Tạo đơn hàng", đồng thời nạp lại các đơn
    // hàng chờ đã "Giữ đơn" từ trước (còn trong hạn 24h) đang lưu trên server.
    renderOrderTabs();
    taiVoucher();
    taiBoLocSanPham();
    taiDanhSachHoaDonChoTuServer();

    // Đồng bộ định kỳ với server: giúp các tab hết hạn 24h tự "biến mất" khỏi Đơn hàng chờ
    // trong vòng vài phút (không cần tải lại trang thủ công).
    setInterval(taiDanhSachHoaDonChoTuServer, 3 * 60 * 1000);
    // Cập nhật riêng huy hiệu đếm ngược mỗi phút mà không cần gọi server, cho mượt hơn.
    setInterval(renderOrderTabs, 60 * 1000);

    // ================= QUÉT MÃ QR BIẾN THỂ (camera hoặc tải ảnh lên) =================
    (function initQrScan() {
        const modalEl = document.getElementById('modalQuetQR');
        const video = document.getElementById('qrVideo');
        const hint = document.getElementById('qrCameraHint');
        const cameraErrorEl = document.getElementById('qrCameraError');
        const resultEl = document.getElementById('qrScanResult');
        const uploadInput = document.getElementById('qrUploadInput');
        const uploadCanvas = document.getElementById('qrUploadCanvas');

        let stream = null;
        let scanLoopId = null;
        const scanCanvas = document.createElement('canvas');
        const scanCtx = scanCanvas.getContext('2d', { willReadFrequently: true });

        // Chống quét trùng: cùng 1 mã trong 1.5s chỉ xử lý 1 lần, để cashier có thể
        // giữ camera trước mã và nó tự cộng thêm số lượng liên tục khi cần.
        const CHO_QUET_LAI_MS = 1500;
        let maCuoiCung = null;
        let lucQuetCuoi = 0;
        // Đang chờ cashier xác nhận Thêm/Hủy cho 1 sản phẩm vừa quét -> tạm dừng xử lý mã mới,
        // tránh vừa hiện xác nhận vừa liên tục quét trùng đè lên nhau.
        let dangChoXacNhan = false;

        function hienKetQua(type, msg) {
            resultEl.innerHTML = '<div class="alert alert-' + type + ' py-2 px-3 mb-0">' + msg + '</div>';
        }

        function hienXacNhanSanPham(p) {
            const anhHtml = p.hinhAnh
                ? '<img src="' + ctx + '/' + p.hinhAnh + '" style="width:60px;height:60px;object-fit:cover;border-radius:10px;border:1px solid #dedede;flex:none;">'
                : '<span style="width:60px;height:60px;flex:none;display:grid;place-items:center;border-radius:10px;border:1px solid #dedede;background:#f5f5f5;color:#999;font-size:22px;"><i class="bi bi-image"></i></span>';
            const hetHang = p.soLuongTon <= 0;

            resultEl.innerHTML =
                '<div class="border rounded-3 p-3">' +
                '<div class="d-flex gap-3 align-items-center">' +
                anhHtml +
                '<div class="flex-grow-1" style="min-width:0;">' +
                '<div class="fw-bold text-truncate">' + (p.tenSanPham || '') + '</div>' +
                '<div class="text-muted small">' + (p.mauSac || '') + ' / ' + (p.kichThuoc || '') + ' &middot; Mã ' + (p.ma || '') + '</div>' +
                '<div class="fw-semibold">' + formatTien(p.giaBan) + ' <span class="text-muted small fw-normal">&middot; ' +
                (hetHang ? '<span class="text-danger">Hết hàng</span>' : 'Còn ' + p.soLuongTon) + '</span></div>' +
                '</div>' +
                '</div>' +
                '<div class="d-flex gap-2 mt-3">' +
                '<button type="button" class="btn btn-outline-secondary flex-grow-1" id="btnHuyThemQR">Hủy</button>' +
                '<button type="button" class="btn btn-dark flex-grow-1" id="btnXacNhanThemQR" ' + (hetHang ? 'disabled' : '') + '>' +
                '<i class="bi bi-cart-plus me-1"></i>Thêm vào giỏ</button>' +
                '</div>' +
                '</div>';

            document.getElementById('btnXacNhanThemQR').addEventListener('click', function () {
                productCache[p.id] = p;
                const truocDo = cart.find(c => c.id === p.id);
                const soLuongTruoc = truocDo ? truocDo.soLuong : 0;
                themVaoGio(p.id);
                const sauDo = cart.find(c => c.id === p.id);
                if (sauDo && sauDo.soLuong > soLuongTruoc) {
                    hienKetQua('success', '<i class="bi bi-check-circle me-1"></i>Đã thêm <strong>' +
                        p.tenSanPham + '</strong> (' + p.mauSac + ' / ' + p.kichThuoc + ') &mdash; mã ' + p.ma);
                }
                // Cảnh báo hết hàng/đã giữ ở đơn khác đã được showAlert() hiển thị bên trong themVaoGio() nếu có.
                dangChoXacNhan = false;
                maCuoiCung = null; // cho phép quét lại cùng mã ngay (ví dụ thêm thêm 1 lần nữa)
            });
            document.getElementById('btnHuyThemQR').addEventListener('click', function () {
                resultEl.innerHTML = '';
                dangChoXacNhan = false;
                maCuoiCung = null;
            });
        }

        function xuLyMaQuetDuoc(ma) {
            if (dangChoXacNhan) return;
            const bayGio = Date.now();
            if (ma === maCuoiCung && (bayGio - lucQuetCuoi) < CHO_QUET_LAI_MS) return;
            maCuoiCung = ma;
            lucQuetCuoi = bayGio;
            dangChoXacNhan = true;

            resultEl.innerHTML = '<div class="text-center text-muted small py-2"><span class="spinner-border spinner-border-sm me-1"></span>Đang tra cứu...</div>';

            fetch(ctx + '/ban-hang-tai-quay?action=timTheoMa&ma=' + encodeURIComponent(ma))
                .then(r => r.json())
                .then(data => {
                    if (!data.success || !data.item) {
                        hienKetQua('danger', '<i class="bi bi-x-circle me-1"></i>' + (data.message || 'Không tìm thấy sản phẩm với mã này.'));
                        dangChoXacNhan = false;
                        return;
                    }
                    hienXacNhanSanPham(data.item);
                })
                .catch(() => {
                    hienKetQua('danger', '<i class="bi bi-x-circle me-1"></i>Lỗi kết nối, thử lại.');
                    dangChoXacNhan = false;
                });
        }

        // ---------- Tab: quét bằng camera ----------
        function dungCamera() {
            if (scanLoopId) cancelAnimationFrame(scanLoopId);
            scanLoopId = null;
            if (stream) {
                stream.getTracks().forEach(t => t.stop());
                stream = null;
            }
            video.srcObject = null;
        }

        function vongLapQuetCamera() {
            if (!video || video.readyState !== video.HAVE_ENOUGH_DATA) {
                scanLoopId = requestAnimationFrame(vongLapQuetCamera);
                return;
            }
            scanCanvas.width = video.videoWidth;
            scanCanvas.height = video.videoHeight;
            scanCtx.drawImage(video, 0, 0, scanCanvas.width, scanCanvas.height);
            const anh = scanCtx.getImageData(0, 0, scanCanvas.width, scanCanvas.height);
            const ketQua = window.jsQR ? window.jsQR(anh.data, anh.width, anh.height) : null;
            if (ketQua && ketQua.data) {
                xuLyMaQuetDuoc(ketQua.data.trim());
            }
            scanLoopId = requestAnimationFrame(vongLapQuetCamera);
        }

        function batCamera() {
            cameraErrorEl.classList.add('d-none');
            if (!navigator.mediaDevices || !navigator.mediaDevices.getUserMedia) {
                cameraErrorEl.textContent = 'Trình duyệt không hỗ trợ truy cập camera.';
                cameraErrorEl.classList.remove('d-none');
                return;
            }
            navigator.mediaDevices.getUserMedia({ video: { facingMode: 'environment' } })
                .then(s => {
                    stream = s;
                    video.srcObject = s;
                    scanLoopId = requestAnimationFrame(vongLapQuetCamera);
                })
                .catch(() => {
                    cameraErrorEl.textContent = 'Không thể truy cập camera. Hãy cấp quyền camera cho trang, hoặc dùng tab "Tải ảnh QR lên".';
                    cameraErrorEl.classList.remove('d-none');
                });
        }

        // ---------- Tab: tải ảnh lên ----------
        uploadInput && uploadInput.addEventListener('change', function () {
            const file = this.files && this.files[0];
            if (!file) return;
            const img = new Image();
            img.onload = function () {
                uploadCanvas.width = img.width;
                uploadCanvas.height = img.height;
                const uctx = uploadCanvas.getContext('2d');
                uctx.drawImage(img, 0, 0);
                const anh = uctx.getImageData(0, 0, uploadCanvas.width, uploadCanvas.height);
                const ketQua = window.jsQR ? window.jsQR(anh.data, anh.width, anh.height) : null;
                URL.revokeObjectURL(img.src);
                if (ketQua && ketQua.data) {
                    xuLyMaQuetDuoc(ketQua.data.trim());
                } else {
                    hienKetQua('danger', '<i class="bi bi-x-circle me-1"></i>Không đọc được mã QR trong ảnh này, thử ảnh rõ nét hơn.');
                }
            };
            img.src = URL.createObjectURL(file);
        });

        // ---------- Chuyển tab ----------
        document.querySelectorAll('#qrScanTabs [data-qr-tab]').forEach(function (btn) {
            btn.addEventListener('click', function () {
                document.querySelectorAll('#qrScanTabs .nav-link').forEach(b => b.classList.remove('active'));
                btn.classList.add('active');
                const laCamera = btn.dataset.qrTab === 'camera';
                document.getElementById('qrPaneCamera').classList.toggle('d-none', !laCamera);
                document.getElementById('qrPaneUpload').classList.toggle('d-none', laCamera);
                if (laCamera) { batCamera(); } else { dungCamera(); }
            });
        });

        // ---------- Vòng đời modal ----------
        modalEl.addEventListener('shown.bs.modal', function () {
            resultEl.innerHTML = '';
            maCuoiCung = null;
            dangChoXacNhan = false;
            hint.classList.remove('d-none');
            const laCamera = !document.getElementById('qrPaneCamera').classList.contains('d-none');
            if (laCamera) batCamera();
        });
        modalEl.addEventListener('hidden.bs.modal', function () {
            dungCamera();
            dangChoXacNhan = false;
            if (uploadInput) uploadInput.value = '';
        });
    })();
</script>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
<script src="${pageContext.request.contextPath}/assets/js/main.js?v=mono3" defer></script>
</body>
</html>
