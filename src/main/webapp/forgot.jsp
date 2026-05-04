<!DOCTYPE html>
<html>
<head>
    <title>Forgot Password</title>

    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;600&display=swap" rel="stylesheet">

    <style>

    body {
        margin: 0;
        height: 100vh;
        font-family: 'Inter', sans-serif;
        background: linear-gradient(120deg, #f8fafc, #e0e7ff, #fdf2f8);
        display: flex;
        justify-content: center;
        align-items: center;
        overflow: hidden;
    }

    body::before, body::after {
        content: "";
        position: absolute;
        border-radius: 50%;
        filter: blur(80px);
        z-index: 0;
    }

    body::before {
        width: 300px;
        height: 300px;
        background: #c7d2fe;
        top: 10%;
        left: 15%;
    }

    body::after {
        width: 350px;
        height: 350px;
        background: #fbcfe8;
        bottom: 10%;
        right: 15%;
    }

    .container {
        position: relative;
        z-index: 1;
        width: 360px;
        padding: 40px 35px;
        border-radius: 18px;
        background: rgba(255, 255, 255, 0.35);
        backdrop-filter: blur(18px);
        box-shadow: 0 10px 40px rgba(0,0,0,0.08);
        border: 1px solid rgba(255,255,255,0.4);
    }

    .container h2 {
        margin-bottom: 20px;
        color: #1e293b;
    }

    .input-group {
        margin-bottom: 15px;
    }

    label {
        font-size: 13px;
        color: #475569;
        display: block;
        margin-bottom: 5px;
    }

    input {
        width: 100%;
        padding: 11px;
        border-radius: 10px;
        border: 1px solid rgba(0,0,0,0.08);
        background: rgba(255,255,255,0.6);
    }

    button {
        width: 100%;
        padding: 12px;
        border-radius: 10px;
        border: none;
        background: linear-gradient(to right, #818cf8, #f472b6);
        color: white;
        font-size: 15px;
        cursor: pointer;
    }

    .error {
        color: #dc2626;
        background: #fee2e2;
        padding: 10px;
        border-radius: 8px;
        margin-bottom: 15px;
        text-align: center;
    }

    .back-link {
        margin-top: 15px;
        text-align: center;
        font-size: 13px;
    }

    </style>
</head>

<body>

<div class="container">
    <h2>Forgot Password</h2>

    <!-- Error -->
    <%
        String error = (String) request.getAttribute("error");
        if(error != null){
    %>
        <div class="error"><%= error %></div>
    <%
        }
    %>

    <form action="ForgotServlet" method="post">
        <div class="input-group">
            <label>Email</label>
            <input type="email" name="email" placeholder="Enter your email" required>
        </div>

        <button type="submit">Verify Email</button>
    </form>

    <div class="back-link">
        <a href="login.jsp">Back to Login</a>
    </div>
</div>

</body>
</html>