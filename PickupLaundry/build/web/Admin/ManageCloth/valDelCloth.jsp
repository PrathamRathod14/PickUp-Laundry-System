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
        <title>Validate Cloth</title>
    </head>
    <body>
        <%
			String code = request.getParameter("code");

			Connection conn = DBConnection.getConnection();

			String sql = "DELETE FROM Cloth WHERE clothCode = ?";

			PreparedStatement ps = conn.prepareStatement(sql);
			ps.setInt(1, Integer.parseInt(code));

			if (ps.executeUpdate() == 1) {
				request.getRequestDispatcher("./ViewCloth.jsp").forward(request, response);
			}
			ps.close();
			conn.close();
		%>
    </body>
</html>
