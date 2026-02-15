<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.oceanview.data.RoomDAO" %>
<%@ page import="java.util.List" %>
<%@ page import="java.util.ArrayList" %>
<%
    // Security Check
    if (session.getAttribute("currentUser") == null) {
        response.sendRedirect("index.jsp"); // Fixed to point to your new login page
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
    <title>Manage Rooms - Admin Portal</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">
    <style>
        /* --- BACKGROUND & OVERLAY --- */
        body {
            background: url('https://images.unsplash.com/photo-1582719508461-905c673771fd?q=80&w=1920&auto=format&fit=crop');
            background-size: cover;
            background-attachment: fixed;
            min-height: 100vh;
            display: flex;
            align-items: center;
            justify-content: center;
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
            margin: 0;
            padding: 40px 0;
            color: white;
        }

        .overlay {
            position: fixed; top: 0; left: 0; width: 100vw; height: 100vh;
            background: rgba(15, 23, 42, 0.6); /* Darker admin overlay */
            z-index: -1;
        }

        /* --- GLASS CONTAINER --- */
        .glass-container {
            background: rgba(255, 255, 255, 0.1);
            backdrop-filter: blur(15px);
            -webkit-backdrop-filter: blur(15px);
            border: 1px solid rgba(255, 255, 255, 0.2);
            border-radius: 20px;
            box-shadow: 0 8px 32px 0 rgba(0,0,0,0.5);
            padding: 40px;
            width: 100%;
            max-width: 900px;
        }

        /* --- GLASS CARDS (For Add Room Section) --- */
        .glass-card {
            background: rgba(0, 0, 0, 0.2);
            border: 1px solid rgba(255, 255, 255, 0.15);
            border-radius: 15px;
            padding: 25px;
            margin-bottom: 30px;
        }

        /* --- GLASS INPUTS --- */
        .form-control {
            background: rgba(255, 255, 255, 0.1);
            border: 1px solid rgba(255, 255, 255, 0.2);
            color: white;
            border-radius: 8px;
            padding: 10px 15px;
        }

        .form-control::placeholder { color: rgba(255, 255, 255, 0.5); }

        .form-control:focus {
            background: rgba(255, 255, 255, 0.2);
            color: white;
            border-color: #d4af37; /* Gold focus for Admin */
            box-shadow: 0 0 10px rgba(212, 175, 55, 0.4);
        }

        /* --- GLASS TABLE --- */
        .table-glass { color: white; margin-top: 10px; }
        .table-glass th {
            background: rgba(212, 175, 55, 0.15);
            color: #d4af37;
            border-color: rgba(255, 255, 255, 0.1);
            font-weight: 600;
            text-transform: uppercase;
            font-size: 0.9rem;
            padding: 15px;
        }
        .table-glass td {
            border-color: rgba(255, 255, 255, 0.1);
            background: rgba(0, 0, 0, 0.1);
            vertical-align: middle;
            padding: 12px;
        }

        /* --- BUTTONS --- */
        .btn-admin {
            background: linear-gradient(135deg, #d4af37, #b4932a);
            border: none;
            color: white;
            border-radius: 8px;
            font-weight: bold;
            transition: 0.3s;
        }
        .btn-admin:hover {
            background: linear-gradient(135deg, #b4932a, #8f7520);
            transform: translateY(-2px);
            box-shadow: 0 4px 15px rgba(212, 175, 55, 0.4);
            color: white;
        }

        .btn-danger-glass {
            background: rgba(220, 38, 38, 0.6);
            border: 1px solid rgba(220, 38, 38, 0.8);
            color: white;
            transition: 0.3s;
        }
        .btn-danger-glass:hover {
            background: rgba(220, 38, 38, 0.9);
            color: white;
            transform: translateY(-2px);
        }

        .btn-back {
            background: rgba(255, 255, 255, 0.1);
            border: 1px solid rgba(255, 255, 255, 0.3);
            color: white;
            border-radius: 50px;
            padding: 10px 30px;
            transition: 0.3s;
            text-decoration: none;
            display: inline-block;
        }
        .btn-back:hover {
            background: rgba(255, 255, 255, 0.2);
            color: white;
            transform: translateY(-2px);
        }

        .alert-glass {
            background: rgba(14, 165, 233, 0.2);
            border: 1px solid rgba(14, 165, 233, 0.4);
            color: #bae6fd;
            backdrop-filter: blur(5px);
        }
    </style>
</head>
<body>

<div class="overlay"></div>

<div class="container">
    <div class="glass-container mx-auto">
        <h2 class="mb-4" style="color: #d4af37; text-shadow: 0 2px 10px rgba(0,0,0,0.5);">
            <i class="fas fa-bed me-2"></i> Manage Room Prices
        </h2>

        <% if (!msg.isEmpty()) { %>
        <div class="alert alert-glass rounded"><i class="fas fa-info-circle me-2"></i><%= msg %></div>
        <% } %>

        <div class="glass-card">
            <h5 class="mb-3" style="color: #cbd5e1;"><i class="fas fa-plus-circle me-2 text-warning"></i>Add New Room Type</h5>
            <form method="post" action="manageRooms.jsp" class="row g-3 align-items-end">
                <input type="hidden" name="action" value="add">

                <div class="col-md-5">
                    <label class="form-label text-light">Room Name</label>
                    <input type="text" name="name" class="form-control" placeholder="e.g. Family Suite" required>
                </div>
                <div class="col-md-5">
                    <label class="form-label text-light">Price (LKR)</label>
                    <input type="number" name="price" class="form-control" placeholder="e.g. 25000" required>
                </div>
                <div class="col-md-2">
                    <button type="submit" class="btn btn-admin w-100 p-2">
                        <i class="fas fa-plus"></i> Add
                    </button>
                </div>
            </form>
        </div>

        <div class="table-responsive">
            <table class="table table-glass align-middle">
                <thead>
                <tr>
                    <th>ID</th>
                    <th>Room Name</th>
                    <th>Price (LKR)</th>
                    <th class="text-center" style="width: 200px;">Actions</th>
                </tr>
                </thead>
                <tbody>
                <% for (String[] r : rooms) { %>
                <tr>
                    <form method="post" action="manageRooms.jsp">
                        <input type="hidden" name="action" value="update">
                        <input type="hidden" name="id" value="<%= r[0] %>">

                        <td class="fw-bold text-secondary">#<%= r[0] %></td>
                        <td>
                            <input type="text" name="name" value="<%= r[1] %>" class="form-control">
                        </td>
                        <td>
                            <input type="number" name="price" value="<%= r[2] %>" class="form-control">
                        </td>
                        <td class="text-center">
                            <button type="submit" class="btn btn-admin btn-sm me-2 px-3">
                                <i class="fas fa-save"></i>
                            </button>

                            <a href="manageRooms.jsp?action=delete&id=<%= r[0] %>"
                               class="btn btn-danger-glass btn-sm px-3"
                               onclick="return confirm('Are you sure? Note: You cannot delete a room type if guests have booked it.')" title="Delete Room">
                                <i class="fas fa-trash"></i>
                            </a>
                        </td>
                    </form>
                </tr>
                <% } %>
                </tbody>
            </table>
        </div>

        <div class="mt-4">
            <a href="admin_dashboard.jsp" class="btn btn-back"><i class="fas fa-arrow-left me-2"></i> Back to Dashboard</a>
        </div>
    </div>
</div>

</body>
</html>