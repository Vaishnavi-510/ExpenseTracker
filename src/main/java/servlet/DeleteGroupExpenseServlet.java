package servlet;

import java.io.*;
import javax.servlet.*;
import javax.servlet.http.*;
import java.sql.*;
import dao.DBConnection;

public class DeleteGroupExpenseServlet extends HttpServlet {

    protected void doGet(HttpServletRequest req, HttpServletResponse res)
    throws IOException {

        HttpSession session = req.getSession();
        int userId = (int) session.getAttribute("userId");

        int expenseId = Integer.parseInt(req.getParameter("expenseId"));
        int groupId = Integer.parseInt(req.getParameter("groupId"));

        try {
            Connection con = DBConnection.getConnection();

            PreparedStatement check = con.prepareStatement(
                "SELECT user_id FROM expenses WHERE id=?"
            );
            check.setInt(1, expenseId);
            ResultSet rs = check.executeQuery();

            if(rs.next()){
                int creator = rs.getInt("user_id");

                if(creator != userId){
                    session.setAttribute("msg", "❌ You cannot delete this expense!");
                    res.sendRedirect("groupDashboard.jsp?groupId=" + groupId);
                    return;
                }
            }

            PreparedStatement delSplit = con.prepareStatement(
                "DELETE FROM expense_split WHERE expense_id=?"
            );
            delSplit.setInt(1, expenseId);
            delSplit.executeUpdate();

            PreparedStatement del = con.prepareStatement(
                "DELETE FROM expenses WHERE id=?"
            );
            del.setInt(1, expenseId);
            del.executeUpdate();

            session.setAttribute("msg", "✅ Expense Deleted!");
            res.sendRedirect("groupDashboard.jsp?groupId=" + groupId);

        } catch(Exception e){
            e.printStackTrace();
        }
    }
}