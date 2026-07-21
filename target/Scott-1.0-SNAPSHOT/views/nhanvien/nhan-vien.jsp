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
        .filter-header { background: #131334; color: #fff; padding: 14px 20px; display: flex; justify-content: space-between; align-items: center; cursor: pointer; user-select: none; }
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

        /* ---- Khung chọn ảnh đại diện tròn ---- */
        .avatar-upload-box {
            width: 100px;
            height: 100px;
            border: 2px dashed #cbd5e1;
            border-radius: 50%;
            display: inline-flex;
            flex-direction: column;
            justify-content: center;
            align-items: center;
            cursor: pointer;
            overflow: hidden;
            position: relative;
            background-color: #f8fafc;
            transition: all 0.2s ease;
        }
        .avatar-upload-box:hover {
            border-color: #3b82f6;
            background-color: #f1f5f9;
        }
        .avatar-placeholder {
            display: flex;
            flex-direction: column;
            align-items: center;
            color: #64748b;
        }
        #avatar-preview-img {
            width: 100%;
            height: 100%;
            object-fit: cover;
        }
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
                                                <img src="${nv.anhDaiDien}" alt="${nv.hoTen}">
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

                    <select class="form-select" style="width: auto;" onchange="changePageSize(this.value)">
                        <option value="10" ${size == 10 ? 'selected' : ''}>10 / trang</option>
                        <option value="20" ${size == 20 ? 'selected' : ''}>20 / trang</option>
                        <option value="50" ${size == 50 ? 'selected' : ''}>50 / trang</option>
                    </select>
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

            <%-- Thêm enctype="multipart/form-data" để form hỗ trợ gửi file ảnh lên server --%>
            <form action="${pageContext.request.contextPath}/nhan-vien/${nv.id == 0 ? 'add' : 'update'}"
                  method="post" enctype="multipart/form-data" class="card p-4"
                  onsubmit="return confirm('Bạn có chắc chắn thông tin đã nhập là chính xác?\n${nv.id == 0 ? 'Xác nhận THÊM MỚI nhân viên này?' : 'Xác nhận CẬP NHẬT thông tin nhân viên này?'}')">
                <input type="hidden" name="id" value="${nv.id}">

                    <%-- Khu vực chọn ảnh đại diện dạng tròn --%>
                <div class="text-center mb-4">
                    <label for="avatar-input" class="avatar-upload-box" title="Bấm vào để chọn ảnh đại diện">
                        <img id="avatar-preview-img" src="${not empty nv.anhDaiDien ? nv.anhDaiDien : ''}" alt="Avatar Preview" style="${not empty nv.anhDaiDien ? 'display: block;' : 'display: none;'}">
                        <div id="avatar-placeholder-content" class="avatar-placeholder" style="${not empty nv.anhDaiDien ? 'display: none;' : 'display: flex;'}">
                            <i class="bi bi-camera fs-3 mb-1"></i>
                            <span style="font-size: 12px;">Chọn ảnh</span>
                        </div>
                    </label>
                    <input type="file" id="avatar-input" name="anhDaiDienFile" accept="image/png, image/jpeg, image/jpg" class="d-none">
                    <div class="form-text text-muted mt-1" style="font-size: 12px;">PNG, JPG, JPEG - Tối đa 5MB</div>
                </div>

                <div class="row">
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
                        <input type="text" name="hoTen" class="form-control" value="${nv.hoTen}" required>
                    </div>
                    <div class="col-md-6 mb-3">
                        <label>Email</label>
                        <input type="email" name="email" class="form-control" value="${nv.email}" required>
                    </div>
                    <div class="col-md-6 mb-3">
                        <label>Số điện thoại</label>
                        <input type="text" name="soDienThoai" class="form-control" value="${nv.soDienThoai}">
                    </div>
                    <div class="col-md-6 mb-3">
                        <label>Ngày sinh</label>
                        <input type="date" name="ngaySinh" class="form-control"
                               value="<fmt:formatDate value='${nv.ngaySinh}' pattern='yyyy-MM-dd'/>">
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
                    <div class="col-12 mb-2"><label class="mb-0">Địa chỉ</label></div>

                    <div class="col-md-4 mb-3">
                        <label class="fw-normal">Tỉnh/Thành phố</label>
                        <select class="form-select" id="tinhThanh" name="tinhThanh">
                            <option value="">-- Chọn Tỉnh/Thành phố --</option>
                        </select>
                    </div>
                    <div class="col-md-4 mb-3">
                        <label class="fw-normal">Quận/Huyện</label>
                        <select class="form-select" id="quanHuyen" name="quanHuyen" disabled>
                            <option value="">-- Chọn Quận/Huyện --</option>
                        </select>
                    </div>
                    <div class="col-md-4 mb-3">
                        <label class="fw-normal">Xã/Phường</label>
                        <select class="form-select" id="xaPhuong" name="xaPhuong" disabled>
                            <option value="">-- Chọn Xã/Phường --</option>
                        </select>
                    </div>
                    <div class="col-md-12 mb-3">
                        <label class="fw-normal">Địa chỉ cụ thể (số nhà, tên đường...)</label>
                        <input type="text" name="diaChiCuThe" id="diaChiCuThe" class="form-control"
                               value="${nv.diaChi}" placeholder="Ví dụ: Số 12, ngõ 34, đường Láng">
                        <c:if test="${nv.id != 0}">
                            <div class="form-text">
                                Đang hiển thị địa chỉ cũ. Nếu chọn lại Tỉnh/Huyện/Xã ở trên, địa chỉ mới sẽ được nối
                                thêm phía trước trường này khi lưu.
                            </div>
                        </c:if>
                    </div>
                </div>
                <div class="d-flex gap-2">
                    <button type="submit" class="btn btn-primary">Lưu</button>
                    <a href="${pageContext.request.contextPath}/nhan-vien/hien-thi" class="btn btn-secondary">Hủy</a>
                </div>
            </form>
        </c:when>

        <%-- =================== XEM CHI TIẾT =================== --%>
        <c:when test="${viewType == 'view'}">
            <h3 class="mb-4">Chi tiết nhân viên</h3>
            <div class="card p-4" style="max-width: 700px;">
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

<!-- Script xử lý xem trước ảnh đại diện tải lên -->
<script>
    const avatarInput = document.getElementById('avatar-input');
    const avatarPreviewImg = document.getElementById('avatar-preview-img');
    const avatarPlaceholderContent = document.getElementById('avatar-placeholder-content');

    if (avatarInput) {
        avatarInput.addEventListener('change', function(event) {
            const file = event.target.files[0];
            if (file) {
                if (file.size > 5 * 1024 * 1024) {
                    alert('Dung lượng ảnh vượt quá giới hạn tối đa 5MB!');
                    avatarInput.value = '';
                    return;
                }

                const reader = new FileReader();
                reader.onload = function(e) {
                    avatarPreviewImg.src = e.target.result;
                    avatarPreviewImg.style.display = 'block';
                    if (avatarPlaceholderContent) {
                        avatarPlaceholderContent.style.display = 'none';
                    }
                }
                reader.readAsDataURL(file);
            }
        });
    }
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

    // ---- Cascading Tỉnh/Thành - Quận/Huyện - Xã/Phường (dữ liệu hành chính VN, API công khai) ----
    (function () {
        const tinhSelect = document.getElementById('tinhThanh');
        const huyenSelect = document.getElementById('quanHuyen');
        const xaSelect = document.getElementById('xaPhuong');
        if (!tinhSelect) return; // không ở trang form thì bỏ qua

        fetch('https://provinces.open-api.vn/api/p/')
            .then(res => res.json())
            .then(data => {
                data.forEach(tinh => {
                    const opt = document.createElement('option');
                    opt.value = tinh.name;
                    opt.dataset.code = tinh.code;
                    opt.textContent = tinh.name;
                    tinhSelect.appendChild(opt);
                });
            })
            .catch(() => {
                tinhSelect.innerHTML = '<option value="">Không tải được danh sách (kiểm tra kết nối mạng)</option>';
            });

        tinhSelect.addEventListener('change', function () {
            huyenSelect.innerHTML = '<option value="">-- Chọn Quận/Huyện --</option>';
            xaSelect.innerHTML = '<option value="">-- Chọn Xã/Phường --</option>';
            huyenSelect.disabled = true;
            xaSelect.disabled = true;

            const selectedOption = tinhSelect.options[tinhSelect.selectedIndex];
            const code = selectedOption ? selectedOption.dataset.code : null;
            if (!code) return;

            fetch('https://provinces.open-api.vn/api/p/' + code + '?depth=2')
                .then(res => res.json())
                .then(data => {
                    (data.districts || []).forEach(huyen => {
                        const opt = document.createElement('option');
                        opt.value = huyen.name;
                        opt.dataset.code = huyen.code;
                        opt.textContent = huyen.name;
                        huyenSelect.appendChild(opt);
                    });
                    huyenSelect.disabled = false;
                });
        });

        huyenSelect.addEventListener('change', function () {
            xaSelect.innerHTML = '<option value="">-- Chọn Xã/Phường --</option>';
            xaSelect.disabled = true;

            const selectedOption = huyenSelect.options[huyenSelect.selectedIndex];
            const code = selectedOption ? selectedOption.dataset.code : null;
            if (!code) return;

            fetch('https://provinces.open-api.vn/api/d/' + code + '?depth=2')
                .then(res => res.json())
                .then(data => {
                    (data.wards || []).forEach(xa => {
                        const opt = document.createElement('option');
                        opt.value = xa.name;
                        opt.textContent = xa.name;
                        xaSelect.appendChild(opt);
                    });
                    xaSelect.disabled = false;
                });
        });
    })();
</script>
</body>
</html>