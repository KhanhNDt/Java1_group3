<%@ page contentType="text/html;charset=UTF-8" language="java" pageEncoding="UTF-8" %>
<%@ taglib uri="jakarta.tags.core" prefix="c" %>
<%@ taglib uri="jakarta.tags.fmt" prefix="fmt" %>
<%@ taglib uri="jakarta.tags.functions" prefix="fn" %>

<fmt:setLocale value="vi_VN"/>

<!DOCTYPE html>
<html lang="vi">
<head>
    <script src="https://unpkg.com/html5-qrcode" type="text/javascript"></script>
    <meta charset="UTF-8">
    <title>Quản lý nhân viên</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.css" rel="stylesheet">
    <style>
        * { box-sizing: border-box; font-family: 'Segoe UI', sans-serif; }
        body { background: #f5f7fb; }
        .main-content { margin-left: 260px; padding: 30px; }

        h3 { font-weight: 700; }

        /* ---- Bộ lọc ---- */
        .filter-card { background: #fff; border-radius: 14px; overflow: hidden; box-shadow: 0 2px 15px rgba(0,0,0,.06); margin-bottom: 18px; }
        .filter-header { background: #ededed; color: #000000; padding: 14px 20px; display: flex; justify-content: space-between; align-items: center; cursor: pointer; user-select: none; }
        .filter-header .title { font-weight: 700; }
        .filter-header .hint { font-size: 13px; opacity: .85; }
        .filter-body { padding: 24px; }
        .filter-body label { font-weight: 600; color: #444; margin-bottom: 6px; display: block; }
        .form-control, .form-select { height: 46px; border-radius: 10px; border: 1px solid #e2e8f0; }
        .btn-reset { background: #fff; border: 1px solid #d1d5db; color: #374151; border-radius: 10px; height: 44px; padding: 0 20px; display: inline-flex; align-items: center; gap: 6px; }
        .btn-reset:hover { background: #f3f4f6; color: #111827; }
        .btn-search { border-radius: 10px; height: 44px; padding: 0 24px; }

        /* ---- Thanh hành động (giữa bộ lọc và bảng) ---- */
        .toolbar-row { display: flex; justify-content: flex-end; gap: 10px; margin-bottom: 18px; }
        .btn-excel { background: #1d7044; color: #fff; border-radius: 10px; padding: 0 20px; height: 44px; display: inline-flex; align-items: center; gap: 8px; border: none; font-weight: 600; }
        .btn-excel:hover { background: #17603a; color: #fff; }
        .btn-add { background: #2563eb; color: #fff; border-radius: 10px; padding: 0 20px; height: 44px; display: inline-flex; align-items: center; gap: 8px; border: none; font-weight: 600; }
        .btn-add:hover { background: #1d4ed8; color: #fff; }

        /* ---- Bảng ---- */
        .table-card { background: #fff; border-radius: 14px; padding: 24px; box-shadow: 0 2px 15px rgba(0,0,0,.06); }
        .table thead th { background: #131334; color: #fff; white-space: nowrap; font-weight: 600; border: none; vertical-align: middle; }
        .table td { vertical-align: middle; }
        .table tbody tr:hover { background: #f8fafc; }

        .avatar-circle { width: 42px; height: 42px; border-radius: 50%; background: #e8ecfb; color: #3949ab; display: flex; align-items: center; justify-content: center; font-weight: 700; font-size: 13px; margin: 0 auto; overflow: hidden; }
        .avatar-circle img { width: 100%; height: 100%; object-fit: cover; }

        .badge-role { display: inline-block; white-space: nowrap; border: 1px solid #d1d5db; border-radius: 30px; padding: 5px 14px; font-size: 13px; color: #374151; background: #fff; }
        .badge-active { display: inline-block; white-space: nowrap; background: #dcfce7; color: #15803d; border-radius: 30px; padding: 6px 16px; font-weight: 600; font-size: 13px; }
        .badge-inactive { display: inline-block; white-space: nowrap; background: #f3f4f6; color: #6b7280; border-radius: 30px; padding: 6px 16px; font-weight: 600; font-size: 13px; }

        .btn-icon { width: 36px; height: 36px; border-radius: 8px; display: inline-flex; align-items: center; justify-content: center; padding: 0; }

        .form-switch .form-check-input { width: 42px; height: 22px; cursor: pointer; }

        .pagination .page-link { color: #131334; }
        .pagination .page-item.active .page-link { background: #131334; border-color: #131334; }

        .view-item { display: flex; padding: 10px 0; border-bottom: 1px solid #f0f0f0; }
        .view-item .label { width: 180px; font-weight: 600; color: #555; }

        /* ---- Form thêm/sửa ---- */
        .gender-radio-group { display: flex; gap: 24px; height: 46px; align-items: center; }
        .gender-radio-group .form-check { display: flex; align-items: center; gap: 6px; }
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

    <c:if test="${not empty error}">
        <div class="alert alert-danger alert-dismissible fade show" role="alert">
            <i class="bi bi-x-circle-fill me-2"></i>${error}
            <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
        </div>
    </c:if>

    <%-- Banner thông báo thành công/thất bại sau khi thêm/sửa/xóa/đổi trạng thái --%>
    <c:if test="${not empty status}">
        <c:set var="actionLabel"
               value="${action == 'add' ? 'Thêm nhân viên' : action == 'update' ? 'Cập nhật nhân viên' : action == 'delete' ? 'Xóa nhân viên' : action == 'toggle' ? 'Đổi trạng thái' : 'Thao tác'}"/>
        <c:choose>
            <c:when test="${status == 'success'}">
                <div class="alert alert-success alert-dismissible fade show" role="alert">
                    <i class="bi bi-check-circle-fill me-2"></i>${actionLabel} thành công!
                    <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
                </div>
            </c:when>
            <c:otherwise>
                <div class="alert alert-danger alert-dismissible fade show" role="alert">
                    <i class="bi bi-x-circle-fill me-2"></i>${actionLabel} thất bại. Vui lòng thử lại!
                    <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
                </div>
            </c:otherwise>
        </c:choose>
    </c:if>

    <c:choose>

        <%-- =================== DANH SÁCH =================== --%>
        <c:when test="${viewType == 'list'}">

            <div class="mb-3">
                <h3 class="mb-0">Nhân viên</h3>
            </div>

            <%-- Bộ lọc tìm kiếm --%>
            <div class="filter-card">
                <div class="filter-header" onclick="toggleFilter()">
                    <span class="title"><i class="bi bi-funnel-fill"></i> Bộ lọc tìm kiếm</span>
                    <span class="hint">Nhấn để thu gọn/mở rộng</span>
                </div>
                <div class="filter-body" id="filterBody">
                    <form id="filterForm" action="${pageContext.request.contextPath}/nhan-vien/hien-thi" method="get">
                        <input type="hidden" name="page" value="1">
                        <input type="hidden" name="size" value="${size}">
                        <div class="row g-3">
                            <div class="col-md-4">
                                <label>Tìm kiếm</label>
                                <input type="text" class="form-control" name="keyword" value="${keyword}"
                                       placeholder="Tìm theo mã, tên, email, SĐT...">
                            </div>
                            <div class="col-md-4">
                                <label>Chức vụ</label>
                                <select class="form-select" name="chucVu">
                                    <option value="" ${empty chucVu ? 'selected' : ''}>Tất cả</option>
                                    <option value="Admin" ${chucVu == 'Admin' ? 'selected' : ''}>Admin</option>
                                    <option value="Nhân viên" ${chucVu == 'Nhân viên' ? 'selected' : ''}>Nhân viên</option>
                                </select>
                            </div>
                            <div class="col-md-4">
                                <label>Trạng thái</label>
                                <div class="d-flex gap-4" style="height:46px; align-items:center;">
                                    <div class="form-check">
                                        <input class="form-check-input" type="radio" name="trangThai" id="tt-all" value=""
                                            ${empty trangThai ? 'checked' : ''}>
                                        <label class="form-check-label" for="tt-all">Tất cả</label>
                                    </div>
                                    <div class="form-check">
                                        <input class="form-check-input" type="radio" name="trangThai" id="tt-active" value="1"
                                            ${trangThai == '1' ? 'checked' : ''}>
                                        <label class="form-check-label" for="tt-active">Đang làm</label>
                                    </div>
                                    <div class="form-check">
                                        <input class="form-check-input" type="radio" name="trangThai" id="tt-inactive" value="0"
                                            ${trangThai == '0' ? 'checked' : ''}>
                                        <label class="form-check-label" for="tt-inactive">Đã nghỉ</label>
                                    </div>
                                </div>
                            </div>
                        </div>
                        <div class="d-flex justify-content-end gap-3 mt-4">
                            <a href="${pageContext.request.contextPath}/nhan-vien/hien-thi" class="btn btn-reset">
                                <i class="bi bi-arrow-clockwise"></i> Đặt lại
                            </a>
                            <button type="submit" class="btn btn-primary btn-search">
                                <i class="bi bi-search"></i> Tìm kiếm
                            </button>
                        </div>
                    </form>
                </div>
            </div>

            <%-- Thanh hành động: Xuất Excel + Thêm nhân viên, nằm giữa bộ lọc và bảng, căn phải --%>
            <div class="toolbar-row">
                <c:url var="exportUrl" value="/nhan-vien/export-excel">
                    <c:param name="keyword" value="${keyword}"/>
                    <c:param name="chucVu" value="${chucVu}"/>
                    <c:param name="trangThai" value="${trangThai}"/>
                </c:url>
                <a href="${exportUrl}" class="btn-excel">
                    <i class="bi bi-file-earmark-excel"></i> Xuất Excel
                </a>
                <a href="${pageContext.request.contextPath}/nhan-vien/detail?id=0" class="btn-add">
                    <i class="bi bi-plus-lg"></i> Thêm nhân viên
                </a>
            </div>

            <%-- Bảng dữ liệu --%>
            <div class="table-card">
                <div class="table-responsive">
                    <table class="table table-hover align-middle">
                        <thead>
                        <tr>
                            <th>#</th>
                            <th>Ảnh</th>
                            <th>Mã NV</th>
                            <th>Họ tên</th>
                            <th>Email</th>
                            <th>SĐT</th>
                            <th>Địa chỉ</th>
                            <th>Chức vụ</th>
                            <th>Trạng thái</th>
                            <th class="text-center">Hành động</th>
                        </tr>
                        </thead>
                        <tbody>
                        <c:forEach items="${list}" var="nv" varStatus="loop">
                            <tr>
                                <td>${(currentPage - 1) * size + loop.index + 1}</td>
                                <td>
                                    <div class="avatar-circle">
                                        <c:choose>
                                            <c:when test="${not empty nv.anhDaiDien}">
                                                <img src="${pageContext.request.contextPath}/${nv.anhDaiDien}" alt="${nv.hoTen}">
                                            </c:when>
                                            <c:when test="${empty nv.hoTen}">
                                                <i class="bi bi-person"></i>
                                            </c:when>
                                            <c:otherwise>
                                                <c:set var="words" value="${fn:split(fn:trim(nv.hoTen), ' ')}"/>
                                                <c:choose>
                                                    <c:when test="${fn:length(words) >= 2 and fn:length(words[0]) > 0 and fn:length(words[fn:length(words)-1]) > 0}">
                                                        ${fn:toUpperCase(fn:substring(words[0],0,1))}${fn:toUpperCase(fn:substring(words[fn:length(words)-1],0,1))}
                                                    </c:when>
                                                    <c:when test="${fn:length(nv.hoTen) >= 2}">
                                                        ${fn:toUpperCase(fn:substring(nv.hoTen,0,2))}
                                                    </c:when>
                                                    <c:otherwise>
                                                        ${fn:toUpperCase(nv.hoTen)}
                                                    </c:otherwise>
                                                </c:choose>
                                            </c:otherwise>
                                        </c:choose>
                                    </div>
                                </td>
                                <td><strong>${nv.maNhanVien}</strong></td>
                                <td>${nv.hoTen}</td>
                                <td>${nv.email}</td>
                                <td>${nv.soDienThoai}</td>
                                <td>${nv.diaChi}</td>
                                <td><span class="badge-role">${nv.chucVu}</span></td>
                                <td>
                                    <c:choose>
                                        <c:when test="${nv.trangThai == 1}">
                                            <span class="badge-active">Đang làm</span>
                                        </c:when>
                                        <c:otherwise>
                                            <span class="badge-inactive">Đã nghỉ</span>
                                        </c:otherwise>
                                    </c:choose>
                                </td>
                                <td>
                                    <div class="d-flex align-items-center justify-content-center gap-2">
                                        <a href="${pageContext.request.contextPath}/nhan-vien/view?id=${nv.id}"
                                           class="btn btn-outline-primary btn-icon" title="Xem chi tiết">
                                            <i class="bi bi-eye"></i>
                                        </a>

                                        <c:url var="deleteUrl" value="/nhan-vien/delete">
                                            <c:param name="id" value="${nv.id}"/>
                                            <c:param name="keyword" value="${keyword}"/>
                                            <c:param name="chucVu" value="${chucVu}"/>
                                            <c:param name="trangThai" value="${trangThai}"/>
                                            <c:param name="page" value="${currentPage}"/>
                                            <c:param name="size" value="${size}"/>
                                        </c:url>

                                        <form action="${pageContext.request.contextPath}/nhan-vien/toggle" method="get" class="d-inline">
                                            <input type="hidden" name="id" value="${nv.id}">
                                            <input type="hidden" name="keyword" value="${keyword}">
                                            <input type="hidden" name="chucVu" value="${chucVu}">
                                            <input type="hidden" name="trangThai" value="${trangThai}">
                                            <input type="hidden" name="page" value="${currentPage}">
                                            <input type="hidden" name="size" value="${size}">
                                            <div class="form-check form-switch mb-0">
                                                <input class="form-check-input" type="checkbox" role="switch"
                                                       onchange="this.form.submit()"
                                                       title="Bật/tắt trạng thái làm việc"
                                                    ${nv.trangThai == 1 ? 'checked' : ''}>
                                            </div>
                                        </form>
                                    </div>
                                </td>
                            </tr>
                        </c:forEach>

                        <c:if test="${empty list}">
                            <tr>
                                <td colspan="10" class="text-center text-muted py-5">Không tìm thấy nhân viên phù hợp.</td>
                            </tr>
                        </c:if>
                        </tbody>
                    </table>
                </div>

                    <%-- Chân trang: tổng số bản ghi + phân trang + số dòng/trang --%>
                <div class="d-flex justify-content-between align-items-center mt-3 flex-wrap gap-3">
                    <div class="text-muted">
                        Hiển thị ${empty list ? 0 : fn:length(list)} / tổng ${totalRecords} bản ghi
                    </div>

                    <nav>
                        <ul class="pagination mb-0">
                            <li class="page-item ${currentPage <= 1 ? 'disabled' : ''}">
                                <c:url var="prevPageUrl" value="/nhan-vien/hien-thi">
                                    <c:param name="page" value="${currentPage-1}"/>
                                    <c:param name="size" value="${size}"/>
                                    <c:param name="keyword" value="${keyword}"/>
                                    <c:param name="chucVu" value="${chucVu}"/>
                                    <c:param name="trangThai" value="${trangThai}"/>
                                </c:url>
                                <a class="page-link" href="${prevPageUrl}"><i class="bi bi-chevron-left"></i></a>
                            </li>
                            <li class="page-item disabled">
                                <span class="page-link">Trang ${currentPage} / ${totalPages}</span>
                            </li>
                            <li class="page-item ${currentPage >= totalPages ? 'disabled' : ''}">
                                <c:url var="nextPageUrl" value="/nhan-vien/hien-thi">
                                    <c:param name="page" value="${currentPage+1}"/>
                                    <c:param name="size" value="${size}"/>
                                    <c:param name="keyword" value="${keyword}"/>
                                    <c:param name="chucVu" value="${chucVu}"/>
                                    <c:param name="trangThai" value="${trangThai}"/>
                                </c:url>
                                <a class="page-link" href="${nextPageUrl}"><i class="bi bi-chevron-right"></i></a>
                            </li>
                        </ul>
                    </nav>

                    <span class="text-muted">5 / trang</span>
                </div>
            </div>
        </c:when>

        <%-- =================== THÊM / SỬA =================== --%>
        <c:when test="${viewType == 'form'}">
            <div class="d-flex justify-content-between align-items-center mb-4">
                <h3 class="mb-0">${nv.id == 0 ? 'Thêm mới' : 'Cập nhật'} nhân viên</h3>
                <button type="button" class="btn btn-outline-primary" data-bs-toggle="modal" data-bs-target="#qrModal">
                    <i class="bi bi-qr-code-scan"></i> Quét mã QR CCCD/VNeID
                </button>
            </div>

            <%-- Modal quét mã QR CCCD/VNeID bằng camera --%>
            <div class="modal fade" id="qrModal" tabindex="-1">
                <div class="modal-dialog modal-dialog-centered">
                    <div class="modal-content">
                        <div class="modal-header">
                            <h5 class="modal-title"><i class="bi bi-qr-code-scan"></i> Quét mã QR CCCD/VNeID</h5>
                            <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
                        </div>
                        <div class="modal-body">
                            <p class="text-muted small mb-2">
                                Đưa mặt sau CCCD gắn chip (hoặc mã QR trong app VNeID) vào khung camera bên dưới.
                            </p>
                            <div id="qrReader" style="width:100%;"></div>
                            <div id="qrResultMsg" class="mt-2"></div>
                        </div>
                    </div>
                </div>
            </div>

            <c:if test="${qrFilled}">
                <div class="alert alert-success">
                    <i class="bi bi-qr-code-scan me-1"></i>
                    Đã tự động điền thông tin từ mã QR CCCD vừa quét. Vui lòng kiểm tra lại trước khi lưu.
                </div>
            </c:if>

            <form id="formNhanVien" action="${pageContext.request.contextPath}/nhan-vien/${nv.id == 0 ? 'add' : 'update'}"
                  method="post" class="card p-4" enctype="multipart/form-data" novalidate
                  onsubmit="return validateFormNhanVien(this) &amp;&amp; confirm('Bạn có chắc chắn thông tin đã nhập là chính xác?\n${nv.id == 0 ? 'Xác nhận THÊM MỚI nhân viên này?' : 'Xác nhận CẬP NHẬT thông tin nhân viên này?'}')">
                <input type="hidden" name="id" value="${nv.id}">

                <div class="row">
                    <div class="col-md-6 mb-3">
                        <label>Ảnh đại diện</label>
                        <c:if test="${not empty nv.anhDaiDien}">
                            <div class="mb-2">
                                <img src="${pageContext.request.contextPath}/${nv.anhDaiDien}" alt="${nv.hoTen}"
                                     style="width:72px;height:72px;object-fit:cover;border-radius:50%;border:1px solid #e2e8f0">
                            </div>
                        </c:if>
                        <input type="file" name="anhDaiDienFile" class="form-control" accept="image/jpeg,image/png,image/webp">
                        <div class="form-text">JPG, PNG hoặc WEBP, tối đa 5 MB.<c:if test="${not empty nv.anhDaiDien}"> Để trống nếu không muốn đổi ảnh.</c:if></div>
                    </div>
                    <div class="col-md-6 mb-3">
                        <label>Mã nhân viên</label>
                        <c:choose>
                            <c:when test="${nv.id == 0}">
                                <input type="text" class="form-control" value="Sẽ được cấp tự động khi lưu (VD: NV008)" disabled>
                                <div class="form-text">Mã nhân viên do hệ thống tự sinh, không cần nhập.</div>
                            </c:when>
                            <c:otherwise>
                                <input type="text" class="form-control" value="${nv.maNhanVien}" disabled>
                                <div class="form-text">Mã nhân viên là định danh cố định, không thể chỉnh sửa.</div>
                            </c:otherwise>
                        </c:choose>
                    </div>
                    <div class="col-md-6 mb-3">
                        <label>Họ tên</label>
                        <input type="text" id="nvHoTen" name="hoTen" class="form-control" value="${nv.hoTen}" required minlength="2">
                        <div class="invalid-feedback">Họ tên phải có ít nhất 2 ký tự.</div>
                    </div>
                    <div class="col-md-6 mb-3">
                        <label>Email</label>
                        <input type="email" id="nvEmail" name="email" class="form-control" value="${nv.email}" required>
                        <div class="invalid-feedback">Email không đúng định dạng (vd: ten@vidu.com).</div>
                    </div>
                    <div class="col-md-6 mb-3">
                        <label>Số điện thoại</label>
                        <input type="text" id="nvSoDienThoai" name="soDienThoai" class="form-control" value="${nv.soDienThoai}">
                        <div class="invalid-feedback">Số điện thoại không hợp lệ (VD: 09xxxxxxxx, 10 số).</div>
                    </div>
                    <div class="col-md-6 mb-3">
                        <label>Ngày sinh</label>
                        <input type="date" id="nvNgaySinh" name="ngaySinh" class="form-control"
                               value="<fmt:formatDate value='${nv.ngaySinh}' pattern='yyyy-MM-dd'/>">
                        <div class="invalid-feedback">Ngày sinh không được lớn hơn ngày hôm nay.</div>
                    </div>
                    <div class="col-md-6 mb-3">
                        <label>Chức vụ</label>
                        <select name="chucVu" class="form-select">
                            <option value="Admin" ${nv.chucVu == 'Admin' ? 'selected' : ''}>Admin</option>
                            <option value="Nhân viên" ${nv.chucVu == 'Nhân viên' ? 'selected' : ''}>Nhân viên</option>
                        </select>
                    </div>
                    <div class="col-md-12 mb-3">
                        <label>Giới tính</label>
                        <div class="gender-radio-group">
                            <div class="form-check">
                                <input class="form-check-input" type="radio" name="gioiTinh" id="gt-nam" value="true"
                                    ${nv.gioiTinh ? 'checked' : (nv.id == 0 ? 'checked' : '')}>
                                <label class="form-check-label" for="gt-nam">Nam</label>
                            </div>
                            <div class="form-check">
                                <input class="form-check-input" type="radio" name="gioiTinh" id="gt-nu" value="false"
                                    ${(!nv.gioiTinh and nv.id != 0) ? 'checked' : ''}>
                                <label class="form-check-label" for="gt-nu">Nữ</label>
                            </div>
                        </div>
                    </div>

                    <div class="col-12"><hr class="my-2"></div>
                    <div class="col-12 mb-2 d-flex justify-content-between align-items-center">
                        <label class="mb-0">Địa chỉ</label>
                        <button type="button" class="btn btn-outline-primary btn-sm" id="btnMoModalDiaChiNV">
                            <i class="bi bi-plus-circle"></i> Thêm địa chỉ
                        </button>
                    </div>
                    <div class="col-12 mb-1">
                        <small class="text-muted">Mỗi nhân viên chỉ có 1 địa chỉ.</small>
                    </div>
                    <div class="col-12 mb-3">
                        <div id="danhSachDiaChiNV">
                            <div class="text-center text-muted py-3 border rounded">Chưa có địa chỉ nào.</div>
                        </div>
                        <input type="hidden" name="diaChi" id="hiddenDiaChiNV" value="${nv.diaChi}">
                    </div>
                </div>
                <div class="d-flex gap-2">
                    <button type="submit" class="btn btn-primary">Lưu</button>
                    <a href="${pageContext.request.contextPath}/nhan-vien/hien-thi" class="btn btn-secondary">Hủy</a>
                </div>
            </form>

            <!-- ================= MODAL ĐỊA CHỈ NHÂN VIÊN ================= -->
            <div class="modal fade" id="modalDiaChiNV" tabindex="-1">
                <div class="modal-dialog modal-lg">
                    <div class="modal-content">
                        <div class="modal-header">
                            <h5 class="modal-title">Địa chỉ nhân viên</h5>
                            <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
                        </div>
                        <div class="modal-body">
                            <div class="row">
                                <div class="col-md-6 mb-3">
                                    <label class="form-label">Tỉnh / Thành phố</label>
                                    <select id="mTinhNV" class="form-select">
                                        <option value="">-- Chọn tỉnh --</option>
                                        <c:forEach items="${listTinh}" var="t">
                                            <option value="${t.id}">${t.ten}</option>
                                        </c:forEach>
                                    </select>
                                </div>
                                <div class="col-md-6 mb-3">
                                    <label class="form-label">Phường / Xã</label>
                                    <select id="mXaNV" class="form-select" disabled>
                                        <option value="">-- Chọn phường/xã --</option>
                                    </select>
                                </div>
                                <div class="col-12 mb-3">
                                    <label class="form-label">Địa chỉ chi tiết</label>
                                    <input id="mChiTietNV" class="form-control" placeholder="Ví dụ: Số nhà 12, đường ABC">
                                </div>
                            </div>
                        </div>
                        <div class="modal-footer">
                            <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Đóng</button>
                            <button type="button" class="btn btn-primary" id="btnSaveDiaChiNV">Lưu địa chỉ</button>
                        </div>
                    </div>
                </div>
            </div>
        </c:when>

        <%-- =================== XEM CHI TIẾT =================== --%>
        <c:when test="${viewType == 'view'}">
            <h3 class="mb-4">Chi tiết nhân viên</h3>
            <div class="card p-4" style="max-width: 700px;">
                <div class="view-item">
                    <div class="label">Ảnh đại diện</div>
                    <div>
                        <c:choose>
                            <c:when test="${not empty nv.anhDaiDien}">
                                <img src="${pageContext.request.contextPath}/${nv.anhDaiDien}" alt="${nv.hoTen}"
                                     style="width:88px;height:88px;object-fit:cover;border-radius:50%;border:1px solid #e2e8f0">
                            </c:when>
                            <c:otherwise><span class="text-muted">Chưa có ảnh</span></c:otherwise>
                        </c:choose>
                    </div>
                </div>
                <div class="view-item"><div class="label">Mã nhân viên</div><div>${nv.maNhanVien}</div></div>
                <div class="view-item"><div class="label">Họ tên</div><div>${nv.hoTen}</div></div>
                <div class="view-item"><div class="label">Email</div><div>${nv.email}</div></div>
                <div class="view-item"><div class="label">Số điện thoại</div><div>${nv.soDienThoai}</div></div>
                <div class="view-item"><div class="label">Ngày sinh</div>
                    <div><fmt:formatDate value="${nv.ngaySinh}" pattern="dd/MM/yyyy"/></div>
                </div>
                <div class="view-item"><div class="label">Giới tính</div><div>${nv.gioiTinh ? 'Nam' : 'Nữ'}</div></div>
                <div class="view-item"><div class="label">Chức vụ</div><div>${nv.chucVu}</div></div>
                <div class="view-item"><div class="label">Địa chỉ</div><div>${nv.diaChi}</div></div>
                <div class="view-item">
                    <div class="label">Trạng thái</div>
                    <div>
                        <c:choose>
                            <c:when test="${nv.trangThai == 1}"><span class="badge-active">Đang làm</span></c:when>
                            <c:otherwise><span class="badge-inactive">Đã nghỉ</span></c:otherwise>
                        </c:choose>
                    </div>
                </div>
                <div class="mt-3 d-flex gap-2">
                    <a href="${pageContext.request.contextPath}/nhan-vien/detail?id=${nv.id}" class="btn btn-warning">
                        <i class="bi bi-pencil"></i> Sửa
                    </a>
                    <a href="${pageContext.request.contextPath}/nhan-vien/delete?id=${nv.id}" class="btn btn-danger"
                       onclick="return confirm('Bạn có chắc muốn xóa nhân viên \'${nv.hoTen}\' không? Hành động này không thể hoàn tác.')">
                        <i class="bi bi-trash"></i> Xóa
                    </a>
                    <a href="${pageContext.request.contextPath}/nhan-vien/hien-thi" class="btn btn-secondary">Quay lại</a>
                </div>
            </div>
        </c:when>

    </c:choose>
</div>

<!-- Live-validate form thêm/sửa nhân viên -->
<script>
    (function () {
        const form = document.getElementById('formNhanVien');
        if (!form) return; // không ở trang form thì bỏ qua

        const hoTenEl = document.getElementById('nvHoTen');
        const emailEl = document.getElementById('nvEmail');
        const sdtEl = document.getElementById('nvSoDienThoai');
        const ngaySinhEl = document.getElementById('nvNgaySinh');

        const EMAIL_RE = /^[^\s@]+@[^\s@]+\.[^\s@]+$/;
        const PHONE_RE = /^(0|\+84)\d{9,10}$/;

        function setValidity(el, isValid) {
            if (!el) return;
            el.classList.remove('is-invalid', 'is-valid');
            el.classList.add(isValid ? 'is-valid' : 'is-invalid');
        }

        function validateHoTen() {
            const ok = hoTenEl.value.trim().length >= 2;
            setValidity(hoTenEl, ok);
            return ok;
        }

        function validateEmail() {
            const ok = EMAIL_RE.test(emailEl.value.trim());
            setValidity(emailEl, ok);
            return ok;
        }

        function validateSdt() {
            const v = sdtEl.value.trim();
            if (v === '') { sdtEl.classList.remove('is-invalid', 'is-valid'); return true; } // không bắt buộc
            const ok = PHONE_RE.test(v);
            setValidity(sdtEl, ok);
            return ok;
        }

        function validateNgaySinh() {
            const v = ngaySinhEl.value;
            if (!v) { ngaySinhEl.classList.remove('is-invalid', 'is-valid'); return true; } // không bắt buộc
            const today = new Date().toISOString().slice(0, 10);
            const ok = v <= today;
            setValidity(ngaySinhEl, ok);
            return ok;
        }

        hoTenEl.addEventListener('input', validateHoTen);
        emailEl.addEventListener('input', validateEmail);
        sdtEl.addEventListener('input', validateSdt);
        ngaySinhEl.addEventListener('change', validateNgaySinh);

        // Chạy kiểm tra ngay khi tải trang để phản ánh dữ liệu đã điền sẵn (VD: từ QR)
        if (hoTenEl.value.trim()) validateHoTen();
        if (emailEl.value.trim()) validateEmail();
        if (sdtEl.value.trim()) validateSdt();
        if (ngaySinhEl.value) validateNgaySinh();

        // Hàm được gọi khi submit form: chặn lưu nếu có trường không hợp lệ
        window.validateFormNhanVien = function () {
            const okHoTen = validateHoTen();
            const okEmail = validateEmail();
            const okSdt = validateSdt();
            const okNgaySinh = validateNgaySinh();
            const hopLe = okHoTen && okEmail && okSdt && okNgaySinh;
            if (!hopLe) {
                alert('Vui lòng kiểm tra lại các trường đang báo lỗi (viền đỏ) trước khi lưu.');
            }
            return hopLe;
        };
    })();
</script>

<!-- Đoạn script tích hợp quét mã QR CCCD/VNeID -->
<script>
    let html5QrcodeScanner = null;

    // Khi Modal được mở lên thì khởi động Camera
    const qrModal = document.getElementById('qrModal');
    if (qrModal) {
        qrModal.addEventListener('shown.bs.modal', function () {
            if (!html5QrcodeScanner) {
                html5QrcodeScanner = new Html5QrcodeScanner(
                    "qrReader", { fps: 10, qrbox: { width: 250, height: 250 } }, false
                );

                html5QrcodeScanner.render(onScanSuccess, onScanFailure);
            }
        });

        // Khi tắt Modal thì dừng hẳn Camera để tiết kiệm tài nguyên
        qrModal.addEventListener('hidden.bs.modal', function () {
            if (html5QrcodeScanner) {
                html5QrcodeScanner.clear().catch(error => {
                    console.error("Không thể tắt camera.", error);
                });
                html5QrcodeScanner = null;
            }
        });
    }

    // Khi quét thành công mã QR CCCD/VNeID
    function onScanSuccess(decodedText, decodedResult) {
        // Dừng camera ngay lập tức
        if (html5QrcodeScanner) {
            html5QrcodeScanner.clear();
        }

        // Hiển thị thông báo thành công ngắn gọn
        const msgDiv = document.getElementById('qrResultMsg');
        if(msgDiv) {
            msgDiv.innerHTML = `<div class="alert alert-success">Quét thành công! Đang chuyển hướng...</div>`;
        }

        // Gửi chuỗi dữ liệu thô vừa quét về Servlet để xử lý và chuyển sang trang thông tin
        setTimeout(() => {
            window.location.href = '${pageContext.request.contextPath}/nhan-vien/XuLyQr?qrData=' + encodeURIComponent(decodedText);
        }, 1000);
    }

    function onScanFailure(error) {
        // Lỗi khung hình quét (bỏ qua vì camera quét liên tục mỗi frame)
    }
</script>
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
<script>
    function toggleFilter() {
        const body = document.getElementById('filterBody');
        if (body) body.style.display = (body.style.display === 'none') ? 'block' : 'none';
    }

    function changePageSize(size) {
        const url = new URL(window.location.href);
        url.searchParams.set('size', size);
        url.searchParams.set('page', 1);
        window.location.href = url.toString();
    }

    // ---- Modal chọn địa chỉ nhân viên (Tỉnh/Phường nội bộ, giống form thêm khách hàng) ----
    (function () {
        const modalEl = document.getElementById('modalDiaChiNV');
        if (!modalEl) return; // không ở trang form thì bỏ qua

        const modal = new bootstrap.Modal(modalEl);
        const btnMoModal = document.getElementById('btnMoModalDiaChiNV');
        const btnSaveDiaChi = document.getElementById('btnSaveDiaChiNV');
        const mTinh = document.getElementById('mTinhNV');
        const mXa = document.getElementById('mXaNV');
        const mChiTiet = document.getElementById('mChiTietNV');
        const hiddenDiaChi = document.getElementById('hiddenDiaChiNV');
        const box = document.getElementById('danhSachDiaChiNV');

        const allPhuong = [
            <c:forEach items="${listPhuong}" var="p" varStatus="st">
            { id: ${p.id}, provinceId: ${p.provinceId}, ten: "${p.ten}" }<c:if test="${!st.last}">,</c:if>
            </c:forEach>
        ];

        btnMoModal.onclick = function () {
            // Nhân viên chỉ được phép có DUY NHẤT 1 địa chỉ
            if (hiddenDiaChi.value && hiddenDiaChi.value.trim() !== "") {
                alert("Mỗi nhân viên chỉ được thêm 1 địa chỉ. Vui lòng xóa địa chỉ hiện tại trước khi thêm địa chỉ mới.");
                return;
            }
            modal.show();
        };

        mTinh.onchange = function () {
            mXa.innerHTML = "<option value=''>-- Chọn phường/xã --</option>";
            mXa.disabled = true;
            if (mTinh.value === "") return;

            const provinceId = parseInt(mTinh.value);
            allPhuong.filter(function (p) { return p.provinceId === provinceId; })
                .forEach(function (p) {
                    mXa.innerHTML += "<option value='" + p.id + "'>" + p.ten + "</option>";
                });
            mXa.disabled = false;
        };

        function capNhatTrangThaiNut() {
            const coDiaChi = hiddenDiaChi.value && hiddenDiaChi.value.trim() !== "";
            btnMoModal.disabled = coDiaChi;
            btnMoModal.classList.toggle('disabled', coDiaChi);
            btnMoModal.title = coDiaChi ? 'Mỗi nhân viên chỉ được thêm 1 địa chỉ. Xóa địa chỉ hiện tại để thêm mới.' : '';
        }

        function renderDiaChi(text) {
            if (!text) {
                box.innerHTML = '<div class="text-center text-muted py-3 border rounded">Chưa có địa chỉ nào.</div>';
                capNhatTrangThaiNut();
                return;
            }
            box.innerHTML =
                '<div class="border rounded p-3 d-flex justify-content-between align-items-start">' +
                '<div>' + text + '</div>' +
                '<button type="button" class="btn btn-outline-danger btn-sm ms-3" id="btnXoaDiaChiNV">Xóa</button>' +
                '</div>';

            const btnXoa = document.getElementById('btnXoaDiaChiNV');
            if (btnXoa) {
                btnXoa.onclick = function () {
                    if (!confirm("Bạn có chắc muốn xóa địa chỉ này?")) return;
                    hiddenDiaChi.value = "";
                    renderDiaChi("");
                };
            }
            capNhatTrangThaiNut();
        }

        // Hiển thị địa chỉ hiện có khi vào trang sửa
        renderDiaChi(hiddenDiaChi.value);

        btnSaveDiaChi.onclick = function () {
            if (mTinh.value === "" || mXa.value === "" || mChiTiet.value.trim() === "") {
                alert("Vui lòng nhập đầy đủ địa chỉ.");
                return;
            }

            const diaChiCuThe = mChiTiet.value.trim();
            const phuongXa = mXa.options[mXa.selectedIndex].text;
            const tinhThanh = mTinh.options[mTinh.selectedIndex].text;
            const fullText = diaChiCuThe + ", " + phuongXa + ", " + tinhThanh;

            hiddenDiaChi.value = fullText;
            renderDiaChi(fullText);
            modal.hide();
        };

        modalEl.addEventListener('hidden.bs.modal', function () {
            mTinh.selectedIndex = 0;
            mXa.innerHTML = "<option value=''>-- Chọn phường/xã --</option>";
            mXa.disabled = true;
            mChiTiet.value = "";
        });
    })();
</script>
</body>
</html>