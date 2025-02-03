<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="java.util.Arrays"%>
<%@page import="java.util.ArrayList"%>
<%@page import="java.util.List"%>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>Add Staff</title>
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

		<h1 align="center">Add Staff</h1>

		<%
			if (request.getAttribute("staffErrors") != null) {
				List<String> errors = (List<String>) request.getAttribute("staffErrors");
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
		
        <form action="valAddStaff.jsp" method="POST">
            <div class="form-outline mb-3">
                <input type="text" name="txtMobileNo" class="form-control" maxlength="10" value="<% if (request.getParameter("txtMobileNo") != null) {
						out.println(request.getParameter("txtMobileNo"));
					} %>"/>
                <label class="form-label">Mobile Number</label>
            </div>

            <div class="form-outline mb-3">
                <input type="text" name="txtUsername" class="form-control" value="<% if (request.getParameter("txtUsername") != null) {
						out.println(request.getParameter("txtUsername"));
					} %>"/>
                <label class="form-label">User Name</label>
            </div>

            <div class="form-outline mb-3">
                <input type="text" name="txtEmail" class="form-control" value="<% if (request.getParameter("txtEmail") != null) {
						out.println(request.getParameter("txtEmail"));
					} %>"/>
                <label class="form-label">Email Address</label>
            </div>

            <div class="form-outline mb-3">
                <input type="text" name="txtCity" class="form-control" value="<% if (request.getParameter("txtCity") != null) {
						out.println(request.getParameter("txtCity"));
					} %>"/>
                <label class="form-label">City</label>
            </div>

            <div class="form-outline mb-3">
                <textarea name="txtAdd" class="form-control"><% if (request.getParameter("txtAdd") != null) {
						out.println(request.getParameter("txtAdd"));
					} %></textarea>
                <label class="form-label">Address</label>
            </div>

            <div class="form-outline mb-3">
                <input type="password" name="txtPass" class="form-control" value="<% if (request.getParameter("txtPass") != null) {
						out.println(request.getParameter("txtPass"));
					} %>"/>
                <label class="form-label">Password</label>
            </div>

            <div class="form-outline mb-3">
                <input type="password" name="txtConPass" class="form-control" value="<% if (request.getParameter("txtConPass") != null)
						out.println(request.getParameter("txtConPass"));%>"/>
                <label class="form-label">Retype Password</label>
            </div>

            <button type="submit" class="btn btn-primary btn-block mb-4">Add</button>

            <div class="text-center">
                <p>Don't want to add? <a href="./ViewStaff.jsp">View Staff</a></p>
            </div>
        </form>
    </body>
</html>
