<%@ page contentType="text/html;charset=UTF-8" language="java" %>

<style>

    .main-content{
        margin-left:260px;
        padding:25px;
    }

    .header{
        height:80px;
        background:white;
        border-radius:18px;
        display:flex;
        justify-content:space-between;
        align-items:center;
        padding:0 30px;
        box-shadow:0 8px 25px rgba(0,0,0,.08);
    }

    .search-box{
        width:420px;
        position:relative;
    }

    .search-box i{
        position:absolute;
        top:14px;
        left:18px;
        color:#999;
    }

    .search-box input{
        width:100%;
        height:48px;
        border:none;
        outline:none;
        background:#f4f7fe;
        border-radius:50px;
        padding-left:50px;
        font-size:15px;
    }

    .header-right{
        display:flex;
        align-items:center;
        gap:25px;
    }

    .icon-box{

        width:45px;
        height:45px;
        border-radius:50%;
        background:#f4f7fe;

        display:flex;
        justify-content:center;
        align-items:center;

        cursor:pointer;

        transition:.3s;

    }

    .icon-box:hover{

        background: #323131;
        color:white;

    }

    .user{

        display:flex;
        align-items:center;

    }

    .user img{

        width:48px;
        height:48px;

        border-radius:50%;
        object-fit:cover;

    }

    .user-info{

        margin-left:12px;

    }

    .user-info h6{

        margin:0;
        font-weight:bold;

    }

    .user-info small{

        color:gray;

    }

</style>

<div class="main-content">

