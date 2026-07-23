<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <%@ include file="/views/layout/head.jsp" %>
    <title>Danh sách sản phẩm</title>
    <style>
        .product-toolbar{display:flex;justify-content:space-between;align-items:center;gap:16px;margin-bottom:18px}
        .filter-box{border:1px solid #dedede;border-radius:16px;background:#fff;box-shadow:0 4px 18px rgba(15,23,42,.05);overflow:hidden}
        .filter-box__head{display:flex;justify-content:space-between;align-items:center;padding:13px 18px;color:#fff;background:linear-gradient(90deg,#111111,#242424);cursor:pointer}
        .filter-box__body{padding:20px}.filter-box.collapsed .filter-box__body{display:none}.filter-box__head small{color:#c9c9c9}
        .price-range-label{display:flex;justify-content:space-between;color:#111111;font-weight:700;font-size:12px}
        .product-table-card{border:1px solid #dedede;border-radius:16px;background:#fff;box-shadow:0 4px 18px rgba(15,23,42,.05);overflow:hidden}
        .product-table-card table{margin:0}.product-table-card thead th{background:#111111!important;color:#fff!important;text-transform:none!important;font-size:12px!important;padding:14px 12px!important}
        .product-table-card tbody td{padding:14px 12px!important}
        .product-status{display:inline-flex;align-items:center;gap:9px;padding:6px 9px 6px 11px;border:1px solid #dedede;border-radius:999px;background:#fff;box-shadow:0 3px 10px rgba(15,23,42,.05)}
        .status-badge{display:inline-flex;align-items:center;gap:7px;min-width:76px;font-size:12px;font-weight:800;white-space:nowrap}.status-badge:before{content:"";width:8px;height:8px;border-radius:50%;box-shadow:0 0 0 3px currentColor;opacity:.85}.status-badge.on{color:#111111}.status-badge.off{color:#686868}
        .status-switch{position:relative;width:48px;height:26px;flex:0 0 48px}.status-switch input{position:absolute;opacity:0;pointer-events:none}.status-switch__track{position:absolute;inset:0;cursor:pointer;border:1px solid #c9c9c9;border-radius:999px;background:#e2e2e2;transition:.2s}.status-switch__track:before{content:"";position:absolute;top:3px;left:3px;width:18px;height:18px;border-radius:50%;background:#fff;box-shadow:0 2px 5px rgba(15,23,42,.25);transition:.2s}.status-switch input:checked+.status-switch__track{border-color:#111111;background:#111111}.status-switch input:checked+.status-switch__track:before{transform:translateX(22px)}.status-switch input:focus-visible+.status-switch__track{box-shadow:0 0 0 4px rgba(37,99,235,.16)}
        .stock-badge{font-weight:700}.action-eye{width:36px;height:36px;display:inline-grid;place-items:center;border:1px solid #888888;border-radius:8px;color:#111111;background:#fff;text-decoration:none}.action-eye:hover{color:#fff;background:#111111}
        .table-footer{display:flex;justify-content:space-between;align-items:center;gap:16px;padding:16px 18px;border-top:1px solid #e2e2e2}.pagination{margin:0}
        .live-filter-note{display:flex;align-items:center;gap:7px;min-height:43px;color:#686868;font-size:12px}.live-filter-note i{color:#111111}.product-table-card.is-loading{position:relative;min-height:180px}.product-table-card.is-loading:after{content:"Đang lọc dữ liệu...";position:absolute;inset:0;z-index:5;display:grid;place-items:center;color:#111111;font-weight:700;background:rgba(255,255,255,.78);backdrop-filter:blur(1px)}
        @media(max-width:992px){.product-toolbar,.table-footer{align-items:stretch;flex-direction:column}.product-toolbar .btn{width:100%}}
    </style>
</head>
<body>
<%@ include file="/views/layout/sidebar.jsp" %>
<main class="main-content">
    <div class="product-toolbar">
        <div>
            <div class="small text-secondary mb-1">Scott Admin / Quản lý sản phẩm / Danh sách sản phẩm</div>
            <h2 class="fw-bold mb-1">Danh sách sản phẩm</h2>
            <div class="text-secondary">Quản lý thông tin, tồn kho, khoảng giá và trạng thái bán.</div>
        </div>
        <div class="d-flex flex-wrap gap-2">
            <a class="btn btn-outline-primary" href="${pageContext.request.contextPath}/san-pham/chi-tiet/hien-thi"><i class="bi bi-layers me-1"></i> Danh sách biến thể</a>
            <a class="btn btn-primary" href="${pageContext.request.contextPath}/san-pham/them-moi"><i class="bi bi-plus-lg me-1"></i> Thêm mới</a>
        </div>
    </div>

    <c:if test="${not empty success}"><div class="alert alert-success alert-dismissible fade show">${success}<button class="btn-close" data-bs-dismiss="alert"></button></div></c:if>
    <c:if test="${not empty error}"><div class="alert alert-danger alert-dismissible fade show">${error}<button class="btn-close" data-bs-dismiss="alert"></button></div></c:if>

    <section class="filter-box mb-4" id="productFilterBox">
        <div class="filter-box__head" id="productFilterToggle">
            <strong><i class="bi bi-funnel-fill me-2"></i>Bộ lọc tìm kiếm</strong>
            <small>Nhấn để thu gọn/mở rộng <i class="bi bi-chevron-up ms-1"></i></small>
        </div>
        <div class="filter-box__body">
            <form id="productLiveFilterForm" method="get" action="${pageContext.request.contextPath}/san-pham/hien-thi" class="row g-3 align-items-end" autocomplete="off">
                <input type="hidden" name="page" value="1">
                <input type="hidden" name="size" value="${pageSize}">
                <div class="col-xl-6 col-lg-5">
                    <label class="form-label">Tìm kiếm</label>
                    <div class="input-group"><span class="input-group-text"><i class="bi bi-search"></i></span><input id="productKeyword" class="form-control" name="keyword" value="${keyword}" placeholder="Tìm theo tên, mã sản phẩm, mã biến thể, màu, size..."></div>
                </div>
                <div class="col-xl-3 col-lg-3">
                    <label class="form-label">Thương hiệu</label>
                    <select class="form-select" name="locThuongHieu"><option value="">-- Tất cả thương hiệu --</option><c:forEach items="${listThuongHieu}" var="x"><option value="${x.id}" ${locThuongHieu == x.id ? 'selected' : ''}>${x.ten}</option></c:forEach></select>
                </div>
                <div class="col-xl-3 col-lg-4">
                    <label class="form-label">Loại sản phẩm</label>
                    <select class="form-select" name="locDanhMuc"><option value="">-- Tất cả loại sản phẩm --</option><c:forEach items="${listDanhMuc}" var="x"><option value="${x.id}" ${locDanhMuc == x.id ? 'selected' : ''}>${x.tenDanhMuc}</option></c:forEach></select>
                </div>
                <div class="col-xl-6 col-lg-6">
                    <label class="form-label">Sắp xếp</label>
                    <select class="form-select" name="sapXep">
                        <option value="mac-dinh" ${sapXep == 'mac-dinh' ? 'selected' : ''}>Mặc định</option><option value="moi-nhat" ${sapXep == 'moi-nhat' ? 'selected' : ''}>Mới nhất</option><option value="ten-az" ${sapXep == 'ten-az' ? 'selected' : ''}>Tên A → Z</option><option value="ten-za" ${sapXep == 'ten-za' ? 'selected' : ''}>Tên Z → A</option><option value="gia-thap" ${sapXep == 'gia-thap' ? 'selected' : ''}>Giá thấp → cao</option><option value="gia-cao" ${sapXep == 'gia-cao' ? 'selected' : ''}>Giá cao → thấp</option>
                    </select>
                </div>
                <div class="col-xl-4 col-lg-4">
                    <label class="form-label d-block">Trạng thái</label>
                    <div class="d-flex gap-3 align-items-center min-h-43"><label class="form-check"><input class="form-check-input" type="radio" name="locTrangThai" value="" ${empty locTrangThai ? 'checked' : ''}> Tất cả</label><label class="form-check"><input class="form-check-input" type="radio" name="locTrangThai" value="1" ${locTrangThai == 1 ? 'checked' : ''}> Đang bán</label><label class="form-check"><input class="form-check-input" type="radio" name="locTrangThai" value="0" ${locTrangThai == 0 ? 'checked' : ''}> Ngừng bán</label></div>
                </div>
                <div class="col-xl-2 col-lg-2 d-flex gap-2 align-items-end"><div class="live-filter-note flex-grow-1"><i class="bi bi-lightning-charge-fill"></i><span>Tự động lọc</span></div><button type="button" id="resetProductFilter" class="btn btn-outline-secondary" title="Đặt lại bộ lọc"><i class="bi bi-arrow-counterclockwise"></i></button></div>
            </form>
        </div>
    </section>

    <section class="product-table-card" id="productResults">
        <div class="px-3 pt-3 pb-2 fw-bold">Tổng số sản phẩm: ${tongSoSanPham}</div>
        <div class="table-responsive">
            <table class="table table-hover align-middle text-center">
                <thead><tr><th>STT</th><th>Mã sản phẩm</th><th class="text-start">Tên sản phẩm</th><th>Loại sản phẩm</th><th>Thương hiệu</th><th>Hàng tồn</th><th>Khoảng giá</th><th>Trạng thái</th><th>Hành động</th></tr></thead>
                <tbody>
                <c:forEach items="${listSanPhamView}" var="sp" varStatus="st">
                    <tr>
                        <td>${(currentPage-1)*pageSize+st.count}</td><td class="fw-semibold">${sp.maSanPham}</td><td class="text-start fw-semibold">${sp.tenSanPham}</td><td>${sp.tenDanhMuc}</td><td>${sp.tenThuongHieu}</td>
                        <td><span class="stock-badge">${empty sp.tongTon ? 0 : sp.tongTon}</span></td>
                        <td><c:choose><c:when test="${empty sp.giaMin}">Chưa có giá</c:when><c:when test="${sp.giaMin == sp.giaMax}"><fmt:formatNumber value="${sp.giaMin}" pattern="#,#00"/> ₫</c:when><c:otherwise><fmt:formatNumber value="${sp.giaMin}" pattern="#,#00"/> – <fmt:formatNumber value="${sp.giaMax}" pattern="#,#00"/> ₫</c:otherwise></c:choose></td>
                        <td><div class="product-status"><span id="product-status-label-${sp.id}" class="status-badge ${sp.trangThai == 1 ? 'on' : 'off'}">${sp.trangThai == 1 ? 'Đang bán' : 'Ngừng bán'}</span><label class="status-switch" title="Đổi trạng thái sản phẩm"><input class="product-status-toggle" type="checkbox" data-id="${sp.id}" aria-label="Đổi trạng thái ${sp.tenSanPham}" ${sp.trangThai == 1 ? 'checked' : ''}><span class="status-switch__track"></span></label></div></td>
                        <td><a class="action-eye" title="Xem biến thể" href="${pageContext.request.contextPath}/san-pham/chi-tiet/hien-thi?idSanPham=${sp.id}"><i class="bi bi-eye"></i></a></td>
                    </tr>
                </c:forEach>
                <c:if test="${empty listSanPhamView}"><tr><td colspan="9" class="py-5 text-secondary"><i class="bi bi-inbox fs-2 d-block mb-2"></i>Không tìm thấy sản phẩm phù hợp.</td></tr></c:if>
                </tbody>
            </table>
        </div>
        <div class="table-footer">
            <span>Hiển thị ${empty listSanPhamView ? 0 : fn:length(listSanPhamView)} / tổng ${tongSoSanPham} bản ghi</span>
            <nav><ul class="pagination pagination-sm"><c:forEach begin="1" end="${tongSoTrang}" var="p"><li class="page-item ${p == currentPage ? 'active' : ''}"><a class="page-link" href="?keyword=${fn:escapeXml(keyword)}&locDanhMuc=${locDanhMuc}&locThuongHieu=${locThuongHieu}&locTrangThai=${locTrangThai}&sapXep=${sapXep}&page=${p}&size=${pageSize}">${p}</a></li></c:forEach></ul></nav>
            <select class="form-select form-select-sm" data-page-size style="width:auto"><option value="10" ${pageSize==10?'selected':''}>10 bản ghi / trang</option><option value="20" ${pageSize==20?'selected':''}>20 bản ghi / trang</option><option value="50" ${pageSize==50?'selected':''}>50 bản ghi / trang</option></select>
        </div>
    </section>
</main>

<div class="modal fade" id="statusConfirmModal" tabindex="-1" aria-hidden="true"><div class="modal-dialog modal-dialog-centered modal-sm"><div class="modal-content"><div class="modal-header"><h5 class="modal-title"><i class="bi bi-arrow-repeat me-2 text-primary"></i>Đổi trạng thái</h5><button class="btn-close" data-bs-dismiss="modal"></button></div><div class="modal-body" id="statusConfirmText"></div><div class="modal-footer"><button class="btn btn-outline-secondary" data-bs-dismiss="modal">Hủy</button><button class="btn btn-primary" id="confirmStatusButton"><i class="bi bi-check2 me-1"></i>Xác nhận</button></div></div></div></div>
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
<script>
const ctx='${pageContext.request.contextPath}';
const filterBox=document.getElementById('productFilterBox');
document.getElementById('productFilterToggle').addEventListener('click',()=>filterBox.classList.toggle('collapsed'));

const liveForm=document.getElementById('productLiveFilterForm');
const keywordInput=document.getElementById('productKeyword');
let liveFilterTimer=null;
let liveFilterController=null;

function buildFilterUrl(page){
    const params=new URLSearchParams(new FormData(liveForm));
    params.set('page',page||'1');
    return liveForm.action+'?'+params.toString();
}

async function loadProductResults(url, pushHistory=true){
    const current=document.getElementById('productResults');
    if(!current)return;
    if(liveFilterController)liveFilterController.abort();
    liveFilterController=new AbortController();
    current.classList.add('is-loading');
    try{
        const response=await fetch(url,{headers:{'X-Requested-With':'XMLHttpRequest'},signal:liveFilterController.signal});
        if(!response.ok)throw new Error('Không thể tải dữ liệu lọc.');
        const html=await response.text();
        const doc=new DOMParser().parseFromString(html,'text/html');
        const next=doc.getElementById('productResults');
        if(!next)throw new Error('Không tìm thấy vùng kết quả sản phẩm.');
        current.replaceWith(next);
        if(pushHistory)history.replaceState({},'',url);
    }catch(error){
        if(error.name!=='AbortError'){
            current.classList.remove('is-loading');
            alert(error.message||'Lọc sản phẩm thất bại.');
        }
    }
}

function scheduleLiveFilter(){
    clearTimeout(liveFilterTimer);
    liveFilterTimer=setTimeout(()=>loadProductResults(buildFilterUrl('1')),350);
}

keywordInput.addEventListener('input',scheduleLiveFilter);
liveForm.querySelectorAll('select,input[type="radio"]').forEach(el=>el.addEventListener('change',()=>loadProductResults(buildFilterUrl('1'))));
liveForm.addEventListener('submit',event=>{event.preventDefault();loadProductResults(buildFilterUrl('1'));});

document.getElementById('resetProductFilter').addEventListener('click',()=>{
    keywordInput.value='';
    liveForm.querySelector('[name="locThuongHieu"]').value='';
    liveForm.querySelector('[name="locDanhMuc"]').value='';
    liveForm.querySelector('[name="sapXep"]').value='mac-dinh';
    const allStatus=liveForm.querySelector('[name="locTrangThai"][value=""]');
    if(allStatus)allStatus.checked=true;
    liveForm.querySelector('[name="page"]').value='1';
    loadProductResults(buildFilterUrl('1'));
});

document.addEventListener('click',event=>{
    const pageLink=event.target.closest('#productResults .pagination a.page-link');
    if(pageLink){event.preventDefault();loadProductResults(pageLink.href);return;}
});
document.addEventListener('change',event=>{
    const sizeSelect=event.target.closest('#productResults select[data-page-size]');
    if(sizeSelect){
        const params=new URLSearchParams(new FormData(liveForm));
        params.set('page','1');params.set('size',sizeSelect.value);
        liveForm.querySelector('[name="size"]').value=sizeSelect.value;
        loadProductResults(liveForm.action+'?'+params.toString());
        return;
    }
    const toggle=event.target.closest('.product-status-toggle');
    if(toggle){
        pendingToggle=toggle;
        pendingToggle.dataset.requestedState=toggle.checked?'1':'0';
        const action=toggle.checked?'Đang bán':'Ngừng bán';
        document.getElementById('statusConfirmText').innerHTML='<div class="text-center py-2"><div class="fs-2 mb-2">'+(toggle.checked?'🟢':'⚪')+'</div><div>Bạn có chắc muốn chuyển sản phẩm sang <strong>'+action+'</strong>?</div><small class="text-secondary d-block mt-2">Thao tác chỉ thay đổi khả năng bán, không xóa dữ liệu sản phẩm.</small></div>';
        toggle.checked=!toggle.checked;
        confirmModal.show();
    }
});

let pendingToggle=null;
const confirmModal=new bootstrap.Modal(document.getElementById('statusConfirmModal'));
document.getElementById('confirmStatusButton').addEventListener('click',function(){
    if(!pendingToggle)return;
    const el=pendingToggle;
    const button=this;
    button.disabled=true;
    button.innerHTML='<span class="spinner-border spinner-border-sm me-1"></span>Đang lưu';
    fetch(ctx+'/san-pham/toggle-trang-thai?id='+encodeURIComponent(el.dataset.id),{method:'POST',headers:{'X-Requested-With':'XMLHttpRequest'}})
        .then(r=>r.json())
        .then(data=>{
            if(!data.success)throw new Error(data.message);
            el.checked=data.trangThai===1;
            const label=document.getElementById('product-status-label-'+el.dataset.id);
            if(label){label.textContent=data.message;label.className='status-badge '+(data.trangThai===1?'on':'off');}
            confirmModal.hide();pendingToggle=null;
        })
        .catch(e=>alert(e.message||'Đổi trạng thái thất bại.'))
        .finally(()=>{button.disabled=false;button.innerHTML='<i class="bi bi-check2 me-1"></i>Xác nhận';});
});
document.getElementById('statusConfirmModal').addEventListener('hidden.bs.modal',()=>{pendingToggle=null;});
</script>
<%@ include file="/views/layout/footer.jsp" %>
</body></html>
