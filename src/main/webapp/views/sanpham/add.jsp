<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <%@ include file="/views/layout/head.jsp" %>
    <title>Thêm sản phẩm mới</title>
    <style>
        .add-page{padding-bottom:90px}.section-card{border:1px solid #dedede;border-radius:16px;background:#fff;box-shadow:0 4px 18px rgba(15,23,42,.05);padding:20px;margin-bottom:18px}.section-title{font-size:15px;font-weight:800;color:#111111;margin-bottom:18px;padding-bottom:12px;border-bottom:1px solid #e7edf5}
        .attribute-field{display:grid;grid-template-columns:1fr 42px;gap:8px}.attribute-field .btn{padding:0}
        .selector-box{border:1px solid #c9c9c9;border-radius:11px;background:#fff;min-height:46px;padding:8px;display:flex;gap:7px;flex-wrap:wrap}.selector-chip{position:relative}.selector-chip input{position:absolute;opacity:0}.selector-chip label{display:inline-flex;align-items:center;gap:6px;padding:7px 10px;border-radius:8px;background:#f1f1f1;border:1px solid #dedede;font-weight:700;font-size:12px;cursor:pointer}.selector-chip input:checked+label{color:#fff;background:#111111;border-color:#111111}.color-dot{width:9px;height:9px;border-radius:50%;background:#444444}
        .generate-btn{width:100%;min-height:46px;margin-top:14px}.variant-area{display:none;margin-top:18px;border:1px solid #dedede;border-radius:14px;overflow:hidden}.variant-area.show{display:block}.variant-head{display:flex;justify-content:space-between;align-items:center;gap:12px;padding:14px 16px;color:#fff;background:linear-gradient(90deg,#1746a2,#111111)}
        .variant-group{border-bottom:1px solid #e2e2e2}.variant-group:last-child{border-bottom:0}.variant-group__head{display:flex;justify-content:space-between;align-items:center;flex-wrap:wrap;gap:10px;padding:12px 14px;background:#f8f8f8}.variant-table{width:100%;border-collapse:collapse}.variant-table th,.variant-table td{padding:10px 12px;border-top:1px solid #edf2f7;text-align:center}.variant-table th{color:#475569;font-size:12px}.variant-table .form-control{min-height:38px}.size-cell{font-weight:800;background:#f8f8f8!important}
        .bulk-panel{display:none;padding:14px;border:1px solid #bfdbfe;border-radius:12px;background:#ededed;margin:14px}.bulk-panel.show{display:block}.image-note{display:flex;align-items:flex-start;gap:10px;padding:13px 15px;border-radius:11px;background:#fff7ed;border:1px solid #fed7aa;color:#9a3412}
        .color-image-label{display:inline-flex;align-items:center;gap:6px;padding:6px 11px;border:1px solid #c9c9c9;border-radius:8px;background:#fff;font-size:12px;font-weight:700;color:#111111;cursor:pointer;white-space:nowrap;transition:.15s}.color-image-label:hover{background:#111111;color:#fff;border-color:#111111}.color-image-thumb{width:32px;height:32px;border-radius:7px;object-fit:cover;border:1px solid #c9c9c9;display:none}.color-image-filename{font-size:11px;color:#686868;max-width:130px;overflow:hidden;text-overflow:ellipsis;white-space:nowrap}
        .sticky-actions{position:fixed;left:var(--admin-sidebar-width);right:0;bottom:0;z-index:1020;display:flex;justify-content:flex-end;gap:10px;padding:13px 34px;background:rgba(255,255,255,.96);border-top:1px solid #dedede;box-shadow:0 -8px 22px rgba(15,23,42,.06);backdrop-filter:blur(8px)}body.admin-sidebar-collapsed .sticky-actions{left:var(--admin-sidebar-collapsed-width)}
        @media(max-width:768px){.sticky-actions{left:var(--admin-sidebar-collapsed-width);padding:12px 14px}.variant-table{min-width:760px}.variant-group{overflow-x:auto}}

        .status-choice{display:grid;grid-template-columns:1fr 1fr;gap:8px;padding:5px;border:1px solid #c9c9c9;border-radius:12px;background:#f8f8f8}.status-choice input{position:absolute;opacity:0}.status-choice label{display:flex;align-items:center;justify-content:center;gap:7px;min-height:38px;margin:0;border-radius:9px;color:#686868;font-size:12px;font-weight:800;cursor:pointer;transition:.18s}.status-choice label:before{content:"";width:8px;height:8px;border-radius:50%;background:#94a3b8}.status-choice input[value="1"]:checked+label{color:#111111;background:#ededed;box-shadow:0 2px 8px rgba(5,150,105,.12)}.status-choice input[value="1"]:checked+label:before{background:#111111;box-shadow:0 0 0 3px rgba(16,185,129,.18)}.status-choice input[value="0"]:checked+label{color:#475569;background:#e2e2e2;box-shadow:0 2px 8px rgba(71,85,105,.10)}.status-choice input[value="0"]:checked+label:before{background:#686868;box-shadow:0 0 0 3px rgba(100,116,139,.16)}
        .submit-product:disabled{cursor:not-allowed;opacity:.78}

        /* Popup chọn nhanh giá đặc biệt cho ô Giá bán */
        .price-picker{position:fixed;z-index:1080;width:280px;padding:12px;border:1px solid #dedede;border-radius:12px;background:#fff;box-shadow:0 12px 32px rgba(15,23,42,.16);display:none}
        .price-picker.show{display:block}
        .price-picker__title{font-size:11.5px;font-weight:800;color:#686868;text-transform:uppercase;letter-spacing:.03em;margin-bottom:8px}
        .price-picker__grid{display:grid;grid-template-columns:1fr 1fr;gap:6px}
        .price-picker__btn{border:1px solid #dedede;border-radius:9px;background:#f8f8f8;padding:8px 6px;font-size:12.5px;font-weight:700;color:#111111;cursor:pointer;text-align:center;transition:.15s}
        .price-picker__btn:hover{background:#111111;color:#fff;border-color:#111111}
        .price-picker__foot{display:flex;align-items:center;justify-content:space-between;gap:8px;margin-top:10px;padding-top:10px;border-top:1px solid #eee}
        .price-picker__hint{font-size:11px;color:#9a9a9a}
        .price-picker__close{border:0;background:transparent;font-size:12px;font-weight:700;color:#686868;cursor:pointer;padding:2px 6px}
        .price-picker__close:hover{color:#111111}
    </style>
</head>
<body>
<%@ include file="/views/layout/sidebar.jsp" %>
<main class="main-content add-page">
    <div class="d-flex justify-content-between align-items-start gap-3 mb-4">
        <div><div class="small text-secondary mb-1">Scott Admin / Sản phẩm / Thêm mới</div><h2 class="fw-bold mb-1">Thêm sản phẩm mới</h2><div class="text-secondary">Nhập thông tin cơ bản, chọn màu và kích thước để tạo biến thể tự động.</div></div>
        <a class="btn btn-outline-secondary" href="${pageContext.request.contextPath}/san-pham/hien-thi"><i class="bi bi-arrow-left me-1"></i>Quay lại danh sách</a>
    </div>
    <c:if test="${not empty error}"><div class="alert alert-danger">${error}</div></c:if>

    <form method="post" enctype="multipart/form-data" action="${pageContext.request.contextPath}/san-pham/add" id="productCreateForm" class="needs-validation" novalidate>
        <section class="section-card">
            <div class="section-title">Thông tin cơ bản</div>
            <div class="row g-3">
                <div class="col-lg-4"><label class="form-label">Mã sản phẩm</label><input class="form-control" value="${goiYMaSanPham}" readonly disabled title="Mã được hệ thống tự động sinh, không thể chỉnh sửa."><div class="form-text">Tự động sinh, không thể sửa.</div></div>
                <div class="col-lg-4"><label class="form-label">Tên sản phẩm <span class="text-danger">*</span></label><input class="form-control" name="tenSanPham" value="${param.tenSanPham}" required minlength="3" maxlength="100" placeholder="Nhập tên sản phẩm"><div class="invalid-feedback">Tên sản phẩm từ 3 đến 100 ký tự.</div></div>
                <div class="col-lg-4"><label class="form-label">Loại sản phẩm <span class="text-danger">*</span></label><div class="attribute-field"><select class="form-select" name="idDanhMuc" required><option value="">-- Chọn loại sản phẩm --</option><c:forEach items="${listDanhMuc}" var="x"><option value="${x.id}" ${param.idDanhMuc == x.id ? 'selected':''}>${x.tenDanhMuc}</option></c:forEach></select><a class="btn btn-outline-primary" href="${pageContext.request.contextPath}/thuoc-tinh/hien-thi?type=danh-muc" target="_blank"><i class="bi bi-plus"></i></a></div></div>
                <div class="col-lg-4"><label class="form-label">Thương hiệu <span class="text-danger">*</span></label><div class="attribute-field"><select class="form-select" name="idThuongHieu" required><option value="">-- Chọn thương hiệu --</option><c:forEach items="${listThuongHieu}" var="x"><option value="${x.id}" ${param.idThuongHieu == x.id ? 'selected':''}>${x.ten}</option></c:forEach></select><a class="btn btn-outline-primary" href="${pageContext.request.contextPath}/thuoc-tinh/hien-thi?type=thuong-hieu" target="_blank"><i class="bi bi-plus"></i></a></div></div>
                <div class="col-lg-4"><label class="form-label">Chất liệu <span class="text-danger">*</span></label><div class="attribute-field"><select class="form-select" name="idChatLieu" required><option value="">-- Chọn chất liệu --</option><c:forEach items="${listChatLieu}" var="x"><option value="${x.id}" ${param.idChatLieu == x.id ? 'selected':''}>${x.tenChatLieu}</option></c:forEach></select><a class="btn btn-outline-primary" href="${pageContext.request.contextPath}/thuoc-tinh/hien-thi?type=chat-lieu" target="_blank"><i class="bi bi-plus"></i></a></div></div>
                <div class="col-lg-4"><label class="form-label">Kiểu dáng <span class="text-danger">*</span></label><div class="attribute-field"><select class="form-select" name="idKieuDang" required><option value="">-- Chọn kiểu dáng --</option><c:forEach items="${listKieuDang}" var="x"><option value="${x.id}" ${param.idKieuDang == x.id ? 'selected':''}>${x.tenKieuDang}</option></c:forEach></select><a class="btn btn-outline-primary" href="${pageContext.request.contextPath}/thuoc-tinh/hien-thi?type=kieu-dang" target="_blank"><i class="bi bi-plus"></i></a></div></div>
                <div class="col-lg-3"><label class="form-label">Giới tính <span class="text-danger">*</span></label><select class="form-select" name="gioiTinh" required><option value="1" ${param.gioiTinh!='0'?'selected':''}>Nam</option><option value="0" ${param.gioiTinh=='0'?'selected':''}>Nữ</option></select></div>
                <div class="col-lg-9"><label class="form-label">Ảnh đại diện</label><input class="form-control" type="file" name="hinhAnhFile" accept="image/jpeg,image/png,image/webp"><div class="form-text">JPG, PNG hoặc WEBP; tối đa 5 MB.</div></div><div class="col-12"><label class="form-label">Mô tả sản phẩm</label><textarea class="form-control" rows="4" maxlength="500" name="moTa" placeholder="Nhập mô tả chi tiết...">${param.moTa}</textarea></div>
            </div>
        </section>

        <section class="section-card">
            <div class="section-title">Biến thể sản phẩm</div>
            <div class="row g-3">
                <div class="col-lg-6"><label class="form-label">Màu sắc <span class="text-danger">*</span></label><div class="selector-box" id="colorSelector"><c:forEach items="${listMauSac}" var="x"><span class="selector-chip"><input type="checkbox" class="color-option" value="${x.id}" data-name="${x.ten}" id="color-${x.id}" ${x.trangThai!=1?'disabled':''}><label for="color-${x.id}"><span class="color-dot"></span>${x.ten}</label></span></c:forEach></div></div>
                <div class="col-lg-6"><label class="form-label">Kích thước <span class="text-danger">*</span></label><div class="selector-box" id="sizeSelector"><c:forEach items="${listSize}" var="x"><span class="selector-chip"><input type="checkbox" class="size-option" value="${x.id}" data-name="${x.ten}" id="size-${x.id}" ${x.trangThai!=1?'disabled':''}><label for="size-${x.id}">${x.ten}</label></span></c:forEach></div></div>
            </div>
            <button type="button" class="btn btn-primary generate-btn" id="generateVariants"><i class="bi bi-lightning-charge-fill me-1"></i>Tạo biến thể tự động</button>
            <div class="image-note mt-3"><i class="bi bi-info-circle-fill"></i><div><strong>Ảnh đại diện ở trên dùng chung cho cả sản phẩm.</strong><br><small>Nếu 1 màu có ảnh riêng, thêm ảnh ngay trong khung màu đó bên dưới (không bắt buộc) — màu nào chưa có ảnh riêng sẽ tự dùng ảnh đại diện. Có thể đổi lại ảnh sau trong màn hình chỉnh sửa sản phẩm/biến thể.</small></div></div>

            <div class="variant-area" id="variantArea">
                <div class="variant-head"><strong>Danh sách biến thể</strong><div class="d-flex gap-2"><button type="button" class="btn btn-sm btn-light" id="openBulk"><i class="bi bi-lightning me-1"></i>Áp dụng cho tất cả</button><button type="button" class="btn btn-sm btn-light" id="clearVariants"><i class="bi bi-trash me-1"></i>Xóa tất cả</button></div></div>
                <div class="bulk-panel" id="bulkPanel"><div class="row g-2 align-items-end"><div class="col-md-4"><label class="form-label">Số lượng tồn chung</label><input type="number" min="0" class="form-control" id="bulkStock" value="0"></div><div class="col-md-4"><label class="form-label">Giá nhập chung</label><input type="number" min="0" step="1000" class="form-control" id="bulkImport" value="0"></div><div class="col-md-4"><label class="form-label">Giá bán chung</label><input type="number" min="0" step="1000" class="form-control" id="bulkPrice" value="0"></div><div class="col-12 text-end"><button type="button" class="btn btn-primary btn-sm" id="applyBulk">Áp dụng</button></div></div></div>
                <div id="variantGroups"></div>
            </div>
        </section>

        <div class="sticky-actions"><a class="btn btn-outline-secondary" href="${pageContext.request.contextPath}/san-pham/hien-thi">Hủy</a><button class="btn btn-primary submit-product" type="submit"><i class="bi bi-check2-circle me-1"></i>Hoàn tất</button></div>
    </form>

    <!-- Popup chọn nhanh, hiện ra khi bấm vào ô Số lượng tồn / Giá nhập / Giá bán -->
    <div class="price-picker" id="pricePicker">
        <div class="price-picker__title" id="pricePickerTitle">Chọn giá bán đặc biệt</div>
        <div class="price-picker__grid" id="pricePickerGrid"></div>
        <div class="price-picker__foot">
            <span class="price-picker__hint">Hoặc tự nhập giá khác vào ô</span>
            <button type="button" class="price-picker__close" id="pricePickerClose">Đóng</button>
        </div>
    </div>
</main>
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
<script src="https://cdn.jsdelivr.net/npm/sweetalert2@11"></script>
<c:if test="${not empty error}">
    <c:set var="isDuplicateError" value="${fn:contains(error, 'đã tồn tại') || fn:contains(error, 'trùng')}" />
    <script>
        Swal.fire({
            icon: 'error',
            title: '<c:choose><c:when test="${isDuplicateError}">Dữ liệu bị trùng</c:when><c:otherwise>Không thể thêm sản phẩm</c:otherwise></c:choose>',
            html: '<c:out value="${error}" />',
            confirmButtonText: 'Đã hiểu',
            confirmButtonColor: '#111111'
        });
    </script>
</c:if>
<%--
    LỖI FONT KHI THÊM SẢN PHẨM - NGUYÊN NHÂN VÀ CÁCH SỬA:
    Trước đây script này được nạp từ file rời assets/js/sanpham-add.js bằng
    thẻ <script src="..." charset="UTF-8">. Thuộc tính charset trên thẻ
    <script src> là thuộc tính đã lỗi thời (deprecated) và trình duyệt hiện
    đại không đảm bảo tôn trọng nó; nếu Tomcat trả về file .js mà không kèm
    charset=UTF-8 trong header Content-Type (thường xảy ra với DefaultServlet
    khi phục vụ static resource), trình duyệt có thể tự suy luận sai bảng mã
    và làm hỏng toàn bộ chữ tiếng Việt được tạo động (Kích cỡ, Số lượng tồn,
    Giá nhập, Đơn giá, Áp dụng nhóm, Hoàn tất...) thành dạng "KÃch cá»¡".
    Ngoài ra file rời còn dễ bị trình duyệt/IDE cache lại bản cũ dù đã sửa.

    CÁCH SỬA: nhúng thẳng script vào trong JSP (giống cách product-form.jsp
    đã làm). Vì JSP đã khai báo contentType="text/html;charset=UTF-8" ở dòng
    đầu file, toàn bộ nội dung kể cả script trong thẻ <script> sẽ luôn được
    trả về đúng UTF-8, không còn phụ thuộc vào cách server phục vụ static
    file hay cache trình duyệt cho file .js riêng nữa.
--%>
<script>
    (function () {
        'use strict';

        var form = document.getElementById('productCreateForm');
        var area = document.getElementById('variantArea');
        var groups = document.getElementById('variantGroups');

        if (!form || !area || !groups) {
            return;
        }

        function getSelected(selector) {
            var checked = document.querySelectorAll(selector + ':checked');
            var result = [];
            var i;

            for (i = 0; i < checked.length; i++) {
                result.push({
                    id: checked[i].value,
                    name: checked[i].getAttribute('data-name') || ''
                });
            }

            return result;
        }

        function escapeHtml(value) {
            return String(value == null ? '' : value).replace(
                /[&<>'"]/g,
                function (character) {
                    var entities = {
                        '&': '&amp;',
                        '<': '&lt;',
                        '>': '&gt;',
                        "'": '&#39;',
                        '"': '&quot;'
                    };

                    return entities[character];
                }
            );
        }

        function createVariantRow(color, size) {
            return '<tr class="variant-row">' +
                '<td class="size-cell">' +
                escapeHtml(size.name) +
                '<input type="hidden" name="variantMauSac" value="' +
                escapeHtml(color.id) +
                '">' +
                '<input type="hidden" name="variantSize" value="' +
                escapeHtml(size.id) +
                '">' +
                '</td>' +
                '<td>' +
                '<input class="form-control stock-input" ' +
                'type="number" min="0" step="1" ' +
                'name="variantSoLuongTon" value="10" required>' +
                '</td>' +
                '<td>' +
                '<input class="form-control import-input" ' +
                'type="number" min="0" step="1000" ' +
                'name="variantGiaNhap" value="0" required>' +
                '</td>' +
                '<td>' +
                '<input class="form-control price-input" ' +
                'type="number" min="0" step="1000" ' +
                'name="variantGiaBan" value="0" required>' +
                '</td>' +
                '<td>' +
                '<button type="button" ' +
                'class="btn btn-sm btn-outline-danger remove-row" ' +
                'title="Xóa biến thể">' +
                '<i class="bi bi-x-lg"></i>' +
                '</button>' +
                '</td>' +
                '</tr>';
        }

        function buildVariants() {
            var colors = getSelected('.color-option');
            var sizes = getSelected('.size-option');
            var colorIndex;
            var sizeIndex;

            if (colors.length === 0 || sizes.length === 0) {
                alert(
                    'Hãy chọn ít nhất một màu sắc và một kích thước.'
                );
                return false;
            }

            if (colors.length * sizes.length > 100) {
                alert(
                    'Mỗi lần chỉ được tạo tối đa 100 biến thể.'
                );
                return false;
            }

            groups.innerHTML = '';

            for (
                colorIndex = 0;
                colorIndex < colors.length;
                colorIndex++
            ) {
                var color = colors[colorIndex];
                var section = document.createElement('section');
                var variantRows = '';

                for (
                    sizeIndex = 0;
                    sizeIndex < sizes.length;
                    sizeIndex++
                ) {
                    variantRows += createVariantRow(
                        color,
                        sizes[sizeIndex]
                    );
                }

                section.className = 'variant-group';

                section.innerHTML =
                    '<div class="variant-group__head">' +
                    '<strong>' +
                    '<span class="color-dot d-inline-block me-2"></span>' +
                    escapeHtml(color.name) +
                    ' <small class="text-secondary">' +
                    '(' + sizes.length + ' kích cỡ)' +
                    '</small>' +
                    '</strong>' +

                    '<div class="d-flex align-items-center gap-2 flex-wrap">' +
                    '<img class="color-image-thumb" alt="">' +
                    '<span class="color-image-filename"></span>' +
                    '<label class="color-image-label" title="Ảnh riêng cho màu ' + escapeHtml(color.name) + ' (không bắt buộc)">' +
                    '<i class="bi bi-image"></i>Ảnh màu' +
                    '<input type="file" class="d-none color-image-input" ' +
                    'name="anhMau_' + escapeHtml(color.id) + '" ' +
                    'accept="image/jpeg,image/png,image/webp">' +
                    '</label>' +

                    '<button type="button" ' +
                    'class="btn btn-sm btn-primary apply-group">' +
                    '<i class="bi bi-lightning me-1"></i>' +
                    'Áp dụng nhóm' +
                    '</button>' +
                    '</div>' +
                    '</div>' +

                    '<table class="variant-table">' +
                    '<thead>' +
                    '<tr>' +
                    '<th>Kích cỡ</th>' +
                    '<th>Số lượng tồn</th>' +
                    '<th>Giá nhập</th>' +
                    '<th>Đơn giá</th>' +
                    '<th></th>' +
                    '</tr>' +
                    '</thead>' +

                    '<tbody>' +
                    variantRows +
                    '</tbody>' +
                    '</table>';

                groups.appendChild(section);
            }

            area.classList.add('show');
            return true;
        }

        function applyValues(
            scope,
            stock,
            importPrice,
            salePrice
        ) {
            var stockInputs =
                scope.querySelectorAll('.stock-input');

            var importInputs =
                scope.querySelectorAll('.import-input');

            var saleInputs =
                scope.querySelectorAll('.price-input');

            var i;

            for (i = 0; i < stockInputs.length; i++) {
                stockInputs[i].value = stock;
            }

            for (i = 0; i < importInputs.length; i++) {
                importInputs[i].value = importPrice;
            }

            for (i = 0; i < saleInputs.length; i++) {
                saleInputs[i].value = salePrice;
            }
        }

        var generateButton =
            document.getElementById('generateVariants');

        var clearButton =
            document.getElementById('clearVariants');

        var openBulkButton =
            document.getElementById('openBulk');

        var applyBulkButton =
            document.getElementById('applyBulk');

        if (generateButton) {
            generateButton.addEventListener(
                'click',
                function () {
                    buildVariants();
                }
            );
        }

        if (clearButton) {
            clearButton.addEventListener(
                'click',
                function () {
                    groups.innerHTML = '';
                    area.classList.remove('show');
                }
            );
        }

        if (openBulkButton) {
            openBulkButton.addEventListener(
                'click',
                function () {
                    var bulkPanel =
                        document.getElementById('bulkPanel');

                    if (bulkPanel) {
                        bulkPanel.classList.toggle('show');
                    }
                }
            );
        }

        if (applyBulkButton) {
            applyBulkButton.addEventListener(
                'click',
                function () {
                    var bulkStock =
                        document.getElementById('bulkStock');

                    var bulkImport =
                        document.getElementById('bulkImport');

                    var bulkPrice =
                        document.getElementById('bulkPrice');

                    if (
                        !bulkStock ||
                        !bulkImport ||
                        !bulkPrice
                    ) {
                        return;
                    }

                    applyValues(
                        groups,
                        bulkStock.value,
                        bulkImport.value,
                        bulkPrice.value
                    );
                }
            );
        }

        // Khi người dùng chọn 1 file ảnh cho khung màu, hiện thử nhanh tên file
        // và ảnh xem trước ngay trong đầu khung màu đó (không upload ngay, chỉ
        // preview cục bộ bằng URL.createObjectURL — file thật sự được gửi lên
        // server khi bấm "Hoàn tất" vì input nằm sẵn trong form).
        groups.addEventListener(
            'change',
            function (event) {
                var input = event.target.closest('.color-image-input');
                if (!input) {
                    return;
                }

                var head = input.closest('.variant-group__head');
                if (!head) {
                    return;
                }

                var thumb = head.querySelector('.color-image-thumb');
                var nameLabel = head.querySelector('.color-image-filename');
                var file = input.files && input.files[0];

                if (!file) {
                    if (thumb) { thumb.style.display = 'none'; thumb.src = ''; }
                    if (nameLabel) { nameLabel.textContent = ''; }
                    return;
                }

                if (nameLabel) {
                    nameLabel.textContent = file.name;
                }

                if (thumb) {
                    thumb.src = URL.createObjectURL(file);
                    thumb.style.display = 'inline-block';
                }
            }
        );

        groups.addEventListener(
            'click',
            function (event) {
                var removeButton =
                    event.target.closest('.remove-row');

                var applyButton;

                if (removeButton) {
                    var row = removeButton.closest('tr');

                    if (row) {
                        row.remove();
                    }

                    if (
                        groups.querySelectorAll('.variant-row')
                            .length === 0
                    ) {
                        area.classList.remove('show');
                    }

                    return;
                }

                applyButton =
                    event.target.closest('.apply-group');

                if (applyButton) {
                    var section =
                        applyButton.closest('.variant-group');

                    var stock = prompt(
                        'Số lượng tồn áp dụng cho nhóm:',
                        '10'
                    );

                    var importPrice;
                    var salePrice;

                    if (stock === null) {
                        return;
                    }

                    importPrice = prompt(
                        'Giá nhập áp dụng cho nhóm:',
                        '0'
                    );

                    if (importPrice === null) {
                        return;
                    }

                    salePrice = prompt(
                        'Giá bán áp dụng cho nhóm:',
                        '0'
                    );

                    if (salePrice === null) {
                        return;
                    }

                    applyValues(
                        section,
                        stock,
                        importPrice,
                        salePrice
                    );
                }
            }
        );

        form.addEventListener(
            'submit',
            function (event) {
                var rows;
                var message = '';
                var i;

                form.classList.add('was-validated');

                if (!form.checkValidity()) {
                    var invalid =
                        form.querySelector(':invalid');

                    event.preventDefault();
                    event.stopPropagation();

                    if (invalid) {
                        invalid.reportValidity();

                        invalid.scrollIntoView({
                            behavior: 'smooth',
                            block: 'center'
                        });
                    }

                    return;
                }

                rows =
                    groups.querySelectorAll('.variant-row');

                if (rows.length === 0) {
                    buildVariants();

                    rows =
                        groups.querySelectorAll(
                            '.variant-row'
                        );
                }

                if (rows.length === 0) {
                    event.preventDefault();

                    alert(
                        'Hãy chọn màu sắc và kích thước để tạo ít nhất một biến thể.'
                    );

                    return;
                }

                for (i = 0; i < rows.length; i++) {
                    var stockInput =
                        rows[i].querySelector(
                            '.stock-input'
                        );

                    var importInput =
                        rows[i].querySelector(
                            '.import-input'
                        );

                    var saleInput =
                        rows[i].querySelector(
                            '.price-input'
                        );

                    var stock =
                        Number(stockInput.value);

                    var importPrice =
                        Number(importInput.value);

                    var salePrice =
                        Number(saleInput.value);

                    if (
                        !Number.isFinite(stock) ||
                        stock < 0 ||
                        !Number.isInteger(stock)
                    ) {
                        message =
                            'Số lượng tồn ở dòng ' +
                            (i + 1) +
                            ' phải là số nguyên không âm.';

                        break;
                    }

                    if (
                        !Number.isFinite(importPrice) ||
                        importPrice < 0
                    ) {
                        message =
                            'Giá nhập ở dòng ' +
                            (i + 1) +
                            ' không hợp lệ.';

                        break;
                    }

                    if (
                        !Number.isFinite(salePrice) ||
                        salePrice < 0
                    ) {
                        message =
                            'Giá bán ở dòng ' +
                            (i + 1) +
                            ' không hợp lệ.';

                        break;
                    }

                    if (salePrice < importPrice) {
                        message =
                            'Giá bán ở dòng ' +
                            (i + 1) +
                            ' phải lớn hơn hoặc bằng giá nhập.';

                        break;
                    }
                }

                if (message) {
                    event.preventDefault();
                    alert(message);
                    return;
                }

                var submitButton =
                    form.querySelector('.submit-product');

                if (submitButton) {
                    submitButton.disabled = true;

                    submitButton.innerHTML =
                        '<span class="spinner-border ' +
                        'spinner-border-sm me-2"></span>' +
                        'Đang lưu sản phẩm...';
                }
            }
        );

        window.addEventListener(
            'pageshow',
            function () {
                var submitButton =
                    form.querySelector('.submit-product');

                if (submitButton) {
                    submitButton.disabled = false;

                    submitButton.innerHTML =
                        '<i class="bi bi-check2-circle me-1"></i>' +
                        'Hoàn tất';
                }
            }
        );

        // ============== POPUP CHỌN NHANH: SỐ LƯỢNG TỒN / GIÁ NHẬP / GIÁ BÁN ==============
        // Khi bấm vào một trong 3 ô "Số lượng tồn", "Giá nhập" hoặc "Giá bán"
        // (trong bảng biến thể hoặc các ô chung ở panel áp dụng hàng loạt),
        // hiện popup gợi ý vài mức giá trị đặc biệt hay dùng cho đúng loại ô
        // đó. Người dùng có thể bấm chọn nhanh hoặc vẫn gõ tay bình thường
        // vào ô nếu muốn một giá trị khác.
        var PICKER_CONFIGS = {
            stock: {
                title: 'Chọn số lượng tồn',
                presets: [10, 20, 50, 100, 200],
                format: function (value) {
                    return value.toLocaleString('vi-VN') + ' cái';
                }
            },
            import: {
                title: 'Chọn giá nhập đặc biệt',
                presets: [50000, 100000, 150000, 200000, 300000],
                format: function (value) {
                    return value.toLocaleString('vi-VN') + ' đ';
                }
            },
            price: {
                title: 'Chọn giá bán đặc biệt',
                presets: [
                    99000, 149000, 199000, 249000,
                    299000, 399000, 499000, 599000,
                    699000, 899000
                ],
                format: function (value) {
                    return value.toLocaleString('vi-VN') + ' đ';
                }
            }
        };

        function pickerKindFor(target) {
            if (target.classList.contains('stock-input') || target.id === 'bulkStock') {
                return 'stock';
            }

            if (target.classList.contains('import-input') || target.id === 'bulkImport') {
                return 'import';
            }

            if (target.classList.contains('price-input') || target.id === 'bulkPrice') {
                return 'price';
            }

            return null;
        }

        var pricePicker = document.getElementById('pricePicker');
        var pricePickerGrid = document.getElementById('pricePickerGrid');
        var pricePickerTitle = document.getElementById('pricePickerTitle');
        var pricePickerClose = document.getElementById('pricePickerClose');
        var activePriceInput = null;

        if (pricePicker && pricePickerGrid) {
            function closePricePicker() {
                pricePicker.classList.remove('show');
                activePriceInput = null;
            }

            function fillPickerGrid(kind) {
                var config = PICKER_CONFIGS[kind];

                pricePickerGrid.innerHTML = '';

                if (pricePickerTitle) {
                    pricePickerTitle.textContent = config.title;
                }

                config.presets.forEach(function (value) {
                    var btn = document.createElement('button');
                    btn.type = 'button';
                    btn.className = 'price-picker__btn';
                    btn.textContent = config.format(value);
                    btn.setAttribute('data-price', String(value));
                    pricePickerGrid.appendChild(btn);
                });
            }

            function openPricePickerFor(input, kind) {
                activePriceInput = input;
                fillPickerGrid(kind);

                var rect = input.getBoundingClientRect();
                var pickerWidth = pricePicker.offsetWidth || 280;
                var spaceBelow = window.innerHeight - rect.bottom;
                var top = spaceBelow > 220
                    ? rect.bottom + 6
                    : rect.top - 6;

                var left = Math.min(
                    rect.left,
                    window.innerWidth - pickerWidth - 12
                );

                pricePicker.style.left = Math.max(12, left) + 'px';

                if (spaceBelow > 220) {
                    pricePicker.style.top = top + 'px';
                    pricePicker.style.transform = 'none';
                } else {
                    pricePicker.style.top = top + 'px';
                    pricePicker.style.transform = 'translateY(-100%)';
                }

                pricePicker.classList.add('show');
            }

            // Dùng focusin (nổi bọt) thay vì focus để bắt được cả những ô
            // Giá bán được sinh ra động sau này trong bảng biến thể.
            document.addEventListener('focusin', function (event) {
                var target = event.target;
                var kind = target && target.tagName === 'INPUT'
                    ? pickerKindFor(target)
                    : null;

                if (kind) {
                    openPricePickerFor(target, kind);
                } else if (
                    !pricePicker.contains(target)
                ) {
                    closePricePicker();
                }
            });

            pricePickerGrid.addEventListener('mousedown', function (event) {
                // mousedown thay vì click để chọn giá trước khi ô input bị blur
                var btn = event.target.closest('.price-picker__btn');

                if (!btn || !activePriceInput) {
                    return;
                }

                event.preventDefault();

                activePriceInput.value = btn.getAttribute('data-price');
                activePriceInput.dispatchEvent(new Event('input', { bubbles: true }));
                activePriceInput.dispatchEvent(new Event('change', { bubbles: true }));
                closePricePicker();
            });

            if (pricePickerClose) {
                pricePickerClose.addEventListener('mousedown', function (event) {
                    event.preventDefault();
                    closePricePicker();
                });
            }

            document.addEventListener('mousedown', function (event) {
                if (
                    pricePicker.classList.contains('show') &&
                    !pricePicker.contains(event.target) &&
                    event.target !== activePriceInput
                ) {
                    closePricePicker();
                }
            });

            document.addEventListener('keydown', function (event) {
                if (event.key === 'Escape') {
                    closePricePicker();
                }
            });

            window.addEventListener('resize', closePricePicker);
            window.addEventListener('scroll', closePricePicker, true);
        }
    }());
</script>
<%@ include file="/views/layout/footer.jsp" %>
</body></html>
