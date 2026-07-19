<%@ page contentType="text/html;charset=UTF-8" language="java" pageEncoding="UTF-8" %>
<%@ taglib uri="jakarta.tags.core" prefix="c" %>
<%@ taglib uri="jakarta.tags.fmt" prefix="fmt" %>

<fmt:setLocale value="vi_VN"/>
<div class="row">
    <div class="col-2"></div>

    <div class="col-10">
        <!DOCTYPE html>
        <html lang="vi">
        <head>
            <meta charset="UTF-8">
            <title>Chi tiết hóa đơn</title>

            <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
            <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.css" rel="stylesheet">
        </head>

        <body class="bg-light">

        <jsp:include page="/views/layout/sidebar.jsp"/>

        <div class="container-fluid mt-4">

            <!-- Header -->
            <div class="d-flex justify-content-between align-items-center mb-4">

                <div>

                    <h3 class="fw-bold mb-1">
                        Chi tiết đơn hàng
                    </h3>

                    <div class="text-secondary">

                        Mã đơn hàng:
                        <strong>${invoice.maHoaDon}</strong>

                        |

                        Ngày tạo:

                        <fmt:formatDate
                                value="${invoice.ngayTao}"
                                pattern="HH:mm:ss dd/MM/yyyy"/>

                    </div>

                </div>

                <a href="${pageContext.request.contextPath}/quanlyhoadon"
                   class="btn btn-secondary">

                    <i class="bi bi-arrow-left"></i>

                    Quay lại danh sách

                </a>

            </div>

            <!-- Dòng 1 -->

            <div class="row">

                <!-- Trạng thái -->

                <div class="col-lg-8">

                    <div class="card shadow-sm">

                        <div class="card-header bg-white">

                            <i class="bi bi-box-seam"></i>

                            Trạng thái đơn hàng

                        </div>

                        <div class="card-body">

                            <div class="row text-center">

                                <div class="col">

                                    <i class="bi bi-hourglass text-warning fs-1"></i>

                                    <h6 class="mt-2">

                                        Chờ xử lý

                                    </h6>

                                    <small class="text-muted">

                                        <fmt:formatDate
                                                value="${invoice.ngayTao}"
                                                pattern="HH:mm dd/MM/yyyy"/>

                                    </small>

                                </div>

                                <div class="col">

                                    <i class="bi bi-check-circle-fill text-success fs-1"></i>

                                    <h6 class="mt-2">

                                        <c:choose>

                                            <c:when test="${invoice.trangThai==1}">
                                                Đã thanh toán
                                            </c:when>

                                            <c:when test="${invoice.trangThai==2}">
                                                Đã hủy
                                            </c:when>

                                            <c:otherwise>
                                                Đang xử lý
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

                <!-- Tổng kết -->

                <div class="col-lg-4">

                    <div class="card shadow-sm">

                        <div class="card-header bg-white">

                            <i class="bi bi-receipt"></i>

                            Tổng kết thanh toán

                        </div>

                        <div class="card-body">

                            <table class="table table-borderless">

                                <tr>

                                    <td>Tổng tiền hàng</td>

                                    <td class="text-end">

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

                                                <div class="fw-semibold">${invoice.maVoucher}</div>
                                                <small class="text-muted">${invoice.tenVoucher}</small>

                                            </c:otherwise>

                                        </c:choose>

                                    </td>

                                </tr>

                                <tr>

                                    <td>Phí vận chuyển</td>

                                    <td class="text-end">

                                        0 ₫

                                    </td>

                                </tr>

                                <tr class="table-light fw-bold">

                                    <td>TỔNG TIỀN</td>

                                    <td class="text-end text-danger">

                                        <fmt:formatNumber
                                                value="${invoice.tongTienThanhToan}"
                                                type="currency"
                                                currencySymbol="₫"/>

                                    </td>

                                </tr>

                            </table>

                        </div>

                    </div>

                </div>

            </div>

            <!-- Dòng 2 -->

            <div class="row mt-3">

                <!-- Khách hàng -->

                <div class="col-lg-4">

                    <div class="card shadow-sm">

                        <div class="card-header bg-white">

                            <i class="bi bi-person"></i>

                            Thông tin khách hàng

                        </div>

                        <div class="card-body">

                            <table class="table table-borderless">

                                <tr>

                                    <td>Khách hàng</td>

                                    <td class="text-end">

                                        ${invoice.tenKhachHang}

                                    </td>

                                </tr>

                                <tr>

                                    <td>Số điện thoại</td>

                                    <td class="text-end">

                                        ${invoice.sdtKhachHang}

                                    </td>

                                </tr>

                                <tr>

                                    <td>Địa chỉ</td>

                                    <td class="text-end">

                                        ${invoice.diaChiKhachHang}

                                    </td>

                                </tr>

                            </table>

                        </div>

                    </div>

                </div>

                <!-- Hóa đơn và nhân viên -->

                <div class="col-lg-4">

                    <div class="card shadow-sm">

                        <div class="card-header bg-white">

                            <i class="bi bi-geo-alt"></i>

                            Thông tin giao nhận

                        </div>

                        <div class="card-body">

                            <table class="table table-borderless">

                                <tr>

                                    <td>Người nhận</td>

                                    <td class="text-end">

                                        ${empty invoice.tenNguoiNhan ? invoice.tenKhachHang : invoice.tenNguoiNhan}

                                    </td>

                                </tr>

                                <tr>

                                    <td>Số điện thoại</td>

                                    <td class="text-end">

                                        ${empty invoice.sdtNguoiNhan ? invoice.sdtKhachHang : invoice.sdtNguoiNhan}

                                    </td>

                                </tr>

                                <tr>
                                    <td>Địa chỉ giao hàng</td>
                                    <td class="text-end">${empty invoice.diaChiGiaoHang ? invoice.diaChiKhachHang : invoice.diaChiGiaoHang}</td>
                                </tr>

                                <tr>
                                    <td>Nhân viên</td>
                                    <td class="text-end">
                                        ${invoice.tenNhanVien} (${invoice.maNhanVien})
                                    </td>
                                </tr>

                                <tr>
                                    <td>Ngày tạo</td>
                                    <td class="text-end">
                                        <fmt:formatDate value="${invoice.ngayTao}" pattern="HH:mm dd/MM/yyyy"/>
                                    </td>
                                </tr>

                            </table>

                        </div>

                    </div>

                </div>

                <!-- Lịch sử thanh toán -->

                <div class="col-lg-4">

                    <div class="card shadow-sm">

                        <div class="card-header bg-white">

                            <i class="bi bi-clock-history"></i>

                            Lịch sử thanh toán

                        </div>

                        <div class="card-body">

                            <p class="mb-2">

                                <strong>

                                    Thanh toán

                                </strong>

                            </p>

                            <div class="text-danger fw-bold">

                                <fmt:formatNumber
                                        value="${invoice.tongTienThanhToan}"
                                        type="currency"
                                        currencySymbol="₫"/>

                            </div>

                            <small class="text-muted">

                                <fmt:formatDate
                                        value="${invoice.ngayThanhToan}"
                                        pattern="HH:mm:ss dd/MM/yyyy"/>

                            </small>

                        </div>

                    </div>

                </div>

            </div>
            <!-- Dòng 3 -->

            <div class="row mt-3">

                <!-- Danh sách sản phẩm -->

                <div class="col-lg-8">

                    <div class="card shadow-sm">

                        <div class="card-header bg-white">

                            <i class="bi bi-cart"></i>

                            Sản phẩm*

                        </div>

                        <div class="card-body">

                            <table class="table table-bordered table-hover align-middle">

                                <thead class="table-light">

                                <tr>

                                    <th>STT</th>
                                    <th>Mã biến thể</th>
                                    <th>Tên sản phẩm</th>
                                    <th>Phân loại</th>
                                    <th>Số lượng</th>
                                    <th>Đơn giá</th>
                                    <th>Thành tiền</th>

                                </tr>

                                </thead>

                                <tbody>

                                <c:forEach items="${details}" var="ct" varStatus="loop">

                                    <tr>

                                        <td>${loop.index+1}</td>
                                        <td>
                                            <div class="fw-semibold">${ct.maBienThe}</div>
                                            <small class="text-muted">${ct.maSanPham}</small>
                                        </td>
                                        <td>${ct.tenSanPham}</td>
                                        <td>${ct.mauSac} / ${ct.kichThuoc}</td>
                                        <td>${ct.soLuong}</td>
                                        <td>
                                            <fmt:formatNumber
                                                    value="${ct.giaBanRa}"
                                                    type="currency"
                                                    currencySymbol="₫"/>
                                        </td>
                                        <td>
                                            <fmt:formatNumber
                                                    value="${ct.tongTien}"
                                                    type="currency"
                                                    currencySymbol="₫"/>
                                        </td>
                                    </tr>

                                </c:forEach>

                                <c:if test="${empty details}">

                                    <tr>

                                        <td colspan="7" class="text-center">

                                            Không có sản phẩm.

                                        </td>

                                    </tr>

                                </c:if>

                                </tbody>

                            </table>

                        </div>

                    </div>

                </div>

                <!-- Thông tin chỉ đọc -->

                <div class="col-lg-4">

                    <div class="card shadow-sm">

                        <div class="card-header bg-white">

                            Thông tin hóa đơn

                        </div>

                        <div class="card-body">

                            <div class="mb-3">
                                <label class="form-label fw-semibold">Trạng thái hóa đơn</label>
                                <input class="form-control" readonly value="${invoice.trangThai == 0 ? 'Chờ xử lý' : invoice.trangThai == 1 ? 'Đã thanh toán' : invoice.trangThai == 2 ? 'Đã hủy' : 'Đã xóa'}">
                            </div>
                            <div class="mb-3">
                                <label class="form-label fw-semibold">Ghi chú</label>
                                <textarea class="form-control" rows="5" readonly>${invoice.ghiChu}</textarea>
                            </div>

                                <div class="d-grid gap-2">

                                    <button
                                            type="button"
                                            onclick="window.print()"
                                            class="btn btn-primary">

                                        <i class="bi bi-printer"></i>

                                        In hóa đơn

                                    </button>

                                </div>

                        </div>

                    </div>

                </div>

            </div>

            <div class="row mt-3">
                <div class="col-lg-6">
                    <div class="card shadow-sm h-100">
                        <div class="card-header bg-white fw-semibold"><i class="bi bi-credit-card me-1"></i> Thanh toán hóa đơn</div>
                        <div class="card-body p-0 table-responsive">
                            <table class="table table-hover align-middle mb-0">
                                <thead class="table-light"><tr><th>Mã giao dịch</th><th>Phương thức</th><th>Số tiền</th><th>Thời gian</th></tr></thead>
                                <tbody>
                                <c:forEach items="${payments}" var="payment">
                                    <tr>
                                        <td>${payment.maGiaoDich}</td>
                                        <td>${payment.tenPhuongThuc}</td>
                                        <td class="fw-semibold text-success"><fmt:formatNumber value="${payment.soTien}" type="number" groupingUsed="true"/> ₫</td>
                                        <td><fmt:formatDate value="${payment.thoiGian}" pattern="HH:mm dd/MM/yyyy"/></td>
                                    </tr>
                                </c:forEach>
                                <c:if test="${empty payments}"><tr><td colspan="4" class="text-center text-muted py-4">Chưa có giao dịch thanh toán.</td></tr></c:if>
                                </tbody>
                            </table>
                        </div>
                    </div>
                </div>
                <div class="col-lg-6">
                    <div class="card shadow-sm h-100">
                        <div class="card-header bg-white fw-semibold"><i class="bi bi-clock-history me-1"></i> Lịch sử hóa đơn</div>
                        <div class="card-body">
                            <c:forEach items="${histories}" var="history">
                                <div class="d-flex gap-3 pb-3 mb-3 border-bottom">
                                    <i class="bi bi-check-circle-fill text-primary"></i>
                                    <div class="flex-grow-1">
                                        <div class="d-flex justify-content-between gap-2">
                                            <span class="fw-semibold">${history.ghiChu}</span>
                                            <small class="text-muted text-nowrap"><fmt:formatDate value="${history.thoiGian}" pattern="HH:mm dd/MM/yyyy"/></small>
                                        </div>
                                        <small class="text-muted">Mã lịch sử: ${history.ma}</small>
                                    </div>
                                </div>
                            </c:forEach>
                            <c:if test="${empty histories}"><div class="text-center text-muted py-4">Chưa có lịch sử cập nhật.</div></c:if>
                        </div>
                    </div>
                </div>
            </div>

        </div>

        <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>

        </body>

        </html>
    </div>
</div>

