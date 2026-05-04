<!DOCTYPE html>
<html>
<head>
    <title>Reset Password</title>

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
    }

    body::before, body::after {
        content: "";
        position: absolute;
        border-radius: 50%;
        filter: blur(80px);
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
        width: 360px;
        padding: 40px 35px;
        border-radius: 18px;
        background: rgba(255, 255, 255, 0.35);
        backdrop-filter: blur(18px);
        box-shadow: 0 10px 40px rgba(0,0,0,0.08);
    }

    h2 {
        margin-bottom: 20px;
        color: #1e293b;
    }

    input {
        width: 100%;
        padding: 11px;
        border-radius: 10px;
        border: 1px solid rgba(0,0,0,0.08);
        margin-bottom: 15px;
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

    </style>
</head>

<body>

<div class="container">
    <h2>Reset Password</h2>

    <form action="ResetServlet" method="post">

        <input type="hidden" name="email" value="<%= request.getAttribute("email") %>">

        <input type="password" name="newPassword" placeholder="Enter new password" required>

        <button type="submit">Update Password</button>

    </form>
</div>

</body>
</html>