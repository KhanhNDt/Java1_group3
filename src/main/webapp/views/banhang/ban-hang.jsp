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
    </style>
</head>
<body>

<jsp:include page="/views/layout/sidebar.jsp"/>

<div class="main-content">
    <h2><i class="bi bi-cart-check"></i> Bán hàng tại quầy</h2>

    <div id="alertBox"></div>

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

                <div class="mt-2" id="tenKhWrap" style="display:none;">
                    <label class="form-label">Tên khách hàng (khách mới)</label>
                    <input type="text" id="tenKhInput" class="form-control" placeholder="Khách lẻ">

                    <label class="form-label mt-2">Email</label>
                    <input type="email" id="emailKhInput" class="form-control" placeholder="email@vidu.com">

                    <label class="form-label mt-2">Địa chỉ</label>
                    <input type="text" id="diaChiKhInput" class="form-control" placeholder="Địa chỉ khách hàng">
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

                <button type="button" class="btn btn-success w-100 mt-3 btn-thanh-toan" id="btnThanhToan">
                    <i class="bi bi-cash-coin"></i> Thanh toán
                </button>
            </div>
        </div>
    </div>
</div>

<script>
    const ctx = "${pageContext.request.contextPath}";
    let cart = [];       // {id, ma, tenSanPham, mauSac, kichThuoc, giaBan, soLuongTon, soLuong}
    let vouchers = [];
    let productCache = {};

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
        const tienHang = tinhTienHang();
        const tienGiam = tinhTienGiam(tienHang);
        document.getElementById('sumTienHang').textContent = formatTien(tienHang);
        document.getElementById('sumGiam').textContent = '- ' + formatTien(tienGiam);
        document.getElementById('sumTong').textContent = formatTien(tienHang - tienGiam);
    }

    // ============== KHÁCH HÀNG ==============
    let sdtTimer = null;
    document.getElementById('sdtInput').addEventListener('input', function () {
        clearTimeout(sdtTimer);
        const sdt = this.value.trim();
        document.getElementById('tenKhWrap').style.display = 'none';
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
                        document.getElementById('tenKhWrap').style.display = 'none';
                    } else {
                        document.getElementById('khStatus').innerHTML =
                            '<span class="text-primary"><i class="bi bi-person-plus"></i> Khách mới, sẽ tạo hồ sơ khi thanh toán</span>';
                        document.getElementById('tenKhWrap').style.display = 'block';
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
                select.innerHTML = '<option value="">-- Không dùng voucher --</option>' +
                    vouchers.map(v => {
                        const mo = v.loaiGiamGia === '%'
                            ? (v.giaTriGiamGia + '%')
                            : formatTien(v.giaTriGiamGia);
                        return '<option value="' + v.id + '">' + v.maVoucher + ' - ' + v.tenVoucher + ' (' + mo + ')</option>';
                    }).join('');
            });
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
        if (email && !/^[^\s@]+@[^\s@]+\.[^\s@]+$/.test(email)) {
            showAlert('danger', 'Email khách hàng không hợp lệ.');
            return;
        }

        const payload = {
            sdtKhachHang: sdt,
            tenKhachHang: document.getElementById('tenKhInput').value.trim(),
            emailKhachHang: email,
            diaChiKhachHang: document.getElementById('diaChiKhInput').value.trim(),
            idPhieuGiamGia: document.getElementById('voucherSelect').value || null,
            ghiChu: document.getElementById('ghiChuInput').value.trim(),
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
                    cart = [];
                    document.getElementById('sdtInput').value = '';
                    document.getElementById('tenKhInput').value = '';
                    document.getElementById('emailKhInput').value = '';
                    document.getElementById('diaChiKhInput').value = '';
                    document.getElementById('ghiChuInput').value = '';
                    document.getElementById('khStatus').innerHTML = '';
                    document.getElementById('tenKhWrap').style.display = 'none';
                    document.getElementById('voucherSelect').value = '';
                    renderCart();
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

    // Khởi tạo
    timSanPham();
    taiVoucher();
    renderCart();
</script>

<script src="${pageContext.request.contextPath}/assets/js/main.js?v=mono3" defer></script>
</body>
</html>
