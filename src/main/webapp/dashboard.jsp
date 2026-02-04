<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%
  if (session.getAttribute("currentUser") == null) {
    response.sendRedirect("index.jsp");
    return;
  }
%>
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <title>Ocean View Admin Dashboard</title>
  <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
  <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">
  <style>
    body { background-color: #f8f9fa; }
    .sidebar { height: 100vh; background: #2c3e50; color: white; position: fixed; width: 250px; padding-top: 20px; }
    .sidebar a { color: #bdc3c7; padding: 15px; display: block; text-decoration: none; font-size: 18px; }
    .sidebar a:hover { background: #34495e; color: white; }
    .content { margin-left: 250px; padding: 20px; }
    .card { border: none; border-radius: 10px; box-shadow: 0 4px 6px rgba(0,0,0,0.1); }
    .bg-gradient-primary { background: linear-gradient(45deg, #4e73df, #224abe); color: white; }
    .bg-gradient-success { background: linear-gradient(45deg, #1cc88a, #13855c); color: white; }
    .bg-gradient-warning { background: linear-gradient(45deg, #f6c23e, #dda20a); color: white; }
  </style>
</head>
<body>

<div class="sidebar">
  <h3 class="text-center mb-4"><i class="fas fa-water"></i> OceanView</h3>
  <a href="dashboard.jsp"><i class="fas fa-home me-2"></i> Dashboard</a>
  <a href="viewReservations.jsp"><i class="fas fa-list me-2"></i> Reservations</a>
  <a href="addReservation.jsp"><i class="fas fa-plus-circle me-2"></i> Add New</a>
  <a href="reports.jsp"><i class="fas fa-chart-line me-2"></i> Reports</a>
  <a href="help.jsp"><i class="fas fa-question-circle me-2"></i> Help</a>
  <a href="index.jsp" class="text-danger mt-5"><i class="fas fa-sign-out-alt me-2"></i> Logout</a>
</div>

<div class="content">
  <h2 class="mb-4">Welcome, <%= session.getAttribute("currentUser") %>!</h2>

  <div class="row mb-4">
    <div class="col-md-4">
      <div class="card bg-gradient-primary p-3">
        <h3>Total Bookings</h3>
        <p class="fs-4">12</p> </div>
    </div>
    <div class="col-md-4">
      <div class="card bg-gradient-success p-3">
        <h3>Revenue</h3>
        <p class="fs-4">LKR 150,000</p>
      </div>
    </div>
    <div class="col-md-4">
      <div class="card bg-gradient-warning p-3">
        <h3>Pending</h3>
        <p class="fs-4">3</p>
      </div>
    </div>
  </div>

  <div class="card p-4">
    <h4>Quick Actions</h4>
    <div class="mt-3">
      <a href="addReservation.jsp" class="btn btn-primary btn-lg me-3"><i class="fas fa-plus"></i> New Reservation</a>
      <a href="viewReservations.jsp" class="btn btn-outline-dark btn-lg"><i class="fas fa-search"></i> Search / Edit</a>
    </div>
  </div>
</div>

</body>
</html>