<%@page import="Database.DBConnection"%>
<%@page import="java.sql.Connection"%>
<%@page import="java.sql.PreparedStatement"%>
<%@page import="java.sql.ResultSet"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>View Service</title>
    </head>
    <body>
		<h1 align="center">Pickup Laundry</h1>
		<div style="text-align: center;">
			<a href="../Homepage.jsp">Dashboard</a>&ensp;| 
			<a href="../Logout.jsp">Logout</a>
		</div>
		<hr>

		<h1 align="center">List of Services</h1>
		<table border="1" cellpadding="10" cellspacing="0" align="center">
			<tr>
				<th>Service Image</th>
				<th>Service Code</th>
				<th>Service Name</th>
				<th>Description</th>
				<th>Action</th>
			</tr>
			<%
				Connection conn = DBConnection.getConnection();
				String sql = "SELECT * FROM Service";

				PreparedStatement ps = conn.prepareStatement(sql);

				ResultSet rs = ps.executeQuery();
				while (rs.next()) {
					out.println("<tr><td><img src='../../assets/images/" + rs.getString("serviceImg") + "' width='100px' height='70px'></td><td>" + rs.getString("serviceCode") + "</td><td>" + rs.getString("serviceName") + "</td><td>" + rs.getString("description") + "</td><td><a href='UpdateService.jsp?code=" + rs.getString("serviceCode") + "'>Update</a>&ensp;<a href='valDelService.jsp?code=" + rs.getString("serviceCode") + "''>Delete</a></td></tr>");
				}
				rs.close();
				ps.close();
				conn.close();
			%>
		</table>
		<p align="center">Want to add service? <a href="./AddService.jsp">Add Service</a></p>
    </body>
</html>
