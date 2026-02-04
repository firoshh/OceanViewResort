package com.oceanview.servlet;

import com.oceanview.data.ReservationDAO;
import java.io.IOException;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

@WebServlet("/UpdateServlet")
public class UpdateServlet extends HttpServlet {

    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        try {
            // 1. Capture all the data from the form
            int id = Integer.parseInt(request.getParameter("id"));
            String name = request.getParameter("name");
            String addr = request.getParameter("address");
            String phone = request.getParameter("phone");
            int typeId = Integer.parseInt(request.getParameter("roomType"));
            String in = request.getParameter("checkIn");
            String out = request.getParameter("checkOut");

            // 2. NEW: Capture the Status (Confirmed/Pending/Cancelled)
            String status = request.getParameter("status");

            // 3. Send it to the DAO
            ReservationDAO dao = new ReservationDAO();
            boolean success = dao.updateFullReservation(id, name, addr, phone, typeId, in, out, status);

            if (success) {
                response.sendRedirect("viewReservations.jsp");
            } else {
                response.getWriter().println("Error updating reservation.");
            }

        } catch (Exception e) {
            e.printStackTrace();
        }
    }
}