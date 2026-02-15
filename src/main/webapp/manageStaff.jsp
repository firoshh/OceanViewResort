<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.oceanview.data.UserDAO" %>
<%@ page import="java.util.List" %>
<%@ page import="java.util.ArrayList" %>
<%
    // Security Check
    if (session.getAttribute("currentUser") == null) {
        response.sendRedirect("index.jsp"); // Fixed to new login
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
    <title>Manage Staff - Admin Portal</title>
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
            background: rgba(15, 23, 42, 0.6); /* Admin dark overlay */
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

        /* --- GLASS CARDS (For Add User Section) --- */
        .glass-card {
            background: rgba(0, 0, 0, 0.2);
            border: 1px solid rgba(255, 255, 255, 0.15);
            border-radius: 15px;
            padding: 25px;
            margin-bottom: 30px;
        }

        /* --- GLASS INPUTS --- */
        .form-control, .form-select {
            background: rgba(255, 255, 255, 0.1);
            border: 1px solid rgba(255, 255, 255, 0.2);
            color: white;
            border-radius: 8px;
            padding: 10px 15px;
        }

        .form-control::placeholder { color: rgba(255, 255, 255, 0.5); }

        .form-control:focus, .form-select:focus {
            background: rgba(255, 255, 255, 0.2);
            color: white;
            border-color: #d4af37; /* Gold focus for Admin */
            box-shadow: 0 0 10px rgba(212, 175, 55, 0.4);
        }

        /* Dropdown options fix */
        option { background-color: #1e293b; color: white; }

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
            border-radius: 8px;
            transition: 0.3s;
        }
        .btn-danger-glass:hover {
            background: rgba(220, 38, 38, 0.9);
            color: white;
            transform: translateY(-2px);
            box-shadow: 0 4px 15px rgba(220, 38, 38, 0.4);
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

        .badge-admin { background: rgba(212, 175, 55, 0.2); color: #d4af37; border: 1px solid rgba(212, 175, 55, 0.5); }
        .badge-staff { background: rgba(14, 165, 233, 0.2); color: #38bdf8; border: 1px solid rgba(14, 165, 233, 0.5); }
    </style>
</head>
<body>

<div class="overlay"></div>

<div class="container">
    <div class="glass-container mx-auto">
        <h2 class="mb-4" style="color: #d4af37; text-shadow: 0 2px 10px rgba(0,0,0,0.5);">
            <i class="fas fa-users-cog me-2"></i> Manage Staff
        </h2>

        <% if(!msg.isEmpty()) { %>
        <div class="alert alert-glass rounded"><i class="fas fa-info-circle me-2"></i><%= msg %></div>
        <% } %>

        <div class="glass-card">
            <h5 class="mb-3" style="color: #cbd5e1;"><i class="fas fa-user-plus me-2 text-warning"></i>Add New Staff Member</h5>
            <form method="post" class="row g-3 align-items-end">
                <input type="hidden" name="action" value="add">
                <div class="col-md-3">
                    <label class="form-label text-light">Username</label>
                    <input type="text" name="u" class="form-control" placeholder="Username" required>
                </div>
                <div class="col-md-3">
                    <label class="form-label text-light">Password</label>
                    <input type="password" name="p" class="form-control" placeholder="Password" required>
                </div>
                <div class="col-md-3">
                    <label class="form-label text-light">Role</label>
                    <select name="r" class="form-select">
                        <option value="Staff">Staff</option>
                        <option value="Admin">Admin</option>
                    </select>
                </div>
                <div class="col-md-3">
                    <button type="submit" class="btn btn-admin w-100 p-2"><i class="fas fa-plus me-2"></i>Add User</button>
                </div>
            </form>
        </div>

        <div class="table-responsive">
            <table class="table table-glass align-middle text-center">
                <thead>
                <tr>
                    <th>ID</th>
                    <th>Username</th>
                    <th>Role</th>
                    <th>Action</th>
                </tr>
                </thead>
                <tbody>
                <% for(String[] user : users) { %>
                <tr>
                    <td class="text-secondary fw-bold">#<%= user[0] %></td>
                    <td class="fw-bold"><i class="fas fa-user-circle me-2 text-muted"></i><%= user[1] %></td>
                    <td>
                            <span class="badge <%= "Admin".equals(user[2]) ? "badge-admin" : "badge-staff" %> px-3 py-2 rounded-pill">
                                <%= user[2] %>
                            </span>
                    </td>
                    <td>
                        <a href="manageStaff.jsp?action=delete&id=<%= user[0] %>"
                           class="btn btn-danger-glass btn-sm px-3"
                           onclick="return confirm('Are you sure you want to delete this user?')">
                            <i class="fas fa-user-times me-1"></i> Remove
                        </a>
                    </td>
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