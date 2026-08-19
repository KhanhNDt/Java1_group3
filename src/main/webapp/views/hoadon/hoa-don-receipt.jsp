<%@ page contentType="text/html;charset=UTF-8" language="java" pageEncoding="UTF-8" %>
<%@ taglib uri="jakarta.tags.core" prefix="c" %>
<%@ taglib uri="jakarta.tags.fmt" prefix="fmt" %>
<fmt:setLocale value="vi_VN"/>

<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <title>Hóa đơn ${invoice.maHoaDon}</title>
    <style>
        * { box-sizing: border-box; }
        html, body {
            margin: 0;
            padding: 0;
            background: #f2f2f2;
            color: #111;
            font-family: Arial, Helvetica, sans-serif;
        }
        .preview-wrap {
            min-height: 100vh;
            padding: 18px 0 28px;
        }
        .receipt {
            width: 360px;
            margin: 0 auto;
            padding: 22px 24px 26px;
            background: #fff;
            box-shadow: 0 8px 30px rgba(0,0,0,.10);
            font-size: 12px;
            line-height: 1.45;
        }
        .center { text-align: center; }
        .shop-name {
            font-size: 19px;
            font-weight: 800;
            letter-spacing: .4px;
        }
        .shop-info {
            margin-top: 2px;
            font-size: 11px;
        }
        .title {
            margin: 11px 0 2px;
            font-size: 14px;
            font-weight: 800;
        }
        .dash {
            border-top: 1px dashed #222;
            margin: 9px 0;
        }
        .meta-row, .total-row {
            display: flex;
            justify-content: space-between;
            gap: 12px;
        }
        .meta-row span:last-child,
        .total-row span:last-child {
            text-align: right;
        }
        .customer {
            margin-top: 6px;
        }
        .items-head, .item-row {
            display: grid;
            grid-template-columns: minmax(0, 1fr) 32px 67px 73px;
            gap: 4px;
            align-items: start;
        }
        .items-head {
            font-size: 10.5px;
            font-weight: 800;
        }
        .items-head div:nth-child(n+2),
        .item-row div:nth-child(n+2) {
            text-align: right;
        }
        .item-row {
            padding: 3px 0;
            font-size: 11px;
        }
        .item-name {
            margin-top: 1px;
            color: #444;
            font-size: 10.5px;
        }
        .grand {
            margin-top: 3px;
            padding-top: 4px;
            border-top: 1px solid #111;
            font-size: 13px;
            font-weight: 800;
        }
        .payment {
            margin-top: 7px;
        }
        .invoice-code {
            margin: 14px auto 4px;
            width: fit-content;
            padding: 8px 12px;
            border: 2px solid #111;
            font-family: "Courier New", monospace;
            font-size: 14px;
            font-weight: 800;
            letter-spacing: 1px;
        }
        .footer {
            margin-top: 12px;
            text-align: center;
            font-size: 11px;
        }

        @media print {
            @page {
                size: 80mm auto;
                margin: 0;
            }
            html, body {
                width: 80mm;
                background: #fff;
            }
            .preview-wrap {
                min-height: 0;
                padding: 0;
            }
            .receipt {
                width: 80mm;
                margin: 0;
                padding: 4mm 4mm 6mm;
                box-shadow: none;
            }
        }
    </style>
</head>
<body>
<div class="preview-wrap">
    <div class="receipt">
        <div class="center">
            <div class="shop-name">SCOTT SHOP</div>
            <div class="shop-info">
                FPT Polytechnic<br>
                ĐT: 0987395826
            </div>
            <div class="title">HÓA ĐƠN BÁN HÀNG</div>
        </div>

        <div class="dash"></div>

        <div class="meta-row">
            <span>Ngày:</span>
            <span><fmt:formatDate value="${invoice.ngayTao}" pattern="dd/MM/yyyy"/></span>
        </div>
        <div class="meta-row">
            <span>Giờ:</span>
            <span><fmt:formatDate value="${invoice.ngayTao}" pattern="HH:mm"/></span>
        </div>
        <div class="meta-row">
            <span>Số HĐ:</span>
            <strong>${invoice.maHoaDon}</strong>
        </div>

        <div class="customer">
            <div><strong>Khách:</strong> ${empty invoice.tenKhachHang ? 'Khách lẻ' : invoice.tenKhachHang}</div>
            <c:if test="${not empty invoice.sdtKhachHang}">
                <div><strong>SĐT:</strong> ${invoice.sdtKhachHang}</div>
            </c:if>
            <c:if test="${not empty invoice.diaChiKhachHang}">
                <div><strong>Đ/c:</strong> ${invoice.diaChiKhachHang}</div>
            </c:if>
        </div>

        <div class="dash"></div>

        <div class="items-head">
            <div>TÊN HÀNG</div>
            <div>SL</div>
            <div>Đ.GIÁ</div>
            <div>TH.TIỀN</div>
        </div>

        <div class="dash"></div>

        <c:forEach items="${details}" var="ct">
            <div class="item-row">
                <div>
                    <strong>${ct.maBienThe}</strong>
                    <div class="item-name">
                            ${ct.tenSanPham}
                        <c:if test="${not empty ct.mauSac || not empty ct.kichThuoc}">
                            (${ct.mauSac}/${ct.kichThuoc})
                        </c:if>
                    </div>
                </div>
                <div>${ct.soLuong}</div>
                <div><fmt:formatNumber value="${ct.giaBanRa}" pattern="#,##0"/></div>
                <div><fmt:formatNumber value="${ct.tongTien}" pattern="#,##0"/></div>
            </div>
        </c:forEach>

        <div class="dash"></div>

        <div class="total-row">
            <span>Tổng SL:</span>
            <span>${invoice.soLuongSanPham}</span>
        </div>
        <div class="total-row">
            <span>Tổng tiền:</span>
            <span><fmt:formatNumber value="${invoice.tienHangGoc}" pattern="#,##0"/> đ</span>
        </div>
        <div class="total-row">
            <span>Giảm giá:</span>
            <span><fmt:formatNumber value="${invoice.tienGiam}" pattern="#,##0"/> đ</span>
        </div>
        <div class="total-row grand">
            <span>TỔNG THANH TOÁN:</span>
            <span><fmt:formatNumber value="${invoice.tongTienThanhToan}" pattern="#,##0"/> đ</span>
        </div>

        <c:if test="${not empty invoice.tienKhachDua}">
            <div class="total-row">
                <span>Khách đưa:</span>
                <span><fmt:formatNumber value="${invoice.tienKhachDua}" pattern="#,##0"/> đ</span>
            </div>
            <div class="total-row">
                <span>Trả lại:</span>
                <span><fmt:formatNumber value="${invoice.tienThua}" pattern="#,##0"/> đ</span>
            </div>
        </c:if>

        <div class="payment">
            <strong>Thanh toán:</strong>
            <c:forEach items="${payments}" var="p" varStatus="st">
                ${p.tenPhuongThuc}<c:if test="${!st.last}">, </c:if>
            </c:forEach>
            <c:if test="${empty payments}">Chưa xác định</c:if>
        </div>

        <div style="margin-top:8px;"><strong>Thu ngân:</strong> ${invoice.tenNhanVien}</div>

        <div class="invoice-code">${invoice.maHoaDon}</div>
        <div class="center" style="font-size:10px;">Quét/đối chiếu theo mã hóa đơn</div>

        <div class="dash"></div>

        <div class="footer">
            Cảm ơn quý khách!<br>
            Vui lòng kiểm tra hàng trước khi rời quầy.
        </div>
    </div>
</div>
</body>
</html>
