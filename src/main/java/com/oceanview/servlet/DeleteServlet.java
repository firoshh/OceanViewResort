package com.oceanview.servlet;

import com.oceanview.data.ReservationDAO;
import java.io.IOException;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

@WebServlet("/DeleteServlet")
public class DeleteServlet extends HttpServlet {

    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        // 1. Get ID from URL parameter
        String idStr = request.getParameter("id");

        if (idStr != null) {
            int id = Integer.parseInt(idStr);

            // 2. Delete from DB
            ReservationDAO dao = new ReservationDAO();
            dao.deleteReservation(id);
        }

        // 3. Go back to the table
        response.sendRedirect("viewReservations.jsp");
    }
}