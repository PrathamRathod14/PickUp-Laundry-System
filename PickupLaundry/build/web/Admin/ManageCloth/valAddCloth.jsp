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
        <title>Validate Cloth</title>
    </head>
    <body>
        <%
			String name = request.getParameter("txtCName");
			String desc = request.getParameter("txtaDesc");

			List<String> errors = new ArrayList<>();
			Connection conn = DBConnection.getConnection();

			// No field left blank validation
			if (name.isEmpty() || desc.isEmpty()) {
				errors.add("All fields must be filled.");
			} else {
				if (name.length() < 2 || name.length() > 50) {
					errors.add("Length of cloth name should be between 2 to 50 characters.");
				}
				if (!name.matches("[A-Za-z ]{2,50}")) {
					errors.add("Cloth name should contain only alphabets.");
				}

				// clothName exist check
				String sql = "SELECT clothName FROM Cloth WHERE clothName = ?";
				PreparedStatement ps = conn.prepareStatement(sql);
				ps.setString(1, name);
				ResultSet rs = ps.executeQuery();
				if (rs.next()) {
					errors.add("Cloth Name already exists. Try another.");
				}

				if (errors.isEmpty()) {
					sql = "INSERT INTO Cloth(clothName,description) VALUES(?,?)";

					ps = conn.prepareStatement(sql);
					ps.setString(1, name);
					ps.setString(2, desc);

					if (ps.executeUpdate() == 1) {
						request.getRequestDispatcher("./ViewCloth.jsp").forward(request, response);
					} else {
						errors.add("Can't add! Please try again.");
					}
				}
				rs.close();
				ps.close();
				conn.close();
			}

			if (!errors.isEmpty()) {
				request.setAttribute("clothErrors", errors);
				request.getRequestDispatcher("./AddCloth.jsp").forward(request, response);
			}
		%>
    </body>
</html>
