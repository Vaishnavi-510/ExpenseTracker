package servlet;

import java.io.*;
import javax.servlet.*;
import javax.servlet.http.*;
import java.sql.*;
import dao.DBConnection;

public class RegisterServlet extends HttpServlet {

    protected void doPost(HttpServletRequest req, HttpServletResponse res)
    throws IOException, ServletException {

        String name = req.getParameter("name");
        String email = req.getParameter("email");
        String pass = req.getParameter("password");
        String cpass = req.getParameter("confirmPassword");

        // 🔹 EMAIL REGEX
        String emailRegex = "^[A-Za-z0-9+_.-]+@[A-Za-z0-9.-]+$";

        // 🔹 EMAIL VALIDATION
        if(email == null || !email.matches(emailRegex)) {
            req.setAttribute("error", "Invalid email! Must contain @ and valid format.");
            req.getRequestDispatcher("register.jsp").forward(req, res);
            return;
        }

        // 🔹 PASSWORD VALIDATION
        if(pass == null || pass.length() < 6) {
            req.setAttribute("error", "Password must be at least 6 characters!");
            req.getRequestDispatcher("register.jsp").forward(req, res);
            return;
        }

        if(!pass.matches(".*[A-Z].*")) {
            req.setAttribute("error", "Password must contain at least 1 uppercase letter!");
            req.getRequestDispatcher("register.jsp").forward(req, res);
            return;
        }

        if(!pass.matches(".*[0-9].*")) {
            req.setAttribute("error", "Password must contain at least 1 number!");
            req.getRequestDispatcher("register.jsp").forward(req, res);
            return;
        }

        // 🔹 CONFIRM PASSWORD
        if(!pass.equals(cpass)) {
            req.setAttribute("error", "Passwords do not match!");
            req.getRequestDispatcher("register.jsp").forward(req, res);
            return;
        }

        try {
            Connection con = DBConnection.getConnection();

            // 🔹 CHECK DUPLICATE EMAIL
            PreparedStatement check = con.prepareStatement(
                "SELECT * FROM users WHERE email=?"
            );
            check.setString(1, email);

            ResultSet rs = check.executeQuery();

            if(rs.next()) {
                req.setAttribute("error", "Email already registered!");
                req.getRequestDispatcher("register.jsp").forward(req, res);
                return;
            }

            // 🔹 INSERT USER
            PreparedStatement ps = con.prepareStatement(
                "INSERT INTO users(name,email,password) VALUES(?,?,?)"
            );
            ps.setString(1, name);
            ps.setString(2, email);
            ps.setString(3, pass);

            int i = ps.executeUpdate();

            if(i > 0) {
                req.setAttribute("msg", "Registration successful! Please login.");
                req.getRequestDispatcher("login.jsp").forward(req, res);
            }

        } catch(Exception e) {
            e.printStackTrace();
            req.setAttribute("error", "Something went wrong!");
            req.getRequestDispatcher("register.jsp").forward(req, res);
        }
    }
}