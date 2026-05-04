<%@ page session="true" %>
<%@ page import="java.sql.*,dao.DBConnection" %>
<%@ page contentType="text/html;charset=UTF-8" pageEncoding="UTF-8" %>
<meta charset="UTF-8">

<!DOCTYPE html>
<html>
<head>
<title>Dashboard</title>

<link href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;600&display=swap" rel="stylesheet">

<style>

/* Background */
body {
    margin: 0;
    font-family: 'Inter', sans-serif;
    background: linear-gradient(120deg, #f8fafc, #e0e7ff, #fdf2f8);
}

/* Top Bar */
.top-bar {
    position: relative;
    padding: 20px 40px;
    text-align: center;
}

/* Title */
.title {
    font-size: 22px;
    font-weight: 600;
    color: #1e293b;
}

/* Logout */
.logout-btn {
    position: absolute;
    right: 40px;
    top: 15px;
    padding: 8px 15px;
    border-radius: 8px;
    border: none;
    background: linear-gradient(to right, #f87171, #ef4444);
    color: white;
    cursor: pointer;
}

/* Alert */
.alert {
    text-align: center;
    color: red;
    font-weight: bold;
    margin-top: 10px;
}

/* Container */
.container {
    display: flex;
    flex-direction: column;
    align-items: center;
    gap: 25px;
    padding: 30px;
}

/* Row */
.row {
    display: flex;
    gap: 20px;
    justify-content: center;
}

/* Card */
.card {
    width: 250px;
    background: rgba(255,255,255,0.4);
    backdrop-filter: blur(15px);
    border-radius: 15px;
    padding: 20px;
    box-shadow: 0 8px 25px rgba(0,0,0,0.08);
    text-align: center;
    transition: 0.3s;
}

.card:hover {
    transform: translateY(-5px);
}

/* Card Title */
.card h3 {
    margin-bottom: 10px;
    color: #1e293b;
}

/* Description */
.card p {
    font-size: 13px;
    color: #64748b;
    margin-bottom: 15px;
}

/* Button */
button {
    padding: 10px 15px;
    border: none;
    border-radius: 8px;
    background: linear-gradient(to right, #818cf8, #f472b6);
    color: white;
    cursor: pointer;
}

/* Budget Table */
.budget-table {
    width: 80%;
    margin: 20px auto;
    border-collapse: collapse;
    background: rgba(255,255,255,0.6);
}

.budget-table th {
    background: #818cf8;
    color: white;
    padding: 10px;
}

.budget-table td {
    padding: 10px;
    text-align: center;
}

</style>
</head>

<body>

<!-- TOP BAR -->
<div class="top-bar">
    <div class="title">Expense Tracker Dashboard</div>

    <a href="logout.jsp">
        <button class="logout-btn">Logout</button>
    </a>
</div>

<!-- ✅ ALERT -->
<%
String alert = (String) session.getAttribute("alert");
if(alert != null){
%>
<div class="alert"><%= alert %></div>
<%
session.removeAttribute("alert");
}
%>

<!-- DASHBOARD -->
<div class="container">

    <div class="row">
        <div class="card">
            <h3>Add Expense</h3>
            <a href="addExpense.jsp"><button>Open</button></a>
        </div>

        <div class="card">
            <h3>View Expenses</h3>
            <a href="viewExpense.jsp"><button>Open</button></a>
        </div>

        <div class="card">
            <h3>Reports</h3>
            <a href="report.jsp"><button>Open</button></a>
        </div>
    </div>

    <div class="row">
        <div class="card">
            <h3>Group Expense</h3>
            <a href="groupList.jsp"><button>Open</button></a>
        </div>

        <div class="card">
            <h3>Set Budget</h3>
            <a href="setBudget.jsp"><button>Open</button></a>
        </div>
    </div>

</div>

<!-- 🔽 MONTH FILTER -->
<form method="get" style="text-align:center; margin-top:20px;">
    <select name="month">
        <option value="">Current Month</option>
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

    <button type="submit">Filter</button>
</form>

<%
String monthParam = request.getParameter("month");
int month;

if(monthParam != null && !monthParam.equals("")){
    month = Integer.parseInt(monthParam);
} else {
    month = java.time.LocalDate.now().getMonthValue();
}

String[] months = {
"","January","February","March","April","May","June",
"July","August","September","October","November","December"
};
%>

<h3 style="text-align:center;">Budget for <%= months[month] %></h3>

<table class="budget-table">
<tr>
<th>Category</th>
<th>Limit</th>
<th>Spent</th>
<th>Remaining</th>
</tr>

<%
Connection con2 = DBConnection.getConnection();
int userId2 = (int) session.getAttribute("userId");

PreparedStatement ps2 = con2.prepareStatement(
"SELECT b.category, b.limit_amount, (SELECT IFNULL(SUM(amount),0) FROM expenses e WHERE e.user_id=b.user_id AND e.category=b.category AND MONTH(e.date)=b.month AND e.group_id IS NULL) as spent FROM budget b WHERE b.user_id=? AND b.month=?"
);

ps2.setInt(1, userId2);
ps2.setInt(2, month);

ResultSet rsb = ps2.executeQuery();

// 🔥 TOTAL VARIABLES
double totalLimit = 0;
double totalSpent = 0;

while(rsb.next()){
    double limit = rsb.getDouble("limit_amount");
    double spent = rsb.getDouble("spent");
    double remaining = limit - spent;

    totalLimit += limit;
    totalSpent += spent;
%>

<tr>
<td><%= rsb.getString("category") %></td>
<td>₹ <%= limit %></td>
<td>₹ <%= spent %></td>
<td>
<%
if(remaining < 0){
%>
<span style="color:red;">Exceeded by ₹ <%= Math.abs(remaining) %></span>
<%
}else{
%>
<span style="color:green;">₹ <%= remaining %></span>
<%
}
%>
</td>
</tr>

<%
}

// 🔥 FINAL TOTAL
double totalRemaining = totalLimit - totalSpent;
%>

<!-- 🔥 TOTAL ROW -->
<tr class="total-row">
<td>Total</td>
<td>₹ <%= totalLimit %></td>
<td>₹ <%= totalSpent %></td>
<td>
<%
if(totalRemaining < 0){
%>
<span style="color:red;">Exceeded by ₹ <%= Math.abs(totalRemaining) %></span>
<%
}else{
%>
<span style="color:green;">₹ <%= totalRemaining %></span>
<%
}
%>
</td>
</tr>

</table>

<!-- 🔥 SUMMARY -->
<div style="text-align:center; margin-top:20px;">
    <h3>Total Spent: ₹ <%= totalSpent %></h3>
    <h3>Remaining: ₹ <%= totalRemaining %></h3>
</div>


</table>
</body>
</html>