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

    // =========================================================
    // LOAD MA TRẬN MÀU × SIZE KHI THÊM BIẾN THỂ
    // =========================================================
    var addModal = document.getElementById('addVariantModal');
    var matrix = document.getElementById('variantMatrixContainer');
    var selectAll = document.getElementById('matrixSelectAll');

    if (addModal && matrix) {
        var addForm = addModal.querySelector('form');
        var productSelect = addModal.querySelector('select[name="idSanPham"]');

        function loadMatrix(idSanPham) {
            if (!idSanPham) {
                matrix.innerHTML =
                    '<div class="text-secondary small py-4 text-center">' +
                    '<i class="bi bi-info-circle me-1"></i>' +
                    'Chọn sản phẩm ở trên để hiển thị bảng màu × size.' +
                    '</div>';
                return;
            }

            matrix.innerHTML =
                '<div class="text-secondary small py-4 text-center">' +
                '<span class="spinner-border spinner-border-sm me-1"></span>' +
                'Đang tải màu × size...' +
                '</div>';

            var url = addForm.action.replace(
                '/chi-tiet/add',
                '/chi-tiet/ma-tran'
            );

            fetch(url + '?idSanPham=' + encodeURIComponent(idSanPham), {
                headers: {
                    'X-Requested-With': 'XMLHttpRequest',
                    'Accept': 'application/json'
                }
            })
                .then(function (response) {
                    if (!response.ok) {
                        throw new Error('Không thể tải ma trận biến thể.');
                    }
                    return response.json();
                })
                .then(function (data) {
                    if (!data.success) {
                        throw new Error(data.message || 'Không thể tải dữ liệu.');
                    }

                    renderMatrix(data);
                })
                .catch(function (error) {
                    matrix.innerHTML =
                        '<div class="text-danger small py-4 text-center">' +
                        '<i class="bi bi-exclamation-circle me-1"></i>' +
                        error.message +
                        '</div>';
                });
        }

        function renderMatrix(data) {
            var mauSac = data.mauSac || [];
            var sizes = data.size || [];
            var existing = new Set((data.existing || []).map(String));

            if (mauSac.length === 0 || sizes.length === 0) {
                matrix.innerHTML =
                    '<div class="text-warning small py-4 text-center">' +
                    'Sản phẩm chưa có màu sắc hoặc kích thước.' +
                    '</div>';
                return;
            }

            var html = '<table class="variant-matrix">';
            html += '<thead><tr>';
            html += '<th>Màu / Size</th>';

            sizes.forEach(function (size) {
                html += '<th>' + size.ten + '</th>';
            });

            html += '</tr></thead><tbody>';

            mauSac.forEach(function (mau) {
                html += '<tr>';
                html += '<th>' + mau.ten + '</th>';

                sizes.forEach(function (size) {
                    var key = mau.id + '-' + size.id;
                    var daCo = existing.has(String(key));
                    var ngungHoatDong = !mau.active || !size.active;
                    var disabled = daCo || ngungHoatDong;

                    html += '<td>';
                    html += '<label class="matrix-cell' +
                        (daCo ? ' taken' : '') +
                        (ngungHoatDong ? ' inactive' : '') +
                        '">';

                    html += '<input type="checkbox" ' +
                        'name="combo" ' +
                        'value="' + key + '" ' +
                        (disabled ? 'disabled' : '') +
                        '>';

                    html += '<span></span>';
                    html += '</label>';
                    html += '</td>';
                });

                html += '</tr>';
            });

            html += '</tbody></table>';

            matrix.innerHTML = html;
        }

        // Chọn sản phẩm -> tải ma trận
        if (productSelect) {
            productSelect.addEventListener('change', function () {
                loadMatrix(this.value);
            });
        }

        // Mở modal mà sản phẩm đã được chọn sẵn
        addModal.addEventListener('shown.bs.modal', function () {
            if (productSelect && productSelect.value) {
                loadMatrix(productSelect.value);
            }
        });

        // Chọn tất cả ô chưa có biến thể
        if (selectAll) {
            selectAll.addEventListener('click', function () {
                var inputs = matrix.querySelectorAll(
                    'input[name="combo"]:not(:disabled)'
                );

                if (inputs.length === 0) {
                    return;
                }

                var allChecked = Array.from(inputs).every(function (input) {
                    return input.checked;
                });

                inputs.forEach(function (input) {
                    input.checked = !allChecked;
                });

                selectAll.textContent = allChecked
                    ? 'Chọn tất cả ô còn trống'
                    : 'Bỏ chọn tất cả';
            });
        }

        // Không cho submit nếu chưa chọn màu × size
        if (addForm) {
            addForm.addEventListener('submit', function (event) {
                var checked = addForm.querySelectorAll(
                    'input[name="combo"]:checked'
                );

                if (checked.length === 0) {
                    event.preventDefault();
                    alert('Vui lòng chọn ít nhất một màu × size.');
                }
            });
        }
    }

}());
