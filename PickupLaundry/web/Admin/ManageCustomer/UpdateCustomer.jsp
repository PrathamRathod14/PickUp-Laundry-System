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
        <title>Update Customer</title>
		<link rel="stylesheet" href="../../assets/bootstrap/css/bootstrap.css">
		<link rel="stylesheet" href="../../assets/style.css">
    </head>
    <body>
		<h1 align="center">Pickup Laundry</h1>
		<div style="text-align: center;">
			<a href="../Homepage.jsp">Dashboard</a>&ensp;|
			<a href="./ViewCustomer.jsp">View Customer</a>&ensp;|
			<a href="../Logout.jsp">Logout</a>
		</div>
		<hr>

		<h1 align="center">Update Customer</h1>

		<%
			String mobileNo = null, username = null, email = null, city = null, address = null;

			Connection conn = DBConnection.getConnection();
			String sql = "SELECT mobileNo,username,email,city,address FROM User WHERE mobileNo = ?";

			PreparedStatement ps = conn.prepareStatement(sql);
			if (request.getParameter("mobileNo") != null) {
				mobileNo = request.getParameter("mobileNo");
			} else {
				mobileNo = session.getAttribute("sesMobileNo").toString();
			}

			ps.setString(1, mobileNo);

			ResultSet rs = ps.executeQuery();
			while (rs.next()) {
				username = rs.getString("username");
				email = rs.getString("email");
				city = rs.getString("city");
				address = rs.getString("address");
			}
			rs.close();
			ps.close();
			conn.close();
		%>

		<%
			if (request.getAttribute("custErrors") != null) {
				List<String> errors = (List<String>) request.getAttribute("custErrors");
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

		<form action="valUpdCust.jsp" method="POST">
			
            <div class="form-outline mb-3">
                <input type="text" name="txtMobileNo" class="form-control" maxlength="10" value="<% out.println(mobileNo); %>"/>
                <label class="form-label">Mobile Number</label>
            </div>

            <div class="form-outline mb-3">
                <input type="text" name="txtUsername" class="form-control" value="<% out.println(username); %>"/>
                <label class="form-label">User Name</label>
            </div>

            <div class="form-outline mb-3">
                <input type="text" name="txtEmail" class="form-control" value="<% out.println(email); %>"/>
                <label class="form-label">Email Address</label>
            </div>

            <div class="form-outline mb-3">
                <input type="text" name="txtCity" class="form-control" value="<% out.println(city); %>"/>
                <label class="form-label">City</label>
            </div>

            <div class="form-outline mb-3">
                <textarea name="txtAdd" class="form-control"><% out.println(address); %></textarea>
                <label class="form-label">Address</label>
            </div>
				
			<!--<button type="submit"  class="btn btn-secondary btn-block mb-4">Edit</button>-->
			<button type="submit" class="btn btn-primary btn-block mb-4">Update</button>

			<div class="text-center">
				<p>Don't want to update? <a href="./ViewCustomer.jsp">View Customer</a></p>
			</div>
		</form>
    </body>
</html>
