<%@page import="java.util.List"%>
<%@page import="Database.DBConnection"%>
<%@page import="java.util.Date"%>
<%@page import="java.sql.*"%>
<%@page import="java.text.DateFormatSymbols"%>
<%@page import="java.util.Calendar"%>
<%@page import="java.text.SimpleDateFormat"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
	<head>
		<meta charset="UTF-8">
		<title>Confirm Order | PL</title>
		<link rel="stylesheet" href="../assets/bootstrap/css/bootstrap.css">
		<link rel="stylesheet" href="../assets/style.css">
	</head>
	<body>
		<%@include file="./Header.jsp" %>
		<h1 align="center">Confirm Order</h1><br>

		<%
			if (request.getAttribute("orderErrors") != null) {
				List<String> errors = (List<String>) request.getAttribute("orderErrors");
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

		<h4 align="center">Review Order</h4>
		<table cellpadding="10" cellspacing="0" align="center">
			<%
				int clothCode = Integer.parseInt(request.getParameter("selCloth"));

				Connection conn = DBConnection.getConnection();

				String sql = "{CALL getClothDetailsByClothId(?)}";

				CallableStatement cs = conn.prepareCall(sql);
				cs.setInt(1, clothCode);
				boolean hasResults = cs.execute();

				if (hasResults) {
					ResultSet rs = cs.getResultSet();

					if (rs.next()) {
						int clothId = rs.getInt("clothCode");
						String clothName = rs.getString("clothName");
						String clothDesc = rs.getString("description");

						out.println("<tr><th>Cloth Name</th><td>" + clothName + "</td></tr>");
						out.println("<tr><th>Cloth Description</th><td>" + clothDesc + "</td></tr>");
					}
					rs.close();
				}

				String[] selectedServices = request.getParameterValues("selServices");
				session.setAttribute("sesSelServ", selectedServices);

				int qty = 0;
				String numQtyParam = request.getParameter("numQty");
				if (numQtyParam != null && !numQtyParam.isEmpty()) {
					try {
						qty = Integer.parseInt(numQtyParam);
					} catch (NumberFormatException e) {
						qty = 0;
					}
				}
				session.setAttribute("sesQty", qty);


			%>

			<tr>
				<th>Services</th>
				<td>
					<%						for (String service : selectedServices) {
							out.println(service + "<br>");
						}
					%>
				</td>
			</tr>
			<%
				double totalPrice = 0;
				int processingDays = 0;

				for (String service : selectedServices) {
					sql = "SELECT rm.price, s.serviceCode, processingDays FROM RateMaster rm, Service s WHERE s.serviceName = ? AND rm.serviceCode = s.serviceCode";

					PreparedStatement ps = conn.prepareStatement(sql);
					ps.setString(1, service);
					ResultSet rs = ps.executeQuery();
					if (rs.next()) {
						double price = rs.getDouble("price");
						int processingDay = rs.getInt("processingDays");
						int serviceCode = rs.getInt("serviceCode");

						// Calculate the total price for the current service and quantity
						double serviceTotalPrice = price * qty;
						totalPrice += serviceTotalPrice;

						// Display the service name, price, quantity, and total price
//						out.println(service + " - Price: " + price + " - Quantity: " + qty + " - Total Price: " + serviceTotalPrice + "<br>");
						// Update the processingDays based on the maximum value
						processingDay = Math.max(processingDay, getProcessingDays(clothCode, serviceCode));
					}
				}

			%>
			<tr>
				<th>Quantity</th>
				<td><%= qty%></td>
			</tr>
			<tr>
				<th>Total Price</th>
				<td><%= totalPrice%></td>
			</tr>

			<%
//				rs.close();
//				ps.close();
				conn.close();

				session.setAttribute("sesCloth", clothCode);
				session.setAttribute("sesServices", selectedServices); // Store selected services as an array
				session.setAttribute("sesQty", qty);
				session.setAttribute("sesPrice", totalPrice);
				session.setAttribute("sesPickupTime", request.getParameter("selPickupTime"));
				session.setAttribute("sesProcessingDays", processingDays);

				try {
					String pickupDateStr = request.getParameter("dtPickupDate");
					SimpleDateFormat dateFormat = new SimpleDateFormat("yyyy-MM-dd");
					Date pickupDate = dateFormat.parse(pickupDateStr);

					Calendar calendar = Calendar.getInstance();
					calendar.setTime(pickupDate);
					calendar.add(Calendar.DAY_OF_YEAR, processingDays);

					SimpleDateFormat formattedDateFormat = new SimpleDateFormat("EEEE, dd-MM-yyyy");
					String formattedDeliveryDate = formattedDateFormat.format(calendar.getTime());

			%>

			<tr>
				<th>Tentative Delivery Date</th>
				<td><%= formattedDeliveryDate%></td>
			</tr>
			<%
					String[] dateParts = formattedDeliveryDate.split(",\\s");

					String expectedDt = dateParts[1];
					session.setAttribute("sesExpectedDt", expectedDt);

				} catch (Exception e) {
					e.printStackTrace();
				}
			%>
		</table>

		<br>
		<form method="POST" action="OrderPlaced.jsp">
			<button type="submit" class="btn btn-primary btn-block mb-4">Place Order</button>
		</form>
	</body>
</html>

<%!
	private int getProcessingDays(int clothCode, int serviceCode) throws SQLException {
		int processingDays = 0;
		Connection conn = DBConnection.getConnection();
		String sql = "SELECT processingDays FROM RateMaster WHERE clothCode = ? AND serviceCode = ?";
		PreparedStatement ps = conn.prepareStatement(sql);
		ps.setInt(1, clothCode);
		ps.setInt(2, serviceCode);
		ResultSet rs = ps.executeQuery();
		if (rs.next()) {
			processingDays = rs.getInt("processingDays");
		}
		rs.close();
		ps.close();
		conn.close();
		return processingDays;
	}
%>
