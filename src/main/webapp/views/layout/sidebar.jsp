<%@ page contentType="text/html;charset=UTF-8" language="java" %>

<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
<link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.css" rel="stylesheet">

<style>

    *{
        margin:0;
        padding:0;
        box-sizing:border-box;
        font-family:'Segoe UI',sans-serif;
    }

    body{
        background:#f4f7fe;
    }

    .sidebar{

        position:fixed;

        left:0;

        top:0;

        width:260px;

        height:100vh;

        background:#5E35B1;

        color:white;

        overflow:auto;

    }

    .logo{

        text-align:center;

        padding:30px 20px;

    }

    .logo h2{

        font-weight:bold;

        letter-spacing:2px;

    }

    .logo span{

        color:#FFD54F;

    }

    .menu{

        padding:10px;

    }

    .menu a{

        display:flex;

        align-items:center;

        text-decoration:none;

        color:white;

        padding:14px 18px;

        margin-bottom:8px;

        border-radius:12px;

        transition:.3s;

    }

    .menu a i{

        font-size:20px;

        margin-right:15px;

    }

    .menu a:hover{

        background:white;

        color:#5E35B1;

    }

    .menu .active{

        background:white;

        color:#5E35B1;

    }

    .bottom{

        position:absolute;

        bottom:20px;

        width:100%;

        padding:0 10px;

    }

    .bottom a{

        display:flex;

        align-items:center;

        color:white;

        text-decoration:none;

        padding:14px 18px;

        border-radius:12px;

    }

    .bottom a:hover{

        background:#7E57C2;

    }

</style>

<div class="sidebar">

    <div class="logo">

        <h2>Scott<span>.</span></h2>

    </div>

    <div class="menu">

        <a href="/dashboard" class="active">

            <i class="bi bi-grid-fill"></i>

            Dashboard

        </a>

        <a href="#">

            <i class="bi bi-bar-chart-fill"></i>

            Bảng xếp hạng

        </a>

        <a href="/hoa-don">

            <i class="bi bi-cart-fill"></i>

            Đơn hàng

        </a>

        <a href="/san-pham">

            <i class="bi bi-bag-fill"></i>

            Sản phẩm

        </a>

        <a href="#">

            <i class="bi bi-graph-up-arrow"></i>

            Báo cáo

        </a>

        <a href="#">

            <i class="bi bi-chat-left-text-fill"></i>

            Tin nhắn

        </a>

        <a href="#">

            <i class="bi bi-gear-fill"></i>

            Cài đặt

        </a>

    </div>

    <div class="bottom">

        <a href="/logout">

            <i class="bi bi-box-arrow-right"></i>

            Đăng xuất

        </a>

    </div>

</div>