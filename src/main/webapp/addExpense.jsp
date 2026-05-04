<!DOCTYPE html>
<html>
<head>
<title>Add Expense</title>

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

/* Blur effect */
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

.back-link:hover {
    color: #6366f1;
}

/* Card */
.container {
    position: relative;
    width: 350px;
    padding: 40px;
    border-radius: 18px;
    background: rgba(255,255,255,0.35);
    backdrop-filter: blur(18px);
    box-shadow: 0 10px 40px rgba(0,0,0,0.08);
}

/* Title */
h2 {
    margin-bottom: 25px;
    color: #1e293b;
    text-align: center;
}

/* Label */
label {
    display: block;
    margin-bottom: 5px;
    font-size: 13px;
    color: #475569;
}

/* Inputs */
input, select {
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

/* Success Message Style */
.success {
    color: green;
    text-align: center;
    margin-bottom: 15px;
    font-weight: 500;
}

</style>
</head>

<body>

<!-- BACK ARROW -->
<a href="dashboard.jsp" class="back-link">&#8592;</a>

<div class="container">

<h2>Add Expense</h2>

<!-- ✅ SUCCESS MESSAGE -->
<%
String success = (String) session.getAttribute("success");
if(success != null){
%>
    <div class="success">
        <%= success %>
    </div>
<%
    session.removeAttribute("success");
}
%>

<form action="AddExpenseServlet" method="post">

  <label>Category</label>
  <select name="category">
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

  <label>Amount</label>
  <input type="number" name="amount" required>

  <button type="submit">Add</button>

</form>

</div>

</body>
</html>