<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Login - Ocean View Resort</title>

    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">
    <link href="https://fonts.googleapis.com/css2?family=Playfair+Display:wght@700&family=Poppins:wght@300;400;600&display=swap" rel="stylesheet">

    <style>
        body {
            /* Beautiful Ocean/Hotel Background */
            background: url('https://images.unsplash.com/photo-1582719508461-905c673771fd?q=80&w=1920&auto=format&fit=crop') no-repeat center center fixed;
            background-size: cover;
            height: 100vh;
            display: flex;
            align-items: center;
            justify-content: center;
            font-family: 'Poppins', sans-serif;
        }

        /* Dark Overlay for better text visibility */
        .overlay {
            position: absolute;
            top: 0; left: 0; width: 100%; height: 100%;
            background: rgba(0, 0, 0, 0.4);
            z-index: 1;
        }

        /* The Glass Card */
        .login-card {
            position: relative;
            z-index: 2;
            background: rgba(255, 255, 255, 0.15); /* Transparent White */
            backdrop-filter: blur(15px); /* The Blur Effect */
            -webkit-backdrop-filter: blur(15px);
            border: 1px solid rgba(255, 255, 255, 0.3);
            border-radius: 20px;
            padding: 40px;
            width: 100%;
            max-width: 400px;
            box-shadow: 0 15px 35px rgba(0, 0, 0, 0.5);
            text-align: center;
            color: white;
            animation: slideUp 0.8s ease-out;
        }

        .login-card h2 {
            font-family: 'Playfair Display', serif;
            font-size: 2rem;
            margin-bottom: 10px;
        }

        .login-card p {
            font-size: 0.9rem;
            color: #ddd;
            margin-bottom: 30px;
        }

        /* Input Fields */
        .form-control {
            background: rgba(255, 255, 255, 0.8);
            border: none;
            border-radius: 50px;
            padding: 12px 20px;
            font-size: 0.95rem;
            margin-bottom: 20px;
        }

        .form-control:focus {
            background: white;
            box-shadow: 0 0 10px rgba(255, 255, 255, 0.5);
        }

        /* Login Button */
        .btn-login {
            width: 100%;
            background: #d4af37; /* Gold Color */
            border: none;
            border-radius: 50px;
            padding: 12px;
            font-weight: bold;
            font-size: 1rem;
            color: white;
            transition: 0.3s;
            box-shadow: 0 5px 15px rgba(212, 175, 55, 0.4);
        }

        .btn-login:hover {
            background: #b5922f;
            transform: translateY(-2px);
            color: white;
        }

        /* Error Message */
        .alert-danger {
            background: rgba(220, 53, 69, 0.8);
            border: none;
            color: white;
            font-size: 0.9rem;
            border-radius: 10px;
        }

        @keyframes slideUp {
            from { opacity: 0; transform: translateY(30px); }
            to { opacity: 1; transform: translateY(0); }
        }
    </style>
</head>
<body>

<div class="overlay"></div>

<div class="login-card">
    <div class="mb-4">
        <i class="fas fa-water fa-3x" style="color: #d4af37;"></i>
    </div>
    <h2>Ocean View Resort</h2>
    <p>Management System Login</p>

    <form action="LoginServlet" method="post">

        <%
            String error = (String) request.getAttribute("errorMessage");
            if (error != null) {
        %>
        <div class="alert alert-danger">
            <i class="fas fa-exclamation-circle"></i> <%= error %>
        </div>
        <%
            }
        %>

        <div class="input-group">
            <input type="text" name="username" class="form-control" placeholder="Username" required>
        </div>

        <div class="input-group">
            <input type="password" name="password" class="form-control" placeholder="Password" required>
        </div>

        <button type="submit" class="btn btn-login">
            Sign In <i class="fas fa-arrow-right ms-2"></i>
        </button>
    </form>

    <div class="mt-4" style="font-size: 0.8rem; color: #ccc;">
        &copy; 2026 Ocean View Resort
    </div>
</div>

</body>
</html>