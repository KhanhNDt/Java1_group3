package com.example.Scott.data;

public class PhuongXa {

    private Integer id;

    private Integer provinceId;

    private String ten;

    public PhuongXa() {
    }

    public PhuongXa(Integer id, Integer provinceId, String ten) {
        this.id = id;
        this.provinceId = provinceId;
        this.ten = ten;
    }

    public Integer getId() {
        return id;
    }

    public void setId(Integer id) {
        this.id = id;
    }

    public Integer getProvinceId() {
        return provinceId;
    }

    public void setProvinceId(Integer provinceId) {
        this.provinceId = provinceId;
    }

    public String getTen() {
        return ten;
    }

    public void setTen(String ten) {
        this.ten = ten;
    }
}