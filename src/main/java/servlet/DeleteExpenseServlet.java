package servlet;

import java.io.*;
import javax.servlet.*;
import javax.servlet.http.*;
import java.sql.*;
import dao.DBConnection;

public class DeleteExpenseServlet extends HttpServlet {
    protected void doGet(HttpServletRequest req, HttpServletResponse res)
    throws IOException {

        int id = Integer.parseInt(req.getParameter("id"));

        try {
            Connection con = DBConnection.getConnection();

            PreparedStatement ps = con.prepareStatement(
                "DELETE FROM expenses WHERE id=?"
            );
            ps.setInt(1, id);

            ps.executeUpdate();

            // ✅ Redirect with message
            res.sendRedirect("viewExpense.jsp?msg=deleted");

        } catch(Exception e) {
            e.printStackTrace();
        }
    }
}