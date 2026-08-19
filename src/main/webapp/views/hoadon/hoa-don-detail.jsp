<%@ page contentType="text/html;charset=UTF-8" language="java" pageEncoding="UTF-8" %>
<%@ taglib uri="jakarta.tags.core" prefix="c" %>
<%@ taglib uri="jakarta.tags.fmt" prefix="fmt" %>

<fmt:setLocale value="vi_VN"/>

<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <title>Chi tiết hóa đơn</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.css" rel="stylesheet">
    <style>
        html,
        body {
            overflow-x: hidden;
            background: #f5f6fa;
        }
        .main-content {
            margin-left: 260px;
            padding: 20px;
        }
        .card {
            border: none;
            border-radius: 10px;
        }
        .card-header {
            background: #fff;
            font-weight: 600;
            font-size: 15px;
            padding: 10px 15px;
        }
        .card-body {
            padding: 15px;
        }
        .card-header i {
            margin-right: 6px;
        }
        .table {
            font-size: 14px;
        }
        .table td,
        .table th {
            padding: .55rem;
            vertical-align: middle;
        }
        .table-borderless td:first-child {
            color: #6c757d;
            width: 40%;
        }
        .step-line {
            position: relative;
        }
        .step-connector {
            position: absolute;
            top: 22px;
            left: 50%;
            right: -50%;
            height: 2px;
            background: #dee2e6;
        }
        .step-icon {
            position: relative;
            z-index: 2;
            background: white;
        }
        textarea {
            resize: none;
        }
        @media print {
            .sidebar,
            .btn,
            .no-print {
                display: none !important;
            }
            .main-content {
                margin: 0 !important;
                padding: 0 !important;
            }
            body {
                background: white;
            }
            .card {
                box-shadow: none !important;
                border: 1px solid #ddd;
            }
        }
        /* ===== Hóa đơn in nhiệt (khổ 80mm) — dùng cho cửa sổ in riêng, xem printInvoice() ===== */
        #receiptPrintable { display: none; }
        .receipt-paper {
            width: 300px; margin: 0 auto; padding: 10px 14px 16px;
            font-family: 'Courier New', Consolas, monospace; font-size: 12.5px; color: #111; background: #fff;
        }
        .receipt-shop-name { text-align: center; font-size: 18px; font-weight: 800; letter-spacing: .5px; }
        .receipt-shop-info { text-align: center; font-size: 11px; line-height: 1.5; margin-top: 2px; }
        .receipt-divider { border-top: 1px dashed #111; margin: 8px 0; }
        .receipt-title { text-align: center; font-weight: 800; font-size: 13.5px; letter-spacing: 1px; margin: 4px 0; }
        .receipt-meta { font-size: 11.5px; line-height: 1.6; }
        .receipt-meta .row-between { display: flex; justify-content: space-between; gap: 8px; }
        .receipt-items-head { display: flex; font-weight: 700; font-size: 11px; padding: 2px 0; }
        .receipt-items-head span:nth-child(1), .receipt-item span:nth-child(1) { flex: 1 1 auto; }
        .receipt-items-head span:nth-child(2), .receipt-item span:nth-child(2) { width: 26px; text-align: center; }
        .receipt-items-head span:nth-child(3), .receipt-item span:nth-child(3) { width: 62px; text-align: right; }
        .receipt-items-head span:nth-child(4), .receipt-item span:nth-child(4) { width: 68px; text-align: right; }
        .receipt-item { display: flex; padding: 3px 0; font-size: 12px; }
        .receipt-item-name { font-size: 11px; color: #333; padding-left: 2px; }
        .receipt-totals .row-between { display: flex; justify-content: space-between; font-size: 12px; padding: 2px 0; }
        .receipt-totals .grand { font-weight: 800; font-size: 13.5px; }
        .receipt-amount-words { font-size: 11.5px; font-style: italic; margin-top: 6px; }
        .receipt-cashier { margin-top: 10px; font-size: 12px; }
        .receipt-footer { text-align: center; font-size: 11px; margin-top: 12px; line-height: 1.6; }
    </style>
</head>
<body>
<jsp:include page="/views/layout/sidebar.jsp"/>
<div class="main-content">
    <div class="container-fluid">
        <c:if test="${param.autoprint == '1'}">
            <div class="alert alert-success d-flex align-items-center no-print" role="alert">
                <i class="bi bi-check-circle-fill fs-4 me-2"></i>
                <div>Thanh toán thành công! Đang mở hộp thoại in hóa đơn...</div>
            </div>
        </c:if>
        <!-- Header -->
        <div class="d-flex justify-content-between align-items-center mb-3">
            <div>
                <h4 class="fw-bold mb-1">
                    Chi tiết đơn hàng
                </h4>
                <div class="text-secondary">
                    Mã đơn hàng:
                    <strong>${invoice.maHoaDon}</strong>
                    &nbsp;|&nbsp;
                    Ngày tạo:
                    <fmt:formatDate
                            value="${invoice.ngayTao}"
                            pattern="HH:mm:ss dd/MM/yyyy"/>
                </div>
            </div>
            <div class="no-print d-flex gap-2">
                <button type="button"
                        class="btn btn-dark"
                        onclick="openReceiptPreview()">
                    <i class="bi bi-receipt"></i>
                    Xem hóa đơn
                </button>

                <a href="${pageContext.request.contextPath}/quanlyhoadon"
                   class="btn btn-secondary">
                    <i class="bi bi-arrow-left"></i>
                    Quay lại
                </a>
            </div>
        </div>
        <!-- Trạng thái đơn hàng -->
        <div class="card shadow-sm mb-3">
            <div class="card-header">
                <i class="bi bi-box-seam"></i>
                Trạng thái đơn hàng
            </div>
            <div class="card-body">
                <div class="row text-center">
                    <div class="col">
                        <div class="step-line">
                            <div class="step-connector"></div>
                            <i class="bi bi-hourglass-split text-warning fs-2 step-icon"></i>
                            <h6 class="mt-2 mb-0">
                                Chờ xử lý
                            </h6>
                            <small class="text-muted">
                                <fmt:formatDate
                                        value="${invoice.ngayTao}"
                                        pattern="HH:mm dd/MM/yyyy"/>
                            </small>
                        </div>
                    </div>
                    <div class="col">
                        <div class="step-line">
                            <c:choose>
                                <c:when test="${invoice.trangThai==1}">
                                    <i class="bi bi-check-circle-fill text-success fs-2 step-icon"></i>
                                </c:when>
                                <c:when test="${invoice.trangThai==2}">
                                    <i class="bi bi-x-circle-fill text-danger fs-2 step-icon"></i>
                                </c:when>
                                <c:otherwise>
                                    <i class="bi bi-arrow-repeat text-primary fs-2 step-icon"></i>
                                </c:otherwise>
                            </c:choose>
                            <h6 class="mt-2 mb-0">
                                <c:choose>
                                    <c:when test="${invoice.trangThai==1}">
                                        Đã thanh toán
                                    </c:when>
                                    <c:when test="${invoice.trangThai==2}">
                                        Đã hủy
                                    </c:when>
                                    <c:otherwise>
                                        Chờ xử lý
                                    </c:otherwise>
                                </c:choose>
                            </h6>
                            <small class="text-muted">
                                <fmt:formatDate
                                        value="${invoice.ngayThanhToan}"
                                        pattern="HH:mm dd/MM/yyyy"/>
                            </small>
                        </div>
                    </div>
                </div>
            </div>
        </div>
        <!-- Khách hàng - Giao nhận - Thanh toán -->
        <div class="row g-3 mb-3">
            <div class="col-lg-4">
                <div class="card h-100 shadow-sm">
                    <div class="card-header">
                        <i class="bi bi-person"></i>
                        Thông tin khách hàng
                    </div>
                    <div class="card-body">
                        <table class="table table-borderless mb-0">
                            <tr>
                                <td>Khách hàng</td>
                                <td class="text-end">${invoice.tenKhachHang}</td>
                            </tr>
                            <tr>
                                <td>SĐT</td>
                                <td class="text-end">${invoice.sdtKhachHang}</td>
                            </tr>
                            <tr>
                                <td>Địa chỉ</td>
                                <td class="text-end">${invoice.diaChiKhachHang}</td>
                            </tr>
                        </table>
                    </div>
                </div>
            </div>
            <div class="col-lg-4">
                <div class="card h-100 shadow-sm">
                    <div class="card-header">
                        <i class="bi bi-geo-alt"></i>
                        Thông tin giao nhận
                    </div>
                    <div class="card-body">
                        <table class="table table-borderless mb-0">
                            <tr>
                                <td>Người nhận</td>
                                <td class="text-end">
                                    ${empty invoice.tenNguoiNhan ? invoice.tenKhachHang : invoice.tenNguoiNhan}
                                </td>
                            </tr>
                            <tr>
                                <td>SĐT</td>
                                <td class="text-end">
                                    ${empty invoice.sdtNguoiNhan ? invoice.sdtKhachHang : invoice.sdtNguoiNhan}
                                </td>
                            </tr>
                            <tr>
                                <td>Địa chỉ</td>
                                <td class="text-end">
                                    ${empty invoice.diaChiGiaoHang ? invoice.diaChiKhachHang : invoice.diaChiGiaoHang}
                                </td>
                            </tr>
                            <tr>
                                <td>Nhân viên</td>
                                <td class="text-end">
                                    ${invoice.tenNhanVien}
                                </td>
                            </tr>
                        </table>
                    </div>
                </div>
            </div>
            <%--         Tong két thanh toan--%>
            <div class="col-lg-4">
                <div class="card h-100 shadow-sm">
                    <div class="card-header">
                        <i class="bi bi-receipt"></i>
                        Tổng kết thanh toán
                    </div>
                    <div class="card-body">
                        <table class="table table-borderless mb-0">
                            <tr>
                                <td>Tổng tiền</td>
                                <td class="text-end fw-bold text-danger">
                                    <fmt:formatNumber
                                            value="${invoice.tongTienThanhToan}"
                                            type="currency"
                                            currencySymbol="₫"/>
                                </td>
                            </tr>
                            <tr>
                                <td>Voucher</td>
                                <td class="text-end">
                                    <c:choose>
                                        <c:when test="${empty invoice.maVoucher}">
                                            Không
                                        </c:when>
                                        <c:otherwise>
                                            ${invoice.maVoucher}
                                        </c:otherwise>
                                    </c:choose>
                                </td>
                            </tr>
                            <tr>
                                <td>Phí ship</td>
                                <td class="text-end">
                                    0 ₫
                                </td>
                            </tr>
                            <tr>
                                <td>Phương thức thanh toán</td>
                                <td class="text-end">
                                    <c:forEach items="${payments}" var="p" varStatus="st">
                                        ${p.tenPhuongThuc}<c:if test="${!st.last}">, </c:if>
                                    </c:forEach>

                                    <c:if test="${empty payments}">
                                        Chưa thanh toán
                                    </c:if>
                                </td>
                            </tr>
                        </table>
                        <div class="d-flex justify-content-between">
                            <strong>Thành tiền</strong>
                            <strong class="text-danger">
                                <fmt:formatNumber
                                        value="${invoice.tongTienThanhToan}"
                                        type="currency"
                                        currencySymbol="₫"/>
                            </strong>
                        </div>
                    </div>
                </div>
            </div>
        </div>
        <!-- Sản phẩm + Thông tin hóa đơn -->
        <div class="row g-3 mb-3">
            <div class="col-lg-8">
                <div class="card shadow-sm h-100">
                    <div class="card-header">
                        <i class="bi bi-cart"></i>
                        Sản phẩm
                    </div>
                    <div class="table-responsive">
                        <table class="table table-bordered table-hover align-middle mb-0">
                            <thead class="table-light">
                            <tr>
                                <th width="60">STT</th>
                                <th>Mã biến thể</th>
                                <th>Tên sản phẩm</th>
                                <th>Phân loại</th>
                                <th width="80">SL</th>
                                <th width="130">Đơn giá</th>
                                <th width="140">Thành tiền</th>
                            </tr>
                            </thead>
                            <tbody>
                            <c:forEach items="${details}" var="ct" varStatus="loop">
                                <tr>
                                    <td>${loop.index+1}</td>
                                    <td>
                                        <div class="fw-semibold">
                                                ${ct.maBienThe}
                                        </div>
                                        <small class="text-muted">
                                                ${ct.maSanPham}
                                        </small>
                                    </td>
                                    <td>
                                            ${ct.tenSanPham}
                                    </td>
                                    <td>
                                            ${ct.mauSac} /
                                            ${ct.kichThuoc}
                                    </td>
                                    <td>
                                            ${ct.soLuong}
                                    </td>
                                    <td class="text-end">
                                        <fmt:formatNumber
                                                value="${ct.giaBanRa}"
                                                type="currency"
                                                currencySymbol="₫"/>
                                    </td>
                                    <td class="text-end">
                                        <fmt:formatNumber
                                                value="${ct.tongTien}"
                                                type="currency"
                                                currencySymbol="₫"/>
                                    </td>
                                </tr>
                            </c:forEach>
                            <c:if test="${empty details}">
                                <tr>
                                    <td colspan="7"
                                        class="text-center py-4">
                                        Không có sản phẩm.
                                    </td>
                                </tr>
                            </c:if>
                            </tbody>
                        </table>
                    </div>
                </div>
            </div>
            <div class="col-lg-4">
                <div class="card shadow-sm h-100">
                    <div class="card-header">
                        <i class="bi bi-info-circle"></i>
                        Thông tin hóa đơn
                    </div>
                    <div class="card-body">
                        <div class="mb-3">
                            <label class="form-label">
                                Trạng thái
                            </label>
                            <input
                                    class="form-control"
                                    readonly
                                    value="${invoice.trangThai == 0 ? 'Chờ xử lý'
                                   : invoice.trangThai == 1 ? 'Đã thanh toán'
                                   : invoice.trangThai == 2 ? 'Đã hủy'
                                   : 'Đã xóa'}">
                        </div>
                        <div class="mb-3">
                            <label class="form-label">
                                Ghi chú
                            </label>
                            <textarea
                                    class="form-control"
                                    rows="5"
                                    readonly>${invoice.ghiChu}</textarea>
                        </div>
                        <div class="d-grid no-print">
                            <button
                                    type="button"
                                    class="btn btn-dark"
                                    onclick="openReceiptPreview()">
                                <i class="bi bi-receipt"></i>
                                Xem / In hóa đơn
                            </button>
                        </div>
                    </div>
                </div>
            </div>
        </div>
        <%--        <!-- Thanh toán + Lịch sử -->--%>
        <%--        <div class="row g-3 mb-4">--%>
        <%--            <!-- Thanh toán -->--%>
        <%--            <div class="col-lg-6">--%>
        <%--                <div class="card shadow-sm h-100">--%>
        <%--                    <div class="card-header">--%>
        <%--                        <i class="bi bi-credit-card"></i>--%>
        <%--                        Thanh toán hóa đơn--%>
        <%--                    </div>--%>
        <%--                    <div class="table-responsive">--%>
        <%--                        <table class="table table-hover align-middle mb-0">--%>
        <%--                            <thead class="table-light">--%>
        <%--                            <tr>--%>
        <%--                                <th>Mã GD</th>--%>
        <%--                                <th>Phương thức</th>--%>
        <%--                                <th>Số tiền</th>--%>
        <%--                                <th>Thời gian</th>--%>
        <%--                            </tr>--%>
        <%--                            </thead>--%>
        <%--                            <tbody>--%>
        <%--                            <c:forEach items="${payments}" var="payment">--%>
        <%--                                <tr>--%>
        <%--                                    <td>${payment.maGiaoDich}</td>--%>
        <%--                                    <td>${payment.tenPhuongThuc}</td>--%>
        <%--                                    <td class="text-success fw-bold text-end">--%>
        <%--                                        <fmt:formatNumber--%>
        <%--                                                value="${payment.soTien}"--%>
        <%--                                                type="number"--%>
        <%--                                                groupingUsed="true"/> ₫--%>
        <%--                                    </td>--%>
        <%--                                    <td>--%>
        <%--                                        <fmt:formatDate--%>
        <%--                                                value="${payment.thoiGian}"--%>
        <%--                                                pattern="HH:mm dd/MM/yyyy"/>--%>
        <%--                                    </td>--%>
        <%--                                </tr>--%>
        <%--                            </c:forEach>--%>
        <%--                            <c:if test="${empty payments}">--%>
        <%--                                <tr>--%>
        <%--                                    <td colspan="4"--%>
        <%--                                        class="text-center py-4 text-muted">--%>
        <%--                                        Chưa có giao dịch.--%>
        <%--                                    </td>--%>
        <%--                                </tr>--%>
        <%--                            </c:if>--%>
        <%--                            </tbody>--%>
        <%--                        </table>--%>
        <%--                    </div>--%>
        <%--                </div>--%>
        <%--            </div>--%>
        <%--            <!-- Lịch sử -->--%>
        <%--            <div class="col-lg-6">--%>
        <%--                <div class="card shadow-sm h-100">--%>
        <%--                    <div class="card-header">--%>
        <%--                        <i class="bi bi-clock-history"></i>--%>
        <%--                        Lịch sử hóa đơn--%>
        <%--                    </div>--%>
        <%--                    <div class="card-body"--%>
        <%--                         style="max-height:320px;overflow:auto;">--%>
        <%--                        <c:forEach items="${histories}" var="history">--%>
        <%--                            <div class="border-bottom pb-2 mb-2">--%>
        <%--                                <div class="d-flex justify-content-between">--%>
        <%--                                    <strong>--%>
        <%--                                            ${history.ghiChu}--%>
        <%--                                    </strong>--%>
        <%--                                    <small class="text-muted">--%>
        <%--                                        <fmt:formatDate--%>
        <%--                                                value="${history.thoiGian}"--%>
        <%--                                                pattern="HH:mm dd/MM/yyyy"/>--%>
        <%--                                    </small>--%>
        <%--                                </div>--%>
        <%--                                <small class="text-muted">--%>
        <%--                                        ${history.ma}--%>
        <%--                                </small>--%>
        <%--                            </div>--%>
        <%--                        </c:forEach>--%>
        <%--                        <c:if test="${empty histories}">--%>
        <%--                            <div class="text-center text-muted py-4">--%>
        <%--                                Chưa có lịch sử.--%>
        <%--                            </div>--%>
        <%--                        </c:if>--%>
        <%--                    </div>--%>
        <%--                </div>--%>
        <%--            </div>--%>
        <%--        </div>--%>
    </div>
</div>


<!-- MODAL XEM HÓA ĐƠN: mở từ trang Chi tiết hóa đơn -->
<div class="modal fade" id="receiptPreviewModal" tabindex="-1" aria-hidden="true">
    <div class="modal-dialog modal-dialog-centered" style="max-width:560px;">
        <div class="modal-content" style="border-radius:16px;overflow:hidden;">
            <div class="modal-header py-2">
                <h6 class="modal-title">
                    <i class="bi bi-receipt"></i>
                    Xem trước hóa đơn (in nhiệt)
                </h6>
                <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
            </div>

            <div class="modal-body p-0" style="background:#f3f3f3;">
                <iframe id="receiptPreviewFrame"
                        title="Xem trước hóa đơn"
                        style="width:100%;height:650px;border:0;background:#f3f3f3;display:block;">
                </iframe>
            </div>

            <div class="modal-footer py-2">
                <button type="button" class="btn btn-outline-secondary" data-bs-dismiss="modal">
                    Đóng
                </button>
                <button type="button" class="btn btn-dark" id="btnPrintReceiptPreview">
                    <i class="bi bi-printer"></i>
                    In / Lưu PDF
                </button>
            </div>
        </div>
    </div>
</div>

<!-- Hóa đơn dạng phiếu in nhiệt (ẩn trên màn hình thường, chỉ dùng làm nội dung cho cửa sổ in) -->
<div id="receiptPrintable">
    <div class="receipt-paper" data-total="${invoice.tongTienThanhToan}">
        <div class="receipt-shop-name">SCOTT FASHION</div>
        <div class="receipt-shop-info">
            FPT Polytechnic<br>
            ĐT: 0987395826
        </div>
        <div class="receipt-divider"></div>
        <div class="receipt-title">HÓA ĐƠN BÁN HÀNG</div>
        <div class="receipt-meta">
            <div class="row-between"><span>Ngày:</span><span><fmt:formatDate value="${invoice.ngayTao}" pattern="dd/MM/yyyy"/></span></div>
            <div class="row-between"><span>Giờ:</span><span><fmt:formatDate value="${invoice.ngayTao}" pattern="HH:mm"/></span></div>
            <div class="row-between"><span>Số HĐ:</span><span>${invoice.maHoaDon}</span></div>
        </div>
        <div class="receipt-divider"></div>
        <div class="receipt-items-head"><span>TÊN HÀNG</span><span>SL</span><span>Đ.GIÁ</span><span>TH.TIỀN</span></div>
        <div class="receipt-divider"></div>
        <c:forEach items="${details}" var="ct">
            <div class="receipt-item">
                <span>${ct.maBienThe}</span>
                <span>${ct.soLuong}</span>
                <span><fmt:formatNumber value="${ct.giaBanRa}" pattern="#,##0"/></span>
                <span><fmt:formatNumber value="${ct.tongTien}" pattern="#,##0"/></span>
            </div>
            <div class="receipt-item-name">${ct.tenSanPham} (${ct.mauSac}/${ct.kichThuoc})</div>
        </c:forEach>
        <div class="receipt-divider"></div>
        <div class="receipt-totals">
            <div class="row-between"><span>Tổng SL:</span><span>${invoice.soLuongSanPham}</span></div>
            <div class="row-between"><span>Tổng tiền:</span><span><fmt:formatNumber value="${invoice.tienHangGoc}" pattern="#,##0"/></span></div>
            <div class="row-between"><span>Tiền giảm:</span><span><fmt:formatNumber value="${invoice.tienGiam}" pattern="#,##0"/></span></div>
            <div class="row-between grand"><span>Phải thu:</span><span><fmt:formatNumber value="${invoice.tongTienThanhToan}" pattern="#,##0"/></span></div>
            <c:if test="${not empty invoice.tienKhachDua}">
                <div class="row-between"><span>Khách đưa:</span><span><fmt:formatNumber value="${invoice.tienKhachDua}" pattern="#,##0"/></span></div>
                <div class="row-between"><span>Thối lại:</span><span><fmt:formatNumber value="${invoice.tienThua}" pattern="#,##0"/></span></div>
            </c:if>
        </div>
        <div class="receipt-amount-words" id="receiptAmountWords"></div>
        <div class="receipt-cashier">Thu ngân: ${invoice.tenNhanVien}</div>
        <div class="receipt-divider"></div>
        <div class="receipt-footer">
            Quý khách vui lòng kiểm tra hàng<br>
            trước khi rời khỏi Shop.<br>
            Giữ hóa đơn khi đổi hàng.<br>
            Xin cảm ơn Quý khách hàng!
        </div>
    </div>
</div>

<script>

    function openReceiptPreview() {
        var frame = document.getElementById('receiptPreviewFrame');
        frame.src = '${pageContext.request.contextPath}/quanlyhoadon?action=receipt&id=${invoice.id}';
        bootstrap.Modal.getOrCreateInstance(
            document.getElementById('receiptPreviewModal')
        ).show();
    }

    document.getElementById('btnPrintReceiptPreview').addEventListener('click', function () {
        var frame = document.getElementById('receiptPreviewFrame');
        if (frame && frame.contentWindow) {
            frame.contentWindow.focus();
            frame.contentWindow.print();
        }
    });

    document.getElementById('receiptPreviewModal').addEventListener('hidden.bs.modal', function () {
        document.getElementById('receiptPreviewFrame').src = 'about:blank';
    });

    // Đọc số tiền thành chữ kiểu hóa đơn Việt Nam (VD: 9500 -> "Chín nghìn năm trăm đồng")
    function soTienBangChu(soTien) {
        soTien = Math.round(Math.abs(soTien || 0));
        if (soTien === 0) return "Không đồng";
        var CHU_SO = ['không', 'một', 'hai', 'ba', 'bốn', 'năm', 'sáu', 'bảy', 'tám', 'chín'];
        var DON_VI = ['', ' nghìn', ' triệu', ' tỷ'];

        function docBaSo(so, coTram) {
            var tram = Math.floor(so / 100), chuc = Math.floor((so % 100) / 10), donvi = so % 10;
            var s = '';
            if (tram > 0 || coTram) s += CHU_SO[tram] + ' trăm ';
            if (chuc === 0) { if (donvi > 0 && (tram > 0 || coTram)) s += 'lẻ '; }
            else if (chuc === 1) s += 'mười ';
            else s += CHU_SO[chuc] + ' mươi ';
            if (donvi === 1 && chuc > 1) s += 'mốt';
            else if (donvi === 5 && chuc >= 1) s += 'lăm';
            else if (donvi > 0) s += CHU_SO[donvi];
            return s.trim();
        }

        var nhom = [];
        var n = soTien;
        while (n > 0) { nhom.push(n % 1000); n = Math.floor(n / 1000); }

        var ketQua = '';
        for (var i = nhom.length - 1; i >= 0; i--) {
            if (nhom[i] === 0) continue;
            ketQua += docBaSo(nhom[i], i < nhom.length - 1) + DON_VI[i] + ' ';
        }
        ketQua = ketQua.trim();
        return ketQua.charAt(0).toUpperCase() + ketQua.slice(1) + ' đồng';
    }

    function printInvoice() {
        var paper = document.querySelector('.receipt-paper');
        var soTien = parseFloat(paper.getAttribute('data-total')) || 0;
        document.getElementById('receiptAmountWords').textContent = soTienBangChu(soTien);

        var printContents = document.getElementById('receiptPrintable').innerHTML;
        var printWindow = window.open("", "", "width=420,height=700");
        var styleTag = document.querySelector('style').outerHTML;
        var html = "<html><head>"
            + "<title>Hoa don " + "${invoice.maHoaDon}" + "</title>"
            + "<meta charset=\"UTF-8\">"
            + styleTag
            + "<style>body{padding:14px 0;background:#fff;}</style>"
            + "</head><body>"
            + printContents
            + "</body></html>";
        printWindow.document.open();
        printWindow.document.write(html);
        printWindow.document.close();

        printWindow.onload = function () {
            // #receiptPrintable vốn display:none để không hiện trên trang chi tiết -> hiện lại
            // trong cửa sổ in riêng này.
            var el = printWindow.document.getElementById('receiptPrintable');
            if (el) el.style.display = 'block';
            printWindow.focus();
            printWindow.print();
            printWindow.close();
        };
    }
</script>
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
