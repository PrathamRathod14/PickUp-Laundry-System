<%@page import="java.util.List"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>Customer Login</title>
		<link rel="stylesheet" href="../assets/bootstrap/css/bootstrap.css">
		<link rel="stylesheet" href="../assets/style.css">
    </head>
    <body>
		<h1 align="center">Pickup Laundry Customer Login</h1>
		<hr>

		<%
			if (request.getAttribute("cLogErrors") != null) {
				List<String> errors = (List<String>) request.getAttribute("cLogErrors");
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

		<%
			Cookie[] cookies = request.getCookies();
			
			String email = null;
			String pass = null;
			
			for (Cookie cookie : cookies) {
				if ("cCkEmail".equals(cookie.getName())) {
					email = cookie.getValue();
				} else if ("cCkPass".equals(cookie.getName())) {
					pass = cookie.getValue();
				}
			}
		%>
		<form action="validateLogin.jsp" method="POST">
			<!-- Email input -->
			<div class="form-outline mb-4">
				<input type="text" name="txtEmail" class="form-control" required="" value="<% if (email != null) out.println(email);%>"/>
				<label class="form-label">Email Address</label>
			</div>

			<!-- Password input -->
			<div class="form-outline mb-4">
				<input type="password" name="txtPass" class="form-control" required="" value="<% if (pass != null) out.println(pass);%>"/>
				<label class="form-label">Password</label>
			</div>

			<div class="row mb-4">
				<div class="col d-flex">
					<!-- Checkbox -->
					<div class="form-check">
						<input class="form-check-input" type="checkbox" name="chkRememberMe" id="form2Example31" />
						<label class="form-check-label"> Remember me </label>
					</div>
				</div>  

				<!--				<div class="col float-right">
									 Simple link 
									<a href="#!">Forgot password?</a>
								</div>-->
			</div>

			<!-- Submit button -->
			<button type="submit" name="btnLogin" class="btn btn-primary btn-block mb-4">Sign In</button>

			<!-- Register buttons -->
			<div class="text-center">
				<p>Not a member? <a href="./Registration.jsp">Register</a></p>
			</div>
		</form>
	</body>

</html>
