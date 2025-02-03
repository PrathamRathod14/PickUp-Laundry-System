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
        <title>View Order</title>
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
		<h1 align="center">View Order</h1>



		<table cellpadding="10" cellspacing="0" align="center" class="table-bordered" border='1'>
			<%
				Connection conn = DBConnection.getConnection();

				String sql = "SELECT * FROM User U, OrderMaster OM, OrderDetail OD, RateMaster RM, Cloth C, Service S "
						+ "WHERE U.mobileNo = OM.mobileNo "
						+ "AND OM.orderNo = OD.orderNo "
						+ "AND OD.clothCode = C.clothCode "
						+ "AND RM.clothCode = C.clothCode "
						+ "AND OD.clothCode = RM.clothCode "
						+ "AND OD.serviceCode = S.serviceCode "
						+ "AND RM.serviceCode = S.serviceCode "
						+ "AND OD.serviceCode = RM.serviceCode "
						+ "AND OM.orderNo = ? "
						+ "AND OD.orderNo = ? LIMIT 1"; 

				PreparedStatement ps = conn.prepareStatement(sql);
				ps.setInt(1, Integer.parseInt(request.getParameter("code").toString()));
				ps.setInt(2, Integer.parseInt(request.getParameter("code").toString()));

				ResultSet rs = ps.executeQuery();


				while (rs.next()) {
					// amount paid or not
					int isAmountPaid = rs.getInt("isAmountPaid");
					String amountPaidStatus;
					if (isAmountPaid == 0) {
						amountPaidStatus = "No";
					}
					else
					amountPaidStatus = "Yes";
					out.println("<tr><td>Email</td><td>" + rs.getString("email") + "</td></tr>"
					+ "<tr><td>Order No.</td><td>" + rs.getInt("orderNo") + "</td></tr>"
					+ "<tr><td>Order Amt.</td><td>" + rs.getDouble("orderAmount") + "</td></tr>"
					+ "<tr><td>Order Date</td><td>" + rs.getString("orderDate") + "</td></tr>"
					+ "<tr><td>Order Pickup Time</td><td>" + rs.getString("orderpickupTime") + "</td></tr>"
					+ "<tr><td>Expected Delivery</td><td>" + rs.getString("expectedDeliveryDate") + "</td></tr>"
					+ "<tr><td>Quantity</td><td>" + rs.getString("quantity") + "</td></tr>"
					+ "<tr><td>Amount Paid</td><td>" + amountPaidStatus + "</td></tr>");
				}
				rs.close();
				ps.close();
				conn.close();
			%>

		</table>

	</body>
</html>
