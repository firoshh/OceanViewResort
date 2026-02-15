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
        body { background-color: #f1f5f9; }
        .sidebar { height: 100vh; background: #334155; color: white; position: fixed; width: 250px; padding-top: 20px; }
        .sidebar a { color: #cbd5e1; padding: 15px; display: block; text-decoration: none; font-size: 18px; }
        .sidebar a:hover { background: #475569; color: white; border-left: 4px solid #3b82f6; }
        .content { margin-left: 250px; padding: 30px; }
        .card { border: none; border-radius: 12px; box-shadow: 0 4px 6px rgba(0,0,0,0.05); transition: 0.3s; }
        .card:hover { transform: translateY(-5px); }
        .bg-blue { background: linear-gradient(135deg, #3b82f6, #2563eb); color: white; }
        .bg-orange { background: linear-gradient(135deg, #f59e0b, #d97706); color: white; }
    </style>
</head>
<body>

<div class="sidebar">
    <h3 class="text-center mb-4"><i class="fas fa-water"></i> OceanView</h3>
    <a href="staff_dashboard.jsp"><i class="fas fa-home me-2"></i> Dashboard</a>
    <a href="viewReservations.jsp"><i class="fas fa-list me-2"></i> View Bookings</a>
    <a href="addReservation.jsp"><i class="fas fa-plus-circle me-2"></i> New Booking</a>

    <a href="LogoutServlet" class="text-danger mt-5"><i class="fas fa-sign-out-alt me-2"></i> Logout</a>
</div>

<div class="content">
    <div class="d-flex justify-content-between align-items-center mb-4">
        <h2>Welcome, <%= session.getAttribute("currentUser") %>!</h2>
        <span class="badge bg-secondary p-2">Staff Access</span>
    </div>

    <div class="row mb-4">
        <div class="col-md-6">
            <div class="card bg-blue p-4">
                <h3><i class="fas fa-bed"></i> Total Bookings</h3>
                <p class="display-4 fw-bold mb-0"><%= stats[0] %></p>
            </div>
        </div>
        <div class="col-md-6">
            <div class="card bg-orange p-4">
                <h3><i class="fas fa-clock"></i> Pending Check-ins</h3>
                <p class="display-4 fw-bold mb-0"><%= stats[2] %></p>
            </div>
        </div>
    </div>

    <div class="card p-5 bg-white">
        <h4 class="mb-4 text-secondary">Front Desk Operations</h4>

        <form action="viewReservations.jsp" method="get" class="d-flex mb-4">
            <input type="text" name="q" class="form-control form-control-lg me-2" placeholder="Search Guest Name...">
            <button type="submit" class="btn btn-primary btn-lg"><i class="fas fa-search"></i></button>
        </form>

        <div class="d-flex gap-3">
            <a href="addReservation.jsp" class="btn btn-success btn-lg flex-grow-1">
                <i class="fas fa-plus-circle"></i> New Reservation
            </a>

            <a href="viewReservations.jsp" class="btn btn-dark btn-lg flex-grow-1">
                <i class="fas fa-list"></i> View All Reservations
            </a>
        </div>
    </div>
</div>

</body>
</html>