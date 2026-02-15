<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.oceanview.data.RoomDAO" %>
<%@ page import="java.util.List" %>
<%
  // 1. Security Check
  if (session.getAttribute("currentUser") == null) {
    response.sendRedirect("index.jsp");
    return;
  }

  // 2. Dynamic Dashboard Link
  String myDashboard = "staff_dashboard.jsp"; // Default for staff
  if ("Admin".equalsIgnoreCase((String) session.getAttribute("role"))) {
    myDashboard = "admin_dashboard.jsp"; // Override for Admin
  }

  // 3. Fetch LIVE Room Types from Database
  RoomDAO roomDao = new RoomDAO();
  List<String[]> rooms = roomDao.getAllRoomTypes();
%>
<!DOCTYPE html>
<html>
<head>
  <title>Add Reservation - Ocean View</title>
  <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
  <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">
  <style>
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
      padding: 20px 0;
    }

    .overlay {
      position: fixed; top: 0; left: 0; width: 100vw; height: 100vh;
      background: rgba(15, 23, 42, 0.5);
      z-index: -1;
    }

    /* --- GLASS CARD --- */
    .glass-card {
      background: rgba(255, 255, 255, 0.15);
      backdrop-filter: blur(15px);
      -webkit-backdrop-filter: blur(15px);
      border: 1px solid rgba(255, 255, 255, 0.2);
      border-radius: 20px;
      box-shadow: 0 8px 32px 0 rgba(0,0,0,0.4);
      padding: 40px;
      color: white;
      width: 100%;
      max-width: 600px;
    }

    /* --- GLASS INPUTS --- */
    .form-control, .form-select {
      background: rgba(255, 255, 255, 0.15);
      border: 1px solid rgba(255, 255, 255, 0.3);
      color: white;
      border-radius: 10px;
      padding: 10px 15px;
    }

    .form-control::placeholder { color: rgba(255, 255, 255, 0.7); }

    .form-control:focus, .form-select:focus {
      background: rgba(255, 255, 255, 0.25);
      color: white;
      border-color: #0ea5e9;
      box-shadow: 0 0 10px rgba(14, 165, 233, 0.4);
    }

    /* Fix dropdown options readability */
    option {
      background-color: #1e293b;
      color: white;
    }

    /* Make calendar icon white for date picker */
    ::-webkit-calendar-picker-indicator {
      filter: invert(1);
      cursor: pointer;
    }

    /* --- BUTTONS --- */
    .btn-save {
      background: linear-gradient(135deg, #10b981, #059669);
      border: none;
      color: white;
      border-radius: 10px;
      padding: 12px;
      font-weight: bold;
      transition: 0.3s;
    }
    .btn-save:hover { background: linear-gradient(135deg, #059669, #047857); transform: translateY(-2px); box-shadow: 0 4px 15px rgba(16, 185, 129, 0.4); color: white;}

    .btn-cancel {
      background: rgba(255, 255, 255, 0.15);
      border: 1px solid rgba(255, 255, 255, 0.3);
      color: white;
      border-radius: 10px;
      padding: 12px;
      font-weight: bold;
      transition: 0.3s;
    }
    .btn-cancel:hover { background: rgba(255, 255, 255, 0.3); color: white; transform: translateY(-2px); }
  </style>
</head>
<body>

<div class="overlay"></div>

<div class="container">
  <div class="glass-card mx-auto">
    <h3 class="text-center mb-4" style="color: #0ea5e9; text-shadow: 0 2px 5px rgba(0,0,0,0.3);">
      <i class="fas fa-plus-circle me-2"></i>New Reservation
    </h3>

    <form action="AddServlet" method="post">
      <div class="mb-3">
        <label class="form-label"><i class="fas fa-user me-2"></i>Guest Name</label>
        <input type="text" name="name" class="form-control" required>
      </div>
      <div class="mb-3">
        <label class="form-label"><i class="fas fa-map-marker-alt me-2"></i>Address</label>
        <input type="text" name="address" class="form-control" required>
      </div>
      <div class="mb-3">
        <label class="form-label"><i class="fas fa-phone-alt me-2"></i>Contact Number</label>
        <input type="text" name="phone" class="form-control" required pattern="\d{10}" title="10 Digits only">
      </div>

      <div class="mb-3">
        <label class="form-label"><i class="fas fa-bed me-2"></i>Room Type</label>
        <select name="roomType" class="form-select" required>
          <option value="" disabled selected>-- Select a Room --</option>
          <%
            if(rooms != null) {
              for(String[] r : rooms) {
          %>
          <option value="<%= r[0] %>"><%= r[1] %> (LKR <%= r[2] %>)</option>
          <%
              }
            }
          %>
        </select>
      </div>

      <div class="row">
        <div class="col-md-6 mb-4">
          <label class="form-label"><i class="fas fa-calendar-alt me-2"></i>Check-In</label>
          <input type="date" name="checkIn" class="form-control" required>
        </div>
        <div class="col-md-6 mb-4">
          <label class="form-label"><i class="fas fa-calendar-check me-2"></i>Check-Out</label>
          <input type="date" name="checkOut" class="form-control" required>
        </div>
      </div>

      <div class="d-grid gap-3">
        <button type="submit" class="btn btn-save"><i class="fas fa-save me-2"></i>Save Reservation</button>
        <a href="<%= myDashboard %>" class="btn btn-cancel text-center text-decoration-none"><i class="fas fa-arrow-left me-2"></i>Cancel & Return</a>
      </div>
    </form>
  </div>
</div>

</body>
</html>