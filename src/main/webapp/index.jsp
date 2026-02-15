<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Staff Login - Ocean View Resort</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">
    <style>
        body {
            background: url('https://images.unsplash.com/photo-1582719508461-905c673771fd?q=80&w=1920&auto=format&fit=crop');
            background-size: cover;
            height: 100vh;
            display: flex;
            align-items: center;
            justify-content: center;
            margin: 0;
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
        }

        .overlay {
            position: absolute; top: 0; left: 0; width: 100%; height: 100%;
            background: rgba(15, 23, 42, 0.4); /* Lighter overlay to let the background show through */
            z-index: 1;
        }

        /* --- GLASSMORPHISM CARD --- */
        .login-card {
            position: relative;
            z-index: 2;
            width: 100%;
            max-width: 400px;

            /* The Glass Effect */
            background: rgba(255, 255, 255, 0.15);
            backdrop-filter: blur(15px);
            -webkit-backdrop-filter: blur(15px);
            border: 1px solid rgba(255, 255, 255, 0.3);
            box-shadow: 0 8px 32px 0 rgba(0, 0, 0, 0.37);

            border-radius: 20px;
            padding: 40px;
            text-align: center;
            color: #ffffff; /* White text for the glass theme */
        }

        /* --- GLASS INPUT FIELDS --- */
        .form-control {
            border-radius: 50px;
            padding: 12px 20px;
            margin-bottom: 15px;
            background: rgba(255, 255, 255, 0.2); /* Semi-transparent inputs */
            border: 1px solid rgba(255, 255, 255, 0.4);
            color: #ffffff;
        }

        .form-control::placeholder {
            color: rgba(255, 255, 255, 0.8);
        }

        .form-control:focus {
            background: rgba(255, 255, 255, 0.3);
            color: #ffffff;
            border-color: #0ea5e9;
            box-shadow: 0 0 10px rgba(14, 165, 233, 0.4);
        }

        .btn-staff {
            width: 100%;
            border-radius: 50px;
            padding: 12px;
            font-weight: bold;
            color: white;
            background: linear-gradient(135deg, #0ea5e9, #2563eb);
            border: none;
            box-shadow: 0 4px 15px rgba(37, 99, 235, 0.3);
            transition: 0.3s;
        }

        .btn-staff:hover {
            transform: translateY(-2px);
            box-shadow: 0 6px 20px rgba(37, 99, 235, 0.5);
        }

        .alert-error {
            background: rgba(220, 38, 38, 0.8); /* Glass red error */
            color: #ffffff;
            padding: 10px;
            border-radius: 10px;
            font-size: 0.9rem;
            margin-bottom: 15px;
            border: 1px solid rgba(255, 255, 255, 0.2);
        }

        .switch-link {
            display: block;
            margin-top: 20px;
            color: rgba(255, 255, 255, 0.8);
            text-decoration: none;
            font-size: 0.9rem;
            transition: 0.2s;
        }

        .switch-link:hover {
            color: #d4af37;
        }
    </style>
</head>
<body>
<div class="overlay"></div>
<div class="login-card">
    <i class="fas fa-water fa-3x mb-3" style="color: #0ea5e9; text-shadow: 0 2px 10px rgba(0,0,0,0.2);"></i>
    <h3 class="mb-1 fw-bold">Ocean View</h3>
    <p class="mb-4" style="color: rgba(255,255,255,0.8);">Staff Portal Access</p>

    <form action="${pageContext.request.contextPath}/LoginServlet" method="post">
        <% String err = (String) request.getAttribute("errorMessage"); if (err != null) { %>
        <div class="alert-error"><i class="fas fa-exclamation-circle"></i> <%= err %></div>
        <% } %>

        <input type="hidden" name="loginType" value="Staff">

        <input type="text" name="username" class="form-control" placeholder="Username" required>
        <input type="password" name="password" class="form-control" placeholder="Password" required>
        <button type="submit" class="btn-staff">Login as Staff</button>
    </form>

    <a href="admin_login.jsp" class="switch-link"><i class="fas fa-shield-alt"></i> Go to Admin Login</a>
</div>
</body>
</html>