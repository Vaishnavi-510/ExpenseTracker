package servlet;

import java.io.*;
import javax.servlet.*;
import javax.servlet.http.*;
import java.sql.*;
import dao.DBConnection;

public class ResetServlet extends HttpServlet {

    protected void doPost(HttpServletRequest req, HttpServletResponse res)
    throws IOException, ServletException {

        String email = req.getParameter("email");
        String newPass = req.getParameter("newPassword");

        try {
            Connection con = DBConnection.getConnection();

            PreparedStatement ps = con.prepareStatement(
                "UPDATE users SET password=? WHERE email=?"
            );
            ps.setString(1, newPass);
            ps.setString(2, email);

            int i = ps.executeUpdate();

            if(i > 0) {
                req.setAttribute("msg", "Password updated successfully!");
                RequestDispatcher rd = req.getRequestDispatcher("login.jsp");
                rd.forward(req, res);
            }

        } catch(Exception e) {
            e.printStackTrace();
        }
    }
}