package servlet;

import java.io.*;
import javax.servlet.*;
import javax.servlet.http.*;
import java.sql.*;
import dao.DBConnection;

public class UpdateExpenseServlet extends HttpServlet {
    protected void doPost(HttpServletRequest req, HttpServletResponse res)
    throws IOException {

        int id = Integer.parseInt(req.getParameter("id"));
        String category = req.getParameter("category");
        double amount = Double.parseDouble(req.getParameter("amount"));

        try {
            Connection con = DBConnection.getConnection();

            PreparedStatement ps = con.prepareStatement(
                "UPDATE expenses SET category=?, amount=? WHERE id=?"
            );
            ps.setString(1, category);
            ps.setDouble(2, amount);
            ps.setInt(3, id);

            ps.executeUpdate();

            res.sendRedirect("viewExpense.jsp?msg=updated");
        } catch(Exception e) {
            e.printStackTrace();
        }
    }
}