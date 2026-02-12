<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.oceanview.data.ReservationDAO" %>
<%
    // Security Check
    if (session.getAttribute("currentUser") == null) {
        response.sendRedirect("login.jsp");
        return;
    }

    int id = Integer.parseInt(request.getParameter("id"));
    ReservationDAO dao = new ReservationDAO();
    String[] bill = dao.getBillingInfo(id);

    if (bill == null) {
        out.println("<h3>Error: Reservation not found.</h3>");
        return;
    }
%>
<!DOCTYPE html>
<html>
<head>
    <title>Invoice #<%= id %> - Ocean View Resort</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://fonts.googleapis.com/css2?family=Playfair+Display:wght@700&family=Roboto:wght@400;500&display=swap" rel="stylesheet">

    <style>
        body { background: #eee; font-family: 'Roboto', sans-serif; padding: 40px; }

        .invoice-box {
            background: white;
            max-width: 800px;
            margin: auto;
            padding: 40px;
            border: 1px solid #ddd;
            box-shadow: 0 0 20px rgba(0, 0, 0, 0.15);
        }

        .header-title { font-family: 'Playfair Display', serif; color: #d4af37; font-size: 32px; font-weight: bold; }
        .invoice-details { margin-top: 20px; color: #555; }

        .table-invoice th { background: #f8f9fa; color: #333; }
        .total-row { font-size: 1.2rem; font-weight: bold; background: #d4af37; color: white; }

        /* HIDE BUTTONS WHEN PRINTING */
        @media print {
            .no-print { display: none; }
            body { background: white; padding: 0; }
            .invoice-box { box-shadow: none; border: none; padding: 0; }
        }
    </style>
</head>
<body>

<div class="invoice-box">
    <div class="row mb-4">
        <div class="col-8">
            <div class="header-title"><i class="fas fa-water"></i> Ocean View Resort</div>
            <p>67 Beach Road, Galle, Sri Lanka<br>
                Hotline: +94 11 222 3333<br>
                Email: billing@oceanview.lk</p>
        </div>
        <div class="col-4 text-end">
            <h4 class="text-secondary">INVOICE</h4>
            <p><strong>Inv No:</strong> #INV-<%= id %><br>
                <strong>Date:</strong> <%= new java.util.Date() %></p>
        </div>
    </div>

    <hr>

    <div class="row mb-4">
        <div class="col-6">
            <h5>Bill To:</h5>
            <p><strong><%= bill[0] %></strong><br>
                <%= bill[1] %><br>
                Phone: <%= bill[2] %></p>
        </div>
        <div class="col-6 text-end">
            <h5>Stay Details:</h5>
            <p><strong>Check-In:</strong> <%= bill[3] %><br>
                <strong>Check-Out:</strong> <%= bill[4] %></p>
        </div>
    </div>

    <table class="table table-invoice table-bordered">
        <thead>
        <tr>
            <th>Description</th>
            <th class="text-end">Rate (LKR)</th>
            <th class="text-center">Nights</th>
            <th class="text-end">Amount (LKR)</th>
        </tr>
        </thead>
        <tbody>
        <tr>
            <td>Room Charge: <%= bill[5] %></td>
            <td class="text-end"><%= bill[6] %></td>
            <td class="text-center"><%= bill[7] %></td>
            <td class="text-end"><%= bill[8] %></td>
        </tr>
        <tr>
            <td>Service Charge (10%)</td>
            <td class="text-end">-</td>
            <td class="text-center">-</td>
            <td class="text-end">Included</td>
        </tr>
        <tr class="total-row">
            <td colspan="3" class="text-end">GRAND TOTAL</td>
            <td class="text-end">LKR <%= bill[8] %></td>
        </tr>
        </tbody>
    </table>

    <div class="mt-5 text-center text-muted" style="font-size: 0.9rem;">
        <p>Thank you for choosing Ocean View Resort!</p>
    </div>

    <div class="text-center mt-4 no-print">
        <button onclick="window.print()" class="btn btn-primary btn-lg me-2">Print Invoice</button>
        <a href="viewReservations.jsp" class="btn btn-secondary btn-lg">Back</a>
    </div>

</div>

</body>
</html>