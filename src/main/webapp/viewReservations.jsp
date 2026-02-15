<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.oceanview.data.ReservationDAO" %>
<%@ page import="java.util.List" %>
<%
    // 1. Security Check
    if (session.getAttribute("currentUser") == null) {
        response.sendRedirect("index.jsp"); // Fixed redirect
        return;
    }

    // --- DYNAMIC DASHBOARD LINK ---
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
    <title>All Reservations - Ocean View</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">

    <style>
        /* --- BACKGROUND & OVERLAY --- */
        body {
            background: url('https://images.unsplash.com/photo-1582719508461-905c673771fd?q=80&w=1920&auto=format&fit=crop');
            background-size: cover;
            background-attachment: fixed;
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
            padding: 2rem;
            margin: 0;
            color: white;
        }

        .overlay {
            position: fixed; top: 0; left: 0; width: 100vw; height: 100vh;
            background: rgba(15, 23, 42, 0.6);
            z-index: -1;
        }

        /* --- HEADER & CONTROLS --- */
        .header { display: flex; justify-content: space-between; align-items: center; margin-bottom: 25px; }

        .btn-back {
            background: rgba(255, 255, 255, 0.15);
            border: 1px solid rgba(255, 255, 255, 0.3);
            color: white;
            padding: 10px 20px;
            text-decoration: none;
            border-radius: 50px;
            font-weight: bold;
            transition: 0.3s;
            display: flex;
            align-items: center;
        }
        .btn-back:hover { background: rgba(255, 255, 255, 0.3); color: white; transform: translateY(-2px); }

        /* --- GLASS SEARCH BAR --- */
        .search-container {
            display: flex; gap: 10px; align-items: center;
            background: rgba(255, 255, 255, 0.1);
            backdrop-filter: blur(10px);
            padding: 12px;
            border-radius: 50px;
            border: 1px solid rgba(255, 255, 255, 0.2);
            box-shadow: 0 4px 15px rgba(0,0,0,0.3);
        }

        .search-box {
            background: rgba(0, 0, 0, 0.2);
            border: 1px solid rgba(255, 255, 255, 0.2);
            color: white;
            padding: 8px 15px;
            border-radius: 50px;
            width: 250px;
            outline: none;
        }
        .search-box::placeholder { color: rgba(255, 255, 255, 0.6); }
        .search-box:focus { border-color: #0ea5e9; box-shadow: 0 0 10px rgba(14, 165, 233, 0.4); }

        .btn-search {
            background: linear-gradient(135deg, #0ea5e9, #2563eb);
            color: white;
            border: none;
            padding: 8px 20px;
            border-radius: 50px;
            cursor: pointer;
            transition: 0.3s;
        }
        .btn-search:hover { transform: translateY(-2px); box-shadow: 0 4px 10px rgba(37, 99, 235, 0.4); }

        .btn-clear {
            background: rgba(255, 255, 255, 0.1);
            color: white;
            border: 1px solid rgba(255, 255, 255, 0.3);
            border-radius: 50px;
            padding: 8px 15px;
            text-decoration: none;
            transition: 0.3s;
        }
        .btn-clear:hover { background: rgba(220, 38, 38, 0.6); border-color: transparent; color: white; }

        /* --- GLASS TABLE --- */
        .table-container {
            background: rgba(255, 255, 255, 0.1);
            backdrop-filter: blur(15px);
            -webkit-backdrop-filter: blur(15px);
            border: 1px solid rgba(255, 255, 255, 0.2);
            border-radius: 20px;
            box-shadow: 0 8px 32px 0 rgba(0,0,0,0.5);
            overflow: hidden;
            margin-top: 20px;
            padding: 20px;
        }

        table { width: 100%; border-collapse: collapse; }
        th, td { padding: 15px; text-align: left; border-bottom: 1px solid rgba(255, 255, 255, 0.1); color: white; }
        th {
            background-color: rgba(0, 0, 0, 0.2);
            color: #0ea5e9;
            text-transform: uppercase;
            font-size: 14px;
            letter-spacing: 1px;
        }
        tr:hover td { background-color: rgba(255, 255, 255, 0.05); }

        /* --- BADGES --- */
        .badge { padding: 6px 12px; border-radius: 50px; font-size: 12px; font-weight: bold; text-transform: uppercase; letter-spacing: 0.5px; }
        .status-Confirmed { background: rgba(16, 185, 129, 0.2); color: #34d399; border: 1px solid rgba(16, 185, 129, 0.5); }
        .status-Pending { background: rgba(245, 158, 11, 0.2); color: #fbbf24; border: 1px solid rgba(245, 158, 11, 0.5); }
        .status-Cancelled { background: rgba(239, 68, 68, 0.2); color: #f87171; border: 1px solid rgba(239, 68, 68, 0.5); }

        /* --- ACTION BUTTONS --- */
        .actions a {
            text-decoration: none;
            padding: 8px 12px;
            border-radius: 8px;
            font-size: 14px;
            margin-right: 5px;
            transition: 0.2s;
            display: inline-block;
            color: white;
            border: 1px solid transparent;
        }

        .btn-edit { background: rgba(245, 158, 11, 0.2); border-color: rgba(245, 158, 11, 0.4); color: #fbbf24 !important; }
        .btn-edit:hover { background: rgba(245, 158, 11, 0.6); color: white !important; transform: translateY(-2px); }

        .btn-bill { background: rgba(14, 165, 233, 0.2); border-color: rgba(14, 165, 233, 0.4); color: #38bdf8 !important; }
        .btn-bill:hover { background: rgba(14, 165, 233, 0.6); color: white !important; transform: translateY(-2px); }

        .btn-del { background: rgba(239, 68, 68, 0.2); border-color: rgba(239, 68, 68, 0.4); color: #f87171 !important; }
        .btn-del:hover { background: rgba(239, 68, 68, 0.6); color: white !important; transform: translateY(-2px); }
    </style>
</head>
<body>

<div class="overlay"></div>

<div class="header">
    <div>
        <h2 class="mb-0" style="color: #0ea5e9; text-shadow: 0 2px 10px rgba(0,0,0,0.5);"><i class="fas fa-folder-open me-2"></i> Reservation List</h2>
        <% if (searchQuery != null && !searchQuery.isEmpty()) { %>
        <span class="d-inline-block mt-2" style="background: rgba(0,0,0,0.4); padding: 5px 15px; border-radius: 50px; font-size: 0.9rem; border: 1px solid rgba(255,255,255,0.2);">
            Showing results for: <b class="text-info">"<%= searchQuery %>"</b>
        </span>
        <% } %>
    </div>

    <div class="search-container">
        <form action="viewReservations.jsp" method="get" style="display:flex; gap:8px; margin: 0;">
            <input type="text" name="q" class="search-box" placeholder="Search Guest Name..." value="<%= (searchQuery != null) ? searchQuery : "" %>">
            <button type="submit" class="btn-search"><i class="fas fa-search"></i></button>
            <% if (searchQuery != null && !searchQuery.isEmpty()) { %>
            <a href="viewReservations.jsp" class="btn-clear" title="Clear Search"><i class="fas fa-times"></i></a>
            <% } %>
        </form>
        <div style="width: 1px; height: 30px; background: rgba(255,255,255,0.2); margin: 0 5px;"></div>
        <a href="<%= myDashboard %>" class="btn-back"><i class="fas fa-arrow-left me-2"></i> Dashboard</a>
    </div>
</div>

<div class="table-container">
    <table>
        <thead>
        <tr>
            <th>ID</th>
            <th>Guest Name</th>
            <th>Check-In</th>
            <th>Check-Out</th>
            <th>Total Cost</th>
            <th>Status</th>
            <th class="text-center">Actions</th>
        </tr>
        </thead>

        <tbody>
        <%
            if (list.isEmpty()) {
        %>
        <tr>
            <td colspan="7" class="text-center p-5" style="color: rgba(255,255,255,0.6);">
                <i class="fas fa-search mb-3" style="font-size: 40px; color: rgba(255,255,255,0.3);"></i><br>
                <h5 class="fw-light">No reservations found.</h5>
            </td>
        </tr>
        <%
        } else {
            for (String[] row : list) {
        %>
        <tr>
            <td class="text-secondary fw-bold">#<%= row[0] %></td>
            <td style="font-weight: 600;"><i class="fas fa-user-circle me-2 text-info"></i><%= row[1] %></td>
            <td><%= row[2] %></td>
            <td><%= row[3] %></td>
            <td style="font-family: monospace; font-size: 15px; color: #fbbf24;">LKR <%= row[4] %></td>

            <td><span class="badge status-<%= row[5] %>"><i class="fas fa-circle me-1" style="font-size: 8px; vertical-align: middle;"></i><%= row[5] %></span></td>

            <td class="actions text-center">
                <a href="editReservation.jsp?id=<%= row[0] %>" class="btn-edit" title="Edit Reservation">
                    <i class="fas fa-edit"></i>
                </a>

                <a href="bill.jsp?id=<%= row[0] %>" class="btn-bill" title="Generate Invoice">
                    <i class="fas fa-file-invoice-dollar"></i>
                </a>

                <a href="DeleteServlet?id=<%= row[0] %>" class="btn-del"
                   onclick="return confirm('Are you sure you want to delete <%= row[1] %>?');" title="Delete Reservation">
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