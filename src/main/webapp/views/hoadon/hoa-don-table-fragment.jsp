<%@ page contentType="text/html;charset=UTF-8" language="java" pageEncoding="UTF-8" %>
<%@ taglib uri="jakarta.tags.core" prefix="c" %>
<%@ taglib uri="jakarta.tags.fmt" prefix="fmt" %>
<fmt:setLocale value="vi_VN"/>
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
                    <c:when test="${hd.trangThai==2}">
                        <span class="badge-danger">Đã hủy</span>
                    </c:when>
                </c:choose>
            </td>
            <td class="text-center">
                <div class="btn-group">
                    <a href="${pageContext.request.contextPath}/quanlyhoadon?action=detail&id=${hd.id}" class="btn btn-outline-primary btn-view" title="Chi tiết">
                        <i class="bi bi-eye"></i>
                    </a>
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
