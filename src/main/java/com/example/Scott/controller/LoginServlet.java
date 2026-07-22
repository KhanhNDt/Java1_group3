package com.example.Scott.controller;

import com.example.Scott.entity.TaiKhoan;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import com.example.Scott.responsitory.TaiKhoanResponsitory;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
@WebServlet("/login")
public class LoginServlet extends HttpServlet {
    private final TaiKhoanResponsitory repo = new TaiKhoanResponsitory();

    @Override
    protected void doGet(HttpServletRequest request,
                         HttpServletResponse response)
            throws ServletException, IOException {

        request.getRequestDispatcher("/login.jsp")
                .forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request,
                          HttpServletResponse response)
            throws ServletException, IOException {

        String username = request.getParameter("username");
        String password = request.getParameter("password");

        TaiKhoan tk = repo.login(username, password);

        if (tk == null) {

            request.setAttribute("error", "Sai tên đăng nhập hoặc mật khẩu!");

            request.getRequestDispatcher("/login.jsp")
                    .forward(request, response);

            return;
        }

        HttpSession session = request.getSession();
        session.invalidate();
        session = request.getSession(true);

        session.setAttribute("user", tk);

        response.sendRedirect(request.getContextPath() + "/dashboard");
    }
}
