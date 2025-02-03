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
        <title>Add Service</title>
		<link rel="stylesheet" href="../../assets/bootstrap/css/bootstrap.css">
		<link rel="stylesheet" href="../../assets/style.css">
    </head>
    <body>
		<h1 align="center">Pickup Laundry</h1>
		<div style="text-align: center;">
			<a href="../Homepage.jsp">Dashboard</a>&ensp;|
			<a href="../Logout.jsp">Logout</a>
		</div>
		<hr>

		<h1 align="center">Add Service</h1>

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

		<form action="../../valAddService" method="POST" enctype="multipart/form-data">
			<div class="form-outline mb-4">
				<input type="text" name="txtSName" class="form-control" required="" value="<% if (request.getParameter("txtSName") != null) {
						out.println(request.getParameter("txtSName"));
					} %>"/>
				<label class="form-label">Service Name</label>
			</div>

			<div class="form-outline mb-4">
				<textarea name="txtaDesc" class="form-control" required=""><% if (request.getParameter("txtaDesc") != null) {
						out.println(request.getParameter("txtaDesc"));
					}%></textarea>
				<label class="form-label">Service Description</label>
			</div>	

			<div class="form-outline mb-4">
				<input type="file" name="fileServiceImage" class="form-control" accept="image/*	" />
				<label class="form-label">Service Image</label>
			</div>

			<button type="submit" class="btn btn-primary btn-block mb-4">Add</button>

			<div class="text-center">
				<p>Don't want to add? <a href="./ViewService.jsp">View Service</a></p>
			</div>
		</form>
    </body>
</html>
