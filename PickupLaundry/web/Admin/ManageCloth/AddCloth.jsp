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
        <title>Add Cloth</title>
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

		<h1 align="center">Add Cloth</h1>

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

		<form action="valAddCloth.jsp" method="POST">
			

			<div class="form-outline mb-4">
				<input type="text" name="txtCName" class="form-control" required="" value="<% if (request.getParameter("txtCName") != null) {
						out.println(request.getParameter("txtCName"));
					} %>"/>
				<label class="form-label">Cloth Name</label>
			</div>

			<div class="form-outline mb-4">
				<textarea name="txtaDesc" class="form-control" required=""><% if (request.getParameter("txtaDesc") != null) {
						out.println(request.getParameter("txtaDesc"));
					} %></textarea>
				<label class="form-label">Cloth Description</label>
			</div>	

				
			
			<!--display none if clicked on edit button-->
			<!--			<div class="form-outline mb-4" >
							<b>Note:</b> Click on Edit button to make changes.
						</div>-->

			<!--<button type="submit"  class="btn btn-secondary btn-block mb-4">Edit</button>-->
			<button type="submit" class="btn btn-primary btn-block mb-4">Add</button>

			<div class="text-center">
				<p>Don't want to add? <a href="./ViewCloth.jsp">View Cloth</a></p>
			</div>
		</form>
    </body>
</html>
