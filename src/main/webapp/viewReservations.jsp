<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.oceanview.data.ReservationDAO" %>
<%@ page import="java.util.List" %>
<%
    // 1. Security Check
    if (session.getAttribute("currentUser") == null) {
        response.sendRedirect("login.jsp");
        return;
    }

    // --- NEW: DYNAMIC DASHBOARD LINK ---
    String myDashboard = "staff_dashboard.jsp"; // Default to staff
    if ("Admin".equalsIgnoreCase((String) session.getAttribute("role"))) {
        myDashboard = "admin_dashboard.jsp"; // Change to admin if they are an admin
    }
    // -----------------------------------

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
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">
    <link rel="stylesheet" href="css/style.css">

    <style>
        body { font-family: 'Segoe UI', sans-serif; padding: 2rem; }

        .header { display: flex; justify-content: space-between; align-items: center; margin-bottom: 20px; }

        .btn-back { background: #64748b; color: white; padding: 10px 20px; text-decoration: none; border-radius: 5px; font-weight: bold; }
        .btn-back:hover { background: #475569; }

        .search-container { display: flex; gap: 10px; align-items: center; background: white; padding: 10px; border-radius: 8px; box-shadow: 0 2px 5px rgba(0,0,0,0.05); }
        .search-box { padding: 8px; border: 1px solid #cbd5e1; border-radius: 4px; width: 250px; }
        .btn-search { background: #3b82f6; color: white; border: none; padding: 8px 15px; border-radius: 4px; cursor: pointer; }

        table { width: 100%; border-collapse: collapse; background: white; box-shadow: 0 4px 6px rgba(0,0,0,0.1); border-radius: 8px; overflow: hidden; margin-top: 20px; }
        th, td { padding: 15px; text-align: left; border-bottom: 1px solid #e2e8f0; }
        th { background-color: #1e293b; color: white; text-transform: uppercase; font-size: 14px; letter-spacing: 0.5px; }
        tr:hover { background-color: #f1f5f9; }

        .badge { padding: 5px 10px; border-radius: 20px; font-size: 12px; font-weight: bold; display: inline-block; }
        .status-Confirmed { background: #dcfce7; color: #166534; border: 1px solid #bbf7d0; }
        .status-Pending { background: #fef3c7; color: #92400e; border: 1px solid #fbbf24; }
        .status-Cancelled { background: #fee2e2; color: #b91c1c; border: 1px solid #f87171; }

        .actions a { text-decoration: none; padding: 6px 12px; border-radius: 4px; font-size: 13px; margin-right: 5px; font-weight: 600; transition: 0.2s; display: inline-block; }

        .btn-edit { background: #fbbf24; color: #78350f; }
        .btn-edit:hover { background: #d97706; color: white; }

        .btn-bill { background: #3b82f6; color: white; }
        .btn-bill:hover { background: #1d4ed8; color: white; }

        .btn-del { background: #ef4444; color: white; }
        .btn-del:hover { background: #dc2626; }
    </style>
</head>
<body>

<div class="header">
    <div>
        <h2 class="text-white" style="text-shadow: 1px 1px 4px black;">📂 Reservation List</h2>
        <% if (searchQuery != null && !searchQuery.isEmpty()) { %>
        <span class="text-white" style="background: rgba(0,0,0,0.5); padding: 5px; border-radius: 4px;">
                Showing results for: <b>"<%= searchQuery %>"</b>
            </span>
        <% } %>
    </div>

    <div class="search-container">
        <form action="viewReservations.jsp" method="get" style="display:flex; gap:5px;">
            <input type="text" name="q" class="search-box" placeholder="Search Guest Name..." value="<%= (searchQuery != null) ? searchQuery : "" %>">
            <button type="submit" class="btn-search"><i class="fas fa-search"></i></button>
            <% if (searchQuery != null && !searchQuery.isEmpty()) { %>
            <a href="viewReservations.jsp" class="btn btn-secondary btn-sm" style="padding: 8px;">Clear</a>
            <% } %>
        </form>
        <a href="<%= myDashboard %>" class="btn-back">← Dashboard</a>
    </div>
</div>

<div class="table-container"> <table>
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
        <td colspan="7" class="text-center p-5 text-muted">
            <i class="fas fa-folder-open mb-3" style="font-size: 40px;"></i><br>
            No reservations found.
        </td>
    </tr>
    <%
    } else {
        for (String[] row : list) {
    %>
    <tr>
        <td>#<%= row[0] %></td>
        <td style="font-weight: bold; color: #334155;"><%= row[1] %></td>
        <td><%= row[2] %></td>
        <td><%= row[3] %></td>
        <td style="font-family: monospace; font-size: 14px;">LKR <%= row[4] %></td>

        <td><span class="badge status-<%= row[5] %>"><%= row[5] %></span></td>

        <td class="actions">
            <a href="editReservation.jsp?id=<%= row[0] %>" class="btn-edit" title="Edit">
                <i class="fas fa-edit"></i>
            </a>

            <a href="bill.jsp?id=<%= row[0] %>" class="btn-bill" title="Generate Invoice">
                <i class="fas fa-file-invoice-dollar"></i>
            </a>

            <a href="DeleteServlet?id=<%= row[0] %>" class="btn-del"
               onclick="return confirm('Are you sure you want to delete <%= row[1] %>?');" title="Delete">
                <i class="fas fa-trash"></i>
            </a>
        </td>
    </tr>
    <%
            }
        }
    %>
    </tbody>
</table>
</div>

</body>
</html>