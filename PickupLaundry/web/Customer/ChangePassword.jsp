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
        <link rel="stylesheet" href="../assets/bootstrap/css/bootstrap.css">
        <link rel="stylesheet" href="../assets/style.css">
        <title>Change Password</title>
		<script src="../assets/jquery-3.2.1.min.js"></script>

    </head>
    <body>
		<%@include file="./Header.jsp" %>

        <h1 align="center">Change Password</h1>
        <%
			if (request.getAttribute("changePassErrors") != null) {
				List<String> errors = (List<String>) request.getAttribute("changePassErrors");
        %>
        <div style="text-align: center;">
            <h3>Error Messages</h3>
            <ul style="display: inline-block; text-align: left;">
                <% for (String error : errors) {%>
                <li><%= error%></li>
                    <% } %>
            </ul>
            <% }%>
        </div>

        <form action="valChangePass.jsp" method="POST">
			<div class="form-outline mb-4">
				<input type="password" name="txtCurPass" class="form-control" value="<% if (request.getParameter("txtCurPass") != null) {
						out.println(request.getParameter("txtCurPass"));
					} %>" />
				<label class="form-label">Current Password</label>
			</div>

			<div class="form-outline mb-4">
				<input type="password" id="newPass" name="txtNewPass" class="form-control" value="<% if (request.getParameter("txtNewPass") != null) {
						out.println(request.getParameter("txtNewPass"));
					} %>" />
				<label class="form-label">New Password</label>
			</div>

			<div class="form-outline mb-4">
				<input type="password" name="txtConPass" class="form-control" value="<% if (request.getParameter("txtConPass") != null) {
						out.println(request.getParameter("txtConPass"));
					}%>" />
				<label class="form-label">Confirm Password</label>
			</div>	
			<div id="passStrength" class="mb-4">
				Password Strength: <span id="strength" class="px-2 pb-1" style="border-radius: 3px;">None</span>
			</div>

			<button type="submit" class="btn btn-primary btn-block mb-4">Change</button>

			<div class="text-center">
				<p>Don't want to change? <a href="./Homepage.jsp">Home</a></p>
			</div>
        </form>


		<script>
			const newPass = document.getElementById('newPass');
			const strength = document.getElementById('strength');

			newPass.addEventListener('input', function () {
				const password = newPass.value;
//				console.log(password);
				const isWeak = password.length < 8;
				const isMedium = password.length >= 8 && password.length <= 10 && /\d/.test(password);
				const isStrong = password.length >= 8 && password.length <= 10 && /\d/.test(password) && /[_!@#$%]/.test(password);

				if (isStrong) {
					strength.textContent = 'Strong';
					strength.style.backgroundColor = 'green';
					strength.style.color = 'white';
				} else if (isMedium) {
					strength.textContent = 'Medium';
					strength.style.backgroundColor = 'orange';
					strength.style.color = 'white';
				} else if (isWeak) {
					strength.textContent = 'Weak';
					strength.style.backgroundColor = 'red';
					strength.style.color = 'white';
				} else {
					strength.textContent = 'Does not meet any criteria.';
					strength.style.backgroundColor = 'black';
					strength.style.color = 'white';
				}
			});
		</script>
    </body>
</html>
