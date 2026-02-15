<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.oceanview.data.RoomDAO" %>
<%@ page import="java.util.List" %>
<%@ page import="java.util.ArrayList" %>
<%
    // Security Check
    if (session.getAttribute("currentUser") == null) {
        response.sendRedirect("login.jsp");
        return;
    }

    RoomDAO dao = new RoomDAO();
    String msg = "";
    String action = request.getParameter("action");

    // --- HANDLE ACTIONS ---

    // 1. Update Room
    if ("update".equals(action)) {
        boolean ok = dao.updateRoomType(request.getParameter("id"), request.getParameter("name"), request.getParameter("price"));
        if(ok) msg = "Room Updated Successfully!";
    }

    // 2. Add New Room
    if ("add".equals(action)) {
        boolean ok = dao.addRoomType(request.getParameter("name"), request.getParameter("price"));
        if(ok) msg = "New Room Type Added!";
    }

    // 3. Delete Room
    if ("delete".equals(action)) {
        boolean ok = dao.deleteRoomType(request.getParameter("id"));
        if(ok) msg = "Room Deleted.";
        else msg = "Cannot delete: This room type is used in existing reservations!";
    }

    // Get List
    List<String[]> rooms = dao.getAllRoomTypes();
%>
<!DOCTYPE html>
<html>
<head>
    <title>Manage Rooms</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">
    <style> body { background-color: #f8f9fa; padding: 40px; } </style>
</head>
<body>
<div class="container bg-white p-5 rounded shadow">
    <h2 class="mb-4"><i class="fas fa-bed"></i> Manage Room Prices</h2>

    <% if (!msg.isEmpty()) { %>
    <div class="alert alert-info"><%= msg %></div>
    <% } %>

    <div class="card p-3 mb-4 bg-light">
        <h5>Add New Room Type</h5>
        <form method="post" action="manageRooms.jsp" class="row g-2 align-items-end">
            <input type="hidden" name="action" value="add">

            <div class="col-md-5">
                <label>Room Name</label>
                <input type="text" name="name" class="form-control" placeholder="e.g. Family Suite" required>
            </div>
            <div class="col-md-5">
                <label>Price (LKR)</label>
                <input type="number" name="price" class="form-control" placeholder="e.g. 25000" required>
            </div>
            <div class="col-md-2">
                <button type="submit" class="btn btn-success w-100">
                    <i class="fas fa-plus"></i> Add
                </button>
            </div>
        </form>
    </div>

    <table class="table table-bordered align-middle">
        <thead class="table-dark">
        <tr>
            <th>ID</th>
            <th>Room Name</th>
            <th>Price (LKR)</th>
            <th style="width: 200px;">Actions</th>
        </tr>
        </thead>
        <tbody>
        <% for (String[] r : rooms) { %>
        <tr>
            <form method="post" action="manageRooms.jsp">
                <input type="hidden" name="action" value="update">
                <input type="hidden" name="id" value="<%= r[0] %>">

                <td>#<%= r[0] %></td>
                <td>
                    <input type="text" name="name" value="<%= r[1] %>" class="form-control">
                </td>
                <td>
                    <input type="number" name="price" value="<%= r[2] %>" class="form-control">
                </td>
                <td>
                    <button type="submit" class="btn btn-primary btn-sm me-2">
                        <i class="fas fa-save"></i> Save
                    </button>

                    <a href="manageRooms.jsp?action=delete&id=<%= r[0] %>"
                       class="btn btn-danger btn-sm"
                       onclick="return confirm('Are you sure? Note: You cannot delete a room type if guests have booked it.')">
                        <i class="fas fa-trash"></i>
                    </a>
                </td>
            </form>
        </tr>
        <% } %>
        </tbody>
    </table>

    <a href="admin_dashboard.jsp" class="btn btn-secondary mt-3">Back to Dashboard</a>
</div>
</body>
</html>