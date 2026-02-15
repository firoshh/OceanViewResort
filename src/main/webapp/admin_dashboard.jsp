<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.oceanview.data.ReservationDAO" %>
<%
    if (session.getAttribute("currentUser") == null) {
        response.sendRedirect("index.jsp");
        return;
    }

    ReservationDAO dao = new ReservationDAO();
    int[] stats = dao.getDashboardStats();
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Ocean View Admin Dashboard</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">
    <style>
        /* --- BACKGROUND & OVERLAY --- */
        body {
            background: url('https://images.unsplash.com/photo-1582719508461-905c673771fd?q=80&w=1920&auto=format&fit=crop');
            background-size: cover;
            background-attachment: fixed;
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
            margin: 0;
            color: #ffffff;
        }

        .overlay {
            position: fixed; top: 0; left: 0; width: 100vw; height: 100vh;
            background: rgba(15, 23, 42, 0.6); /* Darker tint for Admin */
            z-index: -1; /* Keeps it behind everything */
        }

        /* --- GLASS SIDEBAR --- */
        .sidebar {
            height: 100vh;
            position: fixed;
            width: 250px;
            padding-top: 20px;
            background: rgba(15, 23, 42, 0.4);
            backdrop-filter: blur(15px);
            -webkit-backdrop-filter: blur(15px);
            border-right: 1px solid rgba(255, 255, 255, 0.15);
            box-shadow: 2px 0 15px rgba(0,0,0,0.5);
            z-index: 10;
        }
        .sidebar a { color: rgba(255, 255, 255, 0.7); padding: 15px 20px; display: block; text-decoration: none; font-size: 16px; transition: 0.3s; }
        .sidebar a:hover { background: rgba(255, 255, 255, 0.1); color: #d4af37; border-left: 4px solid #d4af37; }

        /* --- MAIN CONTENT --- */
        .content { margin-left: 250px; padding: 30px; }

        /* --- GLASS CARDS --- */
        .glass-card {
            background: rgba(255, 255, 255, 0.1);
            backdrop-filter: blur(12px);
            -webkit-backdrop-filter: blur(12px);
            border: 1px solid rgba(255, 255, 255, 0.2);
            border-radius: 15px;
            box-shadow: 0 8px 32px 0 rgba(0,0,0,0.3);
            color: white;
            transition: transform 0.3s ease;
        }
        .glass-card:hover { transform: translateY(-5px); }

        /* --- STATS CARDS TINTS --- */
        .bg-glass-primary { background: linear-gradient(135deg, rgba(78, 115, 223, 0.5), rgba(34, 74, 190, 0.5)); border: 1px solid rgba(78, 115, 223, 0.4); }
        .bg-glass-success { background: linear-gradient(135deg, rgba(212, 175, 55, 0.5), rgba(180, 147, 42, 0.5)); border: 1px solid rgba(212, 175, 55, 0.4); } /* Changed to Gold for Admin */
        .bg-glass-warning { background: linear-gradient(135deg, rgba(246, 194, 62, 0.5), rgba(221, 162, 10, 0.5)); border: 1px solid rgba(246, 194, 62, 0.4); }

        /* --- GLASS INPUTS & BUTTONS --- */
        .form-control {
            background: rgba(255, 255, 255, 0.15);
            border: 1px solid rgba(255, 255, 255, 0.3);
            color: white;
            border-radius: 50px;
        }
        .form-control::placeholder { color: rgba(255, 255, 255, 0.6); }
        .form-control:focus { background: rgba(255, 255, 255, 0.25); color: white; border-color: #d4af37; box-shadow: 0 0 10px rgba(212, 175, 55, 0.4); }

        .btn-glass { background: rgba(255, 255, 255, 0.15); border: 1px solid rgba(255, 255, 255, 0.3); color: white; transition: 0.3s; }
        .btn-glass:hover { background: rgba(255, 255, 255, 0.3); color: #d4af37; }

        .btn-admin-action { background: linear-gradient(135deg, #d4af37, #b4932a); border: none; color: white; border-radius: 50px; }
        .btn-admin-action:hover { background: linear-gradient(135deg, #b4932a, #8f7520); color: white; box-shadow: 0 4px 15px rgba(212, 175, 55, 0.4); }

        hr { border-color: rgba(255, 255, 255, 0.2); }
    </style>
</head>
<body>

<div class="overlay"></div>

<div class="sidebar">
    <h3 class="text-center mb-4 text-white"><i class="fas fa-crown" style="color: #d4af37;"></i> OceanView</h3>
    <a href="admin_dashboard.jsp"><i class="fas fa-home me-2"></i> Dashboard</a>
    <a href="viewReservations.jsp"><i class="fas fa-list me-2"></i> Reservations</a>
    <a href="reports.jsp"><i class="fas fa-chart-line me-2"></i> Monthly Report</a>
    <a href="manageStaff.jsp"><i class="fas fa-users-cog me-2"></i> Manage Staff</a>
    <a href="manageRooms.jsp"><i class="fas fa-bed me-2"></i> Manage Rooms</a>
    <a href="help.jsp"><i class="fas fa-question-circle me-2"></i> Help Guide</a>
    <a href="LogoutServlet" class="text-danger mt-5" style="color: #ff6b6b !important;"><i class="fas fa-sign-out-alt me-2"></i> Logout</a>
</div>

<div class="content">
    <div class="d-flex justify-content-between align-items-center mb-4">
        <h2>Welcome, <span style="color: #d4af37;"><%= session.getAttribute("currentUser") %></span>!</h2>
        <span class="badge bg-dark border border-warning p-2"><i class="fas fa-shield-alt text-warning me-1"></i> Admin Portal</span>
    </div>

    <div class="row mb-4">
        <div class="col-md-4">
            <div class="glass-card bg-glass-primary p-4 h-100">
                <h4 style="font-weight: 300;"><i class="fas fa-book me-2"></i>Total Bookings</h4>
                <p class="display-5 fw-bold mb-0"><%= stats[0] %></p>
            </div>
        </div>
        <div class="col-md-4">
            <div class="glass-card bg-glass-success p-4 h-100">
                <h4 style="font-weight: 300;"><i class="fas fa-coins me-2"></i>Revenue</h4>
                <p class="display-5 fw-bold mb-0">LKR <%= stats[1] %></p>
            </div>
        </div>
        <div class="col-md-4">
            <div class="glass-card bg-glass-warning p-4 h-100">
                <h4 style="font-weight: 300;"><i class="fas fa-hourglass-half me-2"></i>Pending</h4>
                <p class="display-5 fw-bold mb-0"><%= stats[2] %></p>
            </div>
        </div>
    </div>

    <div class="row">
        <div class="col-md-8">
            <div class="glass-card p-4 h-100">
                <h4><i class="fas fa-calendar-check" style="color: #0ea5e9;"></i> Reservations Management</h4>
                <hr>
                <form action="viewReservations.jsp" method="get" class="d-flex mt-4 mb-4">
                    <input type="text" name="q" class="form-control me-3" placeholder="Search Guest Name...">
                    <button type="submit" class="btn btn-admin-action px-4"><i class="fas fa-search"></i> Search</button>
                </form>
                <div class="d-flex gap-3">
                    <a href="addReservation.jsp" class="btn btn-glass flex-grow-1 py-2"><i class="fas fa-plus-circle me-1"></i> New Reservation</a>
                    <a href="viewReservations.jsp" class="btn btn-glass flex-grow-1 py-2"><i class="fas fa-list me-1"></i> View All</a>
                </div>
            </div>
        </div>

        <div class="col-md-4">
            <div class="glass-card p-4 h-100">
                <h4><i class="fas fa-cogs" style="color: #d4af37;"></i> Quick Actions</h4>
                <hr>
                <div class="d-grid gap-3 mt-4">
                    <a href="reports.jsp" class="btn btn-glass text-start py-3">
                        <i class="fas fa-chart-pie me-2" style="color: #10b981;"></i> Monthly Summary
                    </a>
                    <a href="manageStaff.jsp" class="btn btn-glass text-start py-3">
                        <i class="fas fa-user-plus me-2" style="color: #0ea5e9;"></i> Add/Remove Staff
                    </a>
                    <a href="manageRooms.jsp" class="btn btn-glass text-start py-3">
                        <i class="fas fa-tag me-2" style="color: #f59e0b;"></i> Edit Room Prices
                    </a>
                </div>
            </div>
        </div>
    </div>
</div>

</body>
</html>