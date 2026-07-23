<%--
    Trang chào (welcome file). Truoc day web.xml khong khai bao welcome-file-list
    nen khi mo dung URL goc cua app (vi du http://localhost:8080/Scott_war_exploded/)
    Tomcat khong biet phai hien thi trang nao -> tra ve 404, tao cam giac "app khong load duoc".
    Trang nay chi lam 1 viec: chuyen huong ngay sang Dashboard.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<% response.sendRedirect(request.getContextPath() + "/dashboard"); %>
