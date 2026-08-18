<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <title>Cập nhật phiếu giảm giá - Scott Admin</title>

    <!-- Bootstrap 5 CSS & Icons -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.css" rel="stylesheet">

    <!-- Flatpickr CSS (Định dạng ngày dd/MM/yyyy) -->
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/flatpickr/dist/flatpickr.min.css">

    <style>
        body {
            background-color: #f4f6f9;
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
        }

        .content {
            margin-left: 250px;
            padding: 25px 30px;
        }

        .card {
            border: none;
            border-radius: 10px;
            box-shadow: 0 4px 12px rgba(0, 0, 0, 0.05);
            background: #fff;
        }

        .card-header {
            background-color: #ffffff;
            font-weight: 600;
            border-bottom: 1px solid #edf2f7;
            padding: 16px 20px;
        }

        .flatpickr-input[readonly] {
            background-color: #fff !important;
        }

        /* Popup chọn nhanh giá trị, giống popup ở màn Thêm sản phẩm */
        .value-picker{position:fixed;z-index:1080;width:280px;padding:12px;border:1px solid #dedede;border-radius:12px;background:#fff;box-shadow:0 12px 32px rgba(15,23,42,.16);display:none}
        .value-picker.show{display:block}
        .value-picker__title{font-size:11.5px;font-weight:800;color:#686868;text-transform:uppercase;letter-spacing:.03em;margin-bottom:8px}
        .value-picker__grid{display:grid;grid-template-columns:1fr 1fr;gap:6px}
        .value-picker__btn{border:1px solid #dedede;border-radius:9px;background:#f8f8f8;padding:8px 6px;font-size:12.5px;font-weight:700;color:#111111;cursor:pointer;text-align:center;transition:.15s}
        .value-picker__btn:hover{background:#111111;color:#fff;border-color:#111111}
        .value-picker__foot{display:flex;align-items:center;justify-content:space-between;gap:8px;margin-top:10px;padding-top:10px;border-top:1px solid #eee}
        .value-picker__hint{font-size:11px;color:#9a9a9a}
        .value-picker__close{border:0;background:transparent;font-size:12px;font-weight:700;color:#686868;cursor:pointer;padding:2px 6px}
        .value-picker__close:hover{color:#111111}
    </style>
</head>

<body>

<%@ include file="/views/layout/sidebar.jsp" %>

<div class="content">

    <!-- Header & Back Button -->
    <div class="d-flex justify-content-between align-items-center mb-4">
        <h3 class="fw-bold text-dark mb-0">
            <i class="bi bi-pencil-square me-2"></i>Cập nhật phiếu giảm giá
        </h3>
        <a href="${pageContext.request.contextPath}/phieugiamgia/hien-thi" class="btn btn-outline-secondary">
            <i class="bi bi-arrow-left me-1"></i> Quay lại
        </a>
    </div>

    <c:if test="${not empty error}">
        <div class="alert alert-danger d-flex align-items-center" role="alert">
            <i class="bi bi-exclamation-triangle-fill me-2"></i>
            <div>${error}</div>
        </div>
    </c:if>

    <!-- Form Cập Nhật -->
    <div class="card">
        <div class="card-header fw-bold text-dark">
            Thông tin phiếu giảm giá ID: #${phieugiamgiaS.id}
        </div>
        <div class="card-body p-4">
            <form action="${pageContext.request.contextPath}/phieugiamgia/update" method="post">
                <!-- ID Ẩn để submit -->
                <input type="hidden" name="id" value="${phieugiamgiaS.id}">

                <div class="row g-3">
                    <!-- Mã Voucher -->
                    <div class="col-md-6">
                        <label class="form-label fw-semibold">Mã giảm giá <span class="text-danger">*</span></label>
                        <input type="text" class="form-control" name="maVoucher"
                               value="${phieugiamgiaS.maVoucher}" required placeholder="Ví dụ: VOUCHER2026">
                    </div>

                    <!-- Tên Voucher -->
                    <div class="col-md-6">
                        <label class="form-label fw-semibold">Tên giảm giá <span class="text-danger">*</span></label>
                        <input type="text" class="form-control" name="tenVoucher"
                               value="${phieugiamgiaS.tenVoucher}" required placeholder="Ví dụ: Giảm giá mùa hè">
                    </div>

                    <!-- Loại giảm giá -->
                    <div class="col-md-4">
                        <label class="form-label fw-semibold">Loại giảm giá <span class="text-danger">*</span></label>
                        <select class="form-select" id="loaiGiamGia" name="loaiGiamGia" onchange="toggleGiamToiDa()">
                            <option value="%" ${phieugiamgiaS.loaiGiamGia == '%' ? 'selected' : ''}>Phần trăm (%)</option>
                            <option value="Tiền" ${phieugiamgiaS.loaiGiamGia == 'Tiền' ? 'selected' : ''}>Tiền mặt (VNĐ)</option>
                        </select>
                    </div>

                    <!-- Giá trị giảm -->
                    <div class="col-md-4">
                        <label class="form-label fw-semibold">Giá trị giảm <span class="text-danger">*</span></label>
                        <input type="number" step="any" min="0" class="form-control value-picker-input" id="giaTriGiamGia" name="giaTriGiamGia"
                               value="${phieugiamgiaS.giaTriGiamGia}" required placeholder="Nhập số tiền hoặc %" autocomplete="off">
                    </div>

                    <!-- Giảm tối đa (Tự ẩn nếu là tiền mặt) -->
                    <div class="col-md-4" id="boxGiamToiDa">
                        <label class="form-label fw-semibold">Giảm tối đa (đ)</label>
                        <input type="number" step="any" min="0" class="form-control value-picker-input" id="giamToiDa" name="giamToiDa"
                               value="${phieugiamgiaS.giamToiDa}" placeholder="Nhập số tiền giảm tối đa" autocomplete="off">
                    </div>

                    <!-- Đơn tối thiểu -->
                    <div class="col-md-6">
                        <label class="form-label fw-semibold">Giá trị đơn tối thiểu (đ) <span class="text-danger">*</span></label>
                        <input type="number" step="any" min="0" class="form-control value-picker-input" id="donToiThieu" name="donToiThieu"
                               value="${phieugiamgiaS.donToiThieu}" required placeholder="Nhập điều kiện đơn hàng" autocomplete="off">
                    </div>

                    <!-- Số lượng -->
                    <div class="col-md-6">
                        <label class="form-label fw-semibold">Số lượng phát hành <span class="text-danger">*</span></label>
                        <input type="number" class="form-control value-picker-input" id="soLuong" name="soLuong"
                               value="${phieugiamgiaS.soLuong}" required min="0" autocomplete="off">
                    </div>

                    <!-- Ngày bắt đầu (định dạng dd/mm/yyyy) -->
                    <div class="col-md-4">
                        <label class="form-label fw-semibold">Ngày bắt đầu <span class="text-danger">*</span></label>
                        <input type="text" class="form-control datepicker" id="ngayBatDau" name="ngayBatDau"
                               value="<fmt:formatDate value='${phieugiamgiaS.ngayBatDau}' pattern='yyyy-MM-dd'/>" required placeholder="dd/mm/yyyy">
                        <div class="invalid-feedback" id="fbNgayBatDau">Ngày bắt đầu phải nhỏ hơn ngày kết thúc.</div>
                    </div>

                    <!-- Ngày kết thúc (định dạng dd/mm/yyyy) -->
                    <div class="col-md-4">
                        <label class="form-label fw-semibold">Ngày kết thúc <span class="text-danger">*</span></label>
                        <input type="text" class="form-control datepicker" id="ngayKetThuc" name="ngayKetThuc"
                               value="<fmt:formatDate value='${phieugiamgiaS.ngayKetThuc}' pattern='yyyy-MM-dd'/>" required placeholder="dd/mm/yyyy">
                        <div class="invalid-feedback" id="fbNgayKetThuc">Ngày kết thúc phải lớn hơn ngày bắt đầu.</div>
                    </div>

                    <!-- Trạng thái (tự động, không chỉnh tay được) -->
                    <div class="col-md-4">
                        <label class="form-label fw-semibold">Trạng thái</label>
                        <div>
                            <c:choose>
                                <c:when test="${phieugiamgiaS.trangThai == 1}">
                                    <span class="badge bg-light text-dark border">Đang hoạt động</span>
                                </c:when>
                                <c:when test="${phieugiamgiaS.trangThai == 2}">
                                    <span class="badge bg-warning text-dark">Sắp diễn ra</span>
                                </c:when>
                                <c:otherwise>
                                    <span class="badge bg-secondary">Ngừng hoạt động</span>
                                </c:otherwise>
                            </c:choose>
                        </div>
                        <div class="form-text">Trạng thái được tự động cập nhật theo ngày bắt đầu / kết thúc.</div>
                    </div>
                </div>

                <!-- Action Buttons -->
                <div class="mt-4 text-end">
                    <a href="${pageContext.request.contextPath}/phieugiamgia/hien-thi" class="btn btn-light me-2">Hủy bỏ</a>
                    <button type="submit" class="btn btn-dark px-4">
                        <i class="bi bi-save me-1"></i> Lưu thay đổi
                    </button>
                </div>
            </form>
        </div>
    </div>

    <!-- Popup chọn nhanh giá trị cho các ô Giá trị giảm / Giảm tối đa / Đơn tối thiểu / Số lượng -->
    <div class="value-picker" id="valuePicker">
        <div class="value-picker__title" id="valuePickerTitle">Chọn giá trị</div>
        <div class="value-picker__grid" id="valuePickerGrid"></div>
        <div class="value-picker__foot">
            <span class="value-picker__hint">Hoặc tự nhập giá trị khác vào ô</span>
            <button type="button" class="value-picker__close" id="valuePickerClose">Đóng</button>
        </div>
    </div>

</div>

<!-- JS Bootstrap -->
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>

<!-- JS Flatpickr & Tiếng Việt -->
<script src="https://cdn.jsdelivr.net/npm/flatpickr"></script>
<script src="https://npmcdn.com/flatpickr/dist/l10n/vn.js"></script>

<script>
    // Kích hoạt ô ngày tháng định dạng dd/mm/yyyy
    flatpickr(".datepicker", {
        dateFormat: "Y-m-d",
        altInput: true,
        altFormat: "d/m/Y",
        locale: "vn"
    });

    // Hàm kiểm tra và Ẩn/Hiện ô "Giảm tối đa"
    function toggleGiamToiDa() {
        var loaiGiam = document.getElementById("loaiGiamGia").value;
        var boxGiamToiDa = document.getElementById("boxGiamToiDa");
        var inputGiamToiDa = document.getElementById("giamToiDa");
        var giaTriInput = document.getElementById("giaTriGiamGia");

        if (loaiGiam === "Tiền") {
            boxGiamToiDa.style.display = "none";
            inputGiamToiDa.value = ""; // Xóa value khi ẩn
            giaTriInput.removeAttribute("max");
        } else {
            boxGiamToiDa.style.display = "block";
            giaTriInput.setAttribute("max", "100");
        }
    }

    // Chạy khi tải trang lần đầu
    window.onload = function() {
        toggleGiamToiDa();
    };

    // Live-validate: ngày bắt đầu luôn phải nhỏ hơn ngày kết thúc, kiểm tra ngay khi người dùng
    // đổi 1 trong 2 ô (không cần chờ submit mới báo lỗi).
    (function () {
        var ngayBatDauEl = document.getElementById("ngayBatDau");
        var ngayKetThucEl = document.getElementById("ngayKetThuc");

        function validateKhoangNgay() {
            var batDau = ngayBatDauEl.value;
            var ketThuc = ngayKetThucEl.value;
            if (batDau && ketThuc && batDau >= ketThuc) {
                ngayBatDauEl.classList.add("is-invalid");
                ngayKetThucEl.classList.add("is-invalid");
                return false;
            }
            ngayBatDauEl.classList.remove("is-invalid");
            ngayKetThucEl.classList.remove("is-invalid");
            if (batDau) ngayBatDauEl.classList.add("is-valid"); else ngayBatDauEl.classList.remove("is-valid");
            if (ketThuc) ngayKetThucEl.classList.add("is-valid"); else ngayKetThucEl.classList.remove("is-valid");
            return true;
        }

        ["input", "change"].forEach(function (evt) {
            ngayBatDauEl.addEventListener(evt, validateKhoangNgay);
            ngayKetThucEl.addEventListener(evt, validateKhoangNgay);
        });

        validateKhoangNgay();

        document.querySelector("form").addEventListener("submit", function (e) {
            if (!validateKhoangNgay()) {
                e.preventDefault();
                alert("Ngày bắt đầu phải nhỏ hơn ngày kết thúc.");
            }
        });
    })();

    // ============== POPUP CHỌN NHANH GIÁ TRỊ (giống popup ở màn Thêm sản phẩm) ==============
    (function () {
        var VALUE_PICKER_CONFIGS = {
            giaTriGiamGia_percent: {
                title: 'Chọn % giảm giá',
                presets: [5, 10, 15, 20, 30, 50],
                format: function (v) { return v + '%'; }
            },
            giaTriGiamGia_money: {
                title: 'Chọn số tiền giảm',
                presets: [10000, 20000, 50000, 100000, 150000, 200000],
                format: function (v) { return v.toLocaleString('vi-VN') + ' đ'; }
            },
            giamToiDa: {
                title: 'Chọn mức giảm tối đa',
                presets: [20000, 50000, 100000, 200000, 300000, 500000],
                format: function (v) { return v.toLocaleString('vi-VN') + ' đ'; }
            },
            donToiThieu: {
                title: 'Chọn đơn tối thiểu để áp dụng',
                presets: [100000, 200000, 300000, 500000, 1000000, 2000000],
                format: function (v) { return v.toLocaleString('vi-VN') + ' đ'; }
            },
            soLuong: {
                title: 'Chọn số lượng phát hành',
                presets: [10, 50, 100, 200, 500, 1000],
                format: function (v) { return v.toLocaleString('vi-VN') + ' phiếu'; }
            }
        };

        function pickerKindFor(target) {
            if (!target || !target.classList || !target.classList.contains('value-picker-input')) return null;
            if (target.id === 'giaTriGiamGia') {
                var loaiEl = document.getElementById('loaiGiamGia');
                var loai = loaiEl ? loaiEl.value.trim() : '%';
                return loai === '%' ? 'giaTriGiamGia_percent' : 'giaTriGiamGia_money';
            }
            if (target.id === 'giamToiDa') return 'giamToiDa';
            if (target.id === 'donToiThieu') return 'donToiThieu';
            if (target.id === 'soLuong') return 'soLuong';
            return null;
        }

        var picker = document.getElementById('valuePicker');
        var grid = document.getElementById('valuePickerGrid');
        var title = document.getElementById('valuePickerTitle');
        var closeBtn = document.getElementById('valuePickerClose');
        var activeInput = null;
        if (!picker || !grid) return;

        function closePicker() {
            picker.classList.remove('show');
            activeInput = null;
        }

        function fillGrid(kind) {
            var config = VALUE_PICKER_CONFIGS[kind];
            grid.innerHTML = '';
            if (title) title.textContent = config.title;
            config.presets.forEach(function (value) {
                var btn = document.createElement('button');
                btn.type = 'button';
                btn.className = 'value-picker__btn';
                btn.textContent = config.format(value);
                btn.setAttribute('data-value', String(value));
                grid.appendChild(btn);
            });
        }

        function openPickerFor(input, kind) {
            activeInput = input;
            fillGrid(kind);

            var rect = input.getBoundingClientRect();
            var pickerWidth = picker.offsetWidth || 280;
            var spaceBelow = window.innerHeight - rect.bottom;
            var top = spaceBelow > 220 ? rect.bottom + 6 : rect.top - 6;
            var left = Math.min(rect.left, window.innerWidth - pickerWidth - 12);

            picker.style.left = Math.max(12, left) + 'px';
            if (spaceBelow > 220) {
                picker.style.top = top + 'px';
                picker.style.transform = 'none';
            } else {
                picker.style.top = top + 'px';
                picker.style.transform = 'translateY(-100%)';
            }
            picker.classList.add('show');
        }

        document.addEventListener('focusin', function (event) {
            var target = event.target;
            var kind = target && target.tagName === 'INPUT' ? pickerKindFor(target) : null;
            if (kind) {
                openPickerFor(target, kind);
            } else if (!picker.contains(target)) {
                closePicker();
            }
        });

        grid.addEventListener('mousedown', function (event) {
            var btn = event.target.closest('.value-picker__btn');
            if (!btn || !activeInput) return;
            event.preventDefault();
            activeInput.value = btn.getAttribute('data-value');
            activeInput.dispatchEvent(new Event('input', { bubbles: true }));
            activeInput.dispatchEvent(new Event('change', { bubbles: true }));
            closePicker();
        });

        if (closeBtn) {
            closeBtn.addEventListener('mousedown', function (event) {
                event.preventDefault();
                closePicker();
            });
        }

        document.addEventListener('mousedown', function (event) {
            if (picker.classList.contains('show') && !picker.contains(event.target) && event.target !== activeInput) {
                closePicker();
            }
        });

        document.addEventListener('keydown', function (event) {
            if (event.key === 'Escape') closePicker();
        });

        window.addEventListener('resize', closePicker);
        window.addEventListener('scroll', closePicker, true);
    }());
</script>

</body>
</html>