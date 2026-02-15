<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.oceanview.data.ReservationDAO" %>
<%
    // 1. Security Check
    if (session.getAttribute("currentUser") == null) {
        // Redirect to the actual login page
        response.sendRedirect("index.jsp");
        return;
    }

    // 2. FETCH DATA
    ReservationDAO dao = new ReservationDAO();
    int[] stats = dao.getDashboardStats();
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Staff Dashboard - Ocean View</title>
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
            background: rgba(15, 23, 42, 0.4); /* Lighter tint for Staff */
            z-index: -1;
        }

        /* --- GLASS SIDEBAR --- */
        .sidebar {
            height: 100vh;
            position: fixed;
            width: 250px;
            padding-top: 20px;
            background: rgba(15, 23, 42, 0.5);
            backdrop-filter: blur(15px);
            -webkit-backdrop-filter: blur(15px);
            border-right: 1px solid rgba(255, 255, 255, 0.15);
            box-shadow: 2px 0 15px rgba(0,0,0,0.3);
            z-index: 10;
        }
        .sidebar a { color: rgba(255, 255, 255, 0.8); padding: 15px 20px; display: block; text-decoration: none; font-size: 16px; transition: 0.3s; }
        .sidebar a:hover { background: rgba(255, 255, 255, 0.15); color: #0ea5e9; border-left: 4px solid #0ea5e9; }

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
        .bg-glass-blue { background: linear-gradient(135deg, rgba(14, 165, 233, 0.5), rgba(37, 99, 235, 0.5)); border: 1px solid rgba(14, 165, 233, 0.4); }
        .bg-glass-orange { background: linear-gradient(135deg, rgba(245, 158, 11, 0.5), rgba(217, 119, 6, 0.5)); border: 1px solid rgba(245, 158, 11, 0.4); }

        /* --- GLASS INPUTS & BUTTONS --- */
        .form-control {
            background: rgba(255, 255, 255, 0.15);
            border: 1px solid rgba(255, 255, 255, 0.3);
            color: white;
            border-radius: 50px;
        }
        .form-control::placeholder { color: rgba(255, 255, 255, 0.6); }
        .form-control:focus { background: rgba(255, 255, 255, 0.25); color: white; border-color: #0ea5e9; box-shadow: 0 0 10px rgba(14, 165, 233, 0.4); }

        .btn-glass { background: rgba(255, 255, 255, 0.15); border: 1px solid rgba(255, 255, 255, 0.3); color: white; border-radius: 50px; transition: 0.3s; }
        .btn-glass:hover { background: rgba(255, 255, 255, 0.3); color: white; }

        .btn-staff-action { background: linear-gradient(135deg, #0ea5e9, #2563eb); border: none; color: white; border-radius: 50px; transition: 0.3s; }
        .btn-staff-action:hover { background: linear-gradient(135deg, #0284c7, #1d4ed8); color: white; box-shadow: 0 4px 15px rgba(14, 165, 233, 0.4); transform: translateY(-2px); }

        hr { border-color: rgba(255, 255, 255, 0.2); }
    </style>
</head>
<body>

<div class="overlay"></div>

<div class="sidebar">
    <h3 class="text-center mb-4 text-white"><i class="fas fa-water" style="color: #0ea5e9;"></i> OceanView</h3>
    <a href="staff_dashboard.jsp"><i class="fas fa-home me-2"></i> Dashboard</a>
    <a href="viewReservations.jsp"><i class="fas fa-list me-2"></i> View Bookings</a>
    <a href="addReservation.jsp"><i class="fas fa-plus-circle me-2"></i> New Booking</a>
    <a href="help.jsp"><i class="fas fa-question-circle me-2"></i> Help Guide</a>
    <a href="LogoutServlet" class="text-danger mt-5" style="color: #ff6b6b !important;"><i class="fas fa-sign-out-alt me-2"></i> Logout</a>
</div>

<div class="content">
    <div class="d-flex justify-content-between align-items-center mb-4">
        <h2>Welcome, <span style="color: #0ea5e9;"><%= session.getAttribute("currentUser") %></span>!</h2>
        <span class="badge bg-dark border border-info p-2"><i class="fas fa-user-tie text-info me-1"></i> Staff Access</span>
    </div>

    <div class="row mb-4">
        <div class="col-md-6">
            <div class="glass-card bg-glass-blue p-4">
                <h4 style="font-weight: 300;"><i class="fas fa-bed me-2"></i> Total Bookings</h4>
                <p class="display-4 fw-bold mb-0"><%= stats[0] %></p>
            </div>
        </div>
        <div class="col-md-6">
            <div class="glass-card bg-glass-orange p-4">
                <h4 style="font-weight: 300;"><i class="fas fa-clock me-2"></i> Pending Check-ins</h4>
                <p class="display-4 fw-bold mb-0"><%= stats[2] %></p>
            </div>
        </div>
    </div>

    <div class="glass-card p-5">
        <h4 class="mb-4 text-light"><i class="fas fa-concierge-bell" style="color: #0ea5e9;"></i> Front Desk Operations</h4>
        <hr>

        <form action="viewReservations.jsp" method="get" class="d-flex mt-4 mb-4">
            <input type="text" name="q" class="form-control form-control-lg me-3" placeholder="Search Guest Name...">
            <button type="submit" class="btn btn-staff-action px-5 fs-5"><i class="fas fa-search"></i> Search</button>
        </form>

        <div class="d-flex gap-3">
            <a href="addReservation.jsp" class="btn btn-staff-action btn-lg flex-grow-1">
                <i class="fas fa-plus-circle me-2"></i> New Reservation
            </a>

            <a href="viewReservations.jsp" class="btn btn-glass btn-lg flex-grow-1">
                <i class="fas fa-list me-2"></i> View All Reservations
            </a>
        </div>
    </div>
</div>

</body>
</html>