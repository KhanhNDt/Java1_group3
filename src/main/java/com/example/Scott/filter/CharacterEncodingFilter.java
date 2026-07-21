package com.example.Scott.filter;

import jakarta.servlet.Filter;
import jakarta.servlet.FilterChain;
import jakarta.servlet.ServletException;
import jakarta.servlet.ServletRequest;
import jakarta.servlet.ServletResponse;
import jakarta.servlet.annotation.WebFilter;

import java.io.IOException;

/**
 * BUG QUAN TRỌNG ĐÃ SỬA: dữ liệu tiếng Việt bị lỗi font sau khi Thêm/Sửa.
 *
 * NGUYÊN NHÂN: theo chuẩn Servlet, nếu request KHÔNG được gọi
 * setCharacterEncoding("UTF-8") TRƯỚC LẦN ĐẦU TIÊN request.getParameter(...)
 * được đọc, thì Tomcat sẽ dùng bảng mã mặc định (thường là ISO-8859-1) để giải
 * mã phần dữ liệu form gửi lên (application/x-www-form-urlencoded).
 * Hậu quả: người dùng gõ "Vest công sở" nhưng khi lưu xuống DB lại thành
 * "Vest cÃ´ng sá»Ÿ" — dù trang JSP hiển thị vẫn khai báo charset=UTF-8, DB cũng
 * là NVARCHAR chuẩn Unicode, lỗi này KHÔNG nằm ở đó mà nằm ở bước đọc tham số.
 *
 * CÁCH SỬA: dùng 1 Filter áp dụng cho toàn ứng dụng ("/*"), chạy sớm nhất
 * trong vòng đời mỗi request — TRƯỚC khi bất kỳ Servlet nào kịp gọi
 * getParameter(). Đây là cách làm chuẩn, chỉ cần viết 1 lần duy nhất thay vì
 * phải gọi setCharacterEncoding() rải rác ở đầu từng hàm doGet/doPost.
 */
@WebFilter("/*")
public class CharacterEncodingFilter implements Filter {

    @Override
    public void doFilter(ServletRequest request, ServletResponse response, FilterChain chain)
            throws IOException, ServletException {
        request.setCharacterEncoding("UTF-8");
        response.setCharacterEncoding("UTF-8");
        chain.doFilter(request, response);
    }
}
