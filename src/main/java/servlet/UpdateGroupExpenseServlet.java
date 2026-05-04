package servlet;

import java.io.*;
import javax.servlet.*;
import javax.servlet.http.*;
import java.sql.*;
import dao.DBConnection;

public class UpdateGroupExpenseServlet extends HttpServlet {

    protected void doPost(HttpServletRequest req, HttpServletResponse res)
    throws IOException {

        HttpSession session = req.getSession();

        // 🔒 SESSION CHECK
        if(session.getAttribute("userId") == null){
            res.sendRedirect("login.jsp");
            return;
        }

        int currentUserId = (int) session.getAttribute("userId");

        int expenseId = Integer.parseInt(req.getParameter("expenseId"));
        int groupId = Integer.parseInt(req.getParameter("groupId"));
        String category = req.getParameter("category");
        double amount = Double.parseDouble(req.getParameter("amount"));

        try {
            Connection con = DBConnection.getConnection();

            // 🔍 CHECK OWNER
            PreparedStatement check = con.prepareStatement(
                "SELECT user_id FROM expenses WHERE id=?"
            );
            check.setInt(1, expenseId);
            ResultSet rs = check.executeQuery();

            int ownerId = 0;
            if(rs.next()){
                ownerId = rs.getInt("user_id");
            }

            // ❌ NOT OWNER
            if(currentUserId != ownerId){
                session.setAttribute("msg", "❌ You cannot edit this expense!");
                res.sendRedirect("groupDashboard.jsp?groupId=" + groupId);
                return;
            }

            // ✅ UPDATE EXPENSE
            PreparedStatement ps = con.prepareStatement(
                "UPDATE expenses SET category=?, amount=? WHERE id=?"
            );
            ps.setString(1, category);
            ps.setDouble(2, amount);
            ps.setInt(3, expenseId);

            ps.executeUpdate();

            session.setAttribute("msg", "✅ Expense updated!");
            res.sendRedirect("groupDashboard.jsp?groupId=" + groupId);

        } catch(Exception e){
            e.printStackTrace();
        }
    }
}