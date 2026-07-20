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
	</style>
</head>
<body>
<jsp:include page="/views/layout/sidebar.jsp"/>
<div class="main-content">
	<div class="container-fluid">
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
			<div class="no-print">
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
<%--			Tong két thanh toan--%>
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
									class="btn btn-primary"
									onclick="printInvoice()">
								<i class="bi bi-printer"></i>
								In hóa đơn
							</button>
						</div>
					</div>
				</div>
			</div>
		</div>
		<!-- Thanh toán + Lịch sử -->
		<div class="row g-3 mb-4">
			<!-- Thanh toán -->
			<div class="col-lg-6">
				<div class="card shadow-sm h-100">
					<div class="card-header">
						<i class="bi bi-credit-card"></i>
						Thanh toán hóa đơn
					</div>
					<div class="table-responsive">
						<table class="table table-hover align-middle mb-0">
							<thead class="table-light">
							<tr>
								<th>Mã GD</th>
								<th>Phương thức</th>
								<th>Số tiền</th>
								<th>Thời gian</th>
							</tr>
							</thead>
							<tbody>
							<c:forEach items="${payments}" var="payment">
								<tr>
									<td>${payment.maGiaoDich}</td>
									<td>${payment.tenPhuongThuc}</td>
									<td class="text-success fw-bold text-end">
										<fmt:formatNumber
												value="${payment.soTien}"
												type="number"
												groupingUsed="true"/> ₫
									</td>
									<td>
										<fmt:formatDate
												value="${payment.thoiGian}"
												pattern="HH:mm dd/MM/yyyy"/>
									</td>
								</tr>
							</c:forEach>
							<c:if test="${empty payments}">
								<tr>
									<td colspan="4"
										class="text-center py-4 text-muted">
										Chưa có giao dịch.
									</td>
								</tr>
							</c:if>
							</tbody>
						</table>
					</div>
				</div>
			</div>
			<!-- Lịch sử -->
			<div class="col-lg-6">
				<div class="card shadow-sm h-100">
					<div class="card-header">
						<i class="bi bi-clock-history"></i>
						Lịch sử hóa đơn
					</div>
					<div class="card-body"
						 style="max-height:320px;overflow:auto;">
						<c:forEach items="${histories}" var="history">
							<div class="border-bottom pb-2 mb-2">
								<div class="d-flex justify-content-between">
									<strong>
											${history.ghiChu}
									</strong>
									<small class="text-muted">
										<fmt:formatDate
												value="${history.thoiGian}"
												pattern="HH:mm dd/MM/yyyy"/>
									</small>
								</div>
								<small class="text-muted">
										${history.ma}
								</small>
							</div>
						</c:forEach>
						<c:if test="${empty histories}">
							<div class="text-center text-muted py-4">
								Chưa có lịch sử.
							</div>
						</c:if>
					</div>
				</div>
			</div>
		</div>
	</div>
</div>
<script>
    function printInvoice() {
        var printContents = document.querySelector(".main-content").innerHTML;
        var printWindow = window.open("", "", "width=1000,height=800");
        var html = "<html><head>"
            + "<title>Hoa don</title>"
            + "<link rel=\"stylesheet\" href=\"https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css\">"
            + "<link rel=\"stylesheet\" href=\"https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.css\">"
            + "<style>"
            + "body{padding:20px;font-size:14px;}"
            + ".btn{display:none;}"
            + ".sidebar{display:none;}"
            + "</style>"
            + "</head><body>"
            + printContents
            + "</body></html>";
        printWindow.document.open();
        printWindow.document.write(html);
        printWindow.document.close();

        printWindow.onload = function () {
            printWindow.focus();
            printWindow.print();
            printWindow.close();
        };
    }
</script>
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
