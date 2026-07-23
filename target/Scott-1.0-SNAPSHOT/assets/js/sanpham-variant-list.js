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
}());
