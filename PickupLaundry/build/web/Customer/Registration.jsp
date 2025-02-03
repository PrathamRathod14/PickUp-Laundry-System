<%@page import="java.util.UUID"%>
<%@page import="java.util.Arrays"%>
<%@page import="java.util.ArrayList"%>
<%@page import="java.util.List"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>

<%
	// create random captcha code
	UUID randomUUID = UUID.randomUUID();
	String captcha = randomUUID.toString().substring(0, 6);
	session.setAttribute("sesCaptcha", captcha);

%>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>Customer Registration</title>
        <link rel="stylesheet" href="../assets/bootstrap/css/bootstrap.css">
        <link rel="stylesheet" href="../assets/style.css">
    </head>
    <body>
        <h1 align="center">Pickup Laundry Customer Registration</h1>
        <hr>
        <%			if (request.getAttribute("cRegErrors") != null) {
				List<String> errors = (List<String>) request.getAttribute("cRegErrors");
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
        <form action="validateReg.jsp" method="POST">
            <!-- First Name input -->
            <div class="form-outline mb-3">
                <input type="text" name="txtMobileNo" class="form-control" maxlength="10" value="<% if (request.getParameter("txtMobileNo") != null) {
						out.println(request.getParameter("txtMobileNo"));
					} %>"/>
                <label class="form-label">Mobile Number</label>
            </div>

            <!-- Last Name input -->
            <div class="form-outline mb-3">
                <input type="text" name="txtUsername" class="form-control" value="<% if (request.getParameter("txtUsername") != null) {
						out.println(request.getParameter("txtUsername"));
					} %>"/>
                <label class="form-label">User Name</label>
            </div>

            <!-- Email input -->
            <div class="form-outline mb-3">
                <input type="text" name="txtEmail" class="form-control" value="<% if (request.getParameter("txtEmail") != null) {
						out.println(request.getParameter("txtEmail"));
					} %>"/>
                <label class="form-label">Email Address</label>
            </div>

            <!-- City input -->
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

            <!-- Password input -->
            <div class="form-outline mb-3">
                <input type="password" name="txtPass" class="form-control" value="<% if (request.getParameter("txtPass") != null) {
						out.println(request.getParameter("txtPass"));
					} %>"/>
                <label class="form-label">Password</label>
            </div>

            <!-- Confirm Password input -->
            <div class="form-outline mb-3">
                <input type="password" name="txtConPass" class="form-control" value="<% if (request.getParameter("txtConPass") != null)
						out.println(request.getParameter("txtConPass"));%>"/>
                <label class="form-label">Retype Password</label>
            </div>

            <!-- Captcha display -->
            <center>
				<div class="form-outline mb-3" style="color:white; background-color: gray; font-style: italic; width: 80px;">
					<p><%= captcha%></p>
				</div>
			</center>

            <!-- Captcha input -->
            <div class="form-outline mb-3">
                <input type="text" name="txtCaptcha" class="form-control" maxlength="6"/>
                <label class="form-label">Captcha Code</label>
            </div>

            <!-- Submit button -->
            <button type="submit" name="btnRegister" class="btn btn-primary btn-block mb-4">Sign Up</button>

            <!-- Register buttons -->
            <div class="text-center">
                <p>Already registered? <a href="./Login.jsp">Login</a></p>
            </div>
        </form>
    </body>

</html>
