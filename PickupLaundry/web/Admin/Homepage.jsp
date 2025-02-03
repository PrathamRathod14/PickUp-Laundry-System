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
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>Homepage</title>
    </head>
    <body>
		<h1 align="center">Pickup Laundry</h1>
		<div style="text-align: center;">
			<a href="./Homepage.jsp">Dashboard</a>&ensp;| 
			<a href="./ManageCloth/ViewCloth.jsp">Manage Cloth</a>&ensp;| 
			<a href="./ManageService/ViewService.jsp">Manage Service</a>&ensp;| 
			<a href="./ManageCustomer/ViewCustomer.jsp">Manage Customer</a>&ensp;| 
			<a href="./ManageStaff/ViewStaff.jsp">Manage Staff</a>&ensp;| 
			<a href="./Reports.jsp">Reports</a>&ensp;| 
			<a href="./Logout.jsp">Logout</a>
		</div>
		<hr>
		<h1 align="center">Dashboard</h1>

		<%
			// Set refresh, autoload time as 5 seconds
			response.setIntHeader("Refresh", 30);

			int pendingOrders = 0;

		%>

		<h3 align="center">Today's Order</h3>


		<table cellpadding="10" cellspacing="0" align="center" class="table-bordered" border='1'>
			<tr>
				<th>Email</th>
				<th>Order No.</th>
				<th>Order Amt.</th>
				<th>Quantity</th>
				<th>Amount Paid</th>
				<th>Action</th>
			</tr>



			<%				Connection conn = DBConnection.getConnection();

				String sql = "SELECT * FROM User U, OrderMaster OM, OrderDetail OD, Cloth C, Service S WHERE U.mobileNo = OM.mobileNo  AND OM.orderNo = OD.orderNo  AND OD.clothCode = C.clothCode  AND OD.serviceCode = S.serviceCode AND DATE(OM.orderDate) = CURDATE()";

				PreparedStatement ps = conn.prepareStatement(sql);

				ResultSet rs = ps.executeQuery();

				while (rs.next()) {
					// amount paid or not
					int isAmountPaid = rs.getInt("isAmountPaid");
					String amountPaidStatus;
					if (isAmountPaid == 0) {
						pendingOrders++;
						amountPaidStatus = "No";
					} else {
						amountPaidStatus = "Yes";
					}
					out.println("<tr><td>" + rs.getString("email") + "</td><td>" + rs.getInt("orderNo") + "</td><td>" + rs.getDouble("orderAmount") + "</td><td>" + rs.getString("quantity") + "</td><td>" + amountPaidStatus + "</td><td><a href='ViewOrder.jsp?code=" + rs.getString("orderNo") + "''>View</a></td></tr>");
				}
				rs.close();
				ps.close();
				conn.close();
			%>

		</table>
		<h3 align='center'>Pending Orders: <%= pendingOrders%></h3>

	</body>
</html>
