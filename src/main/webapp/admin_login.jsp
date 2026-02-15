<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <title>Admin Login - Ocean View</title>
  <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
  <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">
  <style>
    body { background: url('https://images.unsplash.com/photo-1582719508461-905c673771fd?q=80&w=1920&auto=format&fit=crop'); background-size: cover; height: 100vh; display: flex; align-items: center; justify-content: center; margin: 0; }
    .overlay { position: absolute; top: 0; left: 0; width: 100%; height: 100%; background: rgba(15, 23, 42, 0.85); backdrop-filter: blur(8px); }
    .login-card { position: relative; z-index: 2; width: 100%; max-width: 400px; background: rgba(255, 255, 255, 0.95); border-radius: 20px; padding: 40px; text-align: center; box-shadow: 0 15px 35px rgba(0,0,0,0.8); }
    .form-control { border-radius: 50px; padding: 12px 20px; margin-bottom: 15px; background: #f8fafc; }
    .btn-admin { width: 100%; border-radius: 50px; padding: 12px; font-weight: bold; color: white; background: linear-gradient(135deg, #d4af37, #b4932a); border: none; }
    .alert-error { background: #fee2e2; color: #991b1b; padding: 10px; border-radius: 10px; font-size: 0.9rem; margin-bottom: 15px; }
    .switch-link { display: block; margin-top: 20px; color: #64748b; text-decoration: none; font-size: 0.9rem; }
    .switch-link:hover { color: #0ea5e9; }
  </style>
</head>
<body>
<div class="overlay"></div>
<div class="login-card">
  <i class="fas fa-crown fa-3x mb-3" style="color: #d4af37;"></i>
  <h3 class="mb-1" style="color: #d4af37;">Administrator</h3>
  <p class="text-muted mb-4">Secure Portal Access</p>

  <form action="${pageContext.request.contextPath}/LoginServlet" method="post">

    <%
      String err = (String) request.getAttribute("errorMessage");
      if (err != null) {
    %>
    <div class="alert-error"><i class="fas fa-exclamation-circle"></i> <%= err %></div>
    <%
      }
    %>

    <input type="hidden" name="loginType" value="Admin">

    <input type="text" name="username" class="form-control" placeholder="Admin Username" required>
    <input type="password" name="password" class="form-control" placeholder="Password" required>
    <button type="submit" class="btn-admin">Login as Admin</button>
  </form>

  <a href="index.jsp" class="switch-link"><i class="fas fa-user-tie"></i> Go to Staff Login</a>
</div>
</body>
</html>