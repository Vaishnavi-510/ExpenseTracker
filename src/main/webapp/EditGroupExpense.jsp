<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.sql.*,dao.DBConnection" %>

<%
int expenseId = Integer.parseInt(request.getParameter("expenseId"));
int groupId = Integer.parseInt(request.getParameter("groupId"));
int currentUserId = (int) session.getAttribute("userId");

Connection con = DBConnection.getConnection();

// 🔍 Fetch expense
PreparedStatement ps = con.prepareStatement(
"SELECT * FROM expenses WHERE id=?"
);
ps.setInt(1, expenseId);
ResultSet rs = ps.executeQuery();

double amount = 0;
String category = "";
int ownerId = 0;

if(rs.next()){
    amount = rs.getDouble("amount");
    category = rs.getString("category");
    ownerId = rs.getInt("user_id");
}

// ❌ BLOCK if not owner
if(currentUserId != ownerId){
    response.sendRedirect("groupDashboard.jsp?groupId=" + groupId);
    return;
}
%>

<!DOCTYPE html>
<html>
<head>
<title>Edit Group Expense</title>

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
    text-align: center;
    color: #1e293b;
}

/* Label */
label {
    display: block;
    margin-bottom: 5px;
    font-size: 13px;
    color: #475569;
}

/* Inputs */
input {
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

</style>
</head>

<body>

<!-- 🔙 BACK BUTTON -->
<a href="groupDashboard.jsp?groupId=<%=groupId%>" class="back-link">&#8592;</a>

<div class="container">

<h2>Edit Group Expense</h2>

<form action="UpdateGroupExpenseServlet" method="post">

    <input type="hidden" name="expenseId" value="<%= expenseId %>">
    <input type="hidden" name="groupId" value="<%= groupId %>">

    <label>Category</label>
    <input type="text" name="category" value="<%= category %>" required>

    <label>Amount</label>
    <input type="number" name="amount" value="<%= amount %>" required>

    <button type="submit">Update</button>

</form>

</div>

</body>
</html>