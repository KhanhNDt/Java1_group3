(function () {
    'use strict';

    if (window.__scottAdminMainLoaded) return;
    window.__scottAdminMainLoaded = true;

    var STORAGE_KEY = 'scottAdminSidebarCollapsed';
    var PRODUCT_MENU_KEY = 'scottAdminProductMenuOpen';

    function getStoredBoolean(key, fallback) {
        try {
            var value = window.localStorage.getItem(key);
            return value === null ? fallback : value === 'true';
        } catch (e) {
            return fallback;
        }
    }

    function storeBoolean(key, value) {
        try {
            window.localStorage.setItem(key, String(value));
        } catch (e) {
            // localStorage may be blocked; the interface still works for the current page.
        }
    }

    function setCollapsed(collapsed) {
        document.body.classList.toggle('admin-sidebar-collapsed', collapsed);
        var toggle = document.getElementById('adminSidebarToggle');
        if (toggle) {
            toggle.setAttribute('aria-expanded', String(!collapsed));
            toggle.setAttribute('title', collapsed ? 'Mở rộng thanh menu' : 'Thu gọn thanh menu');
        }
        storeBoolean(STORAGE_KEY, collapsed);
    }

    function setProductMenuOpen(group, open) {
        if (!group) return;
        group.classList.toggle('open', open);
        var button = group.querySelector('[data-sidebar-submenu-toggle]');
        if (button) button.setAttribute('aria-expanded', String(open));
        storeBoolean(PRODUCT_MENU_KEY, open);
    }

    function initializeSidebar() {
        var sidebar = document.getElementById('adminSidebar');
        if (!sidebar) return;

        var collapsed = getStoredBoolean(STORAGE_KEY, false);
        setCollapsed(collapsed);

        var toggle = document.getElementById('adminSidebarToggle');
        if (toggle) {
            toggle.addEventListener('click', function () {
                setCollapsed(!document.body.classList.contains('admin-sidebar-collapsed'));
            });
        }

        var productGroup = document.getElementById('adminProductMenu');
        var productToggle = productGroup ? productGroup.querySelector('[data-sidebar-submenu-toggle]') : null;
        if (productGroup && productToggle) {
            var isActive = productGroup.getAttribute('data-active') === 'true';
            setProductMenuOpen(productGroup, isActive || getStoredBoolean(PRODUCT_MENU_KEY, false));

            productToggle.addEventListener('click', function () {
                if (document.body.classList.contains('admin-sidebar-collapsed')) {
                    setCollapsed(false);
                    setProductMenuOpen(productGroup, true);
                    return;
                }
                setProductMenuOpen(productGroup, !productGroup.classList.contains('open'));
            });
        }

        sidebar.querySelectorAll('[data-sidebar-tooltip]').forEach(function (item) {
            item.addEventListener('mouseenter', function () {
                if (document.body.classList.contains('admin-sidebar-collapsed')) {
                    item.setAttribute('title', item.getAttribute('data-sidebar-tooltip'));
                } else {
                    item.removeAttribute('title');
                }
            });
        });
    }

    function enhanceTables() {
        document.querySelectorAll('.main-content table.table').forEach(function (table) {
            if (!table.closest('.table-responsive')) {
                var wrapper = document.createElement('div');
                wrapper.className = 'table-responsive';
                table.parentNode.insertBefore(wrapper, table);
                wrapper.appendChild(table);
            }
        });
    }

    function enhancePageHeadings() {
        var main = document.querySelector('.main-content');
        if (!main || main.querySelector('.page-heading')) return;
        var heading = main.querySelector(':scope > h1:first-child, :scope > h2:first-child, :scope > h3:first-child');
        if (heading) heading.classList.add('mb-4');
    }

    function initialize() {
        initializeSidebar();
        enhanceTables();
        enhancePageHeadings();
    }

    if (document.readyState === 'loading') {
        document.addEventListener('DOMContentLoaded', initialize);
    } else {
        initialize();
    }
})();
