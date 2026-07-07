<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="en">
<head>

    <meta charset="UTF-8">
    <title>Quản lý sản phẩm</title>

    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">

    <style>

        body{
            background:#F5FAF6;
            font-family:Segoe UI;
        }

        .sidebar{
            width:240px;
            background:white;
            min-height:100vh;
            box-shadow:0 0 10px rgba(0,0,0,.05);
        }

        .logo{
            width:70px;
            height:70px;
            /*background:#5B4CF8;*/
            color:white;
            display:flex;
            align-items:center;
            justify-content:center;
            border-radius:10px;
            margin:auto;
            font-size:28px;
            margin-top:25px;
        }
        .logo img{
            width: 85px;
            height: 140px;
        }

        .menu a{

            display:block;
            padding:13px 25px;
            color:#555;
            text-decoration:none;

        }

        .menu a.active{

            background:#5B4CF8;
            color:white;
            border-radius:8px;

        }

        .card-box{

            background:white;
            border-radius:12px;
            padding:20px;

        }

        .table{
            margin-top:20px;
        }

        .search{

            border-radius:30px;

        }

        .badge-success{

            background:#D8F5E7;
            color:green;

        }

        .badge-danger{

            background:#FDE3E3;
            color:red;

        }

    </style>

</head>

<body>

<div class="container-fluid">

    <div class="row">

        <div class="col-2 sidebar">

            <div class="logo"><img src="logo.png" alt=""></div>

            <div class="menu mt-4">

                <a href="#">Dashboard</a>

                <a href="#">Ranking</a>

                <a href="order">Đơn hàng</a>

                <a class="active" href="product">Sản phẩm</a>

                <a href="#">Báo cáo</a>

                <a href="#">Tin nhắn</a>

                <a href="#">Cài đặt</a>

            </div>

        </div>

        <div class="col-10 p-4">

            <h2>Bảng quản lý sản phẩm</h2>

            <div class="row mt-4">

                <div class="col-md-3">
                    <div class="card-box">
                        <h6>Tổng số mặt hàng</h6>
                        <h2>482</h2>
                    </div>
                </div>

                <div class="col-md-3">
                    <div class="card-box">
                        <h6>Giá trị kho</h6>
                        <h2>$45K</h2>
                    </div>
                </div>

                <div class="col-md-3">
                    <div class="card-box">
                        <h6>Hàng tồn thấp</h6>
                        <h2>8</h2>
                    </div>
                </div>

                <div class="col-md-3">
                    <div class="card-box">
                        <h6>Tăng trưởng</h6>
                        <h2>12%</h2>
                    </div>
                </div>

            </div>

            <div class="card-box mt-4">

                <div class="d-flex justify-content-between">

                    <h5>Bộ sưu tập thời trang</h5>

                    <div>

                        <input class="form-control search" placeholder="Tìm kiếm">

                    </div>

                </div>

                <table class="table">

                    <thead>

                    <tr>

                        <th>Mặt hàng</th>
                        <th>Danh mục</th>
                        <th>Giá</th>
                        <th>Tồn kho</th>
                        <th>Trạng thái</th>
                        <th>Địa chỉ</th>

                    </tr>

                    </thead>

                    <tbody>

                    <tr>

                        <td>Áo phông nữ cổ tròn</td>
                        <td>Quần áo</td>
                        <td>$45</td>
                        <td>120</td>
                        <td><span class="badge badge-success">Còn hàng</span></td>
                        <td>123 Main St</td>

                    </tr>

                    <tr>

                        <td>Áo phông nữ form rộng</td>
                        <td>Quần áo</td>
                        <td>$89</td>
                        <td>85</td>
                        <td><span class="badge badge-success">Còn hàng</span></td>
                        <td>Los Angeles</td>

                    </tr>

                    <tr>

                        <td>Áo phông nữ dáng croptop</td>
                        <td>Quần áo</td>
                        <td>$150</td>
                        <td>5</td>
                        <td><span class="badge badge-danger">Hết hàng</span></td>
                        <td>Chicago</td>

                    </tr>

                    </tbody>

                </table>

            </div>

        </div>

    </div>

</div>

</body>
</html>