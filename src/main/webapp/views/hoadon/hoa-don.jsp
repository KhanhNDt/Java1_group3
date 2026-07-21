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
                    <input type="text" class="form-control" name="keyword" value="${keyword}" placeholder="Mã HD, tên khách, SĐT...">
                </div>

                <div class="col-md-4">
                    <label class="form-label">Ngày bắt đầu</label>
                    <input type="date" class="form-control" name="fromDate" value="${fromDate}">
                </div>

                <div class="col-md-4">
                    <label class="form-label">Ngày kết thúc</label>
                    <input type="date" class="form-control" name="toDate" value="${toDate}">
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
            <button type="button" onclick="filterByStatus('0')" class="btn status-btn ${status=='0' ? 'status-active' : ''}">Chờ xử lý</button>
            <button type="button" onclick="filterByStatus('1')" class="btn status-btn ${status=='1' ? 'status-active' : ''}">Đã thanh toán</button>
            <button type="button" onclick="filterByStatus('2')" class="btn status-btn ${status=='2' ? 'status-active' : ''}">Đã hủy</button>
            <button type="button" onclick="filterByStatus('3')" class="btn status-btn ${status=='3' ? 'status-active' : ''}">Đã xóa</button>
        </div>

        <table class="table table-hover align-middle">
            <thead>
            <tr>
                <th>STT</th>
                <th>Mã hóa đơn</th>
                <th>Tên nhân viên</th>
                <th>Tên khách hàng</th>
                <th>Ngày tạo</th>
                <th>Tổng tiền</th>
                <th>SĐT</th>
                <th>Trạng thái</th>
                <th class="text-center">Hành động</th>
            </tr>
            </thead>
            <tbody>
            <c:forEach items="${invoiceList}" var="hd" varStatus="loop">
                <tr>
                    <td>${loop.index + 1 + (currentPage-1)*10}</td>
                    <td><strong>${hd.maHoaDon}</strong></td>
                    <td>${hd.tenNhanVien}</td>
                    <td>${empty hd.tenKhachHang ? 'Khách lẻ' : hd.tenKhachHang}</td>
                    <td><fmt:formatDate value="${hd.ngayTao}" pattern="dd/MM/yyyy HH:mm"/></td>
                    <td><fmt:formatNumber value="${hd.tongTienThanhToan}" type="currency" currencySymbol="₫"/></td>
                    <td>${hd.sdtKhachHang}</td>
                    <td>
                        <c:choose>
                            <c:when test="${hd.trangThai==1}">
                                <span class="badge-success">Đã thanh toán</span>
                            </c:when>
                            <c:when test="${hd.trangThai==0}">
                                <span class="badge-warning">Chờ xử lý</span>
                            </c:when>
                            <c:when test="${hd.trangThai==2}">
                                <span class="badge-danger">Đã hủy</span>
                            </c:when>
                            <c:when test="${hd.trangThai==3}">
                                <span class="badge-secondary">Đã xóa</span>
                            </c:when>
                        </c:choose>
                    </td>
                    <td class="text-center">
                        <div class="btn-group">
                            <a href="${pageContext.request.contextPath}/quanlyhoadon?action=detail&id=${hd.id}" class="btn btn-outline-primary btn-view" title="Chi tiết">
                                <i class="bi bi-eye"></i>
                            </a>

<%--                            <button class="btn btn-outline-secondary dropdown-toggle" data-bs-toggle="dropdown"></button>--%>
<%--                            <ul class="dropdown-menu">--%>
<%--                            </ul>--%>

                        </div>
                    </td>
                </tr>
            </c:forEach>

            <c:if test="${empty invoiceList}">
                <tr>
                    <td colspan="9" class="text-center py-5 text-muted">Không có dữ liệu hóa đơn phù hợp.</td>
                </tr>
            </c:if>
            </tbody>
        </table>

        <c:if test="${totalPages > 1}">
            <nav class="mt-4">
                <ul class="pagination justify-content-center">
                    <c:if test="${currentPage > 1}">
                        <li class="page-item">
                            <a class="page-link" href="?page=${currentPage-1}&keyword=${keyword}&status=${empty status ? '' : status}&fromDate=${fromDate}&toDate=${toDate}">
                                <i class="bi bi-chevron-left"></i>
                            </a>
                        </li>
                    </c:if>

                    <c:forEach begin="1" end="${totalPages}" var="i">
                        <li class="page-item ${i==currentPage ? 'active' : ''}">
                            <a class="page-link" href="?page=${i}&keyword=${keyword}&status=${empty status ? '' : status}&fromDate=${fromDate}&toDate=${toDate}">
                                    ${i}
                            </a>
                        </li>
                    </c:forEach>

                    <c:if test="${currentPage < totalPages}">
                        <li class="page-item">
                            <a class="page-link" href="?page=${currentPage+1}&keyword=${keyword}&status=${empty status ? '' : status}&fromDate=${fromDate}&toDate=${toDate}">
                                <i class="bi bi-chevron-right"></i>
                            </a>
                        </li>
                    </c:if>
                </ul>
            </nav>
        </c:if>
    </div>
</div>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>

<script>
    // Hàm bấm tab trạng thái nhanh nhưng giữ lại keyword tìm kiếm
    function filterByStatus(statusValue) {
        document.getElementById('formStatus').value = statusValue;
        document.getElementById('filterForm').submit();
    }

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
