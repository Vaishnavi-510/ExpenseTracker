<%@ page contentType="text/html;charset=UTF-8" %>
<%@ page import="java.sql.*,java.util.*,dao.DBConnection" %>

<%
int groupId = Integer.parseInt(request.getParameter("groupId"));
int currentUserId = (int) session.getAttribute("userId");

Connection con = DBConnection.getConnection();

/* ---------------- GROUP INFO ---------------- */
PreparedStatement gp = con.prepareStatement(
"SELECT g.group_name, u.name as creator_name, g.created_by FROM user_groups g LEFT JOIN users u ON g.created_by=u.id WHERE g.id=?"
);
gp.setInt(1, groupId);
ResultSet grs = gp.executeQuery();

String groupName = "";
String creatorName = "";
int creatorId = 0;

if(grs.next()){
    groupName = grs.getString("group_name");
    creatorName = grs.getString("creator_name");
    creatorId = grs.getInt("created_by");

    if(creatorName == null){
        creatorName = "Unknown";
    }
}
%>

<!DOCTYPE html>
<html>
<head>
<title>Group Dashboard</title>

<link href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;600&display=swap" rel="stylesheet">

<style>
body { margin:0; font-family:'Inter'; background:linear-gradient(120deg,#f8fafc,#e0e7ff,#fdf2f8);}
.container { width:85%; margin:60px auto; padding:25px; border-radius:18px;
background:rgba(255,255,255,0.35); backdrop-filter:blur(18px);}
h2,h3 { text-align:center; }
table { width:100%; border-collapse:collapse; margin-top:15px;}
th { background:#818cf8; color:white; padding:10px;}
td { padding:10px; text-align:center;}
button { padding:6px 10px; border:none; border-radius:8px; cursor:pointer;}
</style>
</head>

<body>
<a href="groupList.jsp" class="back-link">&#8592;</a>


<div class="container">

<h2>💸 <%= groupName %></h2>
<p style="text-align:center;">Created by: <b><%= creatorName %></b></p>
<% if(session.getAttribute("msg") != null){ %>
    <p class="msg"><%= session.getAttribute("msg") %></p>
<% session.removeAttribute("msg"); } %>
<hr>

<!-- MEMBERS -->
<h3>👥 Members</h3>
<table>
<tr><th>Name</th><th>Action</th></tr>

<%
PreparedStatement memPs = con.prepareStatement(
"SELECT u.id, u.name FROM group_members gm JOIN users u ON gm.user_id=u.id WHERE gm.group_id=?"
);
memPs.setInt(1, groupId);
ResultSet memRs = memPs.executeQuery();

List<Integer> userIds = new ArrayList<>();
Map<Integer,String> userMap = new HashMap<>();

while(memRs.next()){
    int uid = memRs.getInt("id");
    userIds.add(uid);
    userMap.put(uid, memRs.getString("name"));
%>
<tr>
<td><%= memRs.getString("name") %></td>
<td>

<% 
// Show remove ONLY if:
// 1. Current user is creator
// 2. Row user is NOT creator
if(currentUserId == creatorId && uid != creatorId){ 
%>

<a href="RemoveMemberServlet?groupId=<%=groupId%>&userId=<%=uid%>"
onclick="return confirm('Are you sure to remove this member?')">
❌ Remove
</a>

<% } else if(uid == creatorId) { %>

<span style="color:gray;">Creator</span>

<% } else { %>

<span style="color:gray;">Not Allowed</span>

<% } %>

</td></tr>
<% } %>
</table>

<hr>

<!-- ADD EXPENSE -->
<h3>➕ Add Expense</h3>
<form action="AddGroupExpenseServlet" method="post">
<input type="hidden" name="groupId" value="<%= groupId %>">

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
<input name="amount" placeholder="Amount" required>

<h4>Select Members:</h4>
<%
for(Integer id : userIds){
%>
<input type="checkbox" name="members" value="<%= id %>"> <%= userMap.get(id) %><br>
<% } %>

<button>Add Expense</button>
</form>

<hr>

<!-- EXPENSE TABLE -->
<h3>📋 Expenses</h3>

<table>
<tr>
<th>User</th>
<th>Amount</th>
<th>Category</th>
<th>Date</th>
<th>Contributed Between</th>
<th>Action</th>
</tr>

<%
PreparedStatement ps = con.prepareStatement(
"SELECT e.*, u.name FROM expenses e JOIN users u ON e.user_id=u.id WHERE e.group_id=?"
);
ps.setInt(1, groupId);
ResultSet rs = ps.executeQuery();

while(rs.next()){
    int expId = rs.getInt("id");

    PreparedStatement splitPs = con.prepareStatement(
        "SELECT u.name FROM expense_split es JOIN users u ON es.user_id=u.id WHERE es.expense_id=?"
    );
    splitPs.setInt(1, expId);
    ResultSet splitRs = splitPs.executeQuery();

    List<String> names = new ArrayList<>();
    while(splitRs.next()){
        names.add(splitRs.getString("name"));
    }

    String display = (names.size() == userIds.size()) ? "All Members" : String.join(", ", names);
%>

<tr>
<td><%= rs.getString("name") %></td>
<td>₹ <%= rs.getDouble("amount") %></td>
<td><%= rs.getString("category") %></td>
<td><%= rs.getDate("date") %></td>
<td><%= display %></td>

<td>
<% if(currentUserId == rs.getInt("user_id")){ %>

<!-- ✏️ EDIT -->
<a href="EditGroupExpense.jsp?expenseId=<%=rs.getInt("id")%>&groupId=<%=groupId%>">✏️</a>

<!-- 🗑️ DELETE -->
<a href="DeleteGroupExpenseServlet?expenseId=<%=rs.getInt("id")%>&groupId=<%=groupId%>">🗑️</a>

<% } else { %>
<button onclick="alert('You cannot edit/delete this expense')">❌</button>
<% } %>
</td>
</tr>

<% } %>
</table>

<hr>

<!-- SUMMARY -->
<%
PreparedStatement totalPs = con.prepareStatement(
"SELECT IFNULL(SUM(amount),0) as total FROM expenses WHERE group_id=?"
);
totalPs.setInt(1, groupId);
ResultSet totalRs = totalPs.executeQuery();

double total = 0;
if(totalRs.next()) total = totalRs.getDouble("total");
%>

<h3>💰 Total: ₹ <%= total %></h3>

<hr>

<!-- CONTRIBUTION -->
<h3>📊 Contribution</h3>

<table>
<tr><th>Name</th><th>Paid</th><th>Share</th><th>Status</th></tr>

<%
Map<Integer, Double> paidMap = new HashMap<>();
Map<Integer, Double> shareMap = new HashMap<>();

PreparedStatement paidPs = con.prepareStatement(
"SELECT user_id, SUM(amount) as paid FROM expenses WHERE group_id=? GROUP BY user_id"
);
paidPs.setInt(1, groupId);
ResultSet paidRs = paidPs.executeQuery();

while(paidRs.next()){
    paidMap.put(paidRs.getInt("user_id"), paidRs.getDouble("paid"));
}

for(Integer uid : userIds){
    paidMap.putIfAbsent(uid, 0.0);
    shareMap.put(uid, 0.0);
}

PreparedStatement expPs = con.prepareStatement(
"SELECT id, amount FROM expenses WHERE group_id=?"
);
expPs.setInt(1, groupId);
ResultSet expRs = expPs.executeQuery();

while(expRs.next()){
    int expId = expRs.getInt("id");
    double amt = expRs.getDouble("amount");

    PreparedStatement cntPs = con.prepareStatement(
        "SELECT COUNT(*) as cnt FROM expense_split WHERE expense_id=?"
    );
    cntPs.setInt(1, expId);
    ResultSet cntRs = cntPs.executeQuery();

    int count = 1;
    if(cntRs.next()) count = cntRs.getInt("cnt");

    double per = amt / count;

    PreparedStatement uPs = con.prepareStatement(
        "SELECT user_id FROM expense_split WHERE expense_id=?"
    );
    uPs.setInt(1, expId);
    ResultSet uRs = uPs.executeQuery();

    while(uRs.next()){
        int uid = uRs.getInt("user_id");
        shareMap.put(uid, shareMap.get(uid) + per);
    }
}

for(Integer uid : userIds){
    double paid = paidMap.get(uid);
    double share = shareMap.get(uid);
    double diff = paid - share;
%>

<tr>
<td><%= userMap.get(uid) %></td>
<td>₹ <%= paid %></td>
<td>₹ <%= share %></td>
<td>
<% if(diff > 0){ %>
Gets ₹ <%= diff %>
<% } else if(diff < 0){ %>
Owes ₹ <%= Math.abs(diff) %>
<% } else { %>
Settled ✓
<% } %>
</td>
</tr>

<% } %>
</table>

<hr>

<!-- SETTLEMENT -->
<h3>💸 Settlement</h3>

<%
List<Integer> users = new ArrayList<>(userIds);
List<Double> balance = new ArrayList<>();

for(Integer u : users){
    balance.add(paidMap.get(u) - shareMap.get(u));
}

for(int i=0;i<users.size();i++){
for(int j=0;j<users.size();j++){

if(balance.get(i) < 0 && balance.get(j) > 0){

double amt = Math.min(Math.abs(balance.get(i)), balance.get(j));

if(amt > 0){
%>

<p><%= userMap.get(users.get(i)) %> pays ₹ <%= amt %> to <b><%= userMap.get(users.get(j)) %></b></p>

<%
balance.set(i, balance.get(i) + amt);
balance.set(j, balance.get(j) - amt);
}
}
}
}
%>

</div>
</body>
</html>