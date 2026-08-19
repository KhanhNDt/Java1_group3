<%@ page contentType="text/html;charset=UTF-8" language="java" pageEncoding="UTF-8" %>
<%@ taglib uri="jakarta.tags.core" prefix="c" %>
<%@ taglib uri="jakarta.tags.fmt" prefix="fmt" %>

<fmt:setLocale value="vi_VN"/>

<!DOCTYPE html>
<html lang="vi">

<head>
    <meta charset="UTF-8">
    <title>Quản lý hóa đơn</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.css" rel="stylesheet">

    <style>
        *{
            margin:0;
            padding:0;
            box-sizing:border-box;
            font-family:'Segoe UI',sans-serif;
        }

        body{
            background:#f5f7fb;
        }

        .main-content{
            margin-left:260px;
            padding:30px;
        }

        h2{
            font-weight:700;
            margin-bottom:25px;
        }

        .card-custom{
            background:#fff;
            border-radius:18px;
            padding:25px;
            box-shadow:0 2px 15px rgba(0,0,0,.06);
            margin-bottom:25px;
        }

        .title-box{
            display:flex;
            align-items:center;
            gap:10px;
            font-size:22px;
            font-weight:700;
            margin-bottom:25px;
        }

        .title-box i{
            color:#666;
        }

        .form-label{
            font-weight:600;
            color:#555;
        }

        .form-control{
            height:50px;
            border-radius:12px;
            border:1px solid #e2e8f0;
        }

        .form-select{
            height:50px;
            border-radius:12px;
            border:1px solid #e2e8f0;
        }

        .btn-reset{
            background:#4b5563;
            color:white;
            border-radius:12px;
            height:50px;
            padding:0 24px;
            border:none;
            display: inline-flex;
            align-items: center;
            justify-content: center;
            text-decoration: none;
        }

        .btn-reset:hover{
            background:#374151;
            color:white;
        }

        .btn-excel{
            height:50px;
            border-radius:12px;
            padding:0 24px;
            background:white;
            border:1px solid #ddd;
        }

        .btn-excel:hover{
            background:#f8f9fa;
        }

        .table-card{
            background:white;
            border-radius:18px;
            padding:25px;
            box-shadow:0 2px 15px rgba(0,0,0,.06);
        }

        .status-btn{
            border-radius:30px;
            border:1px solid #ddd;
            background:white;
            padding:10px 22px;
            margin-right:10px;
            margin-bottom:12px;
            transition:.3s;
        }

        .status-btn:hover{
            background:#ef4444;
            color:white;
            border-color:#ef4444;
        }

        .status-active{
            background:#dc2626;
            color:white;
            border:none;
        }

        .table{
            margin-top:20px;
        }

        .table th{
            white-space:nowrap;
            background:#fafafa;
            font-weight:700;
        }

        .table td{
            vertical-align:middle;
        }

        .badge-success{
            background:#d1fae5;
            color:#047857;
            padding:8px 18px;
            border-radius:30px;
            font-weight:600;
        }

        .badge-warning{
            background:#fef3c7;
            color:#92400e;
            padding:8px 18px;
            border-radius:30px;
            font-weight:600;
        }

        .badge-danger{
            background:#fee2e2;
            color:#b91c1c;
            padding:8px 18px;
            border-radius:30px;
            font-weight:600;
        }

        .badge-secondary{
            background:#e5e7eb;
            color:#374151;
            padding:8px 18px;
            border-radius:30px;
            font-weight:600;
        }

        .btn-view{
            width:40px;
            height:40px;
            border-radius:10px;
        }

        .pagination .page-item.active .page-link{
            background:#dc2626;
            border-color:#dc2626;
        }

        .pagination .page-link{
            color:#dc2626;
        }
    </style>

    <style>
        :root{--mono:#111;--line:#dedede;--soft:#f5f5f5}
        body{background:#f4f4f4!important;color:#171717!important}
        .main-content{margin-left:242px!important;padding:28px!important}
        .card,.table-container,.filter-card,.stat-card{border-color:var(--line)!important;box-shadow:0 4px 14px rgba(0,0,0,.045)!important}
        .btn-primary,.btn-success,.btn-warning,.btn-info,.btn-danger{background:#171717!important;border-color:#171717!important;color:#fff!important}
        .btn-outline-primary,.btn-outline-success,.btn-outline-danger,.btn-outline-warning{color:#171717!important;border-color:#aaa!important}
        .btn-outline-primary:hover,.btn-outline-success:hover,.btn-outline-danger:hover,.btn-outline-warning:hover{background:#171717!important;color:#fff!important;border-color:#171717!important}
        .badge,.status-badge{filter:grayscale(1)}
        .form-control:focus,.form-select:focus{border-color:#333!important;box-shadow:0 0 0 .18rem rgba(0,0,0,.10)!important}
        .table thead th{background:#f4f4f4!important;color:#222!important}
        @media(max-width:900px){.main-content{margin-left:78px!important;padding:18px!important}}
    </style>
</head>

<body>

<jsp:include page="/views/layout/sidebar.jsp"/>

<div class="main-content">

    <h2>Quản lý hóa đơn</h2>

    <c:if test="${not empty sessionScope.message}">
        <div class="alert alert-success alert-dismissible fade show" role="alert">
                ${sessionScope.message}
            <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
        </div>
        <c:remove var="message" scope="session"/>
    </c:if>

    <c:if test="${not empty sessionScope.error}">
        <div class="alert alert-danger alert-dismissible fade show" role="alert">
                ${sessionScope.error}
            <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
        </div>
        <c:remove var="error" scope="session"/>
    </c:if>


    <div class="card-custom">
        <div class="title-box">
            <i class="bi bi-funnel"></i>
            <span>Bộ lọc</span>
        </div>

        <form id="filterForm" action="${pageContext.request.contextPath}/quanlyhoadon" method="get">
            <input type="hidden" id="formStatus" name="status" value="${status}">

            <div class="row">
                <div class="col-md-4">
                    <label class="form-label">Tìm kiếm thông tin</label>
                    <input type="text" class="form-control" id="fKeyword" name="keyword" value="${keyword}" placeholder="Mã HD, tên khách, SĐT...">
                    <div id="liveSearchStatus" class="form-text"></div>
                </div>

                <div class="col-md-4">
                    <label class="form-label">Ngày bắt đầu</label>
                    <input type="date" class="form-control" id="fFromDate" name="fromDate" value="${fromDate}">
                    <div class="invalid-feedback">Ngày bắt đầu phải nhỏ hơn ngày kết thúc.</div>
                </div>

                <div class="col-md-4">
                    <label class="form-label">Ngày kết thúc</label>
                    <input type="date" class="form-control" id="fToDate" name="toDate" value="${toDate}">
                    <div class="invalid-feedback">Ngày kết thúc phải lớn hơn ngày bắt đầu.</div>
                </div>
            </div>

            <div class="d-flex justify-content-end mt-4 gap-3">
                <a href="${pageContext.request.contextPath}/quanlyhoadon" class="btn btn-reset">
                    <i class="bi bi-arrow-clockwise"></i> Đặt lại bộ lọc
                </a>

                <button type="submit" class="btn btn-danger" style="height:50px; border-radius:12px; padding:0 24px;">
                    <i class="bi bi-search"></i> Tìm kiếm
                </button>

                <button type="button" onclick="triggerExportExcel()" class="btn btn-excel">
                    <i class="bi bi-file-earmark-excel"></i> Xuất Excel
                </button>
            </div>
        </form>
    </div>

    <div class="table-card">
        <div class="mb-4">
            <button type="button" onclick="filterByStatus('')" class="btn status-btn ${empty status ? 'status-active' : ''}">Tất cả</button>
            <%--            Hóa đơn "Chờ xử lý" không còn hiển thị ở màn Quản lý hóa đơn nữa (chỉ quản lý bên Bán hàng tại quầy) --%>
            <%--            <button type="button" onclick="filterByStatus('0')" class="btn status-btn ${status=='0' ? 'status-active' : ''}">Chờ xử lý</button>--%>
            <button type="button" onclick="filterByStatus('1')" class="btn status-btn ${status=='1' ? 'status-active' : ''}">Đã thanh toán</button>
            <button type="button" onclick="filterByStatus('2')" class="btn status-btn ${status=='2' ? 'status-active' : ''}">Đã hủy</button>
            <%--            <button type="button" onclick="filterByStatus('3')" class="btn status-btn ${status=='3' ? 'status-active' : ''}">Đã xóa</button>--%>
        </div>

        <div id="hoaDonTableWrapper">
            <jsp:include page="/views/hoadon/hoa-don-table-fragment.jsp"/>
        </div>
    </div>
</div>


<!-- Modal xem hóa đơn in nhiệt -->
<div class="modal fade" id="invoiceReceiptModal" tabindex="-1" aria-hidden="true">
    <div class="modal-dialog modal-dialog-centered" style="max-width:560px;">
        <div class="modal-content" style="border-radius:16px;overflow:hidden;">
            <div class="modal-header py-2">
                <h6 class="modal-title"><i class="bi bi-receipt"></i> Xem trước hóa đơn (in nhiệt)</h6>
                <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
            </div>
            <div class="modal-body p-0" style="background:#f3f3f3;">
                <iframe id="invoiceReceiptFrame" title="Hóa đơn"
                        style="width:100%;height:650px;border:0;background:#f3f3f3;display:block;"></iframe>
            </div>
            <div class="modal-footer py-2">
                <button type="button" class="btn btn-outline-secondary" data-bs-dismiss="modal">Đóng</button>
                <button type="button" class="btn btn-dark" id="btnPrintInvoiceReceipt">
                    <i class="bi bi-printer"></i> In / Lưu PDF
                </button>
            </div>
        </div>
    </div>
</div>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>

<script>

    // Mở hóa đơn dạng phiếu in nhiệt ngay trên màn Quản lý hóa đơn.
    window.openInvoiceReceipt = function (idHoaDon) {
        const frame = document.getElementById('invoiceReceiptFrame');
        frame.src = '${pageContext.request.contextPath}/quanlyhoadon?action=receipt&id=' + encodeURIComponent(idHoaDon);
        bootstrap.Modal.getOrCreateInstance(document.getElementById('invoiceReceiptModal')).show();
    };

    document.getElementById('btnPrintInvoiceReceipt').addEventListener('click', function () {
        const frame = document.getElementById('invoiceReceiptFrame');
        if (frame && frame.contentWindow) {
            frame.contentWindow.focus();
            frame.contentWindow.print();
        }
    });

    document.getElementById('invoiceReceiptModal').addEventListener('hidden.bs.modal', function () {
        document.getElementById('invoiceReceiptFrame').src = 'about:blank';
    });

    // Hàm bấm tab trạng thái nhanh nhưng giữ lại keyword tìm kiếm
    function filterByStatus(statusValue) {
        document.getElementById('formStatus').value = statusValue;
        triggerLiveSearch();
    }

    // ===================== LIVE SEARCH + LIVE VALIDATE NGÀY (Quản lý hóa đơn) =====================
    (function () {
        const keywordEl = document.getElementById('fKeyword');
        const fromDateEl = document.getElementById('fFromDate');
        const toDateEl = document.getElementById('fToDate');
        const statusEl = document.getElementById('formStatus');
        const wrapper = document.getElementById('hoaDonTableWrapper');
        const statusMsg = document.getElementById('liveSearchStatus');
        if (!keywordEl || !wrapper) return;

        let debounceTimer = null;

        function validateKhoangNgay() {
            const batDau = fromDateEl.value;
            const ketThuc = toDateEl.value;
            if (batDau && ketThuc && batDau >= ketThuc) {
                fromDateEl.classList.add('is-invalid');
                toDateEl.classList.add('is-invalid');
                return false;
            }
            fromDateEl.classList.remove('is-invalid');
            toDateEl.classList.remove('is-invalid');
            if (batDau) fromDateEl.classList.add('is-valid'); else fromDateEl.classList.remove('is-valid');
            if (ketThuc) toDateEl.classList.add('is-valid'); else toDateEl.classList.remove('is-valid');
            return true;
        }

        window.triggerLiveSearch = function () {
            if (!validateKhoangNgay()) {
                if (statusMsg) statusMsg.innerHTML = '<span class="text-danger">Ngày bắt đầu phải nhỏ hơn ngày kết thúc.</span>';
                return;
            }
            const params = new URLSearchParams({
                action: 'search',
                keyword: keywordEl.value.trim(),
                fromDate: fromDateEl.value,
                toDate: toDateEl.value,
                status: statusEl.value
            });

            if (statusMsg) statusMsg.innerHTML = '<span class="text-muted"><i class="bi bi-arrow-repeat"></i> Đang tìm...</span>';

            fetch(`${pageContext.request.contextPath}/quanlyhoadon?` + params.toString())
                .then(function (res) { return res.text(); })
                .then(function (html) {
                    wrapper.innerHTML = html;
                    if (statusMsg) statusMsg.innerHTML = '';
                })
                .catch(function () {
                    if (statusMsg) statusMsg.innerHTML = '<span class="text-danger">Không thể tải kết quả tìm kiếm.</span>';
                });
        };

        function debouncedSearch() {
            clearTimeout(debounceTimer);
            debounceTimer = setTimeout(window.triggerLiveSearch, 400);
        }

        keywordEl.addEventListener('input', debouncedSearch);
        [fromDateEl, toDateEl].forEach(function (el) {
            el.addEventListener('change', function () {
                if (validateKhoangNgay()) debouncedSearch();
            });
        });

        // Chặn submit bình thường của form bộ lọc (nút "Tìm kiếm") -> cũng chạy live search thay vì reload trang
        const filterForm = document.getElementById('filterForm');
        if (filterForm) {
            filterForm.addEventListener('submit', function (e) {
                e.preventDefault();
                window.triggerLiveSearch();
            });
        }
    })();

    // Hàm xuất dữ liệu Excel động theo tham số hiện tại trên ô nhập liệu
    function triggerExportExcel() {
        const form = document.getElementById('filterForm');
        const keyword = form.querySelector('input[name="keyword"]').value;
        const fromDate = form.querySelector('input[name="fromDate"]').value;
        const toDate = form.querySelector('input[name="toDate"]').value;
        const status = document.getElementById('formStatus').value;

        window.location.href = `${pageContext.request.contextPath}/quanlyhoadon?action=export&keyword=`
            + encodeURIComponent(keyword) + `&status=` + encodeURIComponent(status)
            + `&fromDate=` + encodeURIComponent(fromDate) + `&toDate=` + encodeURIComponent(toDate);
    }
</script>
</body>
</html>
