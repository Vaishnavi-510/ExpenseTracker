<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page session="true" %>

<!DOCTYPE html>
<html>
<head>
<title>Set Budget</title>

<meta charset="UTF-8">

<link href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;600&display=swap" rel="stylesheet">

<style>

/* Background */
body {
    margin: 0;
    height: 100vh;
    font-family: 'Inter', sans-serif;
    background: linear-gradient(120deg, #f8fafc, #e0e7ff, #fdf2f8);
    display: flex;
    justify-content: center;
    align-items: center;
}

/* Back Arrow */
.back-link {
    position: absolute;
    top: 20px;
    left: 20px;
    font-size: 22px;
    text-decoration: none;
    color: #1e293b;
    font-weight: bold;
}

/* Card */
.container {
    width: 350px;
    padding: 35px;
    border-radius: 18px;
    background: rgba(255,255,255,0.35);
    backdrop-filter: blur(18px);
    box-shadow: 0 10px 40px rgba(0,0,0,0.08);
}

/* Title */
h2 {
    text-align: center;
    margin-bottom: 20px;
    color: #1e293b;
}

/* Label */
label {
    display: block;
    font-size: 13px;
    margin-bottom: 5px;
    color: #475569;
}

/* Inputs */
select, input {
    width: 100%;
    padding: 10px;
    margin-bottom: 15px;
    border-radius: 10px;
    border: 1px solid rgba(0,0,0,0.1);
    background: rgba(255,255,255,0.6);
}

/* Button */
button {
    width: 100%;
    padding: 12px;
    border: none;
    border-radius: 10px;
    background: linear-gradient(to right, #818cf8, #f472b6);
    color: white;
    cursor: pointer;
}

button:hover {
    opacity: 0.9;
}

/* Message */
.msg {
    text-align: center;
    color: green;
    font-weight: bold;
    margin-bottom: 10px;
}

</style>
</head>

<body>

<!-- BACK -->
<a href="dashboard.jsp" class="back-link">&#8592;</a>

<div class="container">

<h2>Set Budget</h2>

<%
String msg = (String) session.getAttribute("msg");
if(msg != null){
%>
<p class="msg"><%= msg %></p>
<%
session.removeAttribute("msg");
}
%>

<form action="SetBudgetServlet" method="post">

<label>Category</label>
<select name="category" required>
   <option>Food</option>
  <option>Groceries</option>
  <option>Transport</option>
  <option>Fuel</option>
  <option>Bills</option>
  <option>Rent</option>
  <option>Shopping</option>
  <option>Clothes</option>
  <option>Entertainment</option>
  <option>Medical</option>
  <option>Miscellaneous</option>
  </select>

<label>Month</label>
<select name="month" required>
  <option value="">Select</option>
  <option value="1">Jan</option>
  <option value="2">Feb</option>
  <option value="3">Mar</option>
  <option value="4">Apr</option>
  <option value="5">May</option>
  <option value="6">Jun</option>
  <option value="7">Jul</option>
  <option value="8">Aug</option>
  <option value="9">Sep</option>
  <option value="10">Oct</option>
  <option value="11">Nov</option>
  <option value="12">Dec</option>
</select>

<label>Limit Amount</label>
<input type="number" name="limit" required>

<button type="submit">Save Budget</button>

</form>

</div>

</body>
</html>