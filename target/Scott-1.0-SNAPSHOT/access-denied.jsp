<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <%@ include file="/views/layout/head.jsp" %>
    <title>Không có quyền truy cập</title>
</head>
<body>
<%@ include file="/views/layout/sidebar.jsp" %>
<main class="main-content">
    <div class="d-flex flex-column align-items-center justify-content-center text-center"
         style="min-height:60vh;">
        <i class="bi bi-shield-lock" style="font-size:64px;color:#dc3545;"></i>
        <h2 class="fw-bold mt-3 mb-2">Bạn là nhân viên </h2>
        <p class="text-secondary mb-4">
            ${not empty error ? error : 'Bạn không có quyền truy cập chức năng này.'}
        </p>
        <a href="${pageContext.request.contextPath}/quanlyhoadon" class="btn btn-dark rounded-pill px-4">
            Quay lại trang chủ
        </a>
    </div>
</main>
<%@ include file="/views/layout/footer.jsp" %>
</body>
</html>
