<%@page import="Database.DBConnection"%>
<%@page import="java.sql.Connection"%>
<%@page import="java.sql.PreparedStatement"%>
<%@page import="java.sql.ResultSet"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>View Cloth</title>
    </head>
    <body>
		<h1 align="center">Pickup Laundry</h1>
		<div style="text-align: center;">
			<a href="../Homepage.jsp">Dashboard</a>&ensp;|
			<a href="../Logout.jsp">Logout</a>
		</div>
		<hr>

		<h1 align="center">List of Cloths</h1>
		<table border="1" cellpadding="10" cellspacing="0" align="center">
			<tr>
				<th>Cloth Code</th>
				<th>Cloth Name</th>
				<th>Description</th>
				<th>Action</th>
			</tr>
			<%
				Connection conn = DBConnection.getConnection();
				String sql = "SELECT * FROM Cloth";

				PreparedStatement ps = conn.prepareStatement(sql);

				ResultSet rs = ps.executeQuery();
				while (rs.next()) {
					out.println("<tr><td>" + rs.getString("clothCode") + "</td><td>" + rs.getString("clothName") + "</td><td>" + rs.getString("description") + "</td><td><a href='UpdateCloth.jsp?code=" + rs.getString("clothCode") + "'>Update</a>&ensp;<a href='valDelCloth.jsp?code=" + rs.getString("clothCode") + "'>Delete</a></td></tr>");
				}
				rs.close();
				ps.close();
				conn.close();
			%>
		</table>
		<p align="center">Want to add cloth? <a href="./AddCloth.jsp">Add Cloth</a></p>
    </body>
</html>
