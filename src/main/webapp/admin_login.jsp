<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <title>Admin Login - Ocean View</title>
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
      /* Slightly darker overlay for Admin to feel more "secure" */
      background: rgba(15, 23, 42, 0.6);
      z-index: 1;
    }

    /* --- GLASSMORPHISM CARD --- */
    .login-card {
      position: relative;
      z-index: 2;
      width: 100%;
      max-width: 400px;

      background: rgba(255, 255, 255, 0.15);
      backdrop-filter: blur(15px);
      -webkit-backdrop-filter: blur(15px);
      border: 1px solid rgba(255, 255, 255, 0.3);
      box-shadow: 0 8px 32px 0 rgba(0, 0, 0, 0.5);

      border-radius: 20px;
      padding: 40px;
      text-align: center;
      color: #ffffff;
    }

    /* --- GLASS INPUT FIELDS --- */
    .form-control {
      border-radius: 50px;
      padding: 12px 20px;
      margin-bottom: 15px;
      background: rgba(255, 255, 255, 0.2);
      border: 1px solid rgba(255, 255, 255, 0.4);
      color: #ffffff;
    }

    .form-control::placeholder {
      color: rgba(255, 255, 255, 0.8);
    }

    .form-control:focus {
      background: rgba(255, 255, 255, 0.3);
      color: #ffffff;
      border-color: #d4af37; /* Gold focus border for Admin */
      box-shadow: 0 0 10px rgba(212, 175, 55, 0.4);
    }

    /* --- ADMIN BUTTON --- */
    .btn-admin {
      width: 100%;
      border-radius: 50px;
      padding: 12px;
      font-weight: bold;
      color: white;
      background: linear-gradient(135deg, #d4af37, #b4932a);
      border: none;
      box-shadow: 0 4px 15px rgba(212, 175, 55, 0.3);
      transition: 0.3s;
    }

    .btn-admin:hover {
      transform: translateY(-2px);
      box-shadow: 0 6px 20px rgba(212, 175, 55, 0.5);
    }

    /* --- ALERTS & LINKS --- */
    .alert-error {
      background: rgba(220, 38, 38, 0.8);
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
      color: #0ea5e9; /* Blue hover to indicate going to the Staff page */
    }
  </style>
</head>
<body>
<div class="overlay"></div>
<div class="login-card">
  <i class="fas fa-crown fa-3x mb-3" style="color: #d4af37; text-shadow: 0 2px 10px rgba(0,0,0,0.3);"></i>
  <h3 class="mb-1 fw-bold" style="color: #d4af37;">Administrator</h3>
  <p class="mb-4" style="color: rgba(255,255,255,0.8);">Secure Portal Access</p>

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