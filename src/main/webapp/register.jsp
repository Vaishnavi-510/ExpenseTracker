<%@ page isELIgnored="false" %>
<%@ page contentType="text/html;charset=UTF-8" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Register</title>

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

/* 🔥 FIX: bring card on top */
.login-card {
    position: relative;
    z-index: 10;
    width: 360px;
    padding: 40px 35px;
    border-radius: 18px;
    background: rgba(255, 255, 255, 0.6);
    backdrop-filter: blur(18px);
    box-shadow: 0 10px 40px rgba(0,0,0,0.1);
}

h2 {
    margin-bottom: 20px;
}

/* 🔥 FIX: proper spacing */
label {
    display: block;
    margin-bottom: 5px;
    font-size: 13px;
}

input {
    width: 100%;
    padding: 10px;
    margin-bottom: 10px;
    border-radius: 8px;
    border: 1px solid #ccc;
}

/* 🔥 BUTTON FIX */
button {
    width: 100%;
    padding: 12px;
    border: none;
    border-radius: 10px;
    background: linear-gradient(to right, #818cf8, #f472b6);
    color: white;
    cursor: pointer;
    margin-top: 10px;
}

.error {
    color: red;
    margin-bottom: 10px;
}

.success {
    color: green;
    margin-bottom: 10px;
}

small {
    display: block;
    margin-bottom: 10px;
}

/* LINKS */
.links {
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
        error.innerHTML = "❌ Min 6 chars";
    } else if (!/[A-Z]/.test(pass)) {
        error.innerHTML = "❌ Add capital letter";
    } else if (!/[0-9]/.test(pass)) {
        error.innerHTML = "❌ Add number";
    } else {
        error.innerHTML = "✅ Strong password";
        error.style.color = "green";
    }
}
</script>

</head>

<body>

<div class="login-card">
    <h2>Create Account</h2>

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

    <form action="RegisterServlet" method="post">

        <label>Email</label>
        <input type="text" id="email" name="email" onkeyup="validateEmail()" required>
        <small id="emailError"></small>

        <label>Password</label>
        <input type="password" id="password" name="password" onkeyup="validatePassword()" required>
        <small id="passError"></small>

        <label>Confirm Password</label>
        <input type="password" name="confirmPassword" required>

        <button type="submit">Register</button>
    </form>

    <div class="links">
        <a href="login.jsp">Already have an account? Login</a>
    </div>
</div>

</body>
</html>