<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>

<!DOCTYPE html>
<html>
<head>
<title>Expense Tracker Dashboard</title>

<link href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;600&display=swap" rel="stylesheet">
<script src="https://cdn.jsdelivr.net/npm/chart.js"></script>

<style>

body {
    margin: 0;
    font-family: 'Inter', sans-serif;
    background: #f4f6fb;
}

/* NAVBAR */
.navbar {
    background: linear-gradient(to right, #4f46e5, #ec4899);
    padding: 15px 25px;
    display: flex;
    justify-content: space-between;
    align-items: center;
    color: white;
}

.navbar a {
    color: white;
    text-decoration: none;
    margin-left: 15px;
    font-weight: 500;
}

/* HERO */
.hero {
    text-align: center;
    padding: 80px 20px;
    background: linear-gradient(120deg, #6366f1, #ec4899);
    color: white;
}

.hero h1 {
    font-size: 40px;
}

/* SECTION */
.section {
    padding: 50px 20px;
    text-align: center;
}

/* CARDS */
.cards {
    display: flex;
    flex-wrap: wrap;
    justify-content: center;
    gap: 20px;
}

.card {
    background: white;
    padding: 20px;
    width: 260px;
    border-radius: 12px;
    box-shadow: 0 5px 20px rgba(0,0,0,0.08);
}

/* BIG CARD */
.big-card {
    background: white;
    padding: 25px;
    width: 70%;
    margin: auto;
    border-radius: 12px;
    box-shadow: 0 5px 20px rgba(0,0,0,0.08);
}

/* SMALL CHART BOX */
.chart-box {
    width: 160px;
    height: 120px;
    margin: 20px auto;
}

/* FOOTER */
.footer {
    background: #111827;
    color: white;
    text-align: center;
    padding: 20px;
    margin-top: 40px;
}

</style>
</head>

<body>

<!-- NAVBAR -->
<div class="navbar">
    <div><b>💰 Expense Tracker</b></div>
    <div>
        <a href="#home">Home</a>
        <a href="#groups">Groups</a>
        <a href="#budget">Budget</a>
        <a href="#analytics">Analytics</a>
        <a href="login.jsp">login</a>
    </div>
</div>

<!-- HERO -->
<div class="hero" id="home">
    <h1>Smart Expense Tracker System</h1>
    <p>Manage Group & Individual Expenses, Budgets & Reports in One Place</p>
</div>

<!-- GROUPS -->
<div class="section" id="groups">
    <h2>👥 Group Expense Management</h2>

    <div class="cards">

        <div class="card">
            <h3>🎉 Party Group</h3>
            <p>Create party expense groups and split cost among friends</p>
        </div>

        <div class="card">
            <h3>🏖️ Trip Group</h3>
            <p>Manage picnic/trip expenses easily</p>
        </div>

        <div class="card">
            <h3>👨‍👩‍👧 Family Group</h3>
            <p>Track shared family expenses</p>
        </div>

    </div>
</div>

<!-- BUDGET -->
<div class="section" id="budget">
    <h2>💰 Budget Control System</h2>

    <div class="big-card">
        <p><b>Category Limits:</b></p>
        <p>🍔 Food → ₹7000</p>
        <p>👕 Clothes → ₹3000</p>
        <p>🚗 Travel → ₹5000</p>

        <hr>

        <p><b>Status:</b></p>
        <p style="color: green;">✔ Food: ₹5000 used (₹2000 left)</p>
        <p style="color: red;">⚠ Clothes: ₹3500 (Over Budget)</p>
    </div>
</div>

<!-- 👤 INDIVIDUAL EXPENSE (ADDED) -->
<div class="section" id="individual">
    <h2>👤 Individual Expense Management</h2>

    <div class="cards">

        <div class="card">
            <h3>➕ Add Personal Expense</h3>
            <p>Track your daily personal expenses</p>
        </div>

        <div class="card">
            <h3>💰 Set Personal Budget</h3>
            <p>Control your monthly spending limit</p>
        </div>

        <div class="card">
            <h3>⚠ Alerts</h3>
            <p>Get alerts when you exceed limit</p>
        </div>

    </div>
</div>

<!-- 📊 REPORTS (ADDED) -->
<div class="section" id="reports">
    <h2>📊 Expense Reports</h2>

    <div class="cards">

        <div class="card">
            <h3>📅 Daily Report</h3>
            <p>View today's expenses</p>
        </div>

        <div class="card">
            <h3>📆 Monthly Report</h3>
            <p>Analyze monthly spending</p>
        </div>

        <div class="card">
            <h3>📈 Yearly Report</h3>
            <p>Track yearly financial summary</p>
        </div>

    </div>
</div>

<!-- SMALL BAR CHART -->
<div class="section" id="analytics">
    <h2>📊 Analytics</h2>

    <div class="chart-box">
        <canvas id="expenseBar"></canvas>
    </div>
</div>

<script>
new Chart(document.getElementById("expenseBar"), {
    type: 'bar',
    data: {
        labels: ['Food', 'Travel', 'Clothes'],
        datasets: [{
            data: [7000, 5000, 3000],
            backgroundColor: ['#4f46e5', '#ec4899', '#10b981']
        }]
    },
    options: {
        responsive: true,
        plugins: {
            legend: { display: false }
        },
        scales: {
            x: { display: false },
            y: { display: false }
        }
    }
});
</script>

<!-- ABOUT -->
<div class="section">
    <h2>📌 About Project</h2>
    <div class="big-card">
        This Expense Tracker System is an MCA project that allows users to:
        <br><br>
        ✔ Create groups (Trip, Party, Family) <br>
        ✔ Split expenses among members <br>
        ✔ Set budget limits for categories <br>
        ✔ View analytics using charts <br>
    </div>
</div>

<!-- CONTACT -->
<div class="section">
    <h2>📞 Contact</h2>
    <div class="big-card">
        Email: support@expensetracker.com <br>
        Phone: +91 9876543210 <br>
        Location: Pune, India
    </div>
</div>

<!-- FOOTER -->
<div class="footer">
    © 2026 Expense Tracker | MCA Project
</div>

</body>
</html>