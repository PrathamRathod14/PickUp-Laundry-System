<%@page import="Database.DBConnection"%>
<%@page import="java.sql.*"%>
<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%
	String priceFilter = request.getParameter("price");
	String serviceFilter = request.getParameter("service");
	String mobileNo = session.getAttribute("sesMobileNo").toString();

	Connection conn = DBConnection.getConnection();
	String sql = "SELECT * FROM User U, Cloth C, Service S, OrderMaster OM, OrderDetail OD "
			+ "WHERE U.mobileNo = OM.mobileNo AND C.clothCode = OD.clothCode AND S.serviceCode = OD.serviceCode "
			+ "AND OM.orderNo = OD.orderNo AND U.mobileNo = ?";

	// Add price and service filters if provided
	if (priceFilter != null && !priceFilter.isEmpty()) {
		sql += " AND orderAmount > ?";
	}
	if (serviceFilter != null && !serviceFilter.isEmpty()) {
		sql += " AND S.serviceName = ?";
	}

	PreparedStatement ps = conn.prepareStatement(sql);
	ps.setString(1, mobileNo);

	// Set parameters for price and service filters if provided
	int paramIndex = 2;
	if (priceFilter != null && !priceFilter.isEmpty()) {
		ps.setDouble(paramIndex++, Double.parseDouble(priceFilter));
	}
	if (serviceFilter != null && !serviceFilter.isEmpty()) {
		ps.setString(paramIndex, serviceFilter);
	}

	ResultSet rs = ps.executeQuery();
%>
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
