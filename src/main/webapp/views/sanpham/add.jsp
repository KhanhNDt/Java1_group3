<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
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
        .variant-group{border-bottom:1px solid #e2e2e2}.variant-group:last-child{border-bottom:0}.variant-group__head{display:flex;justify-content:space-between;align-items:center;padding:12px 14px;background:#f8f8f8}.variant-table{width:100%;border-collapse:collapse}.variant-table th,.variant-table td{padding:10px 12px;border-top:1px solid #edf2f7;text-align:center}.variant-table th{color:#475569;font-size:12px}.variant-table .form-control{min-height:38px}.size-cell{font-weight:800;background:#f8f8f8!important}
        .bulk-panel{display:none;padding:14px;border:1px solid #bfdbfe;border-radius:12px;background:#ededed;margin:14px}.bulk-panel.show{display:block}.image-note{display:flex;align-items:flex-start;gap:10px;padding:13px 15px;border-radius:11px;background:#fff7ed;border:1px solid #fed7aa;color:#9a3412}
        .sticky-actions{position:fixed;left:var(--admin-sidebar-width);right:0;bottom:0;z-index:1020;display:flex;justify-content:flex-end;gap:10px;padding:13px 34px;background:rgba(255,255,255,.96);border-top:1px solid #dedede;box-shadow:0 -8px 22px rgba(15,23,42,.06);backdrop-filter:blur(8px)}body.admin-sidebar-collapsed .sticky-actions{left:var(--admin-sidebar-collapsed-width)}
        @media(max-width:768px){.sticky-actions{left:var(--admin-sidebar-collapsed-width);padding:12px 14px}.variant-table{min-width:760px}.variant-group{overflow-x:auto}}

        .status-choice{display:grid;grid-template-columns:1fr 1fr;gap:8px;padding:5px;border:1px solid #c9c9c9;border-radius:12px;background:#f8f8f8}.status-choice input{position:absolute;opacity:0}.status-choice label{display:flex;align-items:center;justify-content:center;gap:7px;min-height:38px;margin:0;border-radius:9px;color:#686868;font-size:12px;font-weight:800;cursor:pointer;transition:.18s}.status-choice label:before{content:"";width:8px;height:8px;border-radius:50%;background:#94a3b8}.status-choice input[value="1"]:checked+label{color:#111111;background:#ededed;box-shadow:0 2px 8px rgba(5,150,105,.12)}.status-choice input[value="1"]:checked+label:before{background:#111111;box-shadow:0 0 0 3px rgba(16,185,129,.18)}.status-choice input[value="0"]:checked+label{color:#475569;background:#e2e2e2;box-shadow:0 2px 8px rgba(71,85,105,.10)}.status-choice input[value="0"]:checked+label:before{background:#686868;box-shadow:0 0 0 3px rgba(100,116,139,.16)}
        .submit-product:disabled{cursor:not-allowed;opacity:.78}
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

    <form method="post" action="${pageContext.request.contextPath}/san-pham/add" id="productCreateForm" class="needs-validation" novalidate>
        <section class="section-card">
            <div class="section-title">Thông tin cơ bản</div>
            <div class="row g-3">
                <div class="col-lg-4"><label class="form-label">Tên sản phẩm <span class="text-danger">*</span></label><input class="form-control" name="tenSanPham" value="${param.tenSanPham}" required minlength="3" maxlength="100" placeholder="Nhập tên sản phẩm"><div class="invalid-feedback">Tên sản phẩm từ 3 đến 100 ký tự.</div></div>
                <div class="col-lg-4"><label class="form-label">Loại sản phẩm <span class="text-danger">*</span></label><div class="attribute-field"><select class="form-select" name="idDanhMuc" required><option value="">-- Chọn loại sản phẩm --</option><c:forEach items="${listDanhMuc}" var="x"><option value="${x.id}" ${param.idDanhMuc == x.id ? 'selected':''}>${x.tenDanhMuc}</option></c:forEach></select><a class="btn btn-outline-primary" href="${pageContext.request.contextPath}/thuoc-tinh/hien-thi?type=danh-muc" target="_blank"><i class="bi bi-plus"></i></a></div></div>
                <div class="col-lg-4"><label class="form-label">Thương hiệu <span class="text-danger">*</span></label><div class="attribute-field"><select class="form-select" name="idThuongHieu" required><option value="">-- Chọn thương hiệu --</option><c:forEach items="${listThuongHieu}" var="x"><option value="${x.id}" ${param.idThuongHieu == x.id ? 'selected':''}>${x.ten}</option></c:forEach></select><a class="btn btn-outline-primary" href="${pageContext.request.contextPath}/thuoc-tinh/hien-thi?type=thuong-hieu" target="_blank"><i class="bi bi-plus"></i></a></div></div>
                <div class="col-lg-4"><label class="form-label">Chất liệu <span class="text-danger">*</span></label><div class="attribute-field"><select class="form-select" name="idChatLieu" required><option value="">-- Chọn chất liệu --</option><c:forEach items="${listChatLieu}" var="x"><option value="${x.id}" ${param.idChatLieu == x.id ? 'selected':''}>${x.tenChatLieu}</option></c:forEach></select><a class="btn btn-outline-primary" href="${pageContext.request.contextPath}/thuoc-tinh/hien-thi?type=chat-lieu" target="_blank"><i class="bi bi-plus"></i></a></div></div>
                <div class="col-lg-4"><label class="form-label">Kiểu dáng <span class="text-danger">*</span></label><div class="attribute-field"><select class="form-select" name="idKieuDang" required><option value="">-- Chọn kiểu dáng --</option><c:forEach items="${listKieuDang}" var="x"><option value="${x.id}" ${param.idKieuDang == x.id ? 'selected':''}>${x.tenKieuDang}</option></c:forEach></select><a class="btn btn-outline-primary" href="${pageContext.request.contextPath}/thuoc-tinh/hien-thi?type=kieu-dang" target="_blank"><i class="bi bi-plus"></i></a></div></div>
                <div class="col-lg-2"><label class="form-label">Giới tính <span class="text-danger">*</span></label><select class="form-select" name="gioiTinh" required><option value="1" ${param.gioiTinh!='0'?'selected':''}>Nam</option><option value="0" ${param.gioiTinh=='0'?'selected':''}>Nữ</option></select></div>
                <div class="col-lg-4"><label class="form-label">Trạng thái</label><div class="status-choice"><span><input type="radio" name="trangThai" id="product-status-on" value="1" ${param.trangThai != '0' ? 'checked' : ''}><label for="product-status-on">Đang bán</label></span><span><input type="radio" name="trangThai" id="product-status-off" value="0" ${param.trangThai == '0' ? 'checked' : ''}><label for="product-status-off">Ngừng bán</label></span></div></div>
                <div class="col-12"><label class="form-label">Mô tả sản phẩm</label><textarea class="form-control" rows="4" maxlength="500" name="moTa" placeholder="Nhập mô tả chi tiết...">${param.moTa}</textarea></div>
            </div>
        </section>

        <section class="section-card">
            <div class="section-title">Biến thể sản phẩm</div>
            <div class="row g-3">
                <div class="col-lg-6"><label class="form-label">Màu sắc <span class="text-danger">*</span></label><div class="selector-box" id="colorSelector"><c:forEach items="${listMauSac}" var="x"><span class="selector-chip"><input type="checkbox" class="color-option" value="${x.id}" data-name="${x.ten}" id="color-${x.id}" ${x.trangThai!=1?'disabled':''}><label for="color-${x.id}"><span class="color-dot"></span>${x.ten}</label></span></c:forEach></div></div>
                <div class="col-lg-6"><label class="form-label">Kích thước <span class="text-danger">*</span></label><div class="selector-box" id="sizeSelector"><c:forEach items="${listSize}" var="x"><span class="selector-chip"><input type="checkbox" class="size-option" value="${x.id}" data-name="${x.ten}" id="size-${x.id}" ${x.trangThai!=1?'disabled':''}><label for="size-${x.id}">${x.ten}</label></span></c:forEach></div></div>
            </div>
            <button type="button" class="btn btn-primary generate-btn" id="generateVariants"><i class="bi bi-lightning-charge-fill me-1"></i>Tạo biến thể tự động</button>
            <div class="image-note mt-3"><i class="bi bi-info-circle-fill"></i><div><strong>Ảnh theo màu sắc chưa được lưu trong phiên bản này.</strong><br><small>Cơ sở dữ liệu hiện tại chưa có bảng/cột ảnh cho sản phẩm và biến thể. Phần tạo biến thể, giá và tồn kho vẫn hoạt động đầy đủ.</small></div></div>

            <div class="variant-area" id="variantArea">
                <div class="variant-head"><strong>Danh sách biến thể</strong><div class="d-flex gap-2"><button type="button" class="btn btn-sm btn-light" id="openBulk"><i class="bi bi-lightning me-1"></i>Áp dụng cho tất cả</button><button type="button" class="btn btn-sm btn-light" id="clearVariants"><i class="bi bi-trash me-1"></i>Xóa tất cả</button></div></div>
                <div class="bulk-panel" id="bulkPanel"><div class="row g-2 align-items-end"><div class="col-md-4"><label class="form-label">Số lượng tồn chung</label><input type="number" min="0" class="form-control" id="bulkStock" value="0"></div><div class="col-md-4"><label class="form-label">Giá nhập chung</label><input type="number" min="0" step="1000" class="form-control" id="bulkImport" value="0"></div><div class="col-md-4"><label class="form-label">Giá bán chung</label><input type="number" min="0" step="1000" class="form-control" id="bulkPrice" value="0"></div><div class="col-12 text-end"><button type="button" class="btn btn-primary btn-sm" id="applyBulk">Áp dụng</button></div></div></div>
                <div id="variantGroups"></div>
            </div>
        </section>

        <div class="sticky-actions"><a class="btn btn-outline-secondary" href="${pageContext.request.contextPath}/san-pham/hien-thi">Hủy</a><button class="btn btn-primary submit-product" type="submit"><i class="bi bi-check2-circle me-1"></i>Hoàn tất</button></div>
    </form>
</main>
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
<!-- JavaScript tạo biến thể được đặt ở file riêng để tránh xung đột với JSP EL. -->
<script src="${pageContext.request.contextPath}/assets/js/sanpham-add.js?v=20260721-3"></script>
<%@ include file="/views/layout/footer.jsp" %>
</body></html>
