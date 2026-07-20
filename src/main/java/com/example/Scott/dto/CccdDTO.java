package com.example.Scott.dto; // Đổi lại package cho đúng với thư mục của bạn

public class CccdDTO {
    private String soCccd;
    private String hoTen;
    private String ngaySinh;
    private String gioiTinh;
    private String diaChi;

    // Constructor đủ tham số
    public CccdDTO(String soCccd, String hoTen, String ngaySinh, String gioiTinh, String diaChi) {
        this.soCccd = soCccd;
        this.hoTen = hoTen;
        this.ngaySinh = ngaySinh;
        this.gioiTinh = gioiTinh;
        this.diaChi = diaChi;
    }

    // Getters và Setters
    public String getSoCccd() { return soCccd; }
    public void setSoCccd(String soCccd) { this.soCccd = soCccd; }

    public String getHoTen() { return hoTen; }
    public void setHoTen(String hoTen) { this.hoTen = hoTen; }

    public String getNgaySinh() { return ngaySinh; }
    public void setNgaySinh(String ngaySinh) { this.ngaySinh = ngaySinh; }

    public String getGioiTinh() { return gioiTinh; }
    public void setGioiTinh(String gioiTinh) { this.gioiTinh = gioiTinh; }

    public String getDiaChi() { return diaChi; }
    public void setDiaChi(String diaChi) { this.diaChi = diaChi; }
}