package com.example.Scott.dto;

public class ThuocTinhDTO {
    private Integer id;
    private String ma;
    private String ten;
    private String moTa;
    private Integer trangThai;
    private long soLuongSuDung;

    public ThuocTinhDTO() {
    }

    public ThuocTinhDTO(Integer id, String ma, String ten, String moTa, Integer trangThai, long soLuongSuDung) {
        this.id = id;
        this.ma = ma;
        this.ten = ten;
        this.moTa = moTa;
        this.trangThai = trangThai;
        this.soLuongSuDung = soLuongSuDung;
    }

    public Integer getId() { return id; }
    public void setId(Integer id) { this.id = id; }
    public String getMa() { return ma; }
    public void setMa(String ma) { this.ma = ma; }
    public String getTen() { return ten; }
    public void setTen(String ten) { this.ten = ten; }
    public String getMoTa() { return moTa; }
    public void setMoTa(String moTa) { this.moTa = moTa; }
    public Integer getTrangThai() { return trangThai; }
    public void setTrangThai(Integer trangThai) { this.trangThai = trangThai; }
    public long getSoLuongSuDung() { return soLuongSuDung; }
    public void setSoLuongSuDung(long soLuongSuDung) { this.soLuongSuDung = soLuongSuDung; }
}
