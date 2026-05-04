package servlet;

import java.io.*;
import javax.servlet.*;
import javax.servlet.http.*;
import java.sql.*;
import dao.DBConnection;

public class AddGroupExpenseServlet extends HttpServlet {

    protected void doPost(HttpServletRequest req, HttpServletResponse res)
    throws IOException {

        HttpSession session = req.getSession();

        if(session.getAttribute("userId") == null){
            res.sendRedirect("login.jsp");
            return;
        }

        int userId = (int) session.getAttribute("userId");
        int groupId = Integer.parseInt(req.getParameter("groupId"));
        double amount = Double.parseDouble(req.getParameter("amount"));
        String category = req.getParameter("category");

        String[] members = req.getParameterValues("members");

        try {
            Connection con = DBConnection.getConnection();

            PreparedStatement ps = con.prepareStatement(
                "INSERT INTO expenses(user_id, group_id, category, amount) VALUES(?,?,?,?)",
                Statement.RETURN_GENERATED_KEYS
            );

            ps.setInt(1, userId);
            ps.setInt(2, groupId);
            ps.setString(3, category);
            ps.setDouble(4, amount);
            ps.executeUpdate();

            ResultSet rs = ps.getGeneratedKeys();
            int expenseId = 0;

            if(rs.next()){
                expenseId = rs.getInt(1);
            }

            // SPLIT LOGIC
            if(members == null){
                PreparedStatement allPs = con.prepareStatement(
                    "SELECT user_id FROM group_members WHERE group_id=?"
                );
                allPs.setInt(1, groupId);
                ResultSet allRs = allPs.executeQuery();

                while(allRs.next()){
                    PreparedStatement splitPs = con.prepareStatement(
                        "INSERT INTO expense_split(expense_id, user_id) VALUES(?,?)"
                    );
                    splitPs.setInt(1, expenseId);
                    splitPs.setInt(2, allRs.getInt("user_id"));
                    splitPs.executeUpdate();
                }

            } else {
                for(String m : members){
                    PreparedStatement splitPs = con.prepareStatement(
                        "INSERT INTO expense_split(expense_id, user_id) VALUES(?,?)"
                    );
                    splitPs.setInt(1, expenseId);
                    splitPs.setInt(2, Integer.parseInt(m));
                    splitPs.executeUpdate();
                }
            }

            session.setAttribute("msg", "✅ Expense Added!");
            res.sendRedirect("groupDashboard.jsp?groupId=" + groupId);

        } catch(Exception e){
            e.printStackTrace();
        }
    }
}