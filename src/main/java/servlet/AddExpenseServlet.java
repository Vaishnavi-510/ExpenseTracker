package servlet;

import java.io.*;
import javax.servlet.*;
import javax.servlet.http.*;
import java.sql.*;
import dao.DBConnection;

public class AddExpenseServlet extends HttpServlet {

    protected void doPost(HttpServletRequest req, HttpServletResponse res)
    throws IOException {

        HttpSession session = req.getSession();

        int userId = (int) session.getAttribute("userId");

        String category = req.getParameter("category");
        double amount = Double.parseDouble(req.getParameter("amount"));

        Connection con = null;

        try {
            con = DBConnection.getConnection();

            // ➕ INSERT EXPENSE (PERSONAL ONLY)
            PreparedStatement ps = con.prepareStatement(
                "INSERT INTO expenses(user_id, category, amount, group_id) VALUES(?,?,?,NULL)"
            );

            ps.setInt(1, userId);
            ps.setString(2, category);
            ps.setDouble(3, amount);
            ps.executeUpdate();

            // ✅ SUCCESS MESSAGE
            session.setAttribute("success", "Expense added successfully!");

            // 🔥 =========================
            // 🔥 BUDGET CHECK STARTS HERE
            // 🔥 =========================

            // 📅 CURRENT MONTH
            java.time.LocalDate today = java.time.LocalDate.now();
            int currentMonth = today.getMonthValue();

            // 💰 TOTAL SPENT FOR THIS CATEGORY (PERSONAL ONLY)
            PreparedStatement sum = con.prepareStatement(
                "SELECT IFNULL(SUM(amount),0) as total FROM expenses WHERE user_id=? AND category=? AND MONTH(date)=? AND group_id IS NULL"
            );

            sum.setInt(1, userId);
            sum.setString(2, category);
            sum.setInt(3, currentMonth);

            ResultSet rs = sum.executeQuery();

            double total = 0;

            if(rs.next()){
                total = rs.getDouble("total");
            }

            // 📊 GET BUDGET LIMIT
            PreparedStatement bud = con.prepareStatement(
                "SELECT limit_amount FROM budget WHERE user_id=? AND category=? AND month=?"
            );

            bud.setInt(1, userId);
            bud.setString(2, category);
            bud.setInt(3, currentMonth);

            ResultSet rs2 = bud.executeQuery();

            if(rs2.next()){
                double limit = rs2.getDouble("limit_amount");
                double remaining = limit - total;

                // 🚨 EXCEEDED
                if(total >= limit){
                    session.setAttribute("alert",
                        "🚨 " + category + " budget exceeded by ₹" + Math.abs(remaining));
                }
                // ⚠ NEAR LIMIT (85%)
                else if(total >= 0.85 * limit){
                    session.setAttribute("alert",
                        "⚠ " + category + " almost reached! Remaining ₹" + remaining);
                }
                // ✅ SAFE
                else{
                    session.setAttribute("alert",
                        "✅ " + category + " remaining ₹" + remaining);
                }
            }

            // 🔄 REDIRECT TO DASHBOARD (IMPORTANT)
            res.sendRedirect("addExpense.jsp");

        } catch (Exception e) {
            e.printStackTrace();
        }
    }
}