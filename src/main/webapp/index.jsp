<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Staff Login - Ocean View Resort</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">
    <style>
        body { background: url('https://images.unsplash.com/photo-1582719508461-905c673771fd?q=80&w=1920&auto=format&fit=crop'); background-size: cover; height: 100vh; display: flex; align-items: center; justify-content: center; margin: 0; }
        .overlay { position: absolute; top: 0; left: 0; width: 100%; height: 100%; background: rgba(15, 23, 42, 0.7); backdrop-filter: blur(5px); }
        .login-card { position: relative; z-index: 2; width: 100%; max-width: 400px; background: rgba(255, 255, 255, 0.95); border-radius: 20px; padding: 40px; text-align: center; box-shadow: 0 15px 35px rgba(0,0,0,0.5); }
        .form-control { border-radius: 50px; padding: 12px 20px; margin-bottom: 15px; background: #f8fafc; }
        .btn-staff { width: 100%; border-radius: 50px; padding: 12px; font-weight: bold; color: white; background: linear-gradient(135deg, #0ea5e9, #2563eb); border: none; }
        .alert-error { background: #fee2e2; color: #991b1b; padding: 10px; border-radius: 10px; font-size: 0.9rem; margin-bottom: 15px; }
        .switch-link { display: block; margin-top: 20px; color: #64748b; text-decoration: none; font-size: 0.9rem; }
        .switch-link:hover { color: #d4af37; }
    </style>
</head>
<body>
<div class="overlay"></div>
<div class="login-card">
    <i class="fas fa-water fa-3x mb-3" style="color: #0ea5e9;"></i>
    <h3 class="mb-1">Ocean View</h3>
    <p class="text-muted mb-4">Staff Portal Access</p>

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