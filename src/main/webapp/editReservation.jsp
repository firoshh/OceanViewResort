<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.oceanview.data.ReservationDAO" %>
<%
    // 1. Security Check
    if (session.getAttribute("currentUser") == null) {
        response.sendRedirect("index.jsp");
        return;
    }

    // 2. Fetch Existing Data to Fill the Form
    String idStr = request.getParameter("id");
    String[] data = null;
    if (idStr != null) {
        int id = Integer.parseInt(idStr);
        ReservationDAO dao = new ReservationDAO();
        data = dao.getReservationDetails(id); // Use the method you added earlier!
    }

    // Safety: If ID is bad, go back
    if (data == null) {
        response.sendRedirect("viewReservations.jsp");
        return;
    }
%>
<!DOCTYPE html>
<html>
<head>
    <title>Edit Reservation</title>
    <style>
        body { font-family: 'Segoe UI', sans-serif; display: flex; justify-content: center; padding-top: 50px; background-color: #f1f5f9; }
        .form-card { background: white; padding: 2rem; border-radius: 10px; box-shadow: 0 4px 10px rgba(0,0,0,0.1); width: 400px; }
        h2 { text-align: center; margin-bottom: 20px; color: #333; }
        label { display: block; margin-top: 10px; font-weight: bold; color: #555; }
        input, select { width: 100%; padding: 10px; margin-top: 5px; border: 1px solid #ccc; border-radius: 5px; box-sizing: border-box; }
        .btn-update { width: 100%; padding: 12px; background-color: #f59e0b; color: white; border: none; border-radius: 5px; cursor: pointer; font-size: 16px; margin-top: 20px; font-weight: bold; }
        .btn-update:hover { background-color: #d97706; }
        .btn-cancel { display: block; text-align: center; margin-top: 15px; color: #64748b; text-decoration: none; }
    </style>
</head>
<body>

<div class="form-card">
    <h2>Edit Reservation #<%= idStr %></h2>

    <form action="UpdateServlet" method="post">
        <input type="hidden" name="id" value="<%= idStr %>">

        <label>Guest Name</label>
        <input type="text" name="name" value="<%= data[0] %>" required>

        <label>Address</label>
        <input type="text" name="address" value="<%= data[1] %>" required>

        <label>Contact No</label>
        <input type="text" name="phone" value="<%= data[2] %>" required pattern="\d{10}" title="Must be 10 digits">

        <label>Room Type</label>
        <select name="roomType">
            <option value="1" <%= data[3].equals("1") ? "selected" : "" %>>Single (LKR 5000)</option>
            <option value="2" <%= data[3].equals("2") ? "selected" : "" %>>Double (LKR 8500)</option>
            <option value="3" <%= data[3].equals("3") ? "selected" : "" %>>Suite (LKR 15000)</option>
        </select>

        <label>Check-In Date</label>
        <input type="date" name="checkIn" value="<%= data[4] %>" required>

        <label>Check-Out Date</label>
        <input type="date" name="checkOut" value="<%= data[5] %>" required>

        <button type="submit" class="btn-update">Update Reservation</button>
        <a href="viewReservations.jsp" class="btn-cancel">Cancel</a>
    </form>
</div>

</body>
</html>