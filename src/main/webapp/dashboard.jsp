<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<fmt:setLocale value="vi_VN"/>
<!DOCTYPE html>
<html lang="vi">
<head>
    <%@ include file="/views/layout/head.jsp" %>
    <title>Thống kê doanh thu.</title>
    <style>
        .stat-grid{display:grid;grid-template-columns:repeat(4,1fr);gap:16px;margin-bottom:18px}
        @media(max-width:1200px){.stat-grid{grid-template-columns:repeat(2,1fr)}}
        @media(max-width:576px){.stat-grid{grid-template-columns:1fr}}

        .stat-card{background:#fff;border:1px solid var(--admin-slate-200);border-radius:var(--admin-radius-lg);padding:18px 20px;box-shadow:var(--admin-shadow-sm)}
        .stat-card__label{font-size:12.5px;font-weight:700;color:var(--admin-slate-500);text-transform:uppercase;letter-spacing:.4px;display:flex;align-items:center;gap:8px}
        .stat-card__label i{font-size:15px;color:var(--admin-blue-600)}
        .stat-card__value{font-size:23px;font-weight:800;color:var(--admin-slate-900);margin-top:8px}
        .stat-card__sub{margin-top:6px;font-size:12.5px;color:var(--admin-slate-500)}
        .stat-card.accent{background:linear-gradient(135deg,var(--admin-navy-800),var(--admin-blue-600));border:none}
        .stat-card.accent .stat-card__label,.stat-card.accent .stat-card__value,.stat-card.accent .stat-card__sub{color: #1D1D1D !important}
        .stat-card.accent .stat-card__label i{color:#dbeafe}

        .filter-card{background:#fff;border:1px solid var(--admin-slate-200);border-radius:var(--admin-radius-lg);box-shadow:var(--admin-shadow-sm);padding:20px;margin-bottom:18px}
        .quick-range .btn{border-radius:999px}
        .quick-range .btn.active{background:var(--admin-blue-600);border-color:var(--admin-blue-600);color:#fff}

        .panel{background:#fff;border:1px solid var(--admin-slate-200);border-radius:var(--admin-radius-lg);box-shadow:var(--admin-shadow-sm);padding:20px;margin-bottom:18px}
        .panel__head{display:flex;justify-content:space-between;align-items:center;flex-wrap:wrap;gap:10px;margin-bottom:16px}
        .panel__head h5{margin:0;font-weight:800}
        .chart-toggle .btn{border-radius:999px}
        .chart-toggle .btn.active{background:var(--admin-slate-900);border-color:var(--admin-slate-900);color:#fff}

        .growth-up{color:var(--admin-success);font-weight:700}
        .growth-down{color:var(--admin-danger);font-weight:700}
        .growth-flat{color:var(--admin-slate-500);font-weight:700}

        .status-pill{display:inline-flex;align-items:center;gap:6px;font-size:12.5px;font-weight:700}
        .status-dot{width:9px;height:9px;border-radius:50%;display:inline-block}

        .legend-list{list-style:none;padding:0;margin:16px 0 0}
        .legend-list li{display:flex;justify-content:space-between;align-items:center;padding:8px 0;border-bottom:1px dashed var(--admin-slate-200);font-size:13px}
        .legend-list li:last-child{border-bottom:none}

        .empty-note{padding:30px;text-align:center;color:var(--admin-slate-500)}
    </style>
</head>
<body>
<%@ include file="/views/layout/sidebar.jsp" %>
<main class="main-content">

    <div class="d-flex justify-content-between align-items-start flex-wrap gap-2 mb-3">
        <div>
            <div class="small text-secondary mb-1">Scott Admin / Tổng quan</div>
            <h2 class="fw-bold mb-1">Thống kê doanh thu</h2>
            <div class="text-secondary">Tổng quan tình hình kinh doanh của cửa hàng.</div>
        </div>
    </div>

    <%-- ================= BỘ LỌC THỜI GIAN ================= --%>
    <div class="filter-card">
        <form method="get" action="${pageContext.request.contextPath}/dashboard" class="row g-3 align-items-end" id="dashboardFilterForm">
            <div class="col-lg-3 col-sm-6">
                <label class="form-label">Từ ngày</label>
                <input type="date" class="form-control" name="fromDate" value="${fromDate}">
            </div>
            <div class="col-lg-3 col-sm-6">
                <label class="form-label">Đến ngày</label>
                <input type="date" class="form-control" name="toDate" value="${toDate}">
            </div>
            <div class="col-lg-3 col-sm-6">
                <label class="form-label">Nhóm dữ liệu</label>
                <select class="form-select" name="groupBy">
                    <option value="day" ${groupBy == 'day' ? 'selected' : ''}>Theo ngày</option>
                    <option value="week" ${groupBy == 'week' ? 'selected' : ''}>Theo tuần</option>
                    <option value="month" ${groupBy == 'month' ? 'selected' : ''}>Theo tháng</option>
                </select>
            </div>
            <div class="col-lg-3 col-sm-6 d-flex gap-2">
                <button type="submit" class="btn btn-primary flex-fill"><i class="bi bi-funnel-fill me-1"></i>Lọc dữ liệu</button>
                <a href="${pageContext.request.contextPath}/dashboard" class="btn btn-outline-secondary"><i class="bi bi-arrow-counterclockwise"></i></a>
            </div>

            <div class="col-12 quick-range d-flex flex-wrap gap-2 mt-1">
                <c:url var="qToday" value="/dashboard"><c:param name="fromDate" value="${todayLabel}"/><c:param name="toDate" value="${todayLabel}"/><c:param name="groupBy" value="day"/></c:url>
                <c:url var="q30Days" value="/dashboard"><c:param name="groupBy" value="day"/></c:url>
                <c:url var="q12Months" value="/dashboard"><c:param name="groupBy" value="month"/></c:url>
                <a class="btn btn-sm btn-outline-secondary ${customRange && fromDate == todayLabel && toDate == todayLabel ? 'active' : ''}" href="${qToday}">Hôm nay</a>
                <a class="btn btn-sm btn-outline-secondary ${!customRange && groupBy == 'day' ? 'active' : ''}" href="${q30Days}">30 ngày gần nhất</a>
                <a class="btn btn-sm btn-outline-secondary ${!customRange && groupBy == 'month' ? 'active' : ''}" href="${q12Months}">12 tháng gần nhất</a>
                <small class="text-secondary align-self-center ms-2">
                    <i class="bi bi-info-circle"></i>
                    Đang hiển thị dữ liệu từ <strong>${fromDate}</strong> đến <strong>${toDate}</strong>
                </small>
            </div>
        </form>
    </div>

    <%-- ================= THẺ TỔNG QUAN THEO KHOẢNG ĐÃ CHỌN ================= --%>
    <div class="stat-grid">
        <div class="stat-card">
            <div class="stat-card__label"><i class="bi bi-receipt"></i> Tổng đơn hàng</div>
            <div class="stat-card__value">${tongDonHang}</div>
            <div class="stat-card__sub">Trong khoảng thời gian đã chọn</div>
        </div>
        <div class="stat-card">
            <div class="stat-card__label"><i class="bi bi-cash-stack"></i> Tổng doanh thu</div>
            <div class="stat-card__value"><fmt:formatNumber value="${tongDoanhThu}" type="currency" currencySymbol="₫"/></div>
            <div class="stat-card__sub">Không tính đơn đã hủy / đã xóa</div>
        </div>
        <div class="stat-card accent">
            <div class="stat-card__label"><i class="bi bi-check2-circle"></i> Doanh thu thực tế</div>
            <div class="stat-card__value"><fmt:formatNumber value="${doanhThuThucTe}" type="currency" currencySymbol="₫"/></div>
            <div class="stat-card__sub">Đơn đã thanh toán thành công</div>
        </div>
        <div class="stat-card">
            <div class="stat-card__label"><i class="bi bi-hourglass-split"></i> Doanh thu dự kiến</div>
            <div class="stat-card__value"><fmt:formatNumber value="${doanhThuDuKien}" type="currency" currencySymbol="₫"/></div>
            <div class="stat-card__sub">Gồm cả đơn đang chờ xử lý</div>
        </div>
    </div>

    <%-- ================= THẺ NHANH: HÔM NAY / TUẦN / THÁNG / NĂM ================= --%>
    <div class="stat-grid">
        <c:forEach var="pk" items="${bangThongKe}">
            <div class="stat-card">
                <div class="stat-card__label"><i class="bi bi-calendar3"></i> ${pk.nhan}</div>
                <div class="stat-card__value"><fmt:formatNumber value="${pk.doanhThu}" type="currency" currencySymbol="₫"/></div>
                <div class="stat-card__sub">Sản phẩm: ${pk.soSanPham} &nbsp;|&nbsp; Đơn: ${pk.soDon}</div>
            </div>
        </c:forEach>
    </div>

    <%-- ================= BIỂU ĐỒ DOANH THU ================= --%>
    <div class="panel">
        <div class="panel__head">
            <h5><i class="bi bi-graph-up me-2"></i>Biểu đồ doanh thu theo thời gian</h5>
            <div class="chart-toggle btn-group">
                <button type="button" class="btn btn-sm btn-outline-secondary active" id="btnLineChart">Biểu đồ đường</button>
                <button type="button" class="btn btn-sm btn-outline-secondary" id="btnBarChart">Biểu đồ cột</button>
            </div>
        </div>
        <c:choose>
            <c:when test="${empty chartData}">
                <div class="empty-note"><i class="bi bi-bar-chart display-6 d-block mb-2"></i>Không có doanh thu trong khoảng thời gian đã chọn.</div>
            </c:when>
            <c:otherwise>
                <div style="height:340px"><canvas id="revenueChart"></canvas></div>
            </c:otherwise>
        </c:choose>
    </div>

    <div class="row">
        <%-- ================= BẢNG THỐNG KÊ CHI TIẾT ================= --%>
        <div class="col-lg-8 mb-4">
            <div class="panel h-100 mb-0">
                <div class="panel__head"><h5><i class="bi bi-table me-2"></i>Bảng thống kê chi tiết theo thời gian</h5></div>
                <div class="table-responsive">
                    <table class="table table-hover align-middle">
                        <thead>
                        <tr>
                            <th>Thời gian</th>
                            <th>Doanh thu</th>
                            <th>Số đơn</th>
                            <th>Giá trị trung bình/đơn</th>
                            <th>Tăng trưởng (%)</th>
                        </tr>
                        </thead>
                        <tbody>
                        <c:forEach var="pk" items="${bangThongKe}">
                            <tr>
                                <td class="fw-semibold">${pk.nhan}</td>
                                <td><fmt:formatNumber value="${pk.doanhThu}" type="currency" currencySymbol="₫"/></td>
                                <td>${pk.soDon}</td>
                                <td><fmt:formatNumber value="${pk.giaTriTrungBinh}" type="currency" currencySymbol="₫"/></td>
                                <td>
                                    <c:choose>
                                        <c:when test="${pk.tangTruong > 0}"><span class="growth-up"><i class="bi bi-arrow-up-short"></i><fmt:formatNumber value="${pk.tangTruong}" maxFractionDigits="2"/>%</span></c:when>
                                        <c:when test="${pk.tangTruong < 0}"><span class="growth-down"><i class="bi bi-arrow-down-short"></i><fmt:formatNumber value="${pk.tangTruong}" maxFractionDigits="2"/>%</span></c:when>
                                        <c:otherwise><span class="growth-flat">0%</span></c:otherwise>
                                    </c:choose>
                                </td>
                            </tr>
                        </c:forEach>
                        </tbody>
                    </table>
                </div>
            </div>
        </div>

        <%-- ================= PHÂN BỐ TRẠNG THÁI ĐƠN HÀNG ================= --%>
        <div class="col-lg-4 mb-4">
            <div class="panel h-100 mb-0">
                <div class="panel__head"><h5><i class="bi bi-pie-chart me-2"></i>Phân bố trạng thái đơn hàng</h5></div>
                <c:choose>
                    <c:when test="${soChoXuLy == 0 && soDaThanhToan == 0 && soDaHuy == 0 && soDaXoa == 0}">
                        <div class="empty-note">Chưa có đơn hàng nào.</div>
                    </c:when>
                    <c:otherwise>
                        <div style="height:220px"><canvas id="statusChart"></canvas></div>
                        <ul class="legend-list">
                            <li><span class="status-pill"><span class="status-dot" style="background:#d97706"></span>Chờ xử lý</span><strong>${soChoXuLy}</strong></li>
                            <li><span class="status-pill"><span class="status-dot" style="background:#059669"></span>Đã thanh toán</span><strong>${soDaThanhToan}</strong></li>
                            <li><span class="status-pill"><span class="status-dot" style="background:#dc2626"></span>Đã hủy</span><strong>${soDaHuy}</strong></li>
                            <li><span class="status-pill"><span class="status-dot" style="background:#94a3b8"></span>Đã xóa</span><strong>${soDaXoa}</strong></li>
                        </ul>
                    </c:otherwise>
                </c:choose>
            </div>
        </div>
    </div>

    <%-- ================= TOP SẢN PHẨM BÁN CHẠY ================= --%>
    <div class="panel">
        <div class="panel__head">
            <h5><i class="bi bi-trophy me-2"></i>Top sản phẩm bán chạy (30 ngày)</h5>
            <small class="text-secondary">Từ ${top30From} đến ${top30To}</small>
        </div>
        <c:choose>
            <c:when test="${empty topSelling}">
                <div class="empty-note">Chưa có sản phẩm nào được bán trong 30 ngày gần đây.</div>
            </c:when>
            <c:otherwise>
                <div class="table-responsive">
                    <table class="table table-hover align-middle">
                        <thead>
                        <tr>
                            <th>#</th>
                            <th>Sản phẩm</th>
                            <th>Thuộc tính</th>
                            <th>Giá</th>
                            <th>Tồn kho</th>
                            <th>Đã bán</th>
                        </tr>
                        </thead>
                        <tbody>
                        <c:forEach var="sp" items="${topSelling}" varStatus="st">
                            <tr>
                                <td>${st.index + 1}</td>
                                <td>
                                    <div class="fw-semibold">${sp.tenSanPham}</div>
                                    <small class="text-secondary">${sp.maSanPham}</small>
                                </td>
                                <td>
                                    <c:if test="${not empty sp.mauSac}"><span class="badge text-bg-light border me-1">${sp.mauSac}</span></c:if>
                                    <c:if test="${not empty sp.kichThuoc}"><span class="badge text-bg-light border">Size ${sp.kichThuoc}</span></c:if>
                                </td>
                                <td><fmt:formatNumber value="${sp.giaBan}" type="currency" currencySymbol="₫"/></td>
                                <td>${sp.tonKho}</td>
                                <td><span class="fw-bold text-primary">${sp.daBan}</span></td>
                            </tr>
                        </c:forEach>
                        </tbody>
                    </table>
                </div>
            </c:otherwise>
        </c:choose>
    </div>

    <%-- ================= THỐNG KÊ TỒN KHO THEO QUÝ ================= --%>
    <div class="panel mb-4">
        <div class="panel__head">
            <div>
                <h5><i class="bi bi-boxes me-2"></i>Thống kê tồn kho Quý hiện tại</h5>
                <small class="text-secondary">Từ ${quarterStart} đến ${quarterEnd}</small>
            </div>
        </div>

        <form method="get" action="${pageContext.request.contextPath}/dashboard" class="row g-3 align-items-end mb-3">
            <input type="hidden" name="fromDate" value="${fromDate}">
            <input type="hidden" name="toDate" value="${toDate}">
            <input type="hidden" name="groupBy" value="${groupBy}">
            <div class="col-md-3 col-sm-6">
                <label class="form-label">Thương hiệu</label>
                <select class="form-select" name="brand">
                    <option value="">Tất cả</option>
                    <c:forEach var="b" items="${brands}">
                        <option value="${b.id}" ${brandId == b.id ? 'selected' : ''}>${b.ten}</option>
                    </c:forEach>
                </select>
            </div>
            <div class="col-md-3 col-sm-6">
                <label class="form-label">Danh mục</label>
                <select class="form-select" name="category">
                    <option value="">Tất cả</option>
                    <c:forEach var="c" items="${categories}">
                        <option value="${c.id}" ${categoryId == c.id ? 'selected' : ''}>${c.tenDanhMuc}</option>
                    </c:forEach>
                </select>
            </div>
            <div class="col-md-3 col-sm-6">
                <label class="form-label">Trạng thái bán</label>
                <select class="form-select" name="invStatus">
                    <option value="">Tất cả</option>
                    <option value="1" ${invStatus == 1 ? 'selected' : ''}>Đang bán</option>
                    <option value="0" ${invStatus == 0 ? 'selected' : ''}>Ngừng bán</option>
                </select>
            </div>
            <div class="col-md-3 col-sm-6">
                <button type="submit" class="btn btn-primary w-100"><i class="bi bi-funnel-fill me-1"></i>Lọc</button>
            </div>
        </form>

        <c:choose>
            <c:when test="${empty inventory}">
                <div class="empty-note">Không có biến thể sản phẩm nào phù hợp với bộ lọc.</div>
            </c:when>
            <c:otherwise>
                <div class="table-responsive">
                    <table class="table table-hover align-middle">
                        <thead>
                        <tr>
                            <th>Mã SP</th>
                            <th>Sản phẩm</th>
                            <th>Thuộc tính</th>
                            <th>Giá</th>
                            <th>Đã bán / Tồn</th>
                            <th>Tỷ lệ bán</th>
                            <th>Trạng thái</th>
                        </tr>
                        </thead>
                        <tbody>
                        <c:forEach var="sp" items="${inventory}">
                            <tr>
                                <td>${sp.maSanPham}</td>
                                <td>
                                    <div class="fw-semibold">${sp.tenSanPham}</div>
                                    <small class="text-secondary">${sp.tenThuongHieu}</small>
                                </td>
                                <td>
                                    <c:if test="${not empty sp.mauSac}"><span class="badge text-bg-light border me-1">${sp.mauSac}</span></c:if>
                                    <c:if test="${not empty sp.kichThuoc}"><span class="badge text-bg-light border">Size ${sp.kichThuoc}</span></c:if>
                                </td>
                                <td><fmt:formatNumber value="${sp.giaBan}" type="currency" currencySymbol="₫"/></td>
                                <td>${sp.daBan} / ${sp.tonKho}</td>
                                <td><fmt:formatNumber value="${sp.tyLeBanRa}" maxFractionDigits="1"/>%</td>
                                <td>
                                    <c:choose>
                                        <c:when test="${sp.tonKho > 0}"><span class="badge text-bg-success-subtle text-success border border-success-subtle">Còn hàng</span></c:when>
                                        <c:otherwise><span class="badge text-bg-danger-subtle text-danger border border-danger-subtle">Hết hàng</span></c:otherwise>
                                    </c:choose>
                                </td>
                            </tr>
                        </c:forEach>
                        </tbody>
                    </table>
                </div>
            </c:otherwise>
        </c:choose>
    </div>

</main>

<script src="https://cdn.jsdelivr.net/npm/chart.js@4.4.4/dist/chart.umd.min.js"></script>
<%@ include file="/views/layout/footer.jsp" %>

<script>
    (function () {
        var labels = [
            <c:forEach var="p" items="${chartData}" varStatus="st">'${p.nhan}'<c:if test="${!st.last}">,</c:if></c:forEach>
        ];
        var revenues = [
            <c:forEach var="p" items="${chartData}" varStatus="st">${p.doanhThu}<c:if test="${!st.last}">,</c:if></c:forEach>
        ];

        var ctx = document.getElementById('revenueChart');
        var chart = null;

        function renderChart(type) {
            if (!ctx) return;
            if (chart) chart.destroy();
            chart = new Chart(ctx, {
                type: type,
                data: {
                    labels: labels,
                    datasets: [{
                        label: 'Doanh thu',
                        data: revenues,
                        borderColor: '#2563eb',
                        backgroundColor: type === 'bar' ? 'rgba(37,99,235,.55)' : 'rgba(37,99,235,.12)',
                        tension: .35,
                        fill: type === 'line',
                        borderRadius: type === 'bar' ? 6 : 0,
                        pointRadius: type === 'line' ? 3 : 0
                    }]
                },
                options: {
                    responsive: true,
                    maintainAspectRatio: false,
                    plugins: { legend: { display: true } },
                    scales: {
                        y: {
                            beginAtZero: true,
                            ticks: {
                                callback: function (v) { return v.toLocaleString('vi-VN'); }
                            }
                        }
                    }
                }
            });
        }

        if (ctx) {
            renderChart('line');
            document.getElementById('btnLineChart').addEventListener('click', function () {
                this.classList.add('active');
                document.getElementById('btnBarChart').classList.remove('active');
                renderChart('line');
            });
            document.getElementById('btnBarChart').addEventListener('click', function () {
                this.classList.add('active');
                document.getElementById('btnLineChart').classList.remove('active');
                renderChart('bar');
            });
        }

        var statusCtx = document.getElementById('statusChart');
        if (statusCtx) {
            new Chart(statusCtx, {
                type: 'doughnut',
                data: {
                    labels: ['Chờ xử lý', 'Đã thanh toán', 'Đã hủy', 'Đã xóa'],
                    datasets: [{
                        data: [${soChoXuLy}, ${soDaThanhToan}, ${soDaHuy}, ${soDaXoa}],
                        backgroundColor: ['#d97706', '#059669', '#dc2626', '#94a3b8'],
                        borderWidth: 0
                    }]
                },
                options: {
                    responsive: true,
                    maintainAspectRatio: false,
                    plugins: { legend: { display: false } },
                    cutout: '65%'
                }
            });
        }
    })();
</script>
</body>
</html>
