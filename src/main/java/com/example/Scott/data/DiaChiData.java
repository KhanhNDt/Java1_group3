package com.example.Scott.data;

import com.fasterxml.jackson.core.type.TypeReference;
import com.fasterxml.jackson.databind.ObjectMapper;

import java.io.InputStream;
import java.util.ArrayList;
import java.util.Collections;
import java.util.List;

public class DiaChiData {

    // ==========================
    // Danh sách tỉnh/thành
    // ==========================

    private static final List<TinhThanh> dsTinh = new ArrayList<>();

    static {

        dsTinh.add(new TinhThanh(1, "Thành phố Hà Nội"));
        dsTinh.add(new TinhThanh(2, "Tỉnh Bắc Ninh"));
        dsTinh.add(new TinhThanh(3, "Tỉnh Quảng Ninh"));
        dsTinh.add(new TinhThanh(4, "Tỉnh Hải Phòng"));
        dsTinh.add(new TinhThanh(5, "Tỉnh Hưng Yên"));
        dsTinh.add(new TinhThanh(6, "Tỉnh Ninh Bình"));
        dsTinh.add(new TinhThanh(7, "Tỉnh Cao Bằng"));
        dsTinh.add(new TinhThanh(8, "Thành Tuyên Quang"));
        dsTinh.add(new TinhThanh(9, "Tỉnh Lào Cai"));
        dsTinh.add(new TinhThanh(10, "Tỉnh Thái Nguyên"));
        dsTinh.add(new TinhThanh(11, "Tỉnh Lạng Sơn"));
        dsTinh.add(new TinhThanh(12, "Tỉnh Phú Thọ"));
        dsTinh.add(new TinhThanh(13, "Tỉnh Điện Biên"));
        dsTinh.add(new TinhThanh(14, "Tỉnh Lai Châu"));
        dsTinh.add(new TinhThanh(15, "Tỉnh Sơn La"));
        dsTinh.add(new TinhThanh(16, "Tỉnh Thanh Hóa"));
        dsTinh.add(new TinhThanh(17, "Tỉnh Nghệ An"));
        dsTinh.add(new TinhThanh(18, "Tỉnh Hà Tĩnh"));
        dsTinh.add(new TinhThanh(19, "Tỉnh Quảng Trị"));
        dsTinh.add(new TinhThanh(20, "Thành phố Huế"));
        dsTinh.add(new TinhThanh(21, "Tp Đà Nẵng"));
        dsTinh.add(new TinhThanh(22, "Tỉnh Quảng Ngãi"));
        dsTinh.add(new TinhThanh(23, "Tỉnh Khánh Hòa"));
        dsTinh.add(new TinhThanh(24, "Tỉnh Gia Lai"));
        dsTinh.add(new TinhThanh(25, "Tỉnh Đắk Lắk"));
        dsTinh.add(new TinhThanh(26, "Tỉnh Lâm Đồng"));
        dsTinh.add(new TinhThanh(27, "Tỉnh Tây Ninh"));
        dsTinh.add(new TinhThanh(28, "Tỉnh Đồng Nai"));
        dsTinh.add(new TinhThanh(29, "Tp Hồ Chí Minh"));
        dsTinh.add(new TinhThanh(30, "Tỉnh Vĩnh Long"));
        dsTinh.add(new TinhThanh(31, "Tỉnh Đồng Tháp"));
        dsTinh.add(new TinhThanh(32, "Tỉnh An Giang"));
        dsTinh.add(new TinhThanh(33, "Tp Cần Thơ"));
        dsTinh.add(new TinhThanh(34, "Tỉnh Cà Mau"));

    }

    // ==========================
    // Danh sách phường/xã
    // ==========================

    private static final List<PhuongXa> dsPhuong = loadPhuong();

    private static List<PhuongXa> loadPhuong() {

        try {

            ObjectMapper mapper = new ObjectMapper();

            InputStream is = DiaChiData.class
                    .getClassLoader()
                    .getResourceAsStream("data/phuong.json");

            if (is == null) {

                System.out.println("===== KHÔNG TÌM THẤY FILE phuong.json =====");

                return Collections.emptyList();

            }

            return mapper.readValue(
                    is,
                    new TypeReference<List<PhuongXa>>() {
                    });

        } catch (Exception e) {

            e.printStackTrace();

            return Collections.emptyList();

        }

    }

    // ==========================
    // Danh sách tỉnh
    // ==========================

    public static List<TinhThanh> getAllTinh() {

        return dsTinh;

    }

    // ==========================
    // Danh sách phường
    // ==========================

    public static List<PhuongXa> getAllPhuong() {

        return dsPhuong;

    }

    // ==========================
    // Lấy tên tỉnh
    // ==========================

    public static String getTenTinh(Integer id) {

        for (TinhThanh t : dsTinh) {

            if (t.getId().equals(id)) {

                return t.getTen();

            }

        }

        return "";

    }

    // ==========================
    // Lấy tên phường
    // ==========================

    public static String getTenPhuong(Integer id) {

        for (PhuongXa p : dsPhuong) {

            if (p.getId().equals(id)) {

                return p.getTen();

            }

        }

        return "";

    }

    // ==========================
    // Lấy danh sách phường theo tỉnh
    // ==========================

    public static List<PhuongXa> getPhuongTheoTinh(Integer provinceId) {

        List<PhuongXa> list = new ArrayList<>();

        for (PhuongXa p : dsPhuong) {

            if (p.getProvinceId().equals(provinceId)) {

                list.add(p);

            }

        }

        return list;

    }

    // ==========================
    // Test đọc JSON
    // ==========================

    public static void main(String[] args) {

        System.out.println("===== TEST JSON =====");

        System.out.println("Tổng số phường: " + getAllPhuong().size());

        if (!getAllPhuong().isEmpty()) {

            PhuongXa p = getAllPhuong().get(0);

            System.out.println("ID: " + p.getId());
            System.out.println("ProvinceId: " + p.getProvinceId());
            System.out.println("Tên: " + p.getTen());

        }

    }

}