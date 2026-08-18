package com.example.Scott.controller;

import com.example.Scott.service.ThanhToanService;
import com.example.Scott.utils.AppConfig;
import com.example.Scott.utils.QrPaymentSessionManager;
import com.google.gson.Gson;
import com.google.gson.annotations.SerializedName;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.BufferedReader;
import java.io.IOException;
import java.util.LinkedHashMap;
import java.util.Map;

/**
 * Endpoint nhận webhook (IPN) từ SePay mỗi khi tài khoản ngân hàng liên kết có biến động số dư.
 * Cấu hình URL này trong SePay Dashboard: https://<domain-cong-khai-cua-ban>/webhook/sepay
 *
 * SePay sẽ gửi POST kèm header "Authorization: Apikey <token>" (token cấu hình trên Dashboard SePay,
 * đồng thời set biến môi trường SEPAY_WEBHOOK_TOKEN đúng bằng token đó trên server) và body JSON dạng:
 * {
 *   "gateway": "Vietcombank",
 *   "transferAmount": 250000,
 *   "transferType": "in",       // "in" = tiền vào, "out" = tiền ra
 *   "content": "NGUYEN VAN A CHUYEN KHOAN DHK3F9A21B",
 *   "referenceCode": "FT2025...",
 *   ...
 * }
 *
 * LƯU Ý QUAN TRỌNG:
 * - Server chạy servlet này phải có địa chỉ public + HTTPS để SePay gọi tới được (không phải localhost).
 * - Luôn trả JSON {"success": true} với HTTP 200 khi đã xử lý xong (kể cả khi không khớp đơn nào),
 *   nếu không SePay sẽ coi là lỗi và gửi lại nhiều lần.
 */
@WebServlet(name = "SePayWebhookServlet", value = {"/webhook/sepay"})
public class SePayWebhookServlet extends HttpServlet {

    private final Gson gson = new Gson();
    private final ThanhToanService thanhToanService = new ThanhToanService();

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        req.setCharacterEncoding("UTF-8");
        resp.setCharacterEncoding("UTF-8");
        resp.setContentType("application/json;charset=UTF-8");

        // ---- 1) Xác thực request thật sự đến từ SePay (chặn giả mạo webhook để tự "tạo" đơn đã thanh toán) ----
        String auth = req.getHeader("Authorization");
        String tokenCauHinh = AppConfig.sepayWebhookToken();
        boolean hopLe = auth != null &&
                (auth.equals("Apikey " + tokenCauHinh) || auth.equals("Bearer " + tokenCauHinh));
        if (!hopLe) {
            resp.setStatus(HttpServletResponse.SC_UNAUTHORIZED);
            resp.getWriter().write(gson.toJson(mapLoi("Token xác thực không hợp lệ.")));
            return;
        }

        // ---- 2) Đọc & parse body JSON ----
        SePayPayload payload;
        try {
            payload = gson.fromJson(docBody(req), SePayPayload.class);
        } catch (Exception e) {
            resp.getWriter().write(gson.toJson(mapLoi("Không đọc được dữ liệu webhook.")));
            return;
        }
        if (payload == null) {
            resp.getWriter().write(gson.toJson(mapLoi("Body rỗng.")));
            return;
        }

        // Chỉ xử lý giao dịch TIỀN VÀO, bỏ qua tiền ra (rút tiền, chuyển đi...)
        if (payload.transferType != null && !"in".equalsIgnoreCase(payload.transferType)) {
            resp.getWriter().write(gson.toJson(mapOk("Bỏ qua (không phải tiền vào).")));
            return;
        }

        // ---- 3) Khớp nội dung chuyển khoản với 1 phiên QR đang chờ ----
        QrPaymentSessionManager.PhienQR phien =
                QrPaymentSessionManager.timPhienTheoNoiDung(payload.content);

        if (phien == null) {
            // Không khớp đơn nào đang chờ (có thể là giao dịch khác không liên quan tới bán hàng tại quầy).
            resp.getWriter().write(gson.toJson(mapOk("Không tìm thấy đơn hàng chờ khớp với giao dịch này.")));
            return;
        }

        double soTienVe = payload.transferAmount != null ? payload.transferAmount : 0;
        if (soTienVe + 0.01 < phien.soTienDuKien) {
            // Tiền về ít hơn số tiền đơn hàng -> không tự xác nhận, để thu ngân kiểm tra thủ công.
            phien.trangThai = QrPaymentSessionManager.TrangThai.LOI;
            phien.thongBaoLoi = "Số tiền chuyển khoản (" + soTienVe + ") ít hơn số tiền đơn hàng (" + phien.soTienDuKien + ").";
            resp.getWriter().write(gson.toJson(mapOk("Số tiền không khớp, đã đánh dấu để thu ngân kiểm tra thủ công.")));
            return;
        }

        // ---- 4) Khớp rồi -> tạo hóa đơn thật (dùng chung logic với thanh toán tiền mặt) ----
        synchronized (phien) {
            if (phien.trangThai == QrPaymentSessionManager.TrangThai.DA_THANH_TOAN) {
                resp.getWriter().write(gson.toJson(mapOk("Đơn này đã được xác nhận thanh toán trước đó.")));
                return;
            }
            Map<String, Object> ketQua = thanhToanService.xuLyThanhToan(phien.payload, phien.idNhanVien);
            boolean thanhCong = Boolean.TRUE.equals(ketQua.get("success"));
            if (thanhCong) {
                phien.trangThai = QrPaymentSessionManager.TrangThai.DA_THANH_TOAN;
                phien.idHoaDon = (Integer) ketQua.get("idHoaDon");
                phien.maHoaDon = (String) ketQua.get("maHoaDon");
            } else {
                phien.trangThai = QrPaymentSessionManager.TrangThai.LOI;
                phien.thongBaoLoi = String.valueOf(ketQua.get("message"));
            }
        }

        resp.getWriter().write(gson.toJson(mapOk("Đã xử lý.")));
    }

    private String docBody(HttpServletRequest req) throws IOException {
        StringBuilder sb = new StringBuilder();
        try (BufferedReader reader = req.getReader()) {
            String line;
            while ((line = reader.readLine()) != null) sb.append(line);
        }
        return sb.toString();
    }

    private Map<String, Object> mapOk(String ghiChu) {
        Map<String, Object> m = new LinkedHashMap<>();
        m.put("success", true);
        m.put("note", ghiChu);
        return m;
    }

    private Map<String, Object> mapLoi(String message) {
        Map<String, Object> m = new LinkedHashMap<>();
        m.put("success", false);
        m.put("message", message);
        return m;
    }

    /** DTO ứng với payload webhook chuẩn của SePay. */
    public static class SePayPayload {
        String gateway;
        String content;
        @SerializedName("transferAmount")
        Double transferAmount;
        @SerializedName("transferType")
        String transferType; // "in" | "out"
        @SerializedName("referenceCode")
        String referenceCode;
    }
}
