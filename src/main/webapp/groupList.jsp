<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.sql.*,dao.DBConnection" %>

<%
/* ✅ SESSION CHECK (VERY IMPORTANT) */
Integer userIdObj = (Integer) session.getAttribute("userId");

if(userIdObj == null){
    response.sendRedirect("login.jsp");
    return;
}

int userId = userIdObj;
%>

<!DOCTYPE html>
<html>
<head>
<title>Groups</title>

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
    width: 380px;
    padding: 30px;
    border-radius: 18px;
    background: rgba(255,255,255,0.35);
    backdrop-filter: blur(18px);
    box-shadow: 0 10px 40px rgba(0,0,0,0.08);
}

/* Title */
h2, h3 {
    text-align: center;
    color: #1e293b;
}

/* Inputs */
input {
    width: 100%;
    padding: 10px;
    margin: 10px 0;
    border-radius: 10px;
    border: 1px solid rgba(0,0,0,0.1);
    background: rgba(255,255,255,0.6);
}

/* Button */
button {
    width: 100%;
    padding: 10px;
    border: none;
    border-radius: 10px;
    background: linear-gradient(to right, #818cf8, #f472b6);
    color: white;
    cursor: pointer;
}

/* Messages */
.msg {
    text-align: center;
    color: blue;
}

.invite {
    text-align: center;
    color: green;
}

/* Group list */
.group-list {
    margin-top: 15px;
}

.group-list a {
    display: block;
    padding: 10px;
    margin: 5px 0;
    border-radius: 8px;
    background: rgba(255,255,255,0.6);
    text-decoration: none;
    color: #1e293b;
    text-align: center;
}

.group-list a:hover {
    background: #e0e7ff;
}

</style>
</head>

<body>

<!-- BACK -->
<a href="dashboard.jsp" class="back-link">&#8592;</a>

<div class="container">

<h2>Your Groups</h2>

<%
String msg = (String) session.getAttribute("msg");
if(msg != null){
%>
<p class="msg"><%= msg %></p>
<%
session.removeAttribute("msg");
}
%>

<!-- CREATE GROUP -->
<form action="CreateGroupServlet" method="post">
    <input type="text" name="groupName" placeholder="Trip / Party" required>
    <button>Create Group</button>
</form>

<%
String invite = (String) session.getAttribute("inviteCode");
if(invite != null){
%>
<p class="invite">Invite Code: <b><%= invite %></b></p>
<%
session.removeAttribute("inviteCode");
}
%>

<!-- JOIN GROUP -->
<form action="JoinGroupServlet" method="post">
    <input type="text" name="code" placeholder="Enter Invite Code" required>
    <button>Join Group</button>
</form>

<hr>

<h3>My Groups</h3>

<div class="group-list">

<%
Connection con = DBConnection.getConnection();

PreparedStatement ps = con.prepareStatement(
"SELECT g.id, g.group_name FROM user_groups g JOIN group_members gm ON g.id = gm.group_id WHERE gm.user_id=?"
);
ps.setInt(1, userId);

ResultSet rs = ps.executeQuery();

while(rs.next()){
%>

<a href="groupDashboard.jsp?groupId=<%= rs.getInt("id") %>">
    <%= rs.getString("group_name") %>
</a>

<%
}
%>

</div>

</div>

</body>
</html>