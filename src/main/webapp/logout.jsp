<%@ page session="true" %>

<%
    // 🧹 Invalidate session (logout)
    session.invalidate();

    // 🔄 Redirect to home page
    response.sendRedirect("home.jsp");
%>