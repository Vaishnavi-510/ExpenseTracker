<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.sql.*,dao.DBConnection" %>

<!DOCTYPE html>
<html>
<head>
<title>Expense Report</title>

<meta charset="UTF-8">

<link href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;600&display=swap" rel="stylesheet">

<script src="https://cdn.jsdelivr.net/npm/chart.js"></script>

<style>

/* Background */
body {
    margin: 0;
    font-family: 'Inter', sans-serif;
    background: linear-gradient(120deg, #f8fafc, #e0e7ff, #fdf2f8);
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

/* Container */
.container {
    width: 80%;
    margin: 50px auto;
    padding: 30px;
    border-radius: 18px;
    background: rgba(255,255,255,0.35);
    backdrop-filter: blur(18px);
    box-shadow: 0 10px 40px rgba(0,0,0,0.08);
}

/* Title */
h2 {
    text-align: center;
    color: #1e293b;
}

/* Filter */
select, button {
    padding: 10px;
    border-radius: 8px;
    border: none;
    margin: 10px 5px;
}

button {
    background: linear-gradient(to right, #818cf8, #f472b6);
    color: white;
    cursor: pointer;
}

/* Table */
table {
    width: 100%;
    border-collapse: collapse;
    margin-top: 20px;
    background: rgba(255,255,255,0.6);
}

th {
    background: #818cf8;
    color: white;
    padding: 10px;
}

td {
    padding: 10px;
    text-align: center;
}

/* Chart */
.chart-container {
    width: 60%;
    margin: 30px auto;
}

</style>
</head>

<body>

<a href="dashboard.jsp" class="back-link">&#8592;</a>

<div class="container">

<h2>Expense Report</h2>

<!-- FILTER -->
<form method="get">
<select name="month">
  <option value="">All</option>
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
Connection con = DBConnection.getConnection();

int userId = (int) session.getAttribute("userId");  // ✅ IMPORTANT

String monthParam = request.getParameter("month");

PreparedStatement ps;

if(monthParam != null && !monthParam.equals("")){
    ps = con.prepareStatement(
    "SELECT category, SUM(amount) total FROM expenses WHERE user_id=? AND group_id IS NULL AND MONTH(date)=? GROUP BY category"
    );
    ps.setInt(1, userId);
    ps.setInt(2, Integer.parseInt(monthParam));
} else {
    ps = con.prepareStatement(
    "SELECT category, SUM(amount) total FROM expenses WHERE user_id=? AND group_id IS NULL GROUP BY category"
    );
    ps.setInt(1, userId);
}

ResultSet rs = ps.executeQuery();

String labels = "";
String data = "";
%>

<!-- TABLE -->
<table>
<tr>
<th>Category</th>
<th>Total</th>
</tr>

<%
while(rs.next()){
    labels += "'" + rs.getString("category") + "',";
    data += rs.getDouble("total") + ",";
%>
<tr>
<td><%= rs.getString("category") %></td>
<td>&#8377; <%= rs.getDouble("total") %></td>
</tr>
<%
}
%>

</table>

<!-- CHART -->
<div class="chart-container">
    <canvas id="myChart"></canvas>
</div>

</div>

<script>

const ctx = document.getElementById('myChart');

new Chart(ctx, {
    type: 'bar',
    data: {
        labels: [<%= labels %>],
        datasets: [{
            label: 'Expense',
            data: [<%= data %>],
            backgroundColor: [
                '#6366f1',
                '#f472b6',
                '#34d399',
                '#fbbf24',
                '#60a5fa',
                '#fb7185'
            ],
            borderRadius: 8
        }]
    },
    options: {
        responsive: true,
        plugins: {
            legend: {
                display: false
            }
        },
        scales: {
            y: {
                beginAtZero: true
            }
        }
    }
});
</script>
</script>

</body>
</html>   