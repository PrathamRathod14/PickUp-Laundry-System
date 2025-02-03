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
			String mobileNo = request.getParameter("txtMobileNo");
			String username = request.getParameter("txtUsername");
			String email = request.getParameter("txtEmail");
			String city = request.getParameter("txtCity");
			String add = request.getParameter("txtAdd");
			String pass = request.getParameter("txtPass");
			String conPass = request.getParameter("txtConPass");

			List<String> errors = new ArrayList<>();
			Connection conn = DBConnection.getConnection();

			// No field left blank validation
			if (mobileNo.isEmpty() || username.isEmpty() || email.isEmpty() || city.isEmpty() || add.isEmpty() || pass.isEmpty() || conPass.isEmpty()) {
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

				if (pass.length() < 8 || pass.length() > 10) {
					errors.add("Length of Password should be between 8 to 10 characters");
				}

				if (!pass.equals(conPass)) {
					errors.add("Password & Retype password must match.");
				}

				// mobile no. exist check
				String sql = "SELECT mobileNo FROM User WHERE mobileNo = ?";
				PreparedStatement ps = conn.prepareStatement(sql);
				ps.setString(1, mobileNo);
				ResultSet rs = ps.executeQuery();
				if (rs.next()) {
					errors.add("Mobile Number already exists. Try another.");
				}

				// username no. exist check
				sql = "SELECT username FROM User WHERE username = ?";
				ps = conn.prepareStatement(sql);
				ps.setString(1, username);
				rs = ps.executeQuery();
				if (rs.next()) {
					errors.add("Username already exists. Try another.");
				}

				// email exist check
				sql = "SELECT email FROM User WHERE email = ?";
				ps = conn.prepareStatement(sql);
				ps.setString(1, email);
				rs = ps.executeQuery();
				if (rs.next()) {
					errors.add("Email already exists. Try another.");
				}

				if (errors.isEmpty()) {
					sql = "INSERT INTO User(mobileNo, userName, password, email, city, address, registrationDate, roleId) VALUES(?,?,?,?,?,?,?,?)";

					DateFormat dateFormat = new SimpleDateFormat("yyyy/MM/dd HH:mm:ss");
					Date curDate = new Date();

					ps = conn.prepareStatement(sql);
					ps.setString(1, mobileNo);
					ps.setString(2, username);
					ps.setString(3, pass);
					ps.setString(4, email);
					ps.setString(5, city);
					ps.setString(6, add);
					ps.setString(7, dateFormat.format(curDate).toString());
					ps.setInt(8, 3);

					if (ps.executeUpdate() == 1) {
						request.getRequestDispatcher("./ViewStaff.jsp").forward(request, response);
					} else {
						errors.add("Can't add! Please try again.");
					}

				}
				rs.close();
				ps.close();
				conn.close();
			}

			if (!errors.isEmpty()) {
				request.setAttribute("staffErrors", errors);
				request.getRequestDispatcher("./AddStaff.jsp").forward(request, response);
			}
		%>
    </body>
</html>
