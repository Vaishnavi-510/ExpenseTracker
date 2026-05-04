package servlet;

import java.io.*;
import javax.servlet.*;
import javax.servlet.http.*;
import java.sql.*;
import java.util.UUID;
import dao.DBConnection;

public class CreateGroupServlet extends HttpServlet {

    protected void doPost(HttpServletRequest req, HttpServletResponse res)
    throws IOException {

        HttpSession session = req.getSession();

        // 🔒 CHECK LOGIN
        if(session.getAttribute("userId") == null){
            res.sendRedirect("login.jsp");
            return;
        }

        int userId = (int) session.getAttribute("userId");

        // 📥 GET DATA
        String groupName = req.getParameter("groupName");
        if(groupName != null){
            groupName = groupName.trim();
        }

        Connection con = null;

        try {
            con = DBConnection.getConnection();

            // 🔑 GENERATE INVITE CODE
            String code = UUID.randomUUID().toString().replace("-", "").substring(0,6);

            // ✅ FIXED QUERY (comma added)
            PreparedStatement ps = con.prepareStatement(
                "INSERT INTO user_groups(group_name, created_by, invite_code) VALUES(?,?,?)",
                Statement.RETURN_GENERATED_KEYS
            );

            ps.setString(1, groupName);
            ps.setInt(2, userId);   // 👈 creator stored properly
            ps.setString(3, code);

            int rows = ps.executeUpdate();

            if(rows > 0){

                // 📌 GET GENERATED GROUP ID
                ResultSet rs = ps.getGeneratedKeys();
                int groupId = 0;

                if(rs.next()){
                    groupId = rs.getInt(1);
                }

                // ✅ ADD CREATOR TO GROUP MEMBERS
                if(groupId > 0){
                    PreparedStatement add = con.prepareStatement(
                        "INSERT INTO group_members(group_id, user_id) VALUES(?,?)"
                    );
                    add.setInt(1, groupId);
                    add.setInt(2, userId);
                    add.executeUpdate();
                }

                session.setAttribute("inviteCode", code);
                session.setAttribute("msg", "✅ Group created successfully!");

            } else {
                session.setAttribute("msg", "❌ Failed to create group!");
            }

            res.sendRedirect("groupList.jsp");

        } catch(Exception e) {
            e.printStackTrace();
            session.setAttribute("msg", "❌ Error: " + e.getMessage());
            res.sendRedirect("groupList.jsp");
        }
    }
}