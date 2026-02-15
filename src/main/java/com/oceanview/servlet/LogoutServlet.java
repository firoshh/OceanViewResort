package com.oceanview.servlet;

import java.io.IOException;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

@WebServlet("/LogoutServlet")
public class LogoutServlet extends HttpServlet {

    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        // 1. Get the current session
        HttpSession session = request.getSession(false);

        // 2. Destroy the session entirely
        if (session != null) {
            session.invalidate();
        }

        // 3. Send them back to the login page (index.jsp)
        response.sendRedirect("index.jsp");
    }
}