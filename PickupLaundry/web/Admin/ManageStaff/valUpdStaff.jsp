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
        <title>Validate Staff</title>
    </head>
    <body>

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


        <%
			session.setAttribute("sesSMobileNo", request.getParameter("txtMobileNo"));
			String mobileNo = session.getAttribute("sesSMobileNo").toString();
			String username = request.getParameter("txtUsername");
			String email = request.getParameter("txtEmail");
			String city = request.getParameter("txtCity");
			String add = request.getParameter("txtAdd");

			List<String> errors = new ArrayList<>();
			Connection conn = DBConnection.getConnection();

			// No field left blank validation
			if (mobileNo.isEmpty() || username.isEmpty() || email.isEmpty() || city.isEmpty() || add.isEmpty()) {
				errors.add("All fields must be filled.");
			} else {
				if (mobileNo.length() != 10) {
					errors.add("Mobile No. must contain 10 digits.");
				} else if (!mobileNo.matches("[6-9][0-9]{9}")) {
					errors.add("Invalid mobile format.");
				}

				if (!email.matches("^[a-z][a-z0-9]+@(gmail|outlook|hotmail|yahoo|icloud)[.](com|in)$")) {
					errors.add("Invalid email format.");
				}

				String sql = null;
				PreparedStatement ps;
//				ResultSet rs;

				// mobile no. exist check
//				String sql = "SELECT mobileNo FROM User WHERE mobileNo = ?";
//				PreparedStatement ps = conn.prepareStatement(sql);
//				ps.setString(1, mobileNo);
//				ResultSet rs = ps.executeQuery();
//				if (rs.next()) {
//					errors.add("Mobile Number already exists. Try another.");
//				}
//
//				// username no. exist check
//				sql = "SELECT username FROM User WHERE username = ?";
//				ps = conn.prepareStatement(sql);
//				ps.setString(1, username);
//				rs = ps.executeQuery();
//				if (rs.next()) {
//					errors.add("Username already exists. Try another.");
//				}
//
//				// email exist check
//				sql = "SELECT email FROM User WHERE email = ?";
//				ps = conn.prepareStatement(sql);
//				ps.setString(1, email);
//				rs = ps.executeQuery();
//				if (rs.next()) {
//					errors.add("Email already exists. Try another.");
//				}
				if (errors.isEmpty()) {
					sql = "UPDATE User SET  username = ?, email = ?, city = ?, address = ? WHERE mobileNo = ?";

					ps = conn.prepareStatement(sql);
//					ps.setString(1, mobileNo);
					ps.setString(1, username);
					ps.setString(2, email);
					ps.setString(3, city);
					ps.setString(4, add);
					ps.setString(5, mobileNo);

					if (ps.executeUpdate() == 1) {
						request.getRequestDispatcher("./ViewStaff.jsp").forward(request, response);
					} else {
						errors.add("Can't update! Please try again.");
					}

//					rs.close();
					ps.close();
				}

				conn.close();
			}

			if (!errors.isEmpty()) {
				request.setAttribute("staffErrors", errors);
				request.getRequestDispatcher("./UpdateStaff.jsp").forward(request, response);
			}
		%>
    </body>
</html>
