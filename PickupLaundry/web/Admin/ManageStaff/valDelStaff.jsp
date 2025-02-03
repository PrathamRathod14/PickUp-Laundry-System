<%@page import="Database.DBConnection"%>
<%@page import="java.util.Date"%>
<%@page import="java.text.SimpleDateFormat"%>
<%@page import="java.text.DateFormat"%>
<%@page import="java.util.List"%>
<%@page import="java.util.ArrayList"%>
<%@page import="java.sql.DriverManager"%>
<%@page import="java.sql.Connection"%>
<%@page import="java.sql.PreparedStatement"%>
<%@page import="java.sql.ResultSet"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>Validate Customer</title>
    </head>
    <body>
        <%
			String mobileNo = request.getParameter("mobileNo");

			Connection conn = DBConnection.getConnection();

			String sql = "DELETE FROM User WHERE mobileNo = ?";

			PreparedStatement ps = conn.prepareStatement(sql);
			ps.setString(1, mobileNo);

			if (ps.executeUpdate() == 1) {
				request.getRequestDispatcher("./ViewStaff.jsp").forward(request, response);
			}
			ps.close();
			conn.close();
		%>
    </body>
</html>
