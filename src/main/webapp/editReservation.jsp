<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.oceanview.data.ReservationDAO" %>
<%@ page import="com.oceanview.data.RoomDAO" %>
<%@ page import="java.util.List" %>
<%
    // Security Check
    if (session.getAttribute("currentUser") == null) {
        response.sendRedirect("index.jsp");
        return;
    }

    int id = Integer.parseInt(request.getParameter("id"));
    ReservationDAO dao = new ReservationDAO();
    String[] data = dao.getReservationDetails(id);

    // Fetch LIVE Room Types from Database to populate dropdown dynamically
    RoomDAO roomDao = new RoomDAO();
    List<String[]> rooms = roomDao.getAllRoomTypes();
%>
<!DOCTYPE html>
<html>
<head>
    <title>Edit Reservation #<%= id %> - Ocean View</title>
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
            max-width: 650px;
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
            border-color: #f59e0b; /* Orange/Warning focus color */
            box-shadow: 0 0 10px rgba(245, 158, 11, 0.4);
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
        .btn-update {
            background: linear-gradient(135deg, #f59e0b, #d97706);
            border: none;
            color: white;
            border-radius: 10px;
            padding: 12px;
            font-weight: bold;
            transition: 0.3s;
        }
        .btn-update:hover {
            background: linear-gradient(135deg, #d97706, #b45309);
            transform: translateY(-2px);
            box-shadow: 0 4px 15px rgba(245, 158, 11, 0.4);
            color: white;
        }

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

        .highlight-status { color: #f59e0b; text-shadow: 0 1px 3px rgba(0,0,0,0.5); }
    </style>
</head>
<body>

<div class="overlay"></div>

<div class="container">
    <div class="glass-card mx-auto">
        <h3 class="text-center mb-4 highlight-status">
            <i class="fas fa-edit me-2"></i>Edit Reservation #<%= id %>
        </h3>

        <form action="UpdateServlet" method="post">
            <input type="hidden" name="id" value="<%= id %>">

            <div class="mb-3">
                <label class="form-label"><i class="fas fa-user me-2"></i>Guest Name</label>
                <input type="text" name="name" class="form-control" value="<%= data[0] %>" required>
            </div>

            <div class="mb-3">
                <label class="form-label"><i class="fas fa-map-marker-alt me-2"></i>Address</label>
                <input type="text" name="address" class="form-control" value="<%= data[1] %>" required>
            </div>

            <div class="row">
                <div class="col-md-6 mb-3">
                    <label class="form-label"><i class="fas fa-phone-alt me-2"></i>Contact Number</label>
                    <input type="text" name="phone" class="form-control" value="<%= data[2] %>" required pattern="\d{10}">
                </div>

                <div class="col-md-6 mb-3">
                    <label class="form-label highlight-status fw-bold"><i class="fas fa-info-circle me-2"></i>Status</label>
                    <select name="status" class="form-select" style="border: 1px solid #f59e0b;">
                        <option value="Confirmed" <%= data[6].equals("Confirmed") ? "selected" : "" %>>✅ Confirmed</option>
                        <option value="Pending" <%= data[6].equals("Pending") ? "selected" : "" %>>⏳ Pending</option>
                        <option value="Cancelled" <%= data[6].equals("Cancelled") ? "selected" : "" %>>❌ Cancelled</option>
                    </select>
                </div>
            </div>

            <div class="mb-3">
                <label class="form-label"><i class="fas fa-bed me-2"></i>Room Type</label>
                <select name="roomType" class="form-select" required>
                    <%
                        // Dynamic Room Selection mapped to the database
                        if(rooms != null) {
                            for(String[] r : rooms) {
                                String isSelected = data[3].equals(r[0]) ? "selected" : "";
                    %>
                    <option value="<%= r[0] %>" <%= isSelected %>><%= r[1] %> (LKR <%= r[2] %>)</option>
                    <%
                            }
                        }
                    %>
                </select>
            </div>

            <div class="row">
                <div class="col-md-6 mb-4">
                    <label class="form-label"><i class="fas fa-calendar-alt me-2"></i>Check-In</label>
                    <input type="date" name="checkIn" class="form-control" value="<%= data[4] %>" required>
                </div>
                <div class="col-md-6 mb-4">
                    <label class="form-label"><i class="fas fa-calendar-check me-2"></i>Check-Out</label>
                    <input type="date" name="checkOut" class="form-control" value="<%= data[5] %>" required>
                </div>
            </div>

            <div class="d-grid gap-3 mt-2">
                <button type="submit" class="btn btn-update"><i class="fas fa-save me-2"></i>Update Reservation</button>
                <a href="viewReservations.jsp" class="btn btn-cancel text-center text-decoration-none"><i class="fas fa-times-circle me-2"></i>Discard Changes</a>
            </div>
        </form>
    </div>
</div>

</body>
</html>