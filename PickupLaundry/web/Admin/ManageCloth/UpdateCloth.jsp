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
        <title>Update Cloth</title>
		<link rel="stylesheet" href="../../assets/bootstrap/css/bootstrap.css">
		<link rel="stylesheet" href="../../assets/style.css">
    </head>
    <body>
		<h1 align="center">Pickup Laundry</h1>
		<div style="text-align: center;">
			<a href="../Homepage.jsp">Dashboard</a>&ensp;|
			<a href="./ViewCloth.jsp">View Cloth</a>&ensp;|
			<a href="../Logout.jsp">Logout</a>
		</div>
		<hr>

		<h1 align="center">Update Cloth</h1>

		<%
			int code = 0;
			String name = null, description = null;

			Connection conn = DBConnection.getConnection();
			String sql = "SELECT * FROM Cloth WHERE clothCode = ?";

			PreparedStatement ps = conn.prepareStatement(sql);
			if (request.getParameter("code") != null) {
				code = Integer.parseInt(request.getParameter("code"));
			} else {
				code = Integer.parseInt(session.getAttribute("sesCCode").toString());
			}

			ps.setInt(1, code);

			ResultSet rs = ps.executeQuery();
			while (rs.next()) {
				name = rs.getString("clothName");
				description = rs.getString("description");
			}
			rs.close();
			ps.close();
			conn.close();
		%>

		<%
			if (request.getAttribute("clothErrors") != null) {
				List<String> errors = (List<String>) request.getAttribute("clothErrors");
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

		<form action="valUpdCloth.jsp" method="POST">

			<div class="form-outline mb-4">
				<input type="text" name="txtCCode" class="form-control" value="<% out.println(code); %>" />
				<label class="form-label">Cloth Code</label>
			</div>

			<div class="form-outline mb-4">
				<input type="text" name="txtCName" class="form-control" required="" value="<% out.println(name); %>"/>
				<label class="form-label">Cloth Name</label>
			</div>

			<div class="form-outline mb-4">
				<textarea name="txtaDesc" class="form-control" required=""><% out.println(description);%></textarea>
				<label class="form-label">Cloth Description</label>
			</div>	



			<!--display none if clicked on edit button-->
			<!--			<div class="form-outline mb-4" >
							<b>Note:</b> Click on Edit button to make changes.
						</div>-->

			<!--<button type="submit"  class="btn btn-secondary btn-block mb-4">Edit</button>-->
			<button type="submit" class="btn btn-primary btn-block mb-4">Update</button>

			<div class="text-center">
				<p>Don't want to update? <a href="./ViewCloth.jsp">View Cloth</a></p>
			</div>
		</form>
    </body>
</html>
