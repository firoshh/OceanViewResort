package com.oceanview.servlet;

import com.oceanview.data.ReservationDAO;
import java.io.IOException;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

@WebServlet("/AddServlet")
public class AddServlet extends HttpServlet {
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String name = request.getParameter("name");
        String addr = request.getParameter("address");
        String phone = request.getParameter("phone");
        int typeId = Integer.parseInt(request.getParameter("roomType"));
        String in = request.getParameter("checkIn");
        String out = request.getParameter("checkOut");

        ReservationDAO dao = new ReservationDAO();
        if(dao.addReservation(name, addr, phone, typeId, in, out)) {
            response.sendRedirect("viewReservations.jsp");
        } else {
            response.getWriter().println("Error saving reservation.");
        }
    }
}