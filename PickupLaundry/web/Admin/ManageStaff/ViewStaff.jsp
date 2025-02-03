<%@page import="Database.DBConnection"%>
<%@page import="java.sql.Connection"%>
<%@page import="java.sql.PreparedStatement"%>
<%@page import="java.sql.ResultSet"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>View Staff</title>
    </head>
    <body>
		<h1 align="center">Pickup Laundry</h1>
		<div style="text-align: center;">
			<a href="../Homepage.jsp">Dashboard</a>&ensp;| 
			<a href="../Logout.jsp">Logout</a>
		</div>
		<hr>

		<h1 align="center">List of Staffs</h1>
		<table border="1" cellpadding="10" cellspacing="0" align="center">
			<tr>
				<th>Mobile No.</th>
				<th>Username</th>
				<th>Email</th>
				<th>City</th>
				<th>Address</th>
				<th>Registration Date</th>
				<th>Status</th>
				<th>Action</th>
			</tr>
			<%
				Connection conn = DBConnection.getConnection();
				String sql = "SELECT mobileNo, username, email, city, address, registrationDate, status FROM User WHERE roleId = ? ORDER BY registrationDate DESC";

				PreparedStatement ps = conn.prepareStatement(sql);
				ps.setInt(1, 3);

				ResultSet rs = ps.executeQuery();
				while (rs.next()) {
					out.println("<tr><td>" + rs.getString("mobileNo") + "</td><td>" + rs.getString("username") + "</td><td>" + rs.getString("email") + "</td><td>" + rs.getString("city") + "</td><td>" + rs.getString("address") + "</td><td>" + rs.getString("registrationDate") + "</td><td>" + rs.getString("status") + "</td><td><a href='./UpdateStaff.jsp?mobileNo=" + rs.getString("mobileNo") + "'>Update</a>&ensp;<a href='./valDelStaff.jsp?mobileNo=" + rs.getString("mobileNo") + "'>Delete</a></td></tr>");
				}
				rs.close();
				ps.close();
				conn.close();
			%>
		</table>
		<p align="center">Want to add staff? <a href="./AddStaff.jsp">Add Staff</a></p>
    </body>
</html>
