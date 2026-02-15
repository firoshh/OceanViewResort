<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.oceanview.data.UserDAO" %>
<%@ page import="java.util.List" %>
<%@ page import="java.util.ArrayList" %>
<%
    // Security Check
    if (session.getAttribute("currentUser") == null) {
        response.sendRedirect("login.jsp");
        return;
    }

    UserDAO dao = new UserDAO();
    String msg = "";
    String action = request.getParameter("action");

    // Handle Adding User
    if ("add".equals(action)) {
        boolean ok = dao.addUser(request.getParameter("u"), request.getParameter("p"), request.getParameter("r"));
        if(ok) msg = "User added successfully!";
    }
    // Handle Deleting User
    if ("delete".equals(action)) {
        boolean ok = dao.deleteUser(request.getParameter("id"));
        if(ok) msg = "User deleted.";
    }

    // Get List (with safety check)
    List<String[]> users = dao.getAllUsers();
    if (users == null) users = new ArrayList<>();
%>
<!DOCTYPE html>
<html>
<head>
    <title>Manage Staff</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
</head>
<body class="p-4 bg-light">
<div class="container bg-white p-4 rounded shadow">
    <h3>👤 Manage Staff</h3>

    <% if(!msg.isEmpty()) { %>
    <div class="alert alert-info"><%= msg %></div>
    <% } %>

    <div class="card p-3 mb-4 bg-light">
        <h5>Add New Staff Member</h5>
        <form method="post" class="row g-2">
            <input type="hidden" name="action" value="add">
            <div class="col-md-3"><input type="text" name="u" class="form-control" placeholder="Username" required></div>
            <div class="col-md-3"><input type="text" name="p" class="form-control" placeholder="Password" required></div>
            <div class="col-md-3">
                <select name="r" class="form-select">
                    <option value="Staff">Staff</option>
                    <option value="Admin">Admin</option>
                </select>
            </div>
            <div class="col-md-3"><button class="btn btn-success w-100">Add</button></div>
        </form>
    </div>

    <table class="table table-bordered">
        <thead class="table-dark"><tr><th>ID</th><th>Username</th><th>Role</th><th>Action</th></tr></thead>
        <tbody>
        <% for(String[] user : users) { %>
        <tr>
            <td><%= user[0] %></td>
            <td><%= user[1] %></td>
            <td><%= user[2] %></td>
            <td>
                <a href="manageStaff.jsp?action=delete&id=<%= user[0] %>"
                   class="btn btn-danger btn-sm"
                   onclick="return confirm('Delete this user?')">Remove</a>
            </td>
        </tr>
        <% } %>
        </tbody>
    </table>
    <a href="admin_dashboard.jsp" class="btn btn-secondary">Back to Dashboard</a>
</div>
</body>
</html>