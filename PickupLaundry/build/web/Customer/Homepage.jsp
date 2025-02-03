<%@page import="Database.DBConnection"%>
<%@page import="java.sql.Connection"%>
<%@page import="java.sql.PreparedStatement"%>
<%@page import="java.sql.ResultSet"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>Home | PL</title>
		<link rel="stylesheet" href="../assets/bootstrap/css/bootstrap.css">
		<link rel="stylesheet" href="../assets/style.css">
    </head>
    <body>
        <%@include file="./Header.jsp" %>
        <h1 align="center">Home</h1>

		<div style="float: left;width: 50%;">
			<h4 align="center">Available Services</h4>
			<table border="1" cellpadding="10" cellspacing="0" align="center" class="table-bordered">
				<tr>
					<th>Service Image</th>
					<th>Service Name</th>
					<th>Description</th>
				</tr>
				<%
					Connection conn = DBConnection.getConnection();
					String sql = "SELECT * FROM Service";

					PreparedStatement ps = conn.prepareStatement(sql);

					ResultSet rs = ps.executeQuery();
					while (rs.next()) {
						out.println("<tr><td><img src='../assets/images/" + rs.getString("serviceImg") + "' width='100px' height='70px'></td><td>" + rs.getString("serviceName") + "</td><td>" + rs.getString("description") + "</td></tr>");
					}
					rs.close();
					ps.close();
					conn.close();
				%>
			</table>
		</div>

		<div style="float: right; width: 50%">
			<h4 align="center">Make Order</h4>

			<form method="POST" action="ConfirmOrder.jsp" style="width:50%;">
				<div class="form-outline mb-3">
					<select name="selCloth" class="form-control" style="width: 100% !important;">
						<option hidden>Please Select</option>

						<%
							conn = DBConnection.getConnection();
							sql = "SELECT * FROM Cloth";

							ps = conn.prepareStatement(sql);

							rs = ps.executeQuery();
							while (rs.next()) {
								out.println("<option value='" + rs.getInt("clothCode") + "'>" + rs.getString("clothName") + "</option>");
							}
							rs.close();
							ps.close();
							conn.close();
						%>
					</select>
					<label class="form-label">Cloth</label>
				</div>
					<div class="mb-3">
					<!--<label class="form-label">Services</label>-->

					<%
						conn = DBConnection.getConnection();
						sql = "SELECT serviceCode, serviceName FROM Service";

						ps = conn.prepareStatement(sql);

						rs = ps.executeQuery();
						while (rs.next()) {
							int serviceCode = rs.getInt("serviceCode");
							String serviceName = rs.getString("serviceName");
					%>
					<input type="checkbox" name="selServices" value="<%= serviceName %>">
					<label class="form-check-label"><%= serviceName%></label><br>
					<%
						}
						rs.close();
						ps.close();
						conn.close();
					%>

				</div>

				<div class="form-outline mb-3">
					<%
						java.time.LocalDate currentDate = java.time.LocalDate.now();
						java.time.format.DateTimeFormatter dateFormat = java.time.format.DateTimeFormatter.ofPattern("yyyy-MM-dd");
						String formattedDate = currentDate.format(dateFormat);
					%>
					<input type="date" name="dtPickupDate" class="form-control" min="<%= formattedDate%>">
					<label class="form-label">Pickup Date</label>
				</div>
				<div class="form-outline mb-3">				
					<select name="selPickupTime" class="form-control">
						<option hidden>Please Select</option>
						<option>Morning</option>
						<option>Afternoon</option>
					</select>

					<label class="form-label">Pickup Time</label>
				</div>

				<div class="form-outline mb-3"> 
					<input type="number" name="numQty" class="form-control" min="1">
					<label class="form-label">Quantity</label>
				</div>

				<button type="submit" class="btn btn-primary btn-block mb-4">Next</button>
			</form>
		</div>
    </body>
</html>
