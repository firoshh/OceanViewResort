package com.oceanview.servlet;

import com.oceanview.data.UserDAO;
import java.io.IOException;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

@WebServlet("/LoginServlet")
public class LoginServlet extends HttpServlet {

    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String u = request.getParameter("username");
        String p = request.getParameter("password");

        // 1. WHAT PAGE DID THEY COME FROM? (Staff or Admin)
        String loginType = request.getParameter("loginType");

        // Determine where to send them if there is an error
        String errorPage = "Admin".equalsIgnoreCase(loginType) ? "admin_login.jsp" : "index.jsp";

        UserDAO dao = new UserDAO();
        String dbRole = dao.authenticate(u, p); // Get REAL role from DB

        if (dbRole != null) {

            // --- 2. STRICT SECURITY CHECK ---
            // If they are an Admin but tried to use the Staff page (or vice versa), BLOCK THEM.
            if (!dbRole.equalsIgnoreCase(loginType)) {
                request.setAttribute("errorMessage", "Access Denied: Please use the correct login portal.");
                request.getRequestDispatcher(errorPage).forward(request, response);
                return; // Stop execution!
            }

            // --- 3. SUCCESS ---
            HttpSession session = request.getSession();
            session.setAttribute("currentUser", u);
            session.setAttribute("role", dbRole);

            // Redirect based on Role
            if ("Admin".equalsIgnoreCase(dbRole)) {
                response.sendRedirect("admin_dashboard.jsp");
            } else {
                response.sendRedirect("staff_dashboard.jsp");
            }

        } else {
            // --- 4. FAILURE (Wrong password or user) ---
            request.setAttribute("errorMessage", "Invalid Username or Password");
            request.getRequestDispatcher(errorPage).forward(request, response);
        }
    }
}