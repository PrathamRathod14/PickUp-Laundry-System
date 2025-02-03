<%@page import="Database.DBConnection"%>
<%@page import="java.sql.*"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
	<head>
		<meta charset="UTF-8">
		<title>Order History | PL</title>
		<link rel="stylesheet" href="../assets/bootstrap/css/bootstrap.css">
		<link rel="stylesheet" href="../assets/style.css">
		<script src="../assets/jquery-3.2.1.min.js"></script>
	</head>
	<body>
		<%@include file="./Header.jsp" %>
		<h1 align="center">Order History</h1><br>
	<center>
		<div id="filter-options">
<!--			<label for="price-filter">Price:</label>
			<input type="number" id="price-filter">-->
			<label for="service-filter">Service:</label>
			<select id="service-filter">
				<option hidden>Select Service</option>
				<option value="Dry Clean">Dry Clean</option>
				<option value="Washing">Washing</option>
				<option value="Ironing">Ironing</option>
				<option value="Starching">Starching</option>
			</select>
		</div>

		<br>
		<div id="results">
			<table cellpadding="10" cellspacing="0" align="center" class="table-bordered">
				<tr>
					<th>Order No.</th>
					<th>Order Amt.</th>
					<th>Order Date</th>
					<th>Pickup Time</th>
					<th>Expected Delivery</th>
					<th>Quantity</th>
					<th>Amount Paid</th>
				</tr>
				<%
					String mobileNo = session.getAttribute("sesMobileNo").toString();
					Connection conn = DBConnection.getConnection();
					String sql = "SELECT * FROM User U, Cloth C, Service S, OrderMaster OM, OrderDetail OD "
							+ "WHERE U.mobileNo = OM.mobileNo AND C.clothCode = OD.clothCode AND S.serviceCode = OD.serviceCode AND OM.orderNo = OD.orderNo AND U.mobileNo = ?";

					PreparedStatement ps = conn.prepareStatement(sql);
					ps.setString(1, mobileNo);

					ResultSet rs = ps.executeQuery();
					while (rs.next()) {
						// amount paid or not
						int isAmountPaid = rs.getInt("isAmountPaid");
						String amountPaidStatus = (isAmountPaid == 0) ? "No" : "Yes";

						out.println("<tr><td>" + rs.getInt("orderNo") + "</td><td>" + rs.getDouble("orderAmount") + "</td><td>" + rs.getString("orderDate") + "</td><td>" + rs.getString("orderpickupTime") + "</td><td>" + rs.getString("expectedDeliveryDate") + "</td><td>" + rs.getString("quantity") + "</td><td>" + amountPaidStatus + "</td></tr>");
					}
					rs.close();
					ps.close();
					conn.close();
				%>
			</table>
		</div>
	</center>
	<br>



	<script>
		// Function to fetch data from the server using AJAX
		function fetchData() {
			var priceFilter = document.getElementById("price-filter").value;
			var serviceFilter = document.getElementById("service-filter").value;

			// Make an AJAX request to fetch data based on filters
			$.ajax({
				url: "fetchData.jsp", // Replace with the correct URL for your data retrieval JSP page
				data: {price: priceFilter, service: serviceFilter},
				method: "GET",
				success: function (data) {
					// Clear previous results
					$("#results").empty();

					// Display the retrieved HTML content
					$("#results").html(data);
				},
				error: function (xhr, status, error) {
					console.log("Error: " + error);
				}
			});
		}

		// Attach event listeners for filter changes
		$("#price-filter, #service-filter").on("input", fetchData);
	</script>
</body>
</html>
