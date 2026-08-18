package com.example.Scott.utils;

/**
 * Đọc các cấu hình dạng biến môi trường của ứng dụng (theo đúng cách project đang làm với DB
 * trong HibernateConfig: ưu tiên biến môi trường, có giá trị mặc định để chạy thử local).
 */
public class AppConfig {

    private AppConfig() {}

    /**
     * Token bí mật dùng để xác thực webhook từ SePay.
     * Vào SePay Dashboard -> Cấu hình Webhook -> đặt Authorization Header dạng "Apikey <token>",
     * rồi set biến môi trường SEPAY_WEBHOOK_TOKEN đúng bằng token đó (KHÔNG hardcode trong code/git).
     */
    public static String sepayWebhookToken() {
        String token = System.getenv("SEPAY_WEBHOOK_TOKEN");
        if (token == null || token.trim().isEmpty()) {
            // Giá trị mặc định chỉ để chạy thử local — PHẢI đổi khi deploy thật,
            // nếu không ai cũng có thể giả mạo webhook để tự tạo hóa đơn "đã thanh toán".
            token = "DOI_TOKEN_NAY_KHI_DEPLOY_THAT";
        }
        return token;
    }
}
