package com.example.Scott.utils;

import jakarta.mail.*;
import jakarta.mail.internet.InternetAddress;
import jakarta.mail.internet.MimeMessage;

import java.util.Properties;

/**
 * Tiện ích gửi email bằng SMTP (mặc định cấu hình cho Gmail).
 *
 * LƯU Ý QUAN TRỌNG TRƯỚC KHI DÙNG:
 * 1. Thay MAIL_FROM bằng email Gmail thật của bạn.
 * 2. Thay MAIL_PASSWORD bằng "Mật khẩu ứng dụng" (App Password) của Gmail,
 *    KHÔNG dùng mật khẩu đăng nhập Gmail thông thường.
 *    Tạo tại: https://myaccount.google.com/apppasswords
 *    (Tài khoản Google phải bật xác minh 2 bước trước).
 */
public class MailUtils {

    private static final String MAIL_FROM = "phutuananh4827@gmail.com";
    private static final String MAIL_PASSWORD = "loxb oxvj nhhq ntxc";
    private static final String SMTP_HOST = "smtp.gmail.com";
    private static final String SMTP_PORT = "587";

    /**
     * Gửi email thông báo đăng ký nhân viên thành công.
     * Không ném exception ra ngoài để việc gửi mail lỗi không làm hỏng luồng thêm nhân viên.
     *
     * @return true nếu gửi thành công, false nếu thất bại (xem log console để biết chi tiết)
     */
    public static boolean sendWelcomeEmail(String toEmail, String hoTen, String maNhanVien) {
        if (toEmail == null || toEmail.trim().isEmpty()) {
            System.out.println("[MailUtils] Bỏ qua gửi mail: không có địa chỉ email.");
            return false;
        }

        try {
            Properties props = new Properties();
            props.put("mail.smtp.auth", "true");
            props.put("mail.smtp.starttls.enable", "true");
            props.put("mail.smtp.host", SMTP_HOST);
            props.put("mail.smtp.port", SMTP_PORT);

            Session session = Session.getInstance(props, new Authenticator() {
                @Override
                protected PasswordAuthentication getPasswordAuthentication() {
                    return new PasswordAuthentication(MAIL_FROM, MAIL_PASSWORD);
                }
            });

            Message message = new MimeMessage(session);
            message.setFrom(new InternetAddress(MAIL_FROM, "Phòng Nhân sự"));
            message.setRecipients(Message.RecipientType.TO, InternetAddress.parse(toEmail));
            message.setSubject("Đăng ký nhân viên thành công - Mã NV: " + maNhanVien);

            String content = "<div style=\"font-family:Segoe UI,Arial,sans-serif;\">"
                    + "<h2 style=\"color:#1e2a4a;\">Chào mừng " + hoTen + "!</h2>"
                    + "<p>Bạn đã được đăng ký thành công vào hệ thống quản lý nhân viên.</p>"
                    + "<table style=\"border-collapse:collapse;margin-top:10px;\">"
                    + "<tr><td style=\"padding:4px 12px 4px 0;color:#555;\">Mã nhân viên:</td>"
                    + "<td style=\"font-weight:bold;\">" + maNhanVien + "</td></tr>"
                    + "<tr><td style=\"padding:4px 12px 4px 0;color:#555;\">Họ tên:</td>"
                    + "<td style=\"font-weight:bold;\">" + hoTen + "</td></tr>"
                    + "</table>"
                    + "<p style=\"margin-top:16px;color:#888;font-size:13px;\">"
                    + "Đây là email tự động, vui lòng không trả lời email này.</p>"
                    + "</div>";
            message.setContent(content, "text/html; charset=UTF-8");

            Transport.send(message);
            System.out.println("[MailUtils] Gửi mail thành công tới " + toEmail);
            return true;

        } catch (Exception e) {
            System.out.println("[MailUtils] Gửi mail thất bại: " + e.getMessage());
            e.printStackTrace();
            return false;
        }
    }
}
