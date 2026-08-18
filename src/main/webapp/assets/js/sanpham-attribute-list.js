(function () {
    'use strict';

    var form = document.getElementById('variantLiveFilterForm');
    var keyword = document.getElementById('variantKeyword');
    var maxPrice = document.getElementById('variantMaxPrice');
    var resetButton = document.getElementById('resetVariantFilter');
    var modalElement = document.getElementById('variantConfirmModal');
    var confirmButton = document.getElementById('variantConfirmButton');
    var confirmText = document.getElementById('variantConfirmText');
    var timer = null;
    var controller = null;
    var pendingToggle = null;
    var modal = modalElement && window.bootstrap ? new bootstrap.Modal(modalElement) : null;

    if (!form) return;

    function resultArea() {
        return document.getElementById('variantResults');
    }

    function buildUrl(page) {
        var params = new URLSearchParams(new FormData(form));
        params.set('page', page || '1');
        return form.action + '?' + params.toString();
    }

    function loadResults(url, updateHistory) {
        var current = resultArea();
        if (!current) return Promise.resolve();

        if (controller) controller.abort();
        controller = new AbortController();
        current.classList.add('is-loading');

        return fetch(url, {
            headers: {'X-Requested-With': 'XMLHttpRequest'},
            signal: controller.signal
        }).then(function (response) {
            if (!response.ok) throw new Error('Không thể tải dữ liệu biến thể.');
            return response.text();
        }).then(function (html) {
            var doc = new DOMParser().parseFromString(html, 'text/html');
            var next = doc.getElementById('variantResults');
            if (!next) throw new Error('Không tìm thấy vùng kết quả biến thể.');
            current.replaceWith(next);
            if (updateHistory !== false) history.replaceState({}, '', url);
        }).catch(function (error) {
            if (error.name !== 'AbortError') {
                var area = resultArea();
                if (area) area.classList.remove('is-loading');
                alert(error.message || 'Lọc biến thể thất bại.');
            }
        });
    }

    function scheduleFilter() {
        clearTimeout(timer);
        timer = setTimeout(function () {
            loadResults(buildUrl('1'));
        }, 350);
    }

    if (keyword) keyword.addEventListener('input', scheduleFilter);
    if (maxPrice) maxPrice.addEventListener('input', scheduleFilter);

    form.querySelectorAll('select,input[type="radio"]').forEach(function (element) {
        element.addEventListener('change', function () {
            loadResults(buildUrl('1'));
        });
    });

    form.addEventListener('submit', function (event) {
        event.preventDefault();
        loadResults(buildUrl('1'));
    });

    if (resetButton) {
        resetButton.addEventListener('click', function () {
            if (keyword) keyword.value = '';
            if (maxPrice) maxPrice.value = '';
            ['idSanPham', 'idMauSac', 'idSize', 'tonKho'].forEach(function (name) {
                var field = form.querySelector('[name="' + name + '"]');
                if (field) field.value = '';
            });
            var allStatus = form.querySelector('[name="trangThai"][value=""]');
            if (allStatus) allStatus.checked = true;
            form.querySelector('[name="page"]').value = '1';
            loadResults(buildUrl('1'));
        });
    }

    document.addEventListener('click', function (event) {
        var pageLink = event.target.closest('#variantResults .pagination a.page-link');
        if (pageLink) {
            event.preventDefault();
            if (!pageLink.closest('.page-item.disabled')) loadResults(pageLink.href);
        }
    });

    document.addEventListener('change', function (event) {
        var pageSize = event.target.closest('#variantResults select[data-page-size]');
        var toggle;

        if (pageSize) {
            form.querySelector('[name="size"]').value = pageSize.value;
            loadResults(buildUrl('1'));
            return;
        }

        toggle = event.target.closest('#variantResults .variant-switch');
        if (!toggle) return;

        pendingToggle = toggle;
        pendingToggle.dataset.requestedState = toggle.checked ? '1' : '0';
        if (confirmText) {
            confirmText.innerHTML = 'Bạn có chắc muốn đổi trạng thái biến thể thành <strong>' +
                (toggle.checked ? 'Còn bán' : 'Ngừng bán') + '</strong> không?';
        }
        toggle.checked = !toggle.checked;
        if (modal) modal.show();
    });

    if (confirmButton) {
        confirmButton.addEventListener('click', function () {
            if (!pendingToggle) return;

            var element = pendingToggle;
            var originalHtml = confirmButton.innerHTML;
            confirmButton.disabled = true;
            confirmButton.innerHTML = '<span class="spinner-border spinner-border-sm me-1"></span>Đang lưu';

            fetch(form.action.replace('/chi-tiet/hien-thi', '/chi-tiet/toggle-trang-thai') +
                '?id=' + encodeURIComponent(element.dataset.id), {
                method: 'POST',
                headers: {'X-Requested-With': 'XMLHttpRequest'}
            }).then(function (response) {
                return response.json();
            }).then(function (data) {
                if (!data.success) throw new Error(data.message);
                element.checked = data.trangThai === 1;
                var label = document.getElementById('variant-label-' + element.dataset.id);
                if (label) {
                    label.textContent = data.message;
                    label.className = 'status-pill ' + (data.trangThai === 1 ? 'on' : 'off');
                }
                if (modal) modal.hide();
                pendingToggle = null;

                var selectedStatus = form.querySelector('[name="trangThai"]:checked');
                if (selectedStatus && selectedStatus.value !== '') {
                    loadResults(buildUrl('1'));
                }
            }).catch(function (error) {
                alert(error.message || 'Không thể đổi trạng thái biến thể.');
            }).finally(function () {
                confirmButton.disabled = false;
                confirmButton.innerHTML = originalHtml;
            });
        });
    }

    if (modalElement) {
        modalElement.addEventListener('hidden.bs.modal', function () {
            pendingToggle = null;
        });
    }

    // Mở sẵn modal "Thêm biến thể mới" khi đến trang từ link có #addVariantModal
    // (ví dụ nút "Thêm biến thể mới" ở từng dòng sản phẩm trong Danh sách sản phẩm).
    if (window.location.hash === '#addVariantModal') {
        var addVariantEl = document.getElementById('addVariantModal');
        if (addVariantEl && window.bootstrap) {
            new bootstrap.Modal(addVariantEl).show();
        }
    }

    // ================= MA TRẬN MÀU x SIZE trong modal "Thêm biến thể mới" =================
    // Khi chọn 1 sản phẩm, gọi API lấy toàn bộ tổ hợp màu+size ĐÃ CÓ của sản phẩm đó rồi
    // dựng 1 bảng: hàng = màu, cột = size. Ô nào đã tồn tại (hoặc màu/size đang ngừng hoạt
    // động) sẽ bị khóa + tô xám ngay trên giao diện — không cho bấm chọn từ đầu, thay vì
    // chỉ báo lỗi sau khi bấm Lưu. Nếu 1 màu đã dùng hết toàn bộ size đang hoạt động thì cả
    // hàng màu đó cũng bị khóa/tô xám.
    (function () {
        var modalEl = document.getElementById('addVariantModal');
        if (!modalEl) return;
        var productSelect = modalEl.querySelector('select[name="idSanPham"]');
        var container = document.getElementById('variantMatrixContainer');
        var selectAllBtn = document.getElementById('matrixSelectAll');
        var matrixController = null;

        function escapeHtml(text) {
            var div = document.createElement('div');
            div.textContent = text == null ? '' : String(text);
            return div.innerHTML;
        }

        function renderEmpty(message) {
            container.innerHTML = '<div class="text-secondary small py-3 text-center" id="matrixEmptyHint"><i class="bi bi-info-circle me-1"></i>' + escapeHtml(message) + '</div>';
        }

        function renderMatrix(data) {
            var mauSac = data.mauSac || [];
            var size = data.size || [];
            var existing = {};
            (data.existing || []).forEach(function (key) { existing[key] = true; });

            if (mauSac.length === 0 || size.length === 0) {
                renderEmpty('Chưa có màu sắc hoặc kích thước nào trong hệ thống.');
                return;
            }

            var html = '<table class="variant-matrix"><thead><tr><th>Màu \\ Size</th>';
            size.forEach(function (s) {
                html += '<th' + (s.active ? '' : ' title="Size đang ngừng hoạt động"') + '>' + escapeHtml(s.ten) + '</th>';
            });
            html += '</tr></thead><tbody>';

            mauSac.forEach(function (m) {
                var rowHasFreeCell = false;
                var rowCells = '';
                size.forEach(function (s) {
                    var key = m.id + '-' + s.id;
                    var taken = !!existing[key];
                    var inactive = !m.active || !s.active;
                    var disabled = taken || inactive;
                    if (!disabled) rowHasFreeCell = true;
                    var cellClass = taken ? 'taken' : (inactive ? 'inactive' : '');
                    var title = taken ? 'Đã có biến thể này' : (inactive ? 'Màu hoặc size đang ngừng hoạt động' : (m.ten + ' - ' + s.ten));
                    rowCells += '<td><label class="matrix-cell ' + cellClass + '" title="' + escapeHtml(title) + '">' +
                        '<input type="checkbox" name="combo" value="' + key + '"' + (disabled ? ' disabled' : '') + '>' +
                        '<span></span></label></td>';
                });
                html += '<tr class="' + (rowHasFreeCell ? '' : 'row-full') + '"><th' + (m.active ? '' : ' title="Màu đang ngừng hoạt động"') + '>' + escapeHtml(m.ten) + '</th>' + rowCells + '</tr>';
            });

            html += '</tbody></table>';
            container.innerHTML = html;
        }

        function loadMatrix(idSanPham) {
            if (!idSanPham) {
                renderEmpty('Chọn sản phẩm ở trên để hiển thị bảng màu × size.');
                return;
            }
            renderEmpty('Đang tải bảng màu × size...');
            if (matrixController) matrixController.abort();
            matrixController = new AbortController();
            var url = form.action.replace('/chi-tiet/hien-thi', '/chi-tiet/ma-tran') + '?idSanPham=' + encodeURIComponent(idSanPham);
            fetch(url, {headers: {'X-Requested-With': 'XMLHttpRequest'}, signal: matrixController.signal})
                .then(function (response) { return response.json(); })
                .then(function (data) {
                    if (!data.success) throw new Error(data.message || 'Không tải được bảng biến thể.');
                    renderMatrix(data);
                }).catch(function (error) {
                if (error.name !== 'AbortError') {
                    renderEmpty(error.message || 'Không tải được bảng biến thể.');
                }
            });
        }

        if (productSelect) {
            productSelect.addEventListener('change', function () {
                loadMatrix(productSelect.value);
            });
        }

        modalEl.addEventListener('shown.bs.modal', function () {
            if (productSelect && productSelect.value) loadMatrix(productSelect.value);
        });

        if (selectAllBtn) {
            selectAllBtn.addEventListener('click', function () {
                var boxes = container.querySelectorAll('input[type="checkbox"]:not(:disabled)');
                if (boxes.length === 0) return;
                var allChecked = Array.prototype.every.call(boxes, function (cb) { return cb.checked; });
                boxes.forEach(function (cb) { cb.checked = !allChecked; });
            });
        }

        var addVariantForm = modalEl.querySelector('form');
        if (addVariantForm) {
            addVariantForm.addEventListener('submit', function (event) {
                var checked = container.querySelectorAll('input[name="combo"]:checked');
                if (checked.length === 0) {
                    event.preventDefault();
                    // Dùng \uXXXX (Unicode escape) thay vì gõ trực tiếp chữ có dấu:
                    // các ký tự này chỉ là ASCII thuần nên khi trình duyệt tải file
                    // .js này (Content-Type không kèm charset), JS engine vẫn luôn
                    // hiểu đúng và hiển thị đúng tiếng Việt, không phụ thuộc vào việc
                    // server có gắn đúng charset=UTF-8 hay không -> tránh lỗi font
                    // "Vui lÃ²ng chá» n..." mà không cần đụng tới cấu hình web.xml.
                    alert('Vui l\u00f2ng ch\u1ecdn \u00edt nh\u1ea5t 1 \u00f4 m\u00e0u \u00d7 size c\u00f2n tr\u1ed1ng trong b\u1ea3ng.');
                }
            });
        }
    }());
}());
