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
            // 1. Get Data from Form
            int id = Integer.parseInt(request.getParameter("id"));
            String name = request.getParameter("name");
            String addr = request.getParameter("address");
            String phone = request.getParameter("phone");
            int typeId = Integer.parseInt(request.getParameter("roomType"));
            String in = request.getParameter("checkIn");
            String out = request.getParameter("checkOut");

            // 2. Update Database (Using your existing DAO method!)
            ReservationDAO dao = new ReservationDAO();
            boolean success = dao.updateFullReservation(id, name, addr, phone, typeId, in, out);

            // 3. Redirect back to list
            if (success) {
                response.sendRedirect("viewReservations.jsp");
            } else {
                // If it failed, maybe show an error page (optional)
                response.getWriter().println("Error updating reservation.");
            }

        } catch (Exception e) {
            e.printStackTrace();
        }
    }
}