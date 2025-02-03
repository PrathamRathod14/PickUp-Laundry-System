<%@page import="java.util.List"%>
<%@page import="Database.DBConnection"%>
<%@page import="java.sql.Connection"%>
<%@page import="java.sql.PreparedStatement"%>
<%@page import="java.sql.ResultSet"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>Update Service</title>
		<link rel="stylesheet" href="../../assets/bootstrap/css/bootstrap.css">
		<link rel="stylesheet" href="../../assets/style.css">
    </head>
    <body>
		<h1 align="center">Pickup Laundry</h1>
		<div style="text-align: center;">
			<a href="../Homepage.jsp">Dashboard</a>&ensp;|
			<a href="./ViewService.jsp">View Service</a>&ensp;|
			<a href="../Logout.jsp">Logout</a>
		</div>
		<hr>

		<h1 align="center">Update Service</h1>

		<%
			int code = 0;
			String name = null, description = null;
			
			Connection conn = DBConnection.getConnection();
			String sql = "SELECT * FROM Service WHERE serviceCode = ?";

			PreparedStatement ps = conn.prepareStatement(sql);
			if (request.getParameter("code") != null) {
				code = Integer.parseInt(request.getParameter("code"));
			} else {
				code = Integer.parseInt(session.getAttribute("sesSCode").toString());
			}
			ps.setInt(1, code);

			ResultSet rs = ps.executeQuery();
			while (rs.next()) {
				name = rs.getString("serviceName");
				description = rs.getString("description");
			}
			rs.close();
			ps.close();
			conn.close();
		%>

		<%
			if (request.getAttribute("serviceErrors") != null) {
				List<String> errors = (List<String>) request.getAttribute("serviceErrors");
		%>
		<div style="text-align: center;">
			<h3>Error Messages</h3>
			<ul style="display: inline-block; text-align: left;">
				<% for (String error : errors) {%>
				<li><%= error%></li>
					<% } %>
			</ul>
			<% } %>
		</div>

		<form action="valUpdService.jsp" method="POST">

			<div class="form-outline mb-4">
				<input type="text" name="txtSCode" class="form-control" value="<% out.println(code); %>" />
				<label class="form-label">Service Code</label>
			</div>

			<div class="form-outline mb-4">
				<input type="text" name="txtSName" class="form-control" required="" value="<% if (name != null) {
						out.println(name);
					} %>"/>
				<label class="form-label">Service Name</label>
			</div>

			<div class="form-outline mb-4">
				<textarea name="txtaDesc" class="form-control" required=""><% if (description != null) out.println(description); %></textarea>
				<label class="form-label">Service Description</label>
			</div>	

			<button type="submit" class="btn btn-primary btn-block mb-4">Update</button>

			<div class="text-center">
				<p>Don't want to update? <a href="./ViewService.jsp">View Service</a></p>
			</div>
		</form>
    </body>
</html>
