<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.oceanview.data.ReservationDAO" %>
<%
    if (session.getAttribute("currentUser") == null) {
        response.sendRedirect("index.jsp");
        return;
    }
    int id = Integer.parseInt(request.getParameter("id"));
    ReservationDAO dao = new ReservationDAO();
    String[] data = dao.getReservationDetails(id);
    // data[] indices: 0=Name, 1=Address, 2=Phone, 3=Type, 4=In, 5=Out, 6=Status
%>
<!DOCTYPE html>
<html>
<head>
    <title>Edit Reservation</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
</head>
<body class="bg-light">
<div class="container mt-5">
    <div class="card shadow p-4 mx-auto" style="max-width: 600px;">
        <h3 class="text-center mb-4">Edit Reservation #<%= id %></h3>

        <form action="UpdateServlet" method="post">
            <input type="hidden" name="id" value="<%= id %>">

            <div class="mb-3">
                <label>Guest Name</label>
                <input type="text" name="name" class="form-control" value="<%= data[0] %>" required>
            </div>

            <div class="mb-3">
                <label>Address</label>
                <input type="text" name="address" class="form-control" value="<%= data[1] %>" required>
            </div>

            <div class="mb-3">
                <label>Contact Number</label>
                <input type="text" name="phone" class="form-control" value="<%= data[2] %>" required pattern="\d{10}">
            </div>

            <div class="mb-3">
                <label class="fw-bold text-primary">Reservation Status</label>
                <select name="status" class="form-select border-primary">
                    <option value="Confirmed" <%= data[6].equals("Confirmed") ? "selected" : "" %>>✅ Confirmed</option>
                    <option value="Pending" <%= data[6].equals("Pending") ? "selected" : "" %>>⏳ Pending</option>
                    <option value="Cancelled" <%= data[6].equals("Cancelled") ? "selected" : "" %>>❌ Cancelled</option>
                </select>
            </div>

            <div class="mb-3">
                <label>Room Type</label>
                <select name="roomType" class="form-select">
                    <option value="1" <%= data[3].equals("1") ? "selected" : "" %>>Single Room</option>
                    <option value="2" <%= data[3].equals("2") ? "selected" : "" %>>Double Room</option>
                    <option value="3" <%= data[3].equals("3") ? "selected" : "" %>>Suite</option>
                </select>
            </div>

            <div class="row">
                <div class="col-6 mb-3">
                    <label>Check-In</label>
                    <input type="date" name="checkIn" class="form-control" value="<%= data[4] %>" required>
                </div>
                <div class="col-6 mb-3">
                    <label>Check-Out</label>
                    <input type="date" name="checkOut" class="form-control" value="<%= data[5] %>" required>
                </div>
            </div>

            <div class="d-grid gap-2">
                <button type="submit" class="btn btn-warning text-white fw-bold">Update Reservation</button>
                <a href="viewReservations.jsp" class="btn btn-secondary">Cancel</a>
            </div>
        </form>
    </div>
</div>
</body>
</html>