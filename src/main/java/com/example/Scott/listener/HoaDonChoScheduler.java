package com.example.Scott.listener;

import com.example.Scott.responsitory.HoaDonRepo;
import jakarta.servlet.ServletContextEvent;
import jakarta.servlet.ServletContextListener;
import jakarta.servlet.annotation.WebListener;

import java.util.concurrent.Executors;
import java.util.concurrent.ScheduledExecutorService;
import java.util.concurrent.TimeUnit;

/**
 * Chạy nền để tự động hủy các hóa đơn "Chờ xử lý" (giữ đơn tại quầy - Bán hàng tại quầy)
 * đã sang ngày hôm sau mà vẫn chưa được nhân viên hoàn tất thanh toán hoặc hủy thủ công.
 * <p>
 * Quy tắc nghiệp vụ: một hóa đơn chờ được tạo trong ngày hôm nay nhưng KHÔNG được hoàn
 * tất trước khi qua ngày hôm sau sẽ tự động chuyển sang trạng thái "Đã hủy" (trạng thái 2),
 * để đồng bộ với việc màn "Quản lý hóa đơn" chỉ còn hiển thị hóa đơn "Đã thanh toán" và "Đã hủy".
 * <p>
 * Việc kiểm tra cũng được gọi lại (một cách "lười") mỗi khi HoaDonServlet hoặc
 * BanHangServlet tải danh sách hóa đơn/hóa đơn chờ, nên scheduler này chủ yếu đảm bảo
 * quy tắc vẫn tự động đúng hạn ngay cả khi không có ai đang mở các màn hình đó.
 */
@WebListener
public class HoaDonChoScheduler implements ServletContextListener {

    // Chu kỳ kiểm tra định kỳ dưới nền (không cần quá dày vì đã có kiểm tra "lười" mỗi lần tải trang)
    private static final long CHU_KY_PHUT = 15;

    private final HoaDonRepo hoaDonRepo = new HoaDonRepo();
    private ScheduledExecutorService scheduler;

    @Override
    public void contextInitialized(ServletContextEvent sce) {
        scheduler = Executors.newSingleThreadScheduledExecutor(runnable -> {
            Thread thread = new Thread(runnable, "hoa-don-cho-auto-huy");
            thread.setDaemon(true);
            return thread;
        });
        // Chạy ngay khi ứng dụng khởi động (dọn dẹp hóa đơn chờ tồn đọng từ lần chạy trước),
        // sau đó lặp lại định kỳ mỗi CHU_KY_PHUT phút.
        scheduler.scheduleAtFixedRate(this::kiemTraVaHuy, 0, CHU_KY_PHUT, TimeUnit.MINUTES);
    }

    private void kiemTraVaHuy() {
        try {
            int soLuong = hoaDonRepo.huyCacHoaDonChoQuaHan();
            if (soLuong > 0) {
                System.out.println("[HoaDonChoScheduler] Đã tự động hủy " + soLuong + " hóa đơn chờ quá hạn.");
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    @Override
    public void contextDestroyed(ServletContextEvent sce) {
        if (scheduler != null) {
            scheduler.shutdownNow();
        }
    }
}
