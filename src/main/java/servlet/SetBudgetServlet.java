package servlet;

import java.io.*;
import javax.servlet.*;
import javax.servlet.http.*;
import java.sql.*;
import dao.DBConnection;

public class SetBudgetServlet extends HttpServlet {
    protected void doPost(HttpServletRequest req, HttpServletResponse res)
    throws IOException {

        HttpSession session = req.getSession();

        int userId = (int) session.getAttribute("userId");

        String category = req.getParameter("category");
        int month = Integer.parseInt(req.getParameter("month"));
        double limit = Double.parseDouble(req.getParameter("limit"));

        try {
            Connection con = DBConnection.getConnection();

            // 🔍 CHECK IF BUDGET EXISTS
            PreparedStatement check = con.prepareStatement(
                "SELECT * FROM budget WHERE user_id=? AND category=? AND month=?"
            );
            check.setInt(1, userId);
            check.setString(2, category);
            check.setInt(3, month);

            ResultSet rs = check.executeQuery();

            if(rs.next()){
                // 🔄 UPDATE
                PreparedStatement update = con.prepareStatement(
                    "UPDATE budget SET limit_amount=? WHERE user_id=? AND category=? AND month=?"
                );
                update.setDouble(1, limit);
                update.setInt(2, userId);
                update.setString(3, category);
                update.setInt(4, month);
                update.executeUpdate();

                session.setAttribute("msg", "✅ Budget Updated Successfully!");

            } else {
                // ➕ INSERT
                PreparedStatement insert = con.prepareStatement(
                    "INSERT INTO budget(user_id,category,month,limit_amount) VALUES(?,?,?,?)"
                );
                insert.setInt(1, userId);
                insert.setString(2, category);
                insert.setInt(3, month);
                insert.setDouble(4, limit);
                insert.executeUpdate();

                session.setAttribute("msg", "✅ Budget Set Successfully!");
            }

            res.sendRedirect("setBudget.jsp");

        } catch(Exception e) {
            e.printStackTrace();
        }
    }
}