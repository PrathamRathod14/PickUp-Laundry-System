<%@page import="Database.DBConnection"%>
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
        <title>Validate Login</title>
    </head>
    <body>
		<%
			String email = request.getParameter("txtEmail");
			String pass = request.getParameter("txtPass");

			List<String> errors = new ArrayList<>();

			// No field left blank validation
			if (email.isEmpty() || pass.isEmpty()) {
				errors.add("All fields are required.");
			} else {
				if (!email.matches("^[a-z][a-z0-9]+@(gmail|outlook|hotmail|yahoo|icloud)[.](com|in)$")) {
					errors.add("Invalid email format.");
				}

				if (pass.length() < 8 && pass.length() > 10) {
					errors.add("Length of Password should be between 8 to 10 characters");
				}
				if (errors.isEmpty()) {
//					out.println("<h2>Registration successful!</h2>");

					Connection conn = DBConnection.getConnection();
					String sql = "SELECT email, password, status FROM User WHERE email = ? AND password = ? AND roleId = ? AND status = ?";

					PreparedStatement ps = conn.prepareStatement(sql);
					ps.setString(1, email);
					ps.setString(2, pass);
					ps.setInt(3, 1);
					ps.setInt(4, 1);

					ResultSet rs = ps.executeQuery();
					int rowCount = 0;
					while (rs.next()) {
						rowCount++;
					}
					if (rowCount == 1) {
						if (request.getParameter("chkRememberMe") != null) {
							Cookie aCkEmail = new Cookie("aCkEmail", email);
							aCkEmail.setMaxAge(60 * 60 * 24 * 30 * 12 * 5); //setting cookie for 5 years
							response.addCookie(aCkEmail);
							Cookie aCkPass = new Cookie("aCkPass", pass);
							aCkPass.setMaxAge(60 * 60 * 24 * 30 * 12 * 5); //setting cookie for 5 years	
							response.addCookie(aCkPass);
						}
						session.setAttribute("sesEmail", email);
//						request.getRequestDispatcher("./Homepage.jsp").forward(request, response);'
						response.sendRedirect("./Homepage.jsp");
					} else {
						errors.add("Email Id or Password is incorrect.");
					}
					rs.close();
					ps.close();
					conn.close();
				}
			}

			if (!errors.isEmpty()) {
				request.setAttribute("aLogErrors", errors);
				request.getRequestDispatcher("./Login.jsp").forward(request, response);
			}
		%>
    </body>
</html>
