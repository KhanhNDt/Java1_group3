(function () {
    'use strict';

    var form = document.getElementById('productCreateForm');
    var area = document.getElementById('variantArea');
    var groups = document.getElementById('variantGroups');

    if (!form || !area || !groups) {
        return;
    }

    function getSelected(selector) {
        var checked = document.querySelectorAll(selector + ':checked');
        var result = [];
        var i;

        for (i = 0; i < checked.length; i++) {
            result.push({
                id: checked[i].value,
                name: checked[i].getAttribute('data-name') || ''
            });
        }

        return result;
    }

    function escapeHtml(value) {
        return String(value == null ? '' : value).replace(
            /[&<>'"]/g,
            function (character) {
                var entities = {
                    '&': '&amp;',
                    '<': '&lt;',
                    '>': '&gt;',
                    "'": '&#39;',
                    '"': '&quot;'
                };

                return entities[character];
            }
        );
    }

    function createVariantRow(color, size) {
        return '<tr class="variant-row">' +
            '<td class="size-cell">' +
            escapeHtml(size.name) +
            '<input type="hidden" name="variantMauSac" value="' +
            escapeHtml(color.id) +
            '">' +
            '<input type="hidden" name="variantSize" value="' +
            escapeHtml(size.id) +
            '">' +
            '</td>' +
            '<td>' +
            '<input class="form-control ma-input" ' +
            'type="text" maxlength="50" ' +
            'name="variantMa" placeholder="Để trống = tự động">' +
            '</td>' +
            '<td>' +
            '<input class="form-control stock-input" ' +
            'type="number" min="0" step="1" ' +
            'name="variantSoLuongTon" value="10" required>' +
            '</td>' +
            '<td>' +
            '<input class="form-control import-input" ' +
            'type="number" min="0" step="1000" ' +
            'name="variantGiaNhap" value="0" required>' +
            '</td>' +
            '<td>' +
            '<input class="form-control price-input" ' +
            'type="number" min="0" step="1000" ' +
            'name="variantGiaBan" value="0" required>' +
            '</td>' +
            '<td>' +
            '<button type="button" ' +
            'class="btn btn-sm btn-outline-danger remove-row" ' +
            'title="Xóa biến thể">' +
            '<i class="bi bi-x-lg"></i>' +
            '</button>' +
            '</td>' +
            '</tr>';
    }

    function buildVariants() {
        var colors = getSelected('.color-option');
        var sizes = getSelected('.size-option');
        var colorIndex;
        var sizeIndex;

        if (colors.length === 0 || sizes.length === 0) {
            alert(
                'Hãy chọn ít nhất một màu sắc và một kích thước.'
            );
            return false;
        }

        if (colors.length * sizes.length > 100) {
            alert(
                'Mỗi lần chỉ được tạo tối đa 100 biến thể.'
            );
            return false;
        }

        groups.innerHTML = '';

        for (
            colorIndex = 0;
            colorIndex < colors.length;
            colorIndex++
        ) {
            var color = colors[colorIndex];
            var section = document.createElement('section');
            var variantRows = '';

            for (
                sizeIndex = 0;
                sizeIndex < sizes.length;
                sizeIndex++
            ) {
                variantRows += createVariantRow(
                    color,
                    sizes[sizeIndex]
                );
            }

            section.className = 'variant-group';

            section.innerHTML =
                '<div class="variant-group__head">' +
                '<strong>' +
                '<span class="color-dot d-inline-block me-2"></span>' +
                escapeHtml(color.name) +
                ' <small class="text-secondary">' +
                '(' + sizes.length + ' kích cỡ)' +
                '</small>' +
                '</strong>' +

                '<div class="d-flex align-items-center gap-2 flex-wrap">' +
                '<label class="d-flex align-items-center gap-2 mb-0" style="font-weight:600;font-size:12px;">' +
                '<i class="bi bi-image"></i>Ảnh riêng cho màu này' +
                '<input type="file" class="form-control form-control-sm color-image-input" ' +
                'style="max-width:220px;display:inline-block;" ' +
                'name="anhMau_' + escapeHtml(color.id) + '" ' +
                'accept="image/jpeg,image/png,image/webp">' +
                '</label>' +
                '<button type="button" ' +
                'class="btn btn-sm btn-primary apply-group">' +
                '<i class="bi bi-lightning me-1"></i>' +
                'Áp dụng nhóm' +
                '</button>' +
                '</div>' +
                '</div>' +

                '<table class="variant-table">' +
                '<thead>' +
                '<tr>' +
                '<th>Kích cỡ</th>' +
                '<th>Mã biến thể</th>' +
                '<th>Số lượng tồn</th>' +
                '<th>Giá nhập</th>' +
                '<th>Đơn giá</th>' +
                '<th></th>' +
                '</tr>' +
                '</thead>' +

                '<tbody>' +
                variantRows +
                '</tbody>' +
                '</table>';

            groups.appendChild(section);
        }

        area.classList.add('show');
        return true;
    }

    function applyValues(
        scope,
        stock,
        importPrice,
        salePrice
    ) {
        var stockInputs =
            scope.querySelectorAll('.stock-input');

        var importInputs =
            scope.querySelectorAll('.import-input');

        var saleInputs =
            scope.querySelectorAll('.price-input');

        var i;

        for (i = 0; i < stockInputs.length; i++) {
            stockInputs[i].value = stock;
        }

        for (i = 0; i < importInputs.length; i++) {
            importInputs[i].value = importPrice;
        }

        for (i = 0; i < saleInputs.length; i++) {
            saleInputs[i].value = salePrice;
        }
    }

    var generateButton =
        document.getElementById('generateVariants');

    var clearButton =
        document.getElementById('clearVariants');

    var openBulkButton =
        document.getElementById('openBulk');

    var applyBulkButton =
        document.getElementById('applyBulk');

    if (generateButton) {
        generateButton.addEventListener(
            'click',
            function () {
                buildVariants();
            }
        );
    }

    if (clearButton) {
        clearButton.addEventListener(
            'click',
            function () {
                groups.innerHTML = '';
                area.classList.remove('show');
            }
        );
    }

    if (openBulkButton) {
        openBulkButton.addEventListener(
            'click',
            function () {
                var bulkPanel =
                    document.getElementById('bulkPanel');

                if (bulkPanel) {
                    bulkPanel.classList.toggle('show');
                }
            }
        );
    }

    if (applyBulkButton) {
        applyBulkButton.addEventListener(
            'click',
            function () {
                var bulkStock =
                    document.getElementById('bulkStock');

                var bulkImport =
                    document.getElementById('bulkImport');

                var bulkPrice =
                    document.getElementById('bulkPrice');

                if (
                    !bulkStock ||
                    !bulkImport ||
                    !bulkPrice
                ) {
                    return;
                }

                applyValues(
                    groups,
                    bulkStock.value,
                    bulkImport.value,
                    bulkPrice.value
                );
            }
        );
    }

    groups.addEventListener(
        'click',
        function (event) {
            var removeButton =
                event.target.closest('.remove-row');

            var applyButton;

            if (removeButton) {
                var row = removeButton.closest('tr');

                if (row) {
                    row.remove();
                }

                if (
                    groups.querySelectorAll('.variant-row')
                        .length === 0
                ) {
                    area.classList.remove('show');
                }

                return;
            }

            applyButton =
                event.target.closest('.apply-group');

            if (applyButton) {
                var section =
                    applyButton.closest('.variant-group');

                var stock = prompt(
                    'Số lượng tồn áp dụng cho nhóm:',
                    '10'
                );

                var importPrice;
                var salePrice;

                if (stock === null) {
                    return;
                }

                importPrice = prompt(
                    'Giá nhập áp dụng cho nhóm:',
                    '0'
                );

                if (importPrice === null) {
                    return;
                }

                salePrice = prompt(
                    'Giá bán áp dụng cho nhóm:',
                    '0'
                );

                if (salePrice === null) {
                    return;
                }

                applyValues(
                    section,
                    stock,
                    importPrice,
                    salePrice
                );
            }
        }
    );

    form.addEventListener(
        'submit',
        function (event) {
            var rows;
            var message = '';
            var i;

            form.classList.add('was-validated');

            if (!form.checkValidity()) {
                var invalid =
                    form.querySelector(':invalid');

                event.preventDefault();
                event.stopPropagation();

                if (invalid) {
                    invalid.reportValidity();

                    invalid.scrollIntoView({
                        behavior: 'smooth',
                        block: 'center'
                    });
                }

                return;
            }

            rows =
                groups.querySelectorAll('.variant-row');

            if (rows.length === 0) {
                buildVariants();

                rows =
                    groups.querySelectorAll(
                        '.variant-row'
                    );
            }

            if (rows.length === 0) {
                event.preventDefault();

                alert(
                    'Hãy chọn màu sắc và kích thước để tạo ít nhất một biến thể.'
                );

                return;
            }

            for (i = 0; i < rows.length; i++) {
                var stockInput =
                    rows[i].querySelector(
                        '.stock-input'
                    );

                var importInput =
                    rows[i].querySelector(
                        '.import-input'
                    );

                var saleInput =
                    rows[i].querySelector(
                        '.price-input'
                    );

                var stock =
                    Number(stockInput.value);

                var importPrice =
                    Number(importInput.value);

                var salePrice =
                    Number(saleInput.value);

                if (
                    !Number.isFinite(stock) ||
                    stock < 0 ||
                    !Number.isInteger(stock)
                ) {
                    message =
                        'Số lượng tồn ở dòng ' +
                        (i + 1) +
                        ' phải là số nguyên không âm.';

                    break;
                }

                if (
                    !Number.isFinite(importPrice) ||
                    importPrice < 0
                ) {
                    message =
                        'Giá nhập ở dòng ' +
                        (i + 1) +
                        ' không hợp lệ.';

                    break;
                }

                if (
                    !Number.isFinite(salePrice) ||
                    salePrice < 0
                ) {
                    message =
                        'Giá bán ở dòng ' +
                        (i + 1) +
                        ' không hợp lệ.';

                    break;
                }

                if (salePrice < importPrice) {
                    message =
                        'Giá bán ở dòng ' +
                        (i + 1) +
                        ' phải lớn hơn hoặc bằng giá nhập.';

                    break;
                }
            }

            if (message) {
                event.preventDefault();
                alert(message);
                return;
            }

            var submitButton =
                form.querySelector('.submit-product');

            if (submitButton) {
                submitButton.disabled = true;

                submitButton.innerHTML =
                    '<span class="spinner-border ' +
                    'spinner-border-sm me-2"></span>' +
                    'Đang lưu sản phẩm...';
            }
        }
    );

    window.addEventListener(
        'pageshow',
        function () {
            var submitButton =
                form.querySelector('.submit-product');

            if (submitButton) {
                submitButton.disabled = false;

                submitButton.innerHTML =
                    '<i class="bi bi-check2-circle me-1"></i>' +
                    'Hoàn tất';
            }
        }
    );
}());