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
			if (request.getAttribute("clothErrors") != null) {
				List<String> errors = (List<String>) request.getAttribute("clothErrors");
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
			session.setAttribute("sesCCode", request.getParameter("txtCCode"));
			String code = session.getAttribute("sesCCode").toString();
//			String code = request.getParameter("txtCCode");
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
					sql = "UPDATE Cloth SET clothName = ?, description = ? WHERE clothCode = ?";

					ps = conn.prepareStatement(sql);
					ps.setString(1, name);
					ps.setString(2, desc);
					ps.setInt(3, Integer.parseInt(code));

					if (ps.executeUpdate() == 1) {
						request.getRequestDispatcher("./ViewCloth.jsp").forward(request, response);
					} else {
						errors.add("Can't update! Please try again.");
					}
				}
				rs.close();
				ps.close();
				conn.close();
			}

			if (!errors.isEmpty()) {
				request.setAttribute("clothErrors", errors);
				request.getRequestDispatcher("./UpdateCloth.jsp").forward(request, response);
			}
		%>
    </body>
</html>
