<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.oceanview.data.ReservationDAO" %>
<%@ page import="java.util.Arrays" %>
<%
    if (session.getAttribute("currentUser") == null) {
        response.sendRedirect("index.jsp");
        return;
    }

    // 1. Call DAO to get REAL Database numbers
    ReservationDAO dao = new ReservationDAO();
    int[] monthlyData = dao.getMonthlyBookings(); // Returns array like [2, 0, 5, 1...]

    // 2. Convert to Javascript String
    String chartData = Arrays.toString(monthlyData);
%>
<!DOCTYPE html>
<html>
<head>
    <title>Reports & Analytics</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <script src="https://cdn.jsdelivr.net/npm/chart.js"></script>
</head>
<body class="bg-light p-4">
<div class="container">
    <h2 class="mb-4 text-center">📊 Monthly Booking Report</h2>

    <div class="card p-4 shadow mb-4">
        <canvas id="realChart" style="max-height: 400px;"></canvas>
    </div>

    <div class="text-center">
        <a href="admin_dashboard.jsp" class="btn btn-primary">Back to Dashboard</a>
    </div>
</div>

<script>
    // 3. Inject Java Data into JS
    const realData = <%= chartData %>;

    new Chart(document.getElementById('realChart'), {
        type: 'bar',
        data: {
            labels: ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'],
            datasets: [{
                label: 'Total Bookings',
                data: realData, // Using the variable from Java
                backgroundColor: '#36a2eb',
                borderColor: '#36a2eb',
                borderWidth: 1
            }]
        },
        options: {
            scales: {
                y: { beginAtZero: true, ticks: { stepSize: 1 } }
            }
        }
    });
</script>
</body>
</html>