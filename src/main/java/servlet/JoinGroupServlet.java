package servlet;

import java.io.*;
import javax.servlet.*;
import javax.servlet.http.*;
import java.sql.*;
import dao.DBConnection;

public class JoinGroupServlet extends HttpServlet {

    protected void doPost(HttpServletRequest req, HttpServletResponse res)
    throws IOException {

        HttpSession session = req.getSession();

        // 🔒 CHECK LOGIN
        if(session.getAttribute("userId") == null){
            res.sendRedirect("login.jsp");
            return;
        }

        int userId = (int) session.getAttribute("userId");
        String code = req.getParameter("code");

        try {
            Connection con = DBConnection.getConnection();

            // 🔍 FIND GROUP BY CODE
            PreparedStatement ps = con.prepareStatement(
                "SELECT id FROM user_groups WHERE invite_code=?"
            );
            ps.setString(1, code);

            ResultSet rs = ps.executeQuery();

            if(rs.next()){

                int groupId = rs.getInt("id");

                // ✅ CHECK ALREADY JOINED
                PreparedStatement check = con.prepareStatement(
                    "SELECT * FROM group_members WHERE group_id=? AND user_id=?"
                );
                check.setInt(1, groupId);
                check.setInt(2, userId);

                ResultSet rsCheck = check.executeQuery();

                if(!rsCheck.next()){

                    // ➕ ADD USER
                    PreparedStatement add = con.prepareStatement(
                        "INSERT INTO group_members(group_id,user_id) VALUES(?,?)"
                    );
                    add.setInt(1, groupId);
                    add.setInt(2, userId);
                    add.executeUpdate();

                    session.setAttribute("msg", "✅ Joined group successfully!");

                } else {
                    session.setAttribute("msg", "⚠ You already joined this group!");
                }

            } else {
                session.setAttribute("msg", "❌ Invalid invite code!");
            }

            // 🔄 REDIRECT (VERY IMPORTANT)
            res.sendRedirect("groupList.jsp");

        } catch(Exception e) {
            e.printStackTrace();

            session.setAttribute("msg", "❌ Error: " + e.getMessage());
            res.sendRedirect("groupList.jsp");
        }
    }
}