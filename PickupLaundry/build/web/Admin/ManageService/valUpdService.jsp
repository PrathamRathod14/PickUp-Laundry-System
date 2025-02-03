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
        <title>Validate Service</title>
    </head>
    <body>
        <%
			session.setAttribute("sesSCode", request.getParameter("txtSCode"));
			String code = session.getAttribute("sesSCode").toString();
			String name = request.getParameter("txtSName");
			String desc = request.getParameter("txtaDesc");

			List<String> errors = new ArrayList<>();
			Connection conn = DBConnection.getConnection();

			// No field left blank validation
			if (name.isEmpty() || desc.isEmpty()) {
				errors.add("All fields must be filled.");
			} else {
				if (name.length() < 2 || name.length() > 50) {
					errors.add("Length of service name should be between 2 to 50 characters.");
				}
				if (!name.matches("[A-Za-z ]{2,50}")) {
					errors.add("Service name should contain only alphabets.");
				}

				// serviceName exist check
				String sql = "SELECT serviceName FROM Service WHERE serviceName = ?";
				PreparedStatement ps = conn.prepareStatement(sql);
				ps.setString(1, name);
				ResultSet rs = ps.executeQuery();
				if (rs.next()) {
					errors.add("Service Name already exists. Try another.");
				}

				if (errors.isEmpty()) {
					sql = "UPDATE Service SET serviceName = ?, description = ? WHERE serviceCode = ?";

					ps = conn.prepareStatement(sql);
					ps.setString(1, name);
					ps.setString(2, desc);
					ps.setInt(3, Integer.parseInt(code));

					if (ps.executeUpdate() == 1) {
						request.getRequestDispatcher("./ViewService.jsp").forward(request, response);
					} else {
						errors.add("Can't update! Please try again.");
					}
				}
				rs.close();
				ps.close();	
				conn.close();
			}

			if (!errors.isEmpty()) {
				request.setAttribute("serviceErrors", errors);
				request.getRequestDispatcher("./UpdateService.jsp").forward(request, response);
			}
		%>
    </body>
</html>
