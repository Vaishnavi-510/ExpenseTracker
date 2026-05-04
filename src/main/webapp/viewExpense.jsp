<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.sql.*,dao.DBConnection" %>

<!DOCTYPE html>
<html>
<head>
<title>View Expenses</title>

<meta charset="UTF-8">

<link href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;600&display=swap" rel="stylesheet">

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

.back-link:hover {
    color: #6366f1;
}

/* Container */
.container {
    width: 80%;
    margin: 80px auto;
    padding: 30px;
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

/* Table */
table {
    width: 100%;
    border-collapse: collapse;
    background: rgba(255,255,255,0.6);
    border-radius: 10px;
    overflow: hidden;
}

/* Header */
th {
    background: #818cf8;
    color: white;
    padding: 12px;
}

/* Data */
td {
    padding: 10px;
    text-align: center;
    border-bottom: 1px solid #ddd;
}

/* Hover */
tr:hover {
    background: rgba(129,140,248,0.1);
}

/* Action links */
a.action {
    text-decoration: none;
    margin: 0 5px;
    color: #6366f1;
    font-weight: 500;
}

a.action:hover {
    text-decoration: underline;
}

</style>
</head>

<body>

<!-- BACK ARROW -->
<a href="dashboard.jsp" class="back-link">&#8592;</a>

<!-- ✅ MESSAGE (ONLY ONCE) -->
<%
String msg = request.getParameter("msg");

if(msg != null){
    if(msg.equals("deleted")){
%>
        <div class="toast">✅ Expense Deleted Successfully!</div>
<%
    } else if(msg.equals("updated")){
%>
        <div class="toast" >
            ✅  Expense Updated Successfully!
        </div>
<%
    }
}
%>
<div class="container">

<h2>Your Expenses</h2>

<table border="1">
<tr>
<th>ID</th>
<th>Category</th>
<th>Amount</th>
<th>Date</th>
<th>Action</th>
</tr>

<%
try {
    Connection con = DBConnection.getConnection();
    int userId = (int) session.getAttribute("userId");

    PreparedStatement ps = con.prepareStatement(
        "SELECT * FROM expenses WHERE user_id=? AND group_id IS NULL"
    );
    ps.setInt(1, userId);

    ResultSet rs = ps.executeQuery();

    while(rs.next()){
%>

<tr>
<td><%= rs.getInt("id") %></td>
<td><%= rs.getString("category") %></td>
<td>₹ <%= rs.getDouble("amount") %></td>
<td><%= rs.getDate("date") %></td>

<td>
    <a href="DeleteExpenseServlet?id=<%= rs.getInt("id") %>" 
       onclick="return confirm('Are you sure?')">Delete</a>
    |
    <a href="editExpense.jsp?id=<%= rs.getInt("id") %>">Edit</a>
</td>
</tr>

<%
    } // while end

} catch(Exception e){
    out.println("Error: " + e.getMessage());
}
%>

</table>

</div>

</body>
</html>