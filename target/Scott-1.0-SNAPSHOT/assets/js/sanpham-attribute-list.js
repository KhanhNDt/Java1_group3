(function () {
    'use strict';

    var form = document.getElementById('attributeLiveFilterForm');
    var keyword = document.getElementById('attributeKeyword');
    var resetButton = document.getElementById('resetAttributeFilter');
    var timer = null;
    var controller = null;

    if (!form) return;

    function results() {
        return document.getElementById('attributeResults');
    }

    function buildUrl(page) {
        var params = new URLSearchParams(new FormData(form));
        params.set('page', page || '1');
        return form.action + '?' + params.toString();
    }

    function loadResults(url) {
        var current = results();
        if (!current) return;

        if (controller) controller.abort();
        controller = new AbortController();
        current.classList.add('is-loading');

        fetch(url, {
            headers: {'X-Requested-With': 'XMLHttpRequest'},
            signal: controller.signal
        }).then(function (response) {
            if (!response.ok) throw new Error('Không thể tải danh sách thuộc tính.');
            return response.text();
        }).then(function (html) {
            var doc = new DOMParser().parseFromString(html, 'text/html');
            var next = doc.getElementById('attributeResults');
            if (!next) throw new Error('Không tìm thấy vùng kết quả thuộc tính.');
            current.replaceWith(next);

            var total = document.getElementById('attributeTotalCount');
            if (total) total.textContent = 'Tổng ' + (next.getAttribute('data-total') || '0') + ' bản ghi';
            history.replaceState({}, '', url);
        }).catch(function (error) {
            if (error.name !== 'AbortError') {
                var area = results();
                if (area) area.classList.remove('is-loading');
                alert(error.message || 'Lọc thuộc tính thất bại.');
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

    form.addEventListener('submit', function (event) {
        event.preventDefault();
        loadResults(buildUrl('1'));
    });

    if (resetButton) {
        resetButton.addEventListener('click', function () {
            if (keyword) keyword.value = '';
            form.querySelector('[name="page"]').value = '1';
            loadResults(buildUrl('1'));
        });
    }

    document.addEventListener('click', function (event) {
        var link = event.target.closest('#attributeResults [data-page-link]');
        if (!link) return;
        event.preventDefault();
        if (!link.classList.contains('disabled')) loadResults(link.href);
    });

    document.addEventListener('change', function (event) {
        var select = event.target.closest('#attributeResults select[data-page-size]');
        if (!select) return;
        form.querySelector('[name="size"]').value = select.value;
        loadResults(buildUrl('1'));
    });
}());
