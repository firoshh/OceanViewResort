<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%
  // Security Check
  if (session.getAttribute("currentUser") == null) {
    response.sendRedirect("index.jsp");
    return;
  }

  // Determine Role & Dynamic Dashboard Link
  String role = (String) session.getAttribute("role");
  boolean isAdmin = "Admin".equalsIgnoreCase(role);

  String myDashboard = isAdmin ? "admin_dashboard.jsp" : "staff_dashboard.jsp";
  String themeColor = isAdmin ? "#d4af37" : "#0ea5e9"; // Gold for Admin, Blue for Staff
%>
<!DOCTYPE html>
<html>
<head>
  <title>Help & Documentation - Ocean View</title>
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
      padding: 40px 0;
    }

    .overlay {
      position: fixed; top: 0; left: 0; width: 100vw; height: 100vh;
      background: rgba(15, 23, 42, <%= isAdmin ? "0.6" : "0.5" %>);
      z-index: -1;
    }

    .glass-container {
      background: rgba(255, 255, 255, 0.15);
      backdrop-filter: blur(15px);
      -webkit-backdrop-filter: blur(15px);
      border: 1px solid rgba(255, 255, 255, 0.2);
      border-radius: 20px;
      box-shadow: 0 8px 32px 0 rgba(0,0,0,0.4);
      padding: 40px;
      color: white;
      width: 100%;
      max-width: 800px;
    }

    .accordion-item {
      background: transparent;
      border: 1px solid rgba(255, 255, 255, 0.2);
      margin-bottom: 10px;
      border-radius: 10px !important;
      overflow: hidden;
    }

    .accordion-button {
      background: rgba(255, 255, 255, 0.1);
      color: white;
      font-weight: bold;
      box-shadow: none !important;
    }

    .accordion-button:not(.collapsed) {
      background: <%= isAdmin ? "rgba(212, 175, 55, 0.4)" : "rgba(14, 165, 233, 0.4)" %>;
      color: white;
    }

    .accordion-button::after { filter: invert(1); }

    .accordion-body {
      background: rgba(0, 0, 0, 0.3);
      color: #cbd5e1;
      border-top: 1px solid rgba(255, 255, 255, 0.1);
    }

    .btn-back {
      background: rgba(255, 255, 255, 0.15);
      border: 1px solid rgba(255, 255, 255, 0.3);
      color: white;
      border-radius: 50px;
      padding: 10px 30px;
      font-weight: bold;
      transition: 0.3s;
      display: inline-block;
      text-decoration: none;
    }
    .btn-back:hover {
      background: rgba(255, 255, 255, 0.3);
      color: white;
      transform: translateY(-2px);
    }
    hr { border-color: rgba(255, 255, 255, 0.3); }
  </style>
</head>
<body>

<div class="overlay"></div>

<div class="container">
  <div class="glass-container mx-auto">
    <h2 class="mb-3" style="color: <%= themeColor %>; text-shadow: 0 2px 5px rgba(0,0,0,0.3);">
      <i class="fas fa-question-circle me-2"></i> <%= isAdmin ? "Administrator Help" : "Staff Help" %>
    </h2>
    <p class="text-light mb-4">Quick guide for managing your tasks in the Ocean View Resort system.</p>
    <hr>

    <div class="accordion mt-4" id="accordionExample">

      <% if (isAdmin) { %>
      <div class="accordion-item">
        <h2 class="accordion-header">
          <button class="accordion-button" type="button" data-bs-toggle="collapse" data-bs-target="#a1">
            <i class="fas fa-chart-line me-2 text-warning"></i> Viewing Monthly Reports
          </button>
        </h2>
        <div id="a1" class="accordion-collapse collapse show" data-bs-parent="#accordionExample">
          <div class="accordion-body">
            Click on <strong>Monthly Report</strong> in the sidebar. This will show you a live, dynamically updated bar chart of all bookings grouped by month to help you track revenue and occupancy trends.
          </div>
        </div>
      </div>

      <div class="accordion-item">
        <h2 class="accordion-header">
          <button class="accordion-button collapsed" type="button" data-bs-toggle="collapse" data-bs-target="#a2">
            <i class="fas fa-users-cog me-2 text-warning"></i> Managing Staff Accounts
          </button>
        </h2>
        <div id="a2" class="accordion-collapse collapse" data-bs-parent="#accordionExample">
          <div class="accordion-body">
            Go to <strong>Manage Staff</strong>. You can create new accounts and assign them either 'Admin' or 'Staff' roles. You can also revoke access by clicking the red 'Remove' button next to their name.
          </div>
        </div>
      </div>

      <div class="accordion-item">
        <h2 class="accordion-header">
          <button class="accordion-button collapsed" type="button" data-bs-toggle="collapse" data-bs-target="#a3">
            <i class="fas fa-bed me-2 text-warning"></i> Updating Room Prices
          </button>
        </h2>
        <div id="a3" class="accordion-collapse collapse" data-bs-parent="#accordionExample">
          <div class="accordion-body">
            Navigate to <strong>Manage Rooms</strong>. You can adjust the current prices of existing rooms or add completely new room types (e.g., "Presidential Suite"). Note: You cannot delete a room type if it is currently tied to an active reservation.
          </div>
        </div>
      </div>

      <% } else { %>
      <div class="accordion-item">
        <h2 class="accordion-header">
          <button class="accordion-button" type="button" data-bs-toggle="collapse" data-bs-target="#s1">
            <i class="fas fa-plus-circle me-2 text-info"></i> How to Add a Reservation?
          </button>
        </h2>
        <div id="s1" class="accordion-collapse collapse show" data-bs-parent="#accordionExample">
          <div class="accordion-body">
            Go to <strong>New Booking</strong> in the sidebar. Fill in all guest details, select their dates, and choose a room. The system will automatically calculate the total price based on the current rates set by the Admin.
          </div>
        </div>
      </div>

      <div class="accordion-item">
        <h2 class="accordion-header">
          <button class="accordion-button collapsed" type="button" data-bs-toggle="collapse" data-bs-target="#s2">
            <i class="fas fa-edit me-2 text-info"></i> Editing & Deleting Reservations
          </button>
        </h2>
        <div id="s2" class="accordion-collapse collapse" data-bs-parent="#accordionExample">
          <div class="accordion-body">
            Navigate to <strong>View Bookings</strong>. Use the search bar to find the guest. Click the yellow <code>Edit</code> button to modify their dates or room type, or click the red <code>Delete</code> button to cancel the record entirely.
          </div>
        </div>
      </div>

      <div class="accordion-item">
        <h2 class="accordion-header">
          <button class="accordion-button collapsed" type="button" data-bs-toggle="collapse" data-bs-target="#s3">
            <i class="fas fa-file-invoice-dollar me-2 text-info"></i> Generating Invoices
          </button>
        </h2>
        <div id="s3" class="accordion-collapse collapse" data-bs-parent="#accordionExample">
          <div class="accordion-body">
            In the <strong>View Bookings</strong> table, click the blue Invoice icon next to a guest's name. This generates a clean, printable bill. Press the "Print" button on that page to hand the physical copy to the guest.
          </div>
        </div>
      </div>
      <% } %>

    </div>

    <div class="mt-5 text-center">
      <a href="<%= myDashboard %>" class="btn-back"><i class="fas fa-arrow-left me-2"></i> Return to Dashboard</a>
    </div>
  </div>
</div>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>