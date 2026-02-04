<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
  <title>Add Reservation</title>
  <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
</head>
<body class="bg-light">
<div class="container mt-5">
  <div class="card shadow p-4 mx-auto" style="max-width: 600px;">
    <h3 class="text-center text-primary mb-4">New Reservation</h3>

    <form action="AddServlet" method="post">
      <div class="mb-3">
        <label>Guest Name</label>
        <input type="text" name="name" class="form-control" required>
      </div>
      <div class="mb-3">
        <label>Address</label>
        <input type="text" name="address" class="form-control" required>
      </div>
      <div class="mb-3">
        <label>Contact Number</label>
        <input type="text" name="phone" class="form-control" required pattern="\d{10}" title="10 Digits only">
      </div>
      <div class="mb-3">
        <label>Room Type</label>
        <select name="roomType" class="form-select">
          <option value="1">Single Room (LKR 5000)</option>
          <option value="2">Double Room (LKR 8500)</option>
          <option value="3">Suite (LKR 15000)</option>
        </select>
      </div>
      <div class="row">
        <div class="col-md-6 mb-3">
          <label>Check-In</label>
          <input type="date" name="checkIn" class="form-control" required>
        </div>
        <div class="col-md-6 mb-3">
          <label>Check-Out</label>
          <input type="date" name="checkOut" class="form-control" required>
        </div>
      </div>

      <div class="d-grid gap-2">
        <button type="submit" class="btn btn-success">Save Reservation</button>
        <a href="dashboard.jsp" class="btn btn-secondary">Cancel</a>
      </div>
    </form>
  </div>
</div>
</body>
</html>