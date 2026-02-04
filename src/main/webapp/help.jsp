<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
  <title>Staff Help</title>
  <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
</head>
<body class="p-5">
<div class="container">
  <h1>Help & Documentation</h1>
  <hr>
  <div class="accordion" id="accordionExample">
    <div class="accordion-item">
      <h2 class="accordion-header"><button class="accordion-button" type="button" data-bs-toggle="collapse" data-bs-target="#c1">How to Add a Reservation?</button></h2>
      <div id="c1" class="accordion-collapse collapse show"><div class="accordion-body">Go to Dashboard > Add New. Fill in all details. The system automatically calculates the bill.</div></div>
    </div>
    <div class="accordion-item">
      <h2 class="accordion-header"><button class="accordion-button collapsed" type="button" data-bs-toggle="collapse" data-bs-target="#c2">How to Edit/Delete?</button></h2>
      <div id="c2" class="accordion-collapse collapse"><div class="accordion-body">Go to 'Reservations'. Click the yellow 'Edit' button or red 'Delete' button next to the guest.</div></div>
    </div>
  </div>
  <br>
  <a href="dashboard.jsp" class="btn btn-primary">Back</a>
</div>
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>