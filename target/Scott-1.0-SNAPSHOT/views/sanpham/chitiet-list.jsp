<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <%@ include file="/views/layout/head.jsp" %>
    <title>Danh sách biến thể</title>
    <style>
        .filter-card,.variant-card{border:1px solid #dedede;border-radius:16px;background:#fff;overflow:hidden;box-shadow:0 4px 18px rgba(0,0,0,.05)}
        .filter-head{display:flex;justify-content:space-between;align-items:center;padding:13px 18px;color:#fff;background:linear-gradient(90deg,#111,#242424)}
        .filter-head small{color:#d0d0d0}.filter-body{padding:20px}
        .variant-card thead th{background:#111!important;color:#fff!important;text-transform:none!important;font-size:12px!important;padding:14px 10px!important}.variant-card tbody td{padding:13px 10px!important}
        .product-thumb{display:grid;place-items:center;width:68px;height:68px;margin:auto;border:1px solid #dedede;border-radius:10px;background:linear-gradient(145deg,#fafafa,#e7e7e7);color:#666;font-size:24px}
        .color-dot{display:inline-block;width:9px;height:9px;border-radius:50%;background:#444;margin-right:6px}.status-pill{display:inline-flex;padding:5px 10px;border-radius:999px;font-weight:700;font-size:12px;border:1px solid #cfcfcf}.status-pill.on{color:#111;background:#fff}.status-pill.off{color:#777;background:#ededed}
        .variant-switch:checked{background-color:#111;border-color:#111}.table-footer{display:flex;justify-content:space-between;align-items:center;gap:14px;padding:15px 18px;border-top:1px solid #e2e2e2}
        .live-filter-note{display:flex;align-items:center;gap:7px;min-height:43px;color:#666;font-size:12px}.live-filter-note i{color:#111}
        .variant-card.is-loading{position:relative;min-height:220px}.variant-card.is-loading:after{content:"Đang lọc dữ liệu...";position:absolute;inset:0;z-index:5;display:grid;place-items:center;color:#111;font-weight:700;background:rgba(255,255,255,.82);backdrop-filter:blur(1px)}
        @media(max-width:992px){.table-footer{align-items:stretch;flex-direction:column}}
    </style>
</head>
<body>
<%@ include file="/views/layout/sidebar.jsp" %>
<main class="main-content">
    <div class="d-flex justify-content-between align-items-start gap-3 mb-4">
        <div><div class="small text-secondary mb-1">Scott Admin / Quản lý sản phẩm / Danh sách biến thể</div><h2 class="fw-bold mb-1">Danh sách biến thể</h2><div class="text-secondary">Tra cứu biến thể theo sản phẩm, màu sắc, kích thước, tồn kho, giá bán và trạng thái.</div></div>
        <div class="d-flex flex-wrap gap-2"><a class="btn btn-outline-primary" href="${pageContext.request.contextPath}/san-pham/hien-thi"><i class="bi bi-arrow-left me-1"></i>Danh sách sản phẩm</a><a class="btn btn-primary" href="${pageContext.request.contextPath}/san-pham/them-moi"><i class="bi bi-plus-lg me-1"></i>Thêm sản phẩm</a></div>
    </div>
    <c:if test="${not empty success}"><div class="alert alert-success alert-dismissible fade show">${success}<button class="btn-close" data-bs-dismiss="alert"></button></div></c:if>
    <c:if test="${not empty error}"><div class="alert alert-danger alert-dismissible fade show">${error}<button class="btn-close" data-bs-dismiss="alert"></button></div></c:if>

    <section class="filter-card mb-4">
        <div class="filter-head"><strong><i class="bi bi-funnel-fill me-2"></i>Bộ lọc tìm kiếm</strong><small><i class="bi bi-lightning-charge-fill me-1"></i>Tự động lọc</small></div>
        <div class="filter-body">
            <form id="variantLiveFilterForm" method="get" action="${pageContext.request.contextPath}/san-pham/chi-tiet/hien-thi" class="row g-3 align-items-end" autocomplete="off">
                <input type="hidden" name="page" value="1"><input type="hidden" name="size" value="${pageSize}">
                <div class="col-xl-5 col-lg-6"><label class="form-label">Tìm kiếm</label><div class="input-group"><span class="input-group-text"><i class="bi bi-search"></i></span><input id="variantKeyword" class="form-control" name="keyword" value="${keyword}" placeholder="Mã SP, mã biến thể, tên, màu, kích cỡ..."></div></div>
                <div class="col-xl-3 col-lg-3"><label class="form-label">Sản phẩm</label><select class="form-select" name="idSanPham"><option value="">-- Tất cả sản phẩm --</option><c:forEach items="${listSanPham}" var="sp"><option value="${sp.id}" ${idSanPham==sp.id?'selected':''}>${sp.maSanPham} - ${sp.tenSanPham}</option></c:forEach></select></div>
                <div class="col-xl-2 col-lg-3"><label class="form-label">Màu sắc</label><select class="form-select" name="idMauSac"><option value="">-- Tất cả màu --</option><c:forEach items="${listMauSac}" var="x"><option value="${x.id}" ${idMauSac==x.id?'selected':''}>${x.ten}</option></c:forEach></select></div>
                <div class="col-xl-2 col-lg-3"><label class="form-label">Kích cỡ</label><select class="form-select" name="idSize"><option value="">-- Tất cả size --</option><c:forEach items="${listSize}" var="x"><option value="${x.id}" ${idSize==x.id?'selected':''}>${x.ten}</option></c:forEach></select></div>
                <div class="col-xl-3 col-lg-3"><label class="form-label">Số lượng tồn</label><select class="form-select" name="tonKho"><option value="" ${empty tonKho?'selected':''}>-- Tất cả --</option><option value="con-hang" ${tonKho=='con-hang'?'selected':''}>Còn hàng</option><option value="het-hang" ${tonKho=='het-hang'?'selected':''}>Hết hàng</option></select></div>
                <div class="col-xl-3 col-lg-3"><label class="form-label">Giá bán tối đa</label><input id="variantMaxPrice" class="form-control" type="number" min="0" step="1000" name="giaToiDa" value="${giaToiDa}" placeholder="Không giới hạn"></div>
                <div class="col-xl-4 col-lg-4"><label class="form-label d-block">Trạng thái</label><div class="d-flex gap-3 align-items-center min-h-43"><label class="form-check"><input class="form-check-input" type="radio" name="trangThai" value="" ${empty trangThai?'checked':''}> Tất cả</label><label class="form-check"><input class="form-check-input" type="radio" name="trangThai" value="1" ${trangThai==1?'checked':''}> Còn bán</label><label class="form-check"><input class="form-check-input" type="radio" name="trangThai" value="0" ${trangThai==0?'checked':''}> Ngừng bán</label></div></div>
                <div class="col-xl-2 col-lg-2 d-flex gap-2 align-items-end"><div class="live-filter-note flex-grow-1"><i class="bi bi-lightning-charge-fill"></i><span>Lọc live</span></div><button type="button" id="resetVariantFilter" class="btn btn-outline-secondary" title="Đặt lại bộ lọc"><i class="bi bi-arrow-counterclockwise"></i></button></div>
            </form>
        </div>
    </section>

    <section class="variant-card" id="variantResults">
        <div class="px-3 pt-3 pb-2 fw-bold">Tổng số biến thể: ${tongSoBienThe}</div>
        <div class="table-responsive"><table class="table table-hover align-middle text-center mb-0"><thead><tr><th>STT</th><th>Ảnh</th><th>Mã sản phẩm</th><th class="text-start">Tên sản phẩm</th><th>Mã SP chi tiết</th><th>Màu sắc</th><th>Kích cỡ</th><th>Số lượng tồn</th><th>Giá bán</th><th>Trạng thái</th><th>Hành động</th></tr></thead><tbody>
        <c:forEach items="${listAllChiTiet}" var="ct" varStatus="st"><tr>
            <td>${(currentPage-1)*pageSize+st.count}</td><td><div class="product-thumb"><i class="bi bi-image"></i></div></td><td class="fw-semibold">${ct.sanPham.maSanPham}</td><td class="text-start fw-semibold">${ct.sanPham.tenSanPham}</td><td>${ct.ma}</td><td><span class="color-dot"></span>${ct.mauSac.ten}</td><td>${ct.size.ten}</td><td class="fw-semibold">${ct.soLuongTon}</td><td class="fw-bold"><fmt:formatNumber value="${ct.giaBan}" pattern="#,#00"/> ₫</td>
            <td><span id="variant-label-${ct.id}" class="status-pill ${ct.trangThai==1?'on':'off'}">${ct.trangThai==1?'Còn bán':'Ngừng bán'}</span></td>
            <td><div class="d-flex justify-content-center gap-2"><a class="btn btn-sm btn-outline-warning" title="Sửa" href="${pageContext.request.contextPath}/san-pham/chi-tiet/view-update?id=${ct.id}"><i class="bi bi-pencil-square"></i></a><div class="form-check form-switch m-0 pt-1"><input class="form-check-input variant-switch" type="checkbox" data-id="${ct.id}" ${ct.trangThai==1?'checked':''}></div></div></td>
        </tr></c:forEach>
        <c:if test="${empty listAllChiTiet}"><tr><td colspan="11" class="py-5 text-secondary"><i class="bi bi-inbox fs-2 d-block mb-2"></i>Không có biến thể phù hợp.</td></tr></c:if>
        </tbody></table></div>
        <div class="table-footer"><span>Hiển thị ${empty listAllChiTiet?0:fn:length(listAllChiTiet)} / tổng ${tongSoBienThe} bản ghi</span><nav><ul class="pagination pagination-sm mb-0"><c:forEach begin="1" end="${tongSoTrang}" var="p"><li class="page-item ${p==currentPage?'active':''}"><a class="page-link" href="?keyword=${fn:escapeXml(keyword)}&idSanPham=${idSanPham}&idMauSac=${idMauSac}&idSize=${idSize}&tonKho=${tonKho}&trangThai=${trangThai}&giaToiDa=${giaToiDa}&page=${p}&size=${pageSize}">${p}</a></li></c:forEach></ul></nav><select class="form-select form-select-sm" data-page-size style="width:auto"><option value="10" ${pageSize==10?'selected':''}>10 bản ghi / trang</option><option value="20" ${pageSize==20?'selected':''}>20 bản ghi / trang</option><option value="50" ${pageSize==50?'selected':''}>50 bản ghi / trang</option></select></div>
    </section>
</main>
<div class="modal fade" id="variantConfirmModal" tabindex="-1" aria-hidden="true"><div class="modal-dialog modal-dialog-centered modal-sm"><div class="modal-content"><div class="modal-header"><h5 class="modal-title">Xác nhận đổi trạng thái</h5><button class="btn-close" data-bs-dismiss="modal"></button></div><div class="modal-body" id="variantConfirmText"></div><div class="modal-footer"><button class="btn btn-outline-secondary" data-bs-dismiss="modal">Hủy</button><button class="btn btn-primary" id="variantConfirmButton">Xác nhận</button></div></div></div></div>
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
<script src="${pageContext.request.contextPath}/assets/js/sanpham-variant-list.js?v=live1"></script>
<%@ include file="/views/layout/footer.jsp" %>
</body></html>
