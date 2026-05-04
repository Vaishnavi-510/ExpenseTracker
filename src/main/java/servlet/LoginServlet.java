package servlet;

import java.io.*;
import javax.servlet.*;
import javax.servlet.http.*;
import java.sql.*;
import dao.DBConnection;

public class LoginServlet extends HttpServlet {

    protected void doPost(HttpServletRequest req, HttpServletResponse res)
    throws IOException, ServletException {

        String email = req.getParameter("email");
        String pass = req.getParameter("password");

        String emailRegex = "^[A-Za-z0-9+_.-]+@[A-Za-z0-9.-]+$";

        // EMAIL VALIDATION
        if(email == null || !email.matches(emailRegex)) {
            req.setAttribute("error", "Invalid email format!");
            req.getRequestDispatcher("login.jsp").forward(req, res);
            return;
        }

        // PASSWORD EMPTY CHECK
        if(pass == null || pass.trim().isEmpty()) {
            req.setAttribute("error", "Password cannot be empty!");
            req.getRequestDispatcher("login.jsp").forward(req, res);
            return;
        }

        try {
            Connection con = DBConnection.getConnection();

            PreparedStatement ps = con.prepareStatement(
                "SELECT * FROM users WHERE email=?"
            );
            ps.setString(1, email);

            ResultSet rs = ps.executeQuery();

            if(rs.next()) {

                String dbPass = rs.getString("password");

                if(dbPass.equals(pass)) {
                    HttpSession session = req.getSession();
                    session.setAttribute("userId", rs.getInt("id"));

                    res.sendRedirect("dashboard.jsp");
                } else {
                    req.setAttribute("error", "Incorrect password!");
                    req.getRequestDispatcher("login.jsp").forward(req, res);
                }

            } else {
                req.setAttribute("error", "Email not registered!");
                req.getRequestDispatcher("login.jsp").forward(req, res);
            }

        } catch(Exception e) {
            e.printStackTrace();
            req.setAttribute("error", "Something went wrong!");
            req.getRequestDispatcher("login.jsp").forward(req, res);
        }
    }
}