<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.oceanview.data.ReservationDAO" %>
<%@ page import="java.util.Arrays" %>
<%
    // Security Check
    if (session.getAttribute("currentUser") == null) {
        response.sendRedirect("index.jsp");
        return;
    }

    // 1. Call DAO to get REAL Database numbers
    ReservationDAO dao = new ReservationDAO();
    int[] monthlyData = dao.getMonthlyBookings();

    // 2. Convert to Javascript String
    String chartData = Arrays.toString(monthlyData);
%>
<!DOCTYPE html>
<html>
<head>
    <title>Reports & Analytics - Admin Portal</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">
    <script src="https://cdn.jsdelivr.net/npm/chart.js"></script>
    <style>
        /* --- BACKGROUND & OVERLAY --- */
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
            color: white;
        }

        .overlay {
            position: fixed; top: 0; left: 0; width: 100vw; height: 100vh;
            background: rgba(15, 23, 42, 0.6); /* Admin dark overlay */
            z-index: -1;
        }

        /* --- GLASS CONTAINER --- */
        .glass-container {
            background: rgba(255, 255, 255, 0.1);
            backdrop-filter: blur(15px);
            -webkit-backdrop-filter: blur(15px);
            border: 1px solid rgba(255, 255, 255, 0.2);
            border-radius: 20px;
            box-shadow: 0 8px 32px 0 rgba(0,0,0,0.5);
            padding: 40px;
            width: 100%;
            max-width: 900px;
        }

        /* --- GLASS CARDS --- */
        .glass-card {
            background: rgba(0, 0, 0, 0.2);
            border: 1px solid rgba(255, 255, 255, 0.15);
            border-radius: 15px;
            padding: 25px;
            margin-bottom: 30px;
        }

        /* --- BUTTONS --- */
        .btn-back {
            background: rgba(255, 255, 255, 0.1);
            border: 1px solid rgba(255, 255, 255, 0.3);
            color: white;
            border-radius: 50px;
            padding: 10px 30px;
            transition: 0.3s;
            text-decoration: none;
            display: inline-block;
        }
        .btn-back:hover {
            background: rgba(255, 255, 255, 0.2);
            color: white;
            transform: translateY(-2px);
        }
    </style>
</head>
<body>

<div class="overlay"></div>

<div class="container">
    <div class="glass-container mx-auto">
        <h2 class="mb-4 text-center" style="color: #d4af37; text-shadow: 0 2px 10px rgba(0,0,0,0.5);">
            <i class="fas fa-chart-bar me-2"></i> Monthly Booking Report
        </h2>

        <div class="glass-card shadow-lg mb-4">
            <canvas id="realChart" style="max-height: 400px;"></canvas>
        </div>

        <div class="text-center mt-4">
            <a href="admin_dashboard.jsp" class="btn btn-back"><i class="fas fa-arrow-left me-2"></i> Back to Dashboard</a>
        </div>
    </div>
</div>

<script>
    // 3. Inject Java Data into JS
    const realData = <%= chartData %>;

    // Set global default color for Chart.js to white for the glass theme
    Chart.defaults.color = 'rgba(255, 255, 255, 0.8)';
    Chart.defaults.font.family = "'Segoe UI', Tahoma, Geneva, Verdana, sans-serif";

    new Chart(document.getElementById('realChart'), {
        type: 'bar',
        data: {
            labels: ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'],
            datasets: [{
                label: 'Total Bookings',
                data: realData,
                backgroundColor: 'rgba(212, 175, 55, 0.7)', // Admin Gold with transparency
                borderColor: '#d4af37', // Solid Gold border
                borderWidth: 2,
                borderRadius: 5, // Rounded tops on the bars
                hoverBackgroundColor: 'rgba(212, 175, 55, 0.9)'
            }]
        },
        options: {
            responsive: true,
            plugins: {
                legend: {
                    labels: { color: 'white', font: { size: 14 } }
                }
            },
            scales: {
                y: {
                    beginAtZero: true,
                    ticks: { stepSize: 1, color: 'rgba(255, 255, 255, 0.8)' },
                    grid: { color: 'rgba(255, 255, 255, 0.1)' } // Light glass grid lines
                },
                x: {
                    ticks: { color: 'rgba(255, 255, 255, 0.8)' },
                    grid: { display: false } // Hide x grid lines for a cleaner look
                }
            }
        }
    });
</script>
</body>
</html>