package servlet;

import java.io.*;
import javax.servlet.*;
import javax.servlet.http.*;
import java.sql.*;
import dao.DBConnection;



public class ForgotServlet extends HttpServlet {

    protected void doPost(HttpServletRequest req, HttpServletResponse res)
    throws IOException, ServletException {

        String email = req.getParameter("email");

        try {
            Connection con = DBConnection.getConnection();

            PreparedStatement ps = con.prepareStatement(
                "SELECT * FROM users WHERE email=?"
            );
            ps.setString(1, email);

            ResultSet rs = ps.executeQuery();

            if(rs.next()) {
                // email exists → go to reset page
                req.setAttribute("email", email);
                RequestDispatcher rd = req.getRequestDispatcher("reset.jsp");
                rd.forward(req, res);
            } else {
                req.setAttribute("error", "Email not found!");
                RequestDispatcher rd = req.getRequestDispatcher("forgot.jsp");
                rd.forward(req, res);
            }

        } catch(Exception e) {
            e.printStackTrace();
        }
    }
}