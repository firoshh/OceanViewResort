package com.oceanview.servlet;

import com.oceanview.data.UserDAO;
import java.io.IOException;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

// This annotation tells Tomcat: "When the form sends data here, run this code."
@WebServlet("/LoginServlet")
public class LoginServlet extends HttpServlet {

    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {

        // 1. Get the text typed in the boxes
        String user = request.getParameter("username");
        String pass = request.getParameter("password");

        // 2. Validate using the Database (Just like the Desktop App)
        UserDAO dao = new UserDAO();

        if (dao.validateUser(user, pass)) {
            // SUCCESS: Save user in session so they stay logged in
            HttpSession session = request.getSession();
            session.setAttribute("currentUser", user);

            // Go to Dashboard
            response.sendRedirect("dashboard.jsp");
        } else {
            // FAILURE: Send them back to Login with an error message
            request.setAttribute("errorMessage", "Invalid Username or Password!");
            request.getRequestDispatcher("index.jsp").forward(request, response);
        }
    }
}