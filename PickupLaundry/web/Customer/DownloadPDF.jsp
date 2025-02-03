<%@page import="java.text.SimpleDateFormat"%>
<%@page import="java.util.Date"%>
<%@page import="Database.DBConnection"%>
<%@page import="java.sql.*"%>
<%--<%@page contentType="text/html" pageEncoding="UTF-8"%>--%>
<!DOCTYPE html>
<html lang="en">
	<head>
		<meta charset="UTF-8">
		<meta name="viewport" content="width=device-width, initial-scale=1.0">
		<title>Invoice</title>
		<style>
			body {
				font-family: Arial, sans-serif;
				margin: 0;
				padding: 20px;
			}
			.invoice {
				border: 1px solid #ccc;
				max-width: 800px;
				margin: 0 auto;
				padding: 20px;
				background-color: #fff;
				box-shadow: 0 0 10px rgba(0, 0, 0, 0.1);
			}
			.invoice h1 {
				font-size: 24px;
				margin-bottom: 20px;
			}
			.invoice .header {
				display: flex;
				justify-content: space-between;
				align-items: center;
			}
			.invoice .details {
				margin-top: 20px;
				font-size: 16px;
			}
			.invoice .item {
				display: flex;
				justify-content: space-between;
				margin-top: 10px;
			}
			.invoice .item .description {
				flex: 1;
			}
			.invoice .total {
				margin-top: 20px;
				font-size: 18px;
			}
			.invoice .note {
				margin-top: 20px;
				font-size: 14px;
			}
		</style>
	</head>
	<body>
		<p style="float: right;"><%= session.getAttribute("sesLogTime")%></p>
		<h1 align="center" style="clear: right;">Pickup Laundry</h1>
		<%
			int orderNo = Integer.parseInt(session.getAttribute("sesOrderNo").toString());

			Connection conn = DBConnection.getConnection();
			String sql = "SELECT * FROM User U, OrderMaster OM, OrderDetail OD, RateMaster RM, Cloth C, Service S "
					+ "WHERE U.mobileNo = OM.mobileNo "
					+ "AND OM.orderNo = OD.orderNo "
					+ "AND OD.clothCode = C.clothCode "
					+ "AND OD.serviceCode = S.serviceCode "
					+ "AND RM.clothCode = C.clothCode "
					+ "AND RM.serviceCode = S.serviceCode "
					+ "AND OD.orderNo = ?";

			PreparedStatement ps = conn.prepareStatement(sql);
			ps.setInt(1, orderNo);

			ResultSet rs = ps.executeQuery();
			rs.next();
		%>

		<div class="invoice">
			<div class="header">
				<h1>Invoice</h1>

				<p>Invoice #<%= rs.getInt("orderNo")%></p>
			</div>
			<div class="details">
				<p><strong>Customer:</strong> <%= rs.getString("userName")%></p>

				<%
					// Extract the date from the ResultSet
					String orderDateStr = rs.getString("orderDate");
					SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
					Date orderDate = sdf.parse(orderDateStr);

					// Format the extracted date as desired
					SimpleDateFormat formattedDateFormat = new SimpleDateFormat("EEEE, dd-MM-yyyy");
					String formattedOrderDate = formattedDateFormat.format(orderDate);
				%>
				<p><strong>Order Date:</strong> <%= formattedOrderDate%></p>
				<p><strong>Expected Delivery Date:</strong> <%= rs.getString("expectedDeliveryDate")%></p>
			</div>
			<div class="items">
				<table cellpadding="10px" align="center">
					<tr>
						<th>Cloth</th>
						<th>Service</th>
						<th>Quantity</th>
						<th>Price (Rs.)</th>
						<th>Total (Rs.)</th>
					</tr>
					<%
						double totalAmount = 0;
						while (rs.next()) {
							String clothName = rs.getString("clothName");
							String serviceName = rs.getString("serviceName");
							int quantity = rs.getInt("quantity");
							double price = rs.getDouble("price");
							double itemTotal = quantity * price;
							totalAmount += itemTotal;
					%>
					<tr>
						<td><%= clothName%></td>
						<td><%= serviceName%></td>
						<td><%= quantity%></td>
						<td><%= price%></td>
						<td><%= itemTotal%></td>
					</tr>
					<%
						}
					%>
				</table>
			</div>
			<div class="total">
				<%
					double discount = 0;
					// Check if the customer is eligible for a 5% discount
//					if (isEligibleForDiscount(rs)) {
//						discount = totalAmount * 0.05; // 5% discount
//						totalAmount -= discount;
//					}
				%>
				<p><strong>Total Amount:</strong> Rs. <%= totalAmount%></p>
				<%
					if (discount > 0) {
				%>
				<p><strong>Discount (5%):</strong> - Rs. <%= discount%></p>
				<%
					}
				%>
			</div>
		</div>
		<script>
			window.print();
		</script>
	</body>
</html>
