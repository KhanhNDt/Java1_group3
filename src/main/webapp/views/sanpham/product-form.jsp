<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <%@ include file="/views/layout/head.jsp" %>
    <title>${empty sanPhamForm ? 'Thêm sản phẩm mới' : 'Cập nhật sản phẩm'}</title>
    <style>
        .product-form-page{max-width:1700px;margin:0 auto;padding-bottom:82px}.form-page-title{font-size:20px;font-weight:800;color:#0f172a}.section-card{overflow:hidden;margin-bottom:14px;border:1px solid #dce3ee;border-radius:14px;background:#fff;box-shadow:0 4px 16px rgba(15,23,42,.04)}.section-head{padding:14px 16px;border-bottom:1px solid #e5eaf1;font-size:15px;font-weight:800;color:#0f172a}.section-body{padding:18px}.field-with-add{display:grid;grid-template-columns:1fr 38px;gap:7px}.field-add{display:grid;place-items:center;width:38px;height:43px;padding:0}.choice-box{min-height:48px;padding:8px;border:1px solid #c9c9c9;border-radius:11px;background:#fff}.choice-list{display:flex;gap:7px;flex-wrap:wrap}.choice-item{position:relative}.choice-item input{position:absolute;opacity:0;pointer-events:none}.choice-item label{display:flex;align-items:center;gap:6px;margin:0!important;padding:7px 10px;border:1px solid #d8e0ea;border-radius:8px;background:#f8f8f8;cursor:pointer;font-size:12px!important;font-weight:700!important}.choice-item input:checked+label{color:#fff;border-color:#1d4ed8;background:#1d4ed8}.generate-btn{width:100%;min-height:43px;margin-top:12px}.variant-list{margin-top:16px;border:1px solid #dce3ee;border-radius:12px;overflow:hidden}.variant-list-head{display:flex;align-items:center;justify-content:space-between;gap:12px;padding:11px 13px;color:#fff;background:linear-gradient(90deg,#12366c,#244bc3)}.variant-list-head strong{font-size:13px}.variant-toolbar{display:grid;grid-template-columns:1fr 1fr 1fr auto;gap:8px;padding:12px;background:#f8f8f8;border-bottom:1px solid #e2e2e2}.color-group{border-bottom:1px solid #e5e7eb}.color-group:last-child{border-bottom:0}.color-group-head{display:flex;align-items:center;justify-content:space-between;gap:12px;padding:10px 13px;background:#fff}.color-name{display:flex;align-items:center;gap:8px;font-weight:800}.color-dot{width:10px;height:10px;border-radius:50%;background:#1e293b;box-shadow:0 0 0 3px #e2e2e2}.group-apply{display:flex;gap:7px;align-items:center}.group-apply input{width:130px;min-height:34px}.variant-table thead th{padding:10px 12px!important;background:#f8f8f8!important;color:#444444!important;font-size:11px}.variant-table td{padding:8px 12px!important}.variant-table .form-control{min-height:36px!important;height:36px}.size-cell{font-weight:800;background:#faf7ff!important}.remove-row{width:34px;height:34px;padding:0!important}.variant-empty{padding:34px;text-align:center;color:#686868}.form-bottom-bar{position:fixed;right:0;bottom:0;left:var(--admin-sidebar-width);z-index:1030;display:flex;justify-content:flex-end;gap:10px;padding:12px 34px;border-top:1px solid #dce3ee;background:rgba(255,255,255,.95);backdrop-filter:blur(12px);transition:left .25s ease}body.admin-sidebar-collapsed .form-bottom-bar{left:var(--admin-sidebar-collapsed-width)}.helper-note{font-size:11px;color:#686868}.required-star{color:#dc2626}.form-counter{font-size:11px;color:#686868;text-align:right}.variant-count{padding:4px 9px;border-radius:999px;background:rgba(255,255,255,.16);font-size:11px}.error-summary{border-left:4px solid #dc2626}
        @media(max-width:900px){.variant-toolbar{grid-template-columns:1fr 1fr}.group-apply{flex-wrap:wrap}.form-bottom-bar{left:var(--admin-sidebar-collapsed-width);padding:10px 14px}.variant-table{min-width:760px}}
    </style>
</head>
<body>
<%@ include file="/views/layout/sidebar.jsp" %>
<main class="main-content">
<div class="product-form-page">
    <div class="d-flex justify-content-between align-items-center gap-3 flex-wrap mb-3">
        <div><div class="small text-secondary mb-1">Scott Admin / Sản phẩm</div><div class="form-page-title">${empty sanPhamForm ? 'Thêm sản phẩm mới' : 'Cập nhật sản phẩm'} ${not empty sanPhamForm ? '- '.concat(sanPhamForm.maSanPham) : ''}</div></div>
        <a class="btn btn-outline-secondary" href="${pageContext.request.contextPath}/san-pham/hien-thi"><i class="bi bi-arrow-left me-1"></i>Quay lại danh sách</a>
    </div>

    <c:if test="${not empty error}"><div class="alert alert-danger error-summary"><i class="bi bi-exclamation-triangle-fill me-2"></i>${error}</div></c:if>

    <form id="productForm" method="post" action="${pageContext.request.contextPath}/san-pham/${empty sanPhamForm ? 'add' : 'update'}" novalidate>
        <c:if test="${not empty sanPhamForm}"><input type="hidden" name="id" value="${sanPhamForm.id}"></c:if>
        <section class="section-card">
            <div class="section-head">Thông tin cơ bản</div>
            <div class="section-body">
                <div class="row g-3">
                    <div class="col-xl-4 col-md-6">
                        <label class="form-label">Tên sản phẩm <span class="required-star">*</span></label>
                        <input class="form-control" name="tenSanPham" minlength="3" maxlength="100" required value="${not empty param.tenSanPham ? param.tenSanPham : sanPhamForm.tenSanPham}" placeholder="Nhập tên sản phẩm">
                    </div>
                    <div class="col-xl-4 col-md-6">
                        <label class="form-label">Loại sản phẩm <span class="required-star">*</span></label>
                        <div class="field-with-add"><select class="form-select" name="idDanhMuc" required><option value="">-- Chọn loại sản phẩm --</option><c:forEach items="${listDanhMuc}" var="x"><option value="${x.id}" ${(not empty param.idDanhMuc ? param.idDanhMuc == x.id : sanPhamForm.danhMuc.id == x.id) ? 'selected' : ''}>${x.tenDanhMuc}</option></c:forEach></select><a class="btn btn-outline-secondary field-add" title="Thêm danh mục" href="${pageContext.request.contextPath}/thuoc-tinh/hien-thi?type=danh-muc"><i class="bi bi-plus-lg"></i></a></div>
                    </div>
                    <div class="col-xl-4 col-md-6">
                        <label class="form-label">Thương hiệu <span class="required-star">*</span></label>
                        <div class="field-with-add"><select class="form-select" name="idThuongHieu" required><option value="">-- Chọn thương hiệu --</option><c:forEach items="${listThuongHieu}" var="x"><option value="${x.id}" ${(not empty param.idThuongHieu ? param.idThuongHieu == x.id : sanPhamForm.thuongHieu.id == x.id) ? 'selected' : ''}>${x.ten}</option></c:forEach></select><a class="btn btn-outline-secondary field-add" title="Thêm thương hiệu" href="${pageContext.request.contextPath}/thuoc-tinh/hien-thi?type=thuong-hieu"><i class="bi bi-plus-lg"></i></a></div>
                    </div>
                    <div class="col-xl-4 col-md-6">
                        <label class="form-label">Chất liệu <span class="required-star">*</span></label>
                        <div class="field-with-add"><select class="form-select" name="idChatLieu" required><option value="">-- Chọn chất liệu --</option><c:forEach items="${listChatLieu}" var="x"><option value="${x.id}" ${(not empty param.idChatLieu ? param.idChatLieu == x.id : sanPhamForm.chatLieu.id == x.id) ? 'selected' : ''}>${x.tenChatLieu}</option></c:forEach></select><a class="btn btn-outline-secondary field-add" title="Thêm chất liệu" href="${pageContext.request.contextPath}/thuoc-tinh/hien-thi?type=chat-lieu"><i class="bi bi-plus-lg"></i></a></div>
                    </div>
                    <div class="col-xl-4 col-md-6">
                        <label class="form-label">Kiểu dáng <span class="required-star">*</span></label>
                        <div class="field-with-add"><select class="form-select" name="idKieuDang" required><option value="">-- Chọn kiểu dáng --</option><c:forEach items="${listKieuDang}" var="x"><option value="${x.id}" ${(not empty param.idKieuDang ? param.idKieuDang == x.id : sanPhamForm.kieuDang.id == x.id) ? 'selected' : ''}>${x.tenKieuDang}</option></c:forEach></select><a class="btn btn-outline-secondary field-add" title="Thêm kiểu dáng" href="${pageContext.request.contextPath}/thuoc-tinh/hien-thi?type=kieu-dang"><i class="bi bi-plus-lg"></i></a></div>
                    </div>
                    <div class="col-xl-2 col-md-3">
                        <label class="form-label">Giới tính <span class="required-star">*</span></label>
                        <select class="form-select" name="gioiTinh" required><option value="1" ${(not empty param.gioiTinh ? param.gioiTinh == '1' : sanPhamForm.gioiTinh) ? 'selected' : ''}>Nam</option><option value="0" ${(not empty param.gioiTinh ? param.gioiTinh == '0' : not empty sanPhamForm && !sanPhamForm.gioiTinh) ? 'selected' : ''}>Nữ</option></select>
                    </div>
                    <div class="col-xl-2 col-md-3">
                        <label class="form-label">Trạng thái <span class="required-star">*</span></label>
                        <select class="form-select" name="trangThai" required><option value="1" ${(not empty param.trangThai ? param.trangThai == '1' : empty sanPhamForm || sanPhamForm.trangThai == 1) ? 'selected' : ''}>Đang bán</option><option value="0" ${(not empty param.trangThai ? param.trangThai == '0' : sanPhamForm.trangThai == 0) ? 'selected' : ''}>Ngừng bán</option></select>
                    </div>
                    <div class="col-12">
                        <label class="form-label">Mô tả sản phẩm</label>
                        <textarea class="form-control" id="productDescription" name="moTa" rows="4" maxlength="500" placeholder="Nhập mô tả chi tiết...">${not empty param.moTa ? param.moTa : sanPhamForm.moTa}</textarea>
                        <div class="form-counter"><span id="descriptionCount">0</span>/500</div>
                    </div>
                </div>
            </div>
        </section>

        <c:if test="${empty sanPhamForm}">
        <section class="section-card">
            <div class="section-head">Biến thể sản phẩm</div>
            <div class="section-body">
                <div class="row g-3">
                    <div class="col-md-6"><label class="form-label">Màu sắc <span class="required-star">*</span></label><div class="choice-box"><div class="choice-list" id="colorChoices"><c:forEach items="${listMauSac}" var="x"><span class="choice-item"><input type="checkbox" class="variant-color" id="color-${x.id}" value="${x.id}" data-label="${fn:escapeXml(x.ten)}"><label for="color-${x.id}"><span class="color-dot"></span>${x.ten}</label></span></c:forEach></div></div></div>
                    <div class="col-md-6"><label class="form-label">Kích cỡ <span class="required-star">*</span></label><div class="choice-box"><div class="choice-list" id="sizeChoices"><c:forEach items="${listSize}" var="x"><span class="choice-item"><input type="checkbox" class="variant-size" id="size-${x.id}" value="${x.id}" data-label="${fn:escapeXml(x.ten)}"><label for="size-${x.id}">${x.ten}</label></span></c:forEach></div></div></div>
                </div>
                <button type="button" class="btn btn-primary generate-btn" id="generateVariants"><i class="bi bi-lightning-charge-fill me-1"></i>Tạo biến thể tự động</button>

                <div class="variant-list" id="variantList">
                    <div class="variant-list-head"><strong>Danh sách biến thể</strong><div class="d-flex gap-2 align-items-center"><span class="variant-count" id="variantCount">0 biến thể</span><button type="button" class="btn btn-sm btn-light" id="clearVariants"><i class="bi bi-trash me-1"></i>Xóa tất cả</button></div></div>
                    <div class="variant-toolbar">
                        <input class="form-control form-control-sm" id="allStock" type="number" min="0" placeholder="Số lượng áp dụng tất cả">
                        <input class="form-control form-control-sm" id="allPurchase" type="number" min="0" step="1000" placeholder="Giá nhập áp dụng tất cả">
                        <input class="form-control form-control-sm" id="allPrice" type="number" min="0" step="1000" placeholder="Giá bán áp dụng tất cả">
                        <button type="button" class="btn btn-primary btn-sm" id="applyAll"><i class="bi bi-lightning me-1"></i>Áp dụng tất cả</button>
                    </div>
                    <div id="variantGroups"><div class="variant-empty"><i class="bi bi-grid-3x3-gap fs-3 d-block mb-2"></i>Chọn màu sắc, kích cỡ rồi nhấn “Tạo biến thể tự động”.</div></div>
                </div>
                <div class="helper-note mt-2">Mỗi tổ hợp màu và kích cỡ tạo thành một biến thể riêng. Giá bán phải lớn hơn hoặc bằng giá nhập.</div>
            </div>
        </section>
        </c:if>

        <div class="form-bottom-bar"><a class="btn btn-outline-secondary px-4" href="${pageContext.request.contextPath}/san-pham/hien-thi">Hủy</a><button type="submit" class="btn btn-primary px-4"><i class="bi bi-check2-circle me-1"></i>${empty sanPhamForm ? 'Hoàn tất' : 'Cập nhật'}</button></div>
    </form>
</div>
</main>
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
<script>
(function(){
    var desc=document.getElementById('productDescription'), count=document.getElementById('descriptionCount');
    function updateCount(){if(count)count.textContent=desc.value.length;} if(desc){desc.addEventListener('input',updateCount);updateCount();}
    var generate=document.getElementById('generateVariants'); if(!generate)return;
    var groups=document.getElementById('variantGroups'), countEl=document.getElementById('variantCount');
    var savedRows=[<c:forEach items="${paramValues.variantMauSac}" var="m" varStatus="st">{color:'${m}',size:'${paramValues.variantSize[st.index]}',purchase:'${paramValues.variantGiaNhap[st.index]}',price:'${paramValues.variantGiaBan[st.index]}',stock:'${paramValues.variantSoLuongTon[st.index]}'},</c:forEach>];
    function selected(selector){return Array.prototype.slice.call(document.querySelectorAll(selector+':checked')).map(function(x){return{id:x.value,label:x.dataset.label};});}
    function currentValues(){var map={};document.querySelectorAll('.variant-row').forEach(function(row){map[row.dataset.color+'-'+row.dataset.size]={purchase:row.querySelector('[name="variantGiaNhap"]').value,price:row.querySelector('[name="variantGiaBan"]').value,stock:row.querySelector('[name="variantSoLuongTon"]').value};});return map;}
    function esc(v){return String(v).replace(/[&<>"']/g,function(c){return{'&':'&amp;','<':'&lt;','>':'&gt;','"':'&quot;',"'":'&#039;'}[c];});}
    function render(preserved){var colors=selected('.variant-color'), sizes=selected('.variant-size');if(!colors.length||!sizes.length){groups.innerHTML='<div class="variant-empty">Vui lòng chọn ít nhất một màu sắc và một kích cỡ.</div>';countEl.textContent='0 biến thể';return;}var html='',total=0;colors.forEach(function(color){html+='<div class="color-group" data-color-group="'+color.id+'"><div class="color-group-head"><div class="color-name"><span class="color-dot"></span>'+esc(color.label)+' <span class="text-secondary fw-normal">('+sizes.length+' kích cỡ)</span></div><div class="group-apply"><input class="form-control form-control-sm group-stock" type="number" min="0" placeholder="SL nhóm"><input class="form-control form-control-sm group-price" type="number" min="0" placeholder="Giá bán nhóm"><button type="button" class="btn btn-primary btn-sm apply-group">Áp dụng nhóm</button></div></div><div class="table-responsive"><table class="table variant-table align-middle mb-0"><thead><tr><th style="width:25%">Kích cỡ</th><th>Số lượng tồn</th><th>Giá nhập</th><th>Đơn giá</th><th style="width:50px"></th></tr></thead><tbody>';sizes.forEach(function(size){var key=color.id+'-'+size.id,v=preserved[key]||{};html+='<tr class="variant-row" data-color="'+color.id+'" data-size="'+size.id+'"><td class="size-cell">'+esc(size.label)+'<input type="hidden" name="variantMauSac" value="'+color.id+'"><input type="hidden" name="variantSize" value="'+size.id+'"></td><td><input class="form-control" name="variantSoLuongTon" type="number" min="0" required value="'+esc(v.stock||'0')+'"></td><td><input class="form-control" name="variantGiaNhap" type="number" min="0" step="1000" required value="'+esc(v.purchase||'0')+'"></td><td><input class="form-control" name="variantGiaBan" type="number" min="0" step="1000" required value="'+esc(v.price||'0')+'"></td><td><button type="button" class="btn btn-outline-danger remove-row"><i class="bi bi-x-lg"></i></button></td></tr>';total++;});html+='</tbody></table></div></div>';});groups.innerHTML=html;countEl.textContent=total+' biến thể';bindRows();}
    function bindRows(){document.querySelectorAll('.remove-row').forEach(function(btn){btn.onclick=function(){this.closest('tr').remove();cleanupGroups();};});document.querySelectorAll('.apply-group').forEach(function(btn){btn.onclick=function(){var group=this.closest('.color-group'),stock=group.querySelector('.group-stock').value,price=group.querySelector('.group-price').value;group.querySelectorAll('[name="variantSoLuongTon"]').forEach(function(x){if(stock!=='')x.value=stock;});group.querySelectorAll('[name="variantGiaBan"]').forEach(function(x){if(price!=='')x.value=price;});};});}
    function cleanupGroups(){document.querySelectorAll('.color-group').forEach(function(g){if(!g.querySelector('.variant-row'))g.remove();});countEl.textContent=document.querySelectorAll('.variant-row').length+' biến thể';if(!document.querySelector('.variant-row'))groups.innerHTML='<div class="variant-empty">Chưa có biến thể.</div>';}
    generate.addEventListener('click',function(){render(currentValues());});
    document.getElementById('clearVariants').addEventListener('click',function(){groups.innerHTML='<div class="variant-empty">Chưa có biến thể.</div>';countEl.textContent='0 biến thể';});
    document.getElementById('applyAll').addEventListener('click',function(){var stock=document.getElementById('allStock').value,purchase=document.getElementById('allPurchase').value,price=document.getElementById('allPrice').value;document.querySelectorAll('[name="variantSoLuongTon"]').forEach(function(x){if(stock!=='')x.value=stock;});document.querySelectorAll('[name="variantGiaNhap"]').forEach(function(x){if(purchase!=='')x.value=purchase;});document.querySelectorAll('[name="variantGiaBan"]').forEach(function(x){if(price!=='')x.value=price;});});
    document.getElementById('productForm').addEventListener('submit',function(e){var rows=document.querySelectorAll('.variant-row');if(!rows.length){e.preventDefault();alert('Sản phẩm phải có ít nhất một biến thể.');return;}for(var i=0;i<rows.length;i++){var buy=Number(rows[i].querySelector('[name="variantGiaNhap"]').value),sell=Number(rows[i].querySelector('[name="variantGiaBan"]').value);if(sell<buy){e.preventDefault();alert('Giá bán phải lớn hơn hoặc bằng giá nhập ở tất cả biến thể.');return;}}});
    if(savedRows.length){var colorSet={},sizeSet={},map={};savedRows.forEach(function(r){colorSet[r.color]=true;sizeSet[r.size]=true;map[r.color+'-'+r.size]={purchase:r.purchase,price:r.price,stock:r.stock};});Object.keys(colorSet).forEach(function(id){var x=document.getElementById('color-'+id);if(x)x.checked=true;});Object.keys(sizeSet).forEach(function(id){var x=document.getElementById('size-'+id);if(x)x.checked=true;});render(map);}
})();
</script>
<%@ include file="/views/layout/footer.jsp" %>
</body>
</html>
