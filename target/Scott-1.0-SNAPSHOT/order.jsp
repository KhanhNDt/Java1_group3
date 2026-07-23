<%@ page contentType="text/html;charset=UTF-8" language="java" %>

<!DOCTYPE html>
<html>

<head>

    <meta charset="UTF-8">

    <title>Quản lý đơn hàng</title>

    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">

    <style>

        body{

            background:#f4f4f4;
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
            /*background:#171717;*/
            color:white;
            display:flex;
            justify-content:center;
            align-items:center;
            border-radius:10px;
            margin:auto;
            margin-top:20px;

        }
        .logo img{
            width: 85px;
            height: 140px;
        }

        .menu a{

            display:block;
            padding:12px 25px;
            text-decoration:none;
            color:#666;

        }

        .menu a.active{

            background:#171717;
            color:white;
            border-radius:8px;

        }

        .card-box{

            background:white;
            border-radius:12px;
            padding:20px;

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
                <a class="active" href="order">Đơn hàng</a>
                <a href="product">Sản phẩm</a>

            </div>

        </div>

        <div class="col-10 p-4">

            <h2>Bảng quản lý đơn hàng</h2>

            <div class="row mt-4">

                <div class="col">

                    <div class="card-box">

                        <h6>Tổng đơn hàng</h6>

                        <h2>1234</h2>

                    </div>

                </div>

                <div class="col">

                    <div class="card-box">

                        <h6>Đang xử lý</h6>

                        <h2>56</h2>

                    </div>

                </div>

                <div class="col">

                    <div class="card-box">

                        <h6>Đã giao</h6>

                        <h2>1050</h2>

                    </div>

                </div>

            </div>

            <div class="card-box mt-4">

                <div class="d-flex justify-content-between">

                    <h5>Đơn hàng thời trang</h5>

                    <input class="form-control w-25" placeholder="Tìm kiếm">

                </div>

                <table class="table mt-3">

                    <thead>

                    <tr>

                        <th>Mã đơn</th>
                        <th>Số hóa đơn</th>
                        <th>Khách hàng</th>
                        <th>Sản phẩm</th>
                        <th>Giá</th>
                        <th>Ngày</th>
                        <th>Trạng thái</th>

                    </tr>

                    </thead>

                    <tbody>

                    <tr>

                        <td>#ORD-771</td>
                        <td>INV001</td>
                        <td>John Smith</td>
                        <td>Áo phông nữ cổ tròn</td>
                        <td>$299</td>
                        <td>12/12/2024</td>
                        <td><span class="badge bg-success">Còn hàng</span></td>

                    </tr>

                    <tr>

                        <td>#ORD-772</td>
                        <td>INV002</td>
                        <td>Emma Wilson</td>
                        <td>Áo phông nữ</td>
                        <td>$89</td>
                        <td>11/12/2024</td>
                        <td><span class="badge bg-success">Còn hàng</span></td>

                    </tr>

                    </tbody>

                </table>

            </div>

        </div>

    </div>

</div>

</body>

</html>