<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.oceanview.data.ReservationDAO" %>
<%@ page import="java.util.List" %>
<%
    // 1. Security Check
    if (session.getAttribute("currentUser") == null) {
        response.sendRedirect("index.jsp");
        return;
    }

    // 2. FETCH DATA (Smart Logic)
    ReservationDAO dao = new ReservationDAO();
    List<String[]> list;

    // Check if the user typed something in the Search Bar
    String searchQuery = request.getParameter("q");

    if (searchQuery != null && !searchQuery.trim().isEmpty()) {
        // Search Mode: Show only matches
        list = dao.searchReservations(searchQuery);
    } else {
        // Default Mode: Show everything
        list = dao.getAllReservations();
    }
%>
<!DOCTYPE html>
<html>
<head>
    <title>All Reservations</title>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">
    <style>
        body { font-family: 'Segoe UI', sans-serif; padding: 2rem; background-color: #f8fafc; }

        .header { display: flex; justify-content: space-between; align-items: center; margin-bottom: 20px; }

        .btn-back { background: #64748b; color: white; padding: 10px 20px; text-decoration: none; border-radius: 5px; font-weight: bold; }
        .btn-back:hover { background: #475569; }

        /* Search Bar Style */
        .search-container { display: flex; gap: 10px; align-items: center; background: white; padding: 10px; border-radius: 8px; box-shadow: 0 2px 5px rgba(0,0,0,0.05); }
        .search-box { padding: 8px; border: 1px solid #cbd5e1; border-radius: 4px; width: 250px; }
        .btn-search { background: #3b82f6; color: white; border: none; padding: 8px 15px; border-radius: 4px; cursor: pointer; }
        .btn-clear { background: #94a3b8; color: white; text-decoration: none; padding: 8px 15px; border-radius: 4px; font-size: 14px; }

        table { width: 100%; border-collapse: collapse; background: white; box-shadow: 0 4px 6px rgba(0,0,0,0.1); border-radius: 8px; overflow: hidden; margin-top: 20px; }
        th, td { padding: 15px; text-align: left; border-bottom: 1px solid #e2e8f0; }
        th { background-color: #1e293b; color: white; text-transform: uppercase; font-size: 14px; letter-spacing: 0.5px; }
        tr:hover { background-color: #f1f5f9; }

        .badge { padding: 5px 10px; border-radius: 20px; font-size: 12px; font-weight: bold; }
        .confirmed { background: #dcfce7; color: #166534; border: 1px solid #bbf7d0; }

        .actions a { text-decoration: none; padding: 6px 12px; border-radius: 4px; font-size: 13px; margin-right: 5px; font-weight: 600; transition: 0.2s; }
        .btn-edit { background: #fbbf24; color: #78350f; }
        .btn-edit:hover { background: #d97706; color: white; }
        .btn-del { background: #ef4444; color: white; }
        .btn-del:hover { background: #dc2626; }

        .empty-state { text-align: center; padding: 40px; color: #64748b; font-size: 18px; }
    </style>
</head>
<body>

<div class="header">
    <div>
        <h2>📂 Reservation List</h2>
        <% if (searchQuery != null && !searchQuery.isEmpty()) { %>
        <span style="color: #64748b;">Showing results for: <b>"<%= searchQuery %>"</b></span>
        <% } %>
    </div>

    <div class="search-container">
        <form action="viewReservations.jsp" method="get" style="display:flex; gap:5px;">
            <input type="text" name="q" class="search-box" placeholder="Search Guest Name..." value="<%= (searchQuery != null) ? searchQuery : "" %>">
            <button type="submit" class="btn-search"><i class="fas fa-search"></i></button>
            <% if (searchQuery != null && !searchQuery.isEmpty()) { %>
            <a href="viewReservations.jsp" class="btn-clear">Clear</a>
            <% } %>
        </form>
        <a href="dashboard.jsp" class="btn-back">← Dashboard</a>
    </div>
</div>

<table>
    <thead>
    <tr>
        <th>ID</th>
        <th>Guest Name</th>
        <th>Check-In</th>
        <th>Check-Out</th>
        <th>Total Cost</th>
        <th>Status</th>
        <th>Actions</th>
    </tr>
    </thead>
    <tbody>
    <%
        if (list.isEmpty()) {
    %>
    <tr>
        <td colspan="7" class="empty-state">
            <i class="fas fa-folder-open" style="font-size: 40px; margin-bottom: 10px; display:block;"></i>
            No reservations found.
        </td>
    </tr>
    <%
    } else {
        for (String[] row : list) {
    %>
    <tr>
        <td>#<%= row[0] %></td> <td style="font-weight: bold; color: #334155;"><%= row[1] %></td> <td><%= row[2] %></td> <td><%= row[3] %></td> <td style="font-family: monospace; font-size: 14px;">LKR <%= row[4] %></td> <td><span class="badge confirmed"><%= row[5] %></span></td> <td class="actions">
        <a href="editReservation.jsp?id=<%= row[0] %>" class="btn-edit"><i class="fas fa-edit"></i> Edit</a>
        <a href="DeleteServlet?id=<%= row[0] %>" class="btn-del" onclick="return confirm('Are you sure you want to delete <%= row[1] %>?');"><i class="fas fa-trash"></i> Delete</a>
    </td>
    </tr>
    <%
            }
        }
    %>
    </tbody>
</table>

</body>
</html>