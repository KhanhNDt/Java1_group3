<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <%@ include file="/views/layout/head.jsp" %>
    <title>Thuộc tính sản phẩm</title>
    <style>
        :root{--ink:#111;--muted:#707070;--line:#e3e3e3;--soft:#f7f7f7}.page-title{font-size:25px;letter-spacing:-.4px}.panel{background:#fff;border:1px solid var(--line);border-radius:14px;box-shadow:0 5px 18px rgba(0,0,0,.04)}
        .type-tabs{display:flex;flex-wrap:wrap;gap:8px}.type-tab{padding:9px 14px;border:1px solid #d7d7d7;border-radius:999px;color:#4c4c4c;text-decoration:none;background:#fff;font-weight:700;font-size:13px}.type-tab:hover,.type-tab.active{color:#fff;background:#111;border-color:#111}
        .table thead th{background:#111!important;color:#fff!important;border:0;font-size:12px}.table td{border-color:#ededed}.action-btn{width:34px;height:34px;padding:0;display:inline-grid;place-items:center;border:1px solid #cfcfcf;background:#fff;color:#111}.action-btn:hover{background:#111;color:#fff}.empty{padding:44px;color:#888}.required{color:#111}.attribute-result-area.is-loading{position:relative;min-height:180px}.attribute-result-area.is-loading:after{content:"Đang lọc dữ liệu...";position:absolute;inset:0;z-index:3;display:grid;place-items:center;background:rgba(255,255,255,.84);font-weight:700;color:#111}
    </style>
</head>
<body>
<%@ include file="/views/layout/sidebar.jsp" %>
<div class="main-content">
    <div class="d-flex justify-content-between align-items-start gap-3 mb-4">
        <div><div class="small text-secondary mb-1">Scott Admin / Sản phẩm / Thuộc tính</div><h2 class="page-title fw-bold mb-1">Thuộc tính sản phẩm</h2><div class="text-secondary">Quản lý dữ liệu dùng chung khi tạo sản phẩm và biến thể.</div></div>
        <button class="btn btn-dark px-4 text-nowrap" data-bs-toggle="modal" data-bs-target="#attributeModal"><i class="bi bi-plus-lg me-1"></i>Thêm ${typeLabel}</button>
    </div>

    <c:if test="${not empty success}"><div class="alert alert-success alert-dismissible fade show">${success}<button class="btn-close" data-bs-dismiss="alert"></button></div></c:if>
    <c:if test="${not empty error}"><div class="alert alert-danger alert-dismissible fade show">${error}<button class="btn-close" data-bs-dismiss="alert"></button></div></c:if>

    <div class="panel p-3 p-lg-4 mb-4">
        <div class="type-tabs">
            <a class="type-tab ${type == 'danh-muc' ? 'active' : ''}" href="${pageContext.request.contextPath}/thuoc-tinh/hien-thi?type=danh-muc">Danh mục</a>
            <a class="type-tab ${type == 'thuong-hieu' ? 'active' : ''}" href="${pageContext.request.contextPath}/thuoc-tinh/hien-thi?type=thuong-hieu">Thương hiệu</a>
            <a class="type-tab ${type == 'chat-lieu' ? 'active' : ''}" href="${pageContext.request.contextPath}/thuoc-tinh/hien-thi?type=chat-lieu">Chất liệu</a>
            <a class="type-tab ${type == 'kieu-dang' ? 'active' : ''}" href="${pageContext.request.contextPath}/thuoc-tinh/hien-thi?type=kieu-dang">Kiểu dáng</a>
            <a class="type-tab ${type == 'mau-sac' ? 'active' : ''}" href="${pageContext.request.contextPath}/thuoc-tinh/hien-thi?type=mau-sac">Màu sắc</a>
            <a class="type-tab ${type == 'size' ? 'active' : ''}" href="${pageContext.request.contextPath}/thuoc-tinh/hien-thi?type=size">Kích thước</a>
        </div>
    </div>

    <div class="panel overflow-hidden">
        <div class="p-3 p-lg-4 border-bottom">
            <div class="d-flex justify-content-between align-items-center flex-wrap gap-2 mb-3"><div><h5 class="fw-bold mb-0">Danh sách ${typeLabel}</h5><small id="attributeTotalCount" class="text-secondary">Tổng ${tongSoBanGhi} bản ghi</small></div><small class="text-secondary"><i class="bi bi-lightning-charge-fill me-1"></i>Tự động lọc</small></div>
            <form id="attributeLiveFilterForm" method="get" action="${pageContext.request.contextPath}/thuoc-tinh/hien-thi" class="row g-3 align-items-end" autocomplete="off">
                <input type="hidden" name="type" value="${type}"><input type="hidden" name="page" value="1"><input type="hidden" name="size" value="${pageSize}">
                <div class="col-lg-10"><label class="form-label">Tìm kiếm</label><div class="input-group"><span class="input-group-text"><i class="bi bi-search"></i></span><input id="attributeKeyword" class="form-control" name="keyword" maxlength="50" value="${keyword}" placeholder="Nhập tên ${fn:toLowerCase(typeLabel)}"></div></div>
                <div class="col-lg-2"><button type="button" id="resetAttributeFilter" class="btn btn-outline-secondary w-100" title="Xóa bộ lọc"><i class="bi bi-arrow-counterclockwise me-1"></i>Đặt lại</button></div>
            </form>
        </div>
        <div id="attributeResults" class="attribute-result-area" data-total="${tongSoBanGhi}">
            <div class="table-responsive">
                <table class="table align-middle text-center mb-0">
                    <thead><tr><th>STT</th><c:if test="${hasCode}"><th>Mã</th></c:if><th class="text-start">Tên ${typeLabel}</th><c:if test="${hasDescription}"><th class="text-start">Mô tả</th></c:if><th>Đang sử dụng</th><th>Hành động</th></tr></thead>
                    <tbody>
                    <c:forEach items="${listThuocTinh}" var="x" varStatus="st">
                        <tr><td>${(currentPage-1)*pageSize+st.count}</td><c:if test="${hasCode}"><td class="fw-semibold">${x.ma}</td></c:if><td class="text-start fw-semibold">${x.ten}</td><c:if test="${hasDescription}"><td class="text-start text-secondary">${empty x.moTa ? '—' : x.moTa}</td></c:if><td>${x.soLuongSuDung}</td>
                            <td class="text-nowrap"><a class="btn action-btn" title="Sửa" href="${pageContext.request.contextPath}/thuoc-tinh/view-update?type=${type}&id=${x.id}"><i class="bi bi-pencil-square"></i></a> <a class="btn action-btn" title="Xóa" href="${pageContext.request.contextPath}/thuoc-tinh/delete?type=${type}&id=${x.id}" onclick="return confirm('Xóa thuộc tính này? Dữ liệu đang được sử dụng sẽ không thể xóa.');"><i class="bi bi-trash"></i></a></td>
                        </tr>
                    </c:forEach>
                    <c:if test="${empty listThuocTinh}"><tr><td colspan="${3 + (hasCode ? 1 : 0) + (hasDescription ? 1 : 0)}"><div class="empty"><i class="bi bi-inbox fs-2"></i><div class="fw-semibold mt-2">Không tìm thấy dữ liệu</div><small>Thử thay đổi từ khóa tìm kiếm.</small></div></td></tr></c:if>
                    </tbody>
                </table>
            </div>
            <div class="p-3 border-top d-flex justify-content-between align-items-center flex-wrap gap-2">
                <small class="text-secondary">Trang ${currentPage}/${totalPages}</small>
                <div class="d-flex align-items-center gap-2">
                    <c:url value="/thuoc-tinh/hien-thi" var="prev"><c:param name="type" value="${type}"/><c:param name="keyword" value="${keyword}"/><c:param name="size" value="${pageSize}"/><c:param name="page" value="${currentPage > 1 ? currentPage-1 : 1}"/></c:url>
                    <c:url value="/thuoc-tinh/hien-thi" var="next"><c:param name="type" value="${type}"/><c:param name="keyword" value="${keyword}"/><c:param name="size" value="${pageSize}"/><c:param name="page" value="${currentPage < totalPages ? currentPage+1 : totalPages}"/></c:url>
                    <a class="btn btn-outline-secondary btn-sm ${currentPage <= 1 ? 'disabled' : ''}" data-page-link href="${prev}"><i class="bi bi-chevron-left"></i></a><span class="small px-2">${currentPage}</span><a class="btn btn-outline-secondary btn-sm ${currentPage >= totalPages ? 'disabled' : ''}" data-page-link href="${next}"><i class="bi bi-chevron-right"></i></a>
                    <select class="form-select form-select-sm ms-2" data-page-size style="width:auto"><option value="10" ${pageSize==10?'selected':''}>10 / trang</option><option value="20" ${pageSize==20?'selected':''}>20 / trang</option><option value="50" ${pageSize==50?'selected':''}>50 / trang</option></select>
                </div>
            </div>
        </div>
    </div>
</div>

<div class="modal fade" id="attributeModal" tabindex="-1"><div class="modal-dialog modal-dialog-centered"><div class="modal-content"><div class="modal-header"><div><h5 class="modal-title fw-bold">${empty thuocTinhForm.id ? 'Thêm' : 'Cập nhật'} ${typeLabel}</h5><small class="text-secondary">Nhập đúng và đủ thông tin bên dưới.</small></div><button class="btn-close" data-bs-dismiss="modal"></button></div><div class="modal-body p-4">
    <form id="attributeForm" method="post" action="${pageContext.request.contextPath}/thuoc-tinh/${empty thuocTinhForm.id ? 'add' : 'update'}" novalidate>
        <input type="hidden" name="type" value="${type}"><c:if test="${not empty thuocTinhForm.id}"><input type="hidden" name="id" value="${thuocTinhForm.id}"></c:if>
        <c:if test="${hasCode}"><div class="mb-3"><label class="form-label">Mã ${typeLabel} <span class="required">*</span></label><input class="form-control text-uppercase" name="ma" value="${thuocTinhForm.ma}" minlength="2" maxlength="20" pattern="[A-Za-z0-9_-]+" required placeholder="Ví dụ: TT001"><div class="invalid-feedback">Mã gồm 2–20 ký tự, chỉ chứa chữ, số, _ hoặc -.</div></div></c:if>
        <div class="mb-3"><label class="form-label">Tên ${typeLabel} <span class="required">*</span></label><input class="form-control" name="ten" value="${thuocTinhForm.ten}" minlength="2" maxlength="50" required placeholder="Nhập tên ${fn:toLowerCase(typeLabel)}"><div class="invalid-feedback">Tên phải từ 2 đến 50 ký tự.</div></div>
        <c:if test="${hasDescription}"><div class="mb-3"><label class="form-label">Mô tả</label><textarea class="form-control" name="moTa" rows="3" maxlength="255" placeholder="Mô tả ngắn">${thuocTinhForm.moTa}</textarea></div></c:if>
        <div class="d-flex justify-content-end gap-2 pt-3 border-top"><a class="btn btn-outline-secondary px-4" href="${pageContext.request.contextPath}/thuoc-tinh/hien-thi?type=${type}">Hủy</a><button class="btn btn-dark px-4">${empty thuocTinhForm.id ? 'Thêm mới' : 'Cập nhật'}</button></div>
    </form>
</div></div></div></div>
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
<script src="${pageContext.request.contextPath}/assets/js/sanpham-attribute-list.js?v=live1"></script>
<script>
(function(){
 var form=document.getElementById('attributeForm');
 if(form){form.addEventListener('submit',function(e){if(!form.checkValidity()){e.preventDefault();e.stopPropagation();}form.classList.add('was-validated');});}
 document.querySelectorAll('input[name="ma"]').forEach(function(el){el.addEventListener('input',function(){this.value=this.value.toUpperCase().replace(/[^A-Z0-9_-]/g,'');});});
 <c:if test="${openAttributeModal}">new bootstrap.Modal(document.getElementById('attributeModal')).show();</c:if>
})();
</script>
<%@ include file="/views/layout/footer.jsp" %>
</body></html>
