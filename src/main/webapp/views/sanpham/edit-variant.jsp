<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html><html lang="vi"><head><%@ include file="/views/layout/head.jsp" %><title>Cập nhật biến thể</title></head><body>
<%@ include file="/views/layout/sidebar.jsp" %>
<main class="main-content"><div class="d-flex justify-content-between align-items-start mb-4"><div><div class="small text-secondary">Scott Admin / Sản phẩm / Biến thể</div><h2 class="fw-bold mb-1">Cập nhật biến thể</h2><div class="text-secondary">${chiTietForm.sanPham.maSanPham} - ${chiTietForm.sanPham.tenSanPham}</div></div><a class="btn btn-outline-secondary" href="${pageContext.request.contextPath}/san-pham/chi-tiet/hien-thi?idSanPham=${chiTietForm.sanPham.id}"><i class="bi bi-arrow-left me-1"></i>Quay lại</a></div>
    <section class="card"><div class="card-header"><h5 class="mb-0 fw-bold">Thông tin biến thể</h5></div><div class="card-body"><form method="post" enctype="multipart/form-data" action="${pageContext.request.contextPath}/san-pham/chi-tiet/update" class="row g-3"><input type="hidden" name="id" value="${chiTietForm.id}"><input type="hidden" name="idSanPham" value="${chiTietForm.sanPham.id}"><div class="col-lg-4"><label class="form-label">Mã biến thể</label><input class="form-control" name="maChiTiet" value="${chiTietForm.ma}" required maxlength="50"></div><div class="col-lg-4"><label class="form-label">Màu sắc</label><select class="form-select" name="idMauSac" required><c:forEach items="${listMauSac}" var="x"><option value="${x.id}" ${chiTietForm.mauSac.id==x.id?'selected':''}>${x.ten}</option></c:forEach></select></div><div class="col-lg-4"><label class="form-label">Kích thước</label><select class="form-select" name="idSize" required><c:forEach items="${listSize}" var="x"><option value="${x.id}" ${chiTietForm.size.id==x.id?'selected':''}>${x.ten}</option></c:forEach></select></div><div class="col-lg-4"><label class="form-label">Giá nhập</label><input class="form-control quick-pick-input" data-picker="import" type="number" min="0" step="1000" name="giaNhap" value="${chiTietForm.giaNhap}" required autocomplete="off"></div><div class="col-lg-4"><label class="form-label">Giá bán</label><input class="form-control quick-pick-input" data-picker="price" type="number" min="0" step="1000" name="giaBan" value="${chiTietForm.giaBan}" required autocomplete="off"></div><div class="col-lg-4"><label class="form-label">Số lượng tồn</label><input class="form-control quick-pick-input" data-picker="stock" type="number" min="0" name="soLuongTon" value="${chiTietForm.soLuongTon}" required autocomplete="off"></div><div class="col-lg-6"><label class="form-label">Ảnh riêng cho màu ${chiTietForm.mauSac.ten}</label><c:if test="${not empty anhMauHienTai}"><div class="mb-2"><img src="${pageContext.request.contextPath}/${anhMauHienTai}" alt="Ảnh màu ${chiTietForm.mauSac.ten}" style="width:80px;height:80px;object-fit:cover;border-radius:10px;border:1px solid #ddd"></div></c:if><input class="form-control" type="file" name="anhMauFile" accept="image/jpeg,image/png,image/webp"><div class="form-text">${empty anhMauHienTai ? 'Chưa có ảnh riêng cho màu này, đang dùng ảnh bìa sản phẩm.' : 'Để trống nếu giữ nguyên ảnh hiện tại.'}</div></div><div class="col-12 d-flex justify-content-end gap-2"><a class="btn btn-outline-secondary" href="${pageContext.request.contextPath}/san-pham/chi-tiet/hien-thi?idSanPham=${chiTietForm.sanPham.id}">Hủy</a><button class="btn btn-primary"><i class="bi bi-check2-circle me-1"></i>Cập nhật</button></div></form></div></section>

    <!-- Popup chọn nhanh số lượng tồn / giá nhập / giá bán -->
    <div class="quick-pick" id="quickPick" style="position:fixed;z-index:1080;width:260px;padding:12px;border:1px solid #dedede;border-radius:12px;background:#fff;box-shadow:0 12px 32px rgba(15,23,42,.16);display:none">
        <div style="font-size:11.5px;font-weight:800;color:#686868;text-transform:uppercase;letter-spacing:.03em;margin-bottom:8px" id="quickPickTitle">Chọn nhanh</div>
        <div style="display:grid;grid-template-columns:1fr 1fr;gap:6px" id="quickPickGrid"></div>
        <div style="display:flex;align-items:center;justify-content:space-between;gap:8px;margin-top:10px;padding-top:10px;border-top:1px solid #eee">
            <span style="font-size:11px;color:#9a9a9a">Hoặc tự nhập giá trị khác vào ô</span>
            <button type="button" id="quickPickClose" style="border:0;background:transparent;font-size:12px;font-weight:700;color:#686868;cursor:pointer;padding:2px 6px">Đóng</button>
        </div>
    </div>
    <style>.quick-pick__btn{border:1px solid #dedede;border-radius:9px;background:#f8f8f8;padding:8px 6px;font-size:12.5px;font-weight:700;color:#111111;cursor:pointer;text-align:center;transition:.15s}.quick-pick__btn:hover{background:#111111;color:#fff;border-color:#111111}</style>
    <script>
        (function () {
            'use strict';

            var CONFIGS = {
                stock: { title: 'Chọn số lượng tồn', presets: [10, 20, 50, 100, 200], format: function (v) { return v.toLocaleString('vi-VN') + ' cái'; } },
                import: { title: 'Chọn giá nhập đặc biệt', presets: [50000, 100000, 150000, 200000, 300000], format: function (v) { return v.toLocaleString('vi-VN') + ' đ'; } },
                price: { title: 'Chọn giá bán đặc biệt', presets: [99000, 149000, 199000, 249000, 299000], format: function (v) { return v.toLocaleString('vi-VN') + ' đ'; } }
            };

            var picker = document.getElementById('quickPick');
            var grid = document.getElementById('quickPickGrid');
            var title = document.getElementById('quickPickTitle');
            var closeBtn = document.getElementById('quickPickClose');
            var active = null;

            if (!picker || !grid) { return; }

            function close() { picker.style.display = 'none'; active = null; }

            function open(input) {
                var kind = input.getAttribute('data-picker');
                var config = CONFIGS[kind];
                if (!config) { return; }

                active = input;
                title.textContent = config.title;
                grid.innerHTML = '';

                config.presets.forEach(function (value) {
                    var btn = document.createElement('button');
                    btn.type = 'button';
                    btn.className = 'quick-pick__btn';
                    btn.textContent = config.format(value);
                    btn.setAttribute('data-value', String(value));
                    grid.appendChild(btn);
                });

                var rect = input.getBoundingClientRect();
                picker.style.left = Math.max(12, rect.left) + 'px';
                picker.style.top = (rect.bottom + 6) + 'px';
                picker.style.display = 'block';
            }

            document.addEventListener('focusin', function (event) {
                if (event.target && event.target.classList && event.target.classList.contains('quick-pick-input')) {
                    open(event.target);
                } else if (!picker.contains(event.target)) {
                    close();
                }
            });

            grid.addEventListener('mousedown', function (event) {
                var btn = event.target.closest('.quick-pick__btn');
                if (!btn || !active) { return; }
                event.preventDefault();
                active.value = btn.getAttribute('data-value');
                active.dispatchEvent(new Event('input', { bubbles: true }));
                close();
            });

            if (closeBtn) {
                closeBtn.addEventListener('mousedown', function (event) { event.preventDefault(); close(); });
            }

            document.addEventListener('mousedown', function (event) {
                if (picker.style.display === 'block' && !picker.contains(event.target) && event.target !== active) {
                    close();
                }
            });

            document.addEventListener('keydown', function (event) {
                if (event.key === 'Escape') { close(); }
            });
        }());
    </script>
</main>
<%@ include file="/views/layout/footer.jsp" %></body></html>
