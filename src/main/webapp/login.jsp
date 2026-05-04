<%@ page contentType="text/html;charset=UTF-8" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Login</title>

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

/* Background blur */
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

/* Card */
.container {
    position: relative;
    z-index: 10;
    width: 360px;
    padding: 40px 35px;
    border-radius: 18px;
    background: rgba(255,255,255,0.6);
    backdrop-filter: blur(18px);
    box-shadow: 0 10px 40px rgba(0,0,0,0.1);
}

h2 {
    margin-bottom: 20px;
}

/* Inputs */
label {
    display: block;
    margin-bottom: 5px;
    font-size: 13px;
}

input {
    width: 100%;
    padding: 10px;
    margin-bottom: 8px;
    border-radius: 8px;
    border: 1px solid #ccc;
}

/* Button */
button {
    width: 100%;
    padding: 12px;
    border-radius: 10px;
    border: none;
    background: linear-gradient(to right, #818cf8, #f472b6);
    color: white;
    cursor: pointer;
    margin-top: 10px;
}

/* Messages */
.error {
    color: red;
    margin-bottom: 10px;
    text-align: center;
}
.success {
    color: green;
    margin-bottom: 10px;
    text-align: center;
}

small {
    display: block;
    margin-bottom: 10px;
}

/* Links */
.register-link {
    text-align: center;
    margin-top: 15px;
}

</style>

<script>
function validateEmail() {
    let email = document.getElementById("email").value;
    let error = document.getElementById("emailError");

    let regex = /^[A-Za-z0-9+_.-]+@[A-Za-z0-9.-]+$/;

    if (email === "") {
        error.innerHTML = "";
    } else if (!email.includes("@")) {
        error.innerHTML = "❌ @ missing";
    } else if (!regex.test(email)) {
        error.innerHTML = "❌ Invalid email";
    } else {
        error.innerHTML = "✅ Valid email";
        error.style.color = "green";
    }
}

function validatePassword() {
    let pass = document.getElementById("password").value;
    let error = document.getElementById("passError");

    if (pass.length === 0) {
        error.innerHTML = "";
    } else if (pass.length < 6) {
        error.innerHTML = "❌ Minimum 6 characters";
    } else {
        error.innerHTML = "✅ Valid password";
        error.style.color = "green";
    }
}
</script>

</head>

<body>

<div class="container">
    <h2>Login</h2>

    <!-- ERROR -->
    <%
        String error = (String) request.getAttribute("error");
        if(error != null){
    %>
        <div class="error"><%= error %></div>
    <%
        }
    %>

    <!-- SUCCESS -->
    <%
        String msg = (String) request.getAttribute("msg");
        if(msg != null){
    %>
        <div class="success"><%= msg %></div>
    <%
        }
    %>

    <form action="LoginServlet" method="post">

        <label>Email</label>
        <input type="text" id="email" name="email" onkeyup="validateEmail()" required>
        <small id="emailError"></small>

        <label>Password</label>
        <input type="password" id="password" name="password" onkeyup="validatePassword()" required>
        <small id="passError"></small>

        <div style="text-align:right;">
            <a href="forgot.jsp" style="font-size:13px;">Forgot Password?</a>
        </div>

        <button type="submit">Login</button>
    </form>

    <div class="register-link">
        Don't have an account? <a href="register.jsp">Register</a>
    </div>
</div>

</body>
</html>