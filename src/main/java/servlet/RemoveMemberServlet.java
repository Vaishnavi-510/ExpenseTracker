package servlet;

import java.io.*;
import javax.servlet.*;
import javax.servlet.http.*;
import java.sql.*;
import dao.DBConnection;

public class RemoveMemberServlet extends HttpServlet {

    protected void doGet(HttpServletRequest req, HttpServletResponse res)
    throws IOException {

        HttpSession session = req.getSession();

        // 🔒 CHECK LOGIN
        if(session.getAttribute("userId") == null){
            res.sendRedirect("login.jsp");
            return;
        }

        int currentUserId = (int) session.getAttribute("userId");
        int groupId = Integer.parseInt(req.getParameter("groupId"));
        int userIdToRemove = Integer.parseInt(req.getParameter("userId"));

        try {
            Connection con = DBConnection.getConnection();

            // 🔍 CHECK IF CURRENT USER IS CREATOR
            PreparedStatement check = con.prepareStatement(
                "SELECT created_by FROM user_groups WHERE id=?"
            );
            check.setInt(1, groupId);
            ResultSet rs = check.executeQuery();

            int creatorId = 0;
            if(rs.next()){
                creatorId = rs.getInt("created_by");
            }

            // ❌ NOT CREATOR
            if(currentUserId != creatorId){
                session.setAttribute("msg", "❌ Only group creator can remove members!");
                res.sendRedirect("groupDashboard.jsp?groupId=" + groupId);
                return;
            }

            // ❌ PREVENT CREATOR FROM REMOVING SELF
            if(userIdToRemove == creatorId){
                session.setAttribute("msg", "❌ Creator cannot remove themselves!");
                res.sendRedirect("groupDashboard.jsp?groupId=" + groupId);
                return;
            }

            // ✅ DELETE MEMBER
            PreparedStatement ps = con.prepareStatement(
                "DELETE FROM group_members WHERE group_id=? AND user_id=?"
            );
            ps.setInt(1, groupId);
            ps.setInt(2, userIdToRemove);
            ps.executeUpdate();

            // ✅ SUCCESS MESSAGE
            session.setAttribute("msg", "✅ Member removed successfully!");

            // 🔁 REDIRECT BACK
            res.sendRedirect("groupDashboard.jsp?groupId=" + groupId);

        } catch(Exception e){
            e.printStackTrace();

            session.setAttribute("msg", "❌ Error removing member!");
            res.sendRedirect("groupDashboard.jsp?groupId=" + groupId);
        }
    }
}