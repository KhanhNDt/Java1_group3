package com.example.Scott.utils;

import com.example.Scott.controller.BanHangServlet;

import java.util.Iterator;
import java.util.Map;
import java.util.concurrent.ConcurrentHashMap;

/**
 * Lưu tạm (in-memory) các phiên "chờ khách chuyển khoản QR" giữa lúc thu ngân bấm Thanh toán
 * (chọn Chuyển khoản QR) cho tới khi có tiền về thật.
 *
 * Mỗi phiên có 1 mã tham chiếu duy nhất (vd: DHK3F9A2) được nhúng vào nội dung chuyển khoản của QR.
 * Khi SePay báo có giao dịch vào tài khoản với nội dung chứa mã này và số tiền khớp,
 * webhook sẽ tự tạo hóa đơn dùng đúng payload đã lưu ở đây.
 *
 * Lưu ý: đây là lưu trong bộ nhớ (RAM) của 1 instance server. Nếu triển khai nhiều instance
 * (load balancer) hoặc restart server giữa lúc đang chờ thanh toán, phiên sẽ mất -> cần chuyển
 * sang lưu DB/Redis nếu scale lên nhiều server. Với 1 server bán hàng tại quầy thì dùng RAM là đủ.
 */
public class QrPaymentSessionManager {

    public enum TrangThai { CHO_THANH_TOAN, DA_THANH_TOAN, LOI }

    public static class PhienQR {
        public String maThamChieu;
        public double soTienDuKien;
        public Integer idNhanVien;
        public BanHangServlet.ThanhToanRequest payload;
        public volatile TrangThai trangThai = TrangThai.CHO_THANH_TOAN;
        public volatile Integer idHoaDon;
        public volatile String maHoaDon;
        public volatile double tongTienThanhToan;
        public volatile String thongBaoLoi;
        public final long thoiGianTaoMs = System.currentTimeMillis();
    }

    private static final Map<String, PhienQR> PHIEN = new ConcurrentHashMap<>();
    private static final long HET_HAN_MS = 15 * 60 * 1000L; // phiên QR hết hạn sau 15 phút không thanh toán

    private QrPaymentSessionManager() {}

    /** Sinh mã tham chiếu ngắn, duy nhất, để nhúng vào nội dung chuyển khoản QR (vd: DHK3F9A21B). */
    public static String taoMaThamChieu() {
        String ma;
        do {
            long phanThoiGian = System.currentTimeMillis() % 1_000_000L;
            int phanNgauNhien = (int) (Math.random() * 46656); // 36^3
            ma = "DH" + Long.toString(phanThoiGian, 36).toUpperCase()
                    + Integer.toString(phanNgauNhien, 36).toUpperCase();
        } while (PHIEN.containsKey(ma));
        return ma;
    }

    public static void luuPhien(PhienQR phien) {
        donDep();
        PHIEN.put(phien.maThamChieu, phien);
    }

    public static PhienQR layPhien(String maThamChieu) {
        if (maThamChieu == null) return null;
        return PHIEN.get(maThamChieu.trim().toUpperCase());
    }

    /**
     * Tìm phiên đang CHỜ THANH TOÁN có mã tham chiếu xuất hiện trong nội dung chuyển khoản.
     * Dùng khi webhook gửi lên nội dung dạng "NGUYEN VAN A chuyen tien DHK3F9A21B" (có thể
     * kèm thêm ký tự khác do ngân hàng/app chèn vào, nên tìm theo kiểu "chứa mã", không so khớp tuyệt đối).
     */
    public static PhienQR timPhienTheoNoiDung(String noiDungChuyenKhoan) {
        if (noiDungChuyenKhoan == null || noiDungChuyenKhoan.isEmpty()) return null;
        String noiDungChuanHoa = noiDungChuyenKhoan.toUpperCase().replaceAll("[^A-Z0-9]", "");
        donDep();
        for (PhienQR p : PHIEN.values()) {
            if (p.trangThai == TrangThai.CHO_THANH_TOAN && noiDungChuanHoa.contains(p.maThamChieu)) {
                return p;
            }
        }
        return null;
    }

    private static void donDep() {
        long now = System.currentTimeMillis();
        Iterator<Map.Entry<String, PhienQR>> it = PHIEN.entrySet().iterator();
        while (it.hasNext()) {
            PhienQR p = it.next().getValue();
            boolean qHan = (now - p.thoiGianTaoMs) > HET_HAN_MS;
            boolean daXongLauRoi = p.trangThai != TrangThai.CHO_THANH_TOAN && (now - p.thoiGianTaoMs) > (HET_HAN_MS * 2);
            if (qHan && p.trangThai == TrangThai.CHO_THANH_TOAN) {
                it.remove();
            } else if (daXongLauRoi) {
                it.remove();
            }
        }
    }
}
