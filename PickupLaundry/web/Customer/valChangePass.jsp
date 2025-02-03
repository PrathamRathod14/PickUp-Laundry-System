<%@page import="Database.DBConnection"%>
<%@page import="java.util.Date"%>
<%@page import="java.text.SimpleDateFormat"%>
<%@page import="java.text.DateFormat"%>
<%@page import="java.util.List"%>
<%@page import="java.util.ArrayList"%>
<%@page import="java.sql.DriverManager"%>
<%@page import="java.sql.Connection"%>
<%@page import="java.sql.PreparedStatement"%>
<%@page import="java.sql.ResultSet"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>Validate Change Password</title>
    </head>
    <body>

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
			<% } %>
		</div>


        <%
			String curPass = request.getParameter("txtCurPass");
			String newPass = request.getParameter("txtNewPass");
			String conPass = request.getParameter("txtConPass");

			boolean isStrong = false;

			List<String> errors = new ArrayList<>();
			String passStrength = null;
			Connection conn = DBConnection.getConnection();

			// No field left blank validation
			if (curPass.isEmpty() || newPass.isEmpty() || conPass.isEmpty()) {
				errors.add("All fields must be filled.");
			} else {
				// checking current pass is correct or not
				String sql = "SELECT email FROM User WHERE email = ? AND password = ?";
				PreparedStatement ps = conn.prepareStatement(sql);
				ps.setString(1, session.getAttribute("sesEmail").toString());
				ps.setString(2, curPass);
				ResultSet rs = ps.executeQuery();
				if (!rs.next()) {
					errors.add("Your current password is incorrect.");
				} else if (!newPass.equals(conPass)) {
					errors.add("New & confirm password should match.");
				}
				if (newPass.length() < 8) {
					passStrength = "Password is weak!";
				}
				if (newPass.length() >= 8 && newPass.length() <= 10 && newPass.matches("[0-9]")) {
					passStrength = "Password is medium!";
				} 
				if (newPass.length() >= 8 && newPass.length() <= 10 && newPass.matches("[0-9]") && newPass.matches("[_!@#$%]")) {
					passStrength = null;
				}
//				else {
//					passStrength = "Password is weak!";
//				}
				
//				if(passStrength != null)
//					errors.add(passStrength);

				if (errors.isEmpty() && passStrength == null) {
					sql = "UPDATE User SET password = ? WHERE email = ?";

					ps = conn.prepareStatement(sql);
					ps.setString(1, newPass);
					ps.setString(2, session.getAttribute("sesEmail").toString());

					if (ps.executeUpdate() == 1) {
						out.println("<script>alert('Password Successfully Changed!');</script");
						request.getRequestDispatcher("./Homepage.jsp").forward(request, response);
					} else {
						errors.add("Can't change! Please try again.");
					}
				}
				rs.close();
				ps.close();
				conn.close();
			}

			if (!errors.isEmpty()) {
				request.setAttribute("changePassErrors", errors);
				request.getRequestDispatcher("./ChangePassword.jsp").forward(request, response);
			}
		%>
    </body>
</html>
