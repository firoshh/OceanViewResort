<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.oceanview.data.ReservationDAO" %>
<%
    // Security Check
    if (session.getAttribute("currentUser") == null) {
        response.sendRedirect("index.jsp"); // Fixed redirect to index.jsp
        return;
    }

    int id = Integer.parseInt(request.getParameter("id"));
    ReservationDAO dao = new ReservationDAO();
    String[] bill = dao.getBillingInfo(id);

    if (bill == null) {
        out.println("<h3 style='color:white; text-align:center; margin-top:50px;'>Error: Reservation not found.</h3>");
        return;
    }
%>
<!DOCTYPE html>
<html>
<head>
    <title>Invoice #<%= id %> - Ocean View Resort</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://fonts.googleapis.com/css2?family=Playfair+Display:wght@700&family=Roboto:wght@400;500&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">

    <style>
        /* --- SCREEN STYLES (GLASSMORPHISM) --- */
        @media screen {
            body {
                background: url('https://images.unsplash.com/photo-1582719508461-905c673771fd?q=80&w=1920&auto=format&fit=crop');
                background-size: cover;
                background-attachment: fixed;
                font-family: 'Roboto', sans-serif;
                padding: 40px;
                color: white;
            }
            .overlay {
                position: fixed; top: 0; left: 0; width: 100vw; height: 100vh;
                background: rgba(15, 23, 42, 0.6);
                z-index: -1;
            }
            .invoice-box {
                background: rgba(255, 255, 255, 0.1);
                backdrop-filter: blur(15px);
                -webkit-backdrop-filter: blur(15px);
                border: 1px solid rgba(255, 255, 255, 0.2);
                border-radius: 15px;
                box-shadow: 0 8px 32px 0 rgba(0,0,0,0.4);
                max-width: 800px;
                margin: auto;
                padding: 50px;
            }
            .header-title { font-family: 'Playfair Display', serif; color: #d4af37; font-size: 32px; font-weight: bold; }
            .text-secondary { color: #cbd5e1 !important; }
            .text-muted { color: #94a3b8 !important; }
            hr { border-color: rgba(255, 255, 255, 0.3); }

            /* Glass Table */
            .table-invoice { color: white; border-color: rgba(255, 255, 255, 0.2); margin-top: 20px;}
            .table-invoice th { background: rgba(255, 255, 255, 0.15); color: #d4af37; border-color: rgba(255, 255, 255, 0.2); font-weight: 500;}
            .table-invoice td { border-color: rgba(255, 255, 255, 0.2); background: transparent; }
            .total-row td { font-size: 1.2rem; font-weight: bold; background: rgba(212, 175, 55, 0.2) !important; color: #d4af37; }

            /* Buttons */
            .btn-print { background: linear-gradient(135deg, #0ea5e9, #2563eb); border: none; color: white; transition: 0.3s; border-radius: 50px;}
            .btn-print:hover { transform: translateY(-2px); box-shadow: 0 4px 15px rgba(14, 165, 233, 0.4); color: white;}
            .btn-back { background: rgba(255, 255, 255, 0.15); border: 1px solid rgba(255, 255, 255, 0.3); color: white; transition: 0.3s; border-radius: 50px;}
            .btn-back:hover { background: rgba(255, 255, 255, 0.3); color: white; transform: translateY(-2px);}
        }

        /* --- PRINT STYLES (CLEAN PAPER LOOK) --- */
        @media print {
            .no-print { display: none !important; }
            .overlay { display: none !important; }
            body { background: white; color: black; padding: 0; font-family: 'Roboto', sans-serif; }
            .invoice-box { border: none; box-shadow: none; padding: 20px; max-width: 100%; margin: 0; }
            .header-title { color: black; font-size: 32px; font-weight: bold; }
            .table-invoice { width: 100%; margin-top: 20px; border-collapse: collapse; }
            .table-invoice th { background: #f8f9fa !important; color: black !important; border: 1px solid #ddd; padding: 10px;}
            .table-invoice td { border: 1px solid #ddd; padding: 10px; color: black !important; }
            .total-row td { font-weight: bold; background: #eee !important; color: black !important; font-size: 1.2rem; }
            hr { border-color: #ddd; }
        }
    </style>
</head>
<body>

<div class="overlay"></div>

<div class="invoice-box">
    <div class="row mb-4">
        <div class="col-8">
            <div class="header-title"><i class="fas fa-water"></i> Ocean View Resort</div>
            <p>67 Beach Road, Galle, Sri Lanka<br>
                Hotline: +94 11 222 3333<br>
                Email: billing@oceanview.lk</p>
        </div>
        <div class="col-4 text-end">
            <h4 class="text-secondary" style="letter-spacing: 2px;">INVOICE</h4>
            <p><strong>Inv No:</strong> #INV-<%= id %><br>
                <strong>Date:</strong> <%= new java.text.SimpleDateFormat("yyyy-MMM-dd").format(new java.util.Date()) %></p>
        </div>
    </div>

    <hr>

    <div class="row mb-4 mt-4">
        <div class="col-6">
            <h5 style="color: #d4af37;">Bill To:</h5>
            <p><strong><%= bill[0] %></strong><br>
                <%= bill[1] %><br>
                Phone: <%= bill[2] %></p>
        </div>
        <div class="col-6 text-end">
            <h5 style="color: #d4af37;">Stay Details:</h5>
            <p><strong>Check-In:</strong> <%= bill[3] %><br>
                <strong>Check-Out:</strong> <%= bill[4] %></p>
        </div>
    </div>

    <table class="table table-invoice">
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
            <td colspan="3" class="text-end border-0 pt-3">GRAND TOTAL</td>
            <td class="text-end border-0 pt-3">LKR <%= bill[8] %></td>
        </tr>
        </tbody>
    </table>

    <div class="mt-5 text-center text-muted" style="font-size: 0.9rem;">
        <p>Thank you for choosing Ocean View Resort!</p>
    </div>

    <div class="text-center mt-5 no-print">
        <button onclick="window.print()" class="btn btn-print btn-lg me-3 px-4"><i class="fas fa-print me-2"></i> Print Invoice</button>
        <a href="viewReservations.jsp" class="btn btn-back btn-lg px-4"><i class="fas fa-arrow-left me-2"></i> Back</a>
    </div>

</div>

</body>
</html>