
<style>
:root{--mono:#111;--line:#dedede;--soft:#f5f5f5}
body{background:#f4f4f4!important;color:#171717!important}
.main-content{margin-left:242px!important;padding:28px!important}
.card,.table-container,.filter-card,.stat-card{border-color:var(--line)!important;box-shadow:0 4px 14px rgba(0,0,0,.045)!important}
.btn-primary,.btn-success,.btn-warning,.btn-info,.btn-danger{background:#171717!important;border-color:#171717!important;color:#fff!important}
.btn-outline-primary,.btn-outline-success,.btn-outline-danger,.btn-outline-warning{color:#171717!important;border-color:#aaa!important}
.btn-outline-primary:hover,.btn-outline-success:hover,.btn-outline-danger:hover,.btn-outline-warning:hover{background:#171717!important;color:#fff!important;border-color:#171717!important}
.badge,.status-badge{filter:grayscale(1)}
.form-control:focus,.form-select:focus{border-color:#333!important;box-shadow:0 0 0 .18rem rgba(0,0,0,.10)!important}
.table thead th{background:#f4f4f4!important;color:#222!important}
@media(max-width:900px){.main-content{margin-left:78px!important;padding:18px!important}}
</style>
<html>

<body>


<h2>CHI TIẾT NHÂN VIÊN</h2>


<p>
    Mã:
    ${nv.maNhanVien}
</p>


<p>
    Tên:
    ${nv.tenNhanVien}
</p>


<p>
    Ngày sinh:
    ${nv.ngaySinh}
</p>


<p>
    Giới tính:
    ${nv.gioiTinh}
</p>


<p>
    SĐT:
    ${nv.soDienThoai}
</p>


<p>
    Email:
    ${nv.email}
</p>


<a href="../nhanvien">
    Quay lại
</a>


</body>

</html>