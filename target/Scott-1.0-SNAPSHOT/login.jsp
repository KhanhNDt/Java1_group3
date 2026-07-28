<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <title>Đăng nhập - Scott</title>

    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css"
          rel="stylesheet">

    <style>
        body{
            background:#f4f6f9;
        }

        .card{
            border-radius:20px;
            border:none;
        }

        /* Logo */
        .admin-sidebar__logo-wrap{
            display:flex;
            justify-content:center;
            align-items:center;
            padding-top:25px;
            padding-bottom:15px;
        }

        .admin-sidebar__logo-wrap img{
            width:120px;
            height:auto;
        }

        /* Tiêu đề */
        .login-title{
            display:flex;
            align-items:center;
            justify-content:center;
            gap:15px;
            margin-bottom:10px;
        }
        .login-title span{
            flex:1;
            height:1px;
            background:#dcdcdc;
        }
        .login-title h3{
            margin:0;
            font-weight:700;
            font-size:35px;
            white-space:nowrap;
        }
        .card-header{
            background:white;
            border:none;
            padding-bottom:25px;
        }
        .form-control{
            height:48px;
            border-radius:10px;
        }
        .btn-primary{
            height:48px;
            border-radius:10px;
            font-size:18px;
        }
    </style>
</head>
<body>
<div class="container">
    <div class="row justify-content-center mt-5">
        <div class="col-md-6">
            <div class="card shadow">
                <!-- Logo -->
                <div class="admin-sidebar__logo-wrap">
                    <img src="${pageContext.request.contextPath}/assets/images/scott-logo.png"
                         alt="Scott">
                </div>
                <!-- Tiêu đề -->
                <div class="card-header">
                    <div class="login-title">
                        <span></span>
                        <h3>Đăng nhập</h3>
                        <span></span>
                    </div>
                    <p class="text-center text-muted mb-0">
                        Đăng nhập để truy cập hệ thống Scott
                    </p>
                </div>
                <div class="card-body px-4 pb-4">
                    <% if(request.getAttribute("error") != null){ %>
                    <div class="alert alert-danger">
                        <%= request.getAttribute("error") %>
                    </div>
                    <% } %>
                    <form action="${pageContext.request.contextPath}/login" method="post">
                        <div class="mb-3">
                            <label class="form-label">Tên đăng nhập</label>
                            <input type="text"
                                   name="username"
                                   class="form-control"
                                   required>
                        </div>
                        <div class="mb-4">
                            <label class="form-label">Mật khẩu</label>
                            <input type="password"
                                   name="password"
                                   class="form-control"
                                   required>
                        </div>
                        <button class="btn btn-primary w-100">
                            Đăng nhập
                        </button>
                    </form>
                </div>
            </div>
        </div>
    </div>
</div>

</body>
</html>