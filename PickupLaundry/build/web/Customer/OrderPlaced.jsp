<%@page import="java.util.ArrayList"%>
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
		<title>Order Placed | PL</title>
		<link rel="stylesheet" href="../assets/bootstrap/css/bootstrap.css">
		<link rel="stylesheet" href="../assets/style.css">
	</head>
	<body>
		<%
			String mobileNo = null;
			List<String> errors = new ArrayList<>();
			Connection conn = DBConnection.getConnection();
			String sql = "SELECT mobileNo FROM User WHERE email = ?";

			String email = (String) session.getAttribute("sesEmail");
			PreparedStatement cs = null;
			PreparedStatement ps = null; // Add a new prepared statement variable

			try {
				cs = conn.prepareStatement(sql);
				cs.setString(1, email);

				ResultSet rs = cs.executeQuery();
				while (rs.next()) {
					mobileNo = rs.getString("mobileNo");
					session.setAttribute("sesMobileNo", mobileNo);
				}
			} catch (SQLException e) {
				e.printStackTrace();
				errors.add("Database error while fetching mobile number.");
			} finally {
				// Close the result set and prepared statement
				if (cs != null) {
					try {
						cs.close();
					} catch (SQLException e) {
						e.printStackTrace();
					}
				}
			}

			int clothCode = (int) session.getAttribute("sesCloth");
			int qty = (int) session.getAttribute("sesQty");
			double price = (double) session.getAttribute("sesPrice");
			String expectedDt = (String) session.getAttribute("sesExpectedDt");
			String pickupTime = (String) session.getAttribute("sesPickupTime");

			SimpleDateFormat inputDateFormat = new SimpleDateFormat("dd-MM-yyyy");
			SimpleDateFormat mysqlDateFormat = new SimpleDateFormat("yyyy-MM-dd");

			Date inputDate = inputDateFormat.parse(expectedDt);

			String mysqlFormattedDate = mysqlDateFormat.format(inputDate);

			int insOM = 0, insOD = 0;

			int lastOrderId = 0;

			sql = "SELECT MAX(orderNo) AS maxOrderNo FROM OrderMaster";

			try {
				cs = conn.prepareStatement(sql);
				ResultSet rs = cs.executeQuery();

				if (rs.next()) {
					lastOrderId = rs.getInt("maxOrderNo");
				}
			} catch (SQLException e) {
				e.printStackTrace();
				errors.add("Database error while fetching the maximum order number.");
			} finally {
				if (cs != null) {
					try {
						cs.close();
					} catch (SQLException e) {
						e.printStackTrace();
					}
				}
			}

			int newOrderNo = lastOrderId + 1;

			sql = "INSERT INTO OrderMaster(mobileNo, orderAmount, orderpickupTime, expectedDeliveryDate, isAmountPaid) VALUES(?, ?, ?, ?, ?)";

			try {
				ps = conn.prepareStatement(sql);
				ps.setString(1, mobileNo);
				ps.setDouble(2, price * qty);
				ps.setString(3, pickupTime);
				ps.setString(4, mysqlFormattedDate);
				ps.setBoolean(5, false);
				insOM = ps.executeUpdate();
			} catch (SQLException e) {
				e.printStackTrace();
				errors.add("Database error while inserting into OrderMaster.");
			} finally {
				// Close the prepared statement
				if (ps != null) {
					try {
						ps.close();
					} catch (SQLException e) {
						e.printStackTrace();
					}
				}
			}

			String[] selectedServices = (String[]) session.getAttribute("sesSelServ");

			if (selectedServices != null) {
				for (String serviceName : selectedServices) {
					// Query to fetch serviceCode from the Service table
					String serviceQuery = "SELECT serviceCode FROM Service WHERE serviceName = ?";

					try {
						// Prepare and execute the query
						PreparedStatement serviceStatement = conn.prepareStatement(serviceQuery);
						serviceStatement.setString(1, serviceName);
						ResultSet serviceResult = serviceStatement.executeQuery();

						if (serviceResult.next()) {
							String serviceCode = serviceResult.getString("serviceCode");

							// Assuming you have a cloth code for each service, adjust this part
							// Query to fetch price from RateMaster based on clothCode and serviceCode
							String rateQuery = "SELECT price FROM RateMaster WHERE clothCode = ? AND serviceCode = ?";

							try {
								// Prepare and execute the query
								PreparedStatement rateStatement = conn.prepareStatement(rateQuery);
								rateStatement.setInt(1, clothCode); // Adjust clothCode as needed
								rateStatement.setString(2, serviceCode);
								ResultSet rateResult = rateStatement.executeQuery();

								if (rateResult.next()) {
									price = rateResult.getDouble("price");

									// Now, you have the price for this service, and you can insert it into the OrderDetail table.
									String insertOrderDetailQuery = "INSERT INTO OrderDetail(orderNo, clothCode, quantity, amount, serviceCode) VALUES(?, ?, ?, ?, ?)";

									PreparedStatement orderDetailStatement = conn.prepareStatement(insertOrderDetailQuery);
									orderDetailStatement.setInt(1, newOrderNo);
									orderDetailStatement.setInt(2, clothCode);
									orderDetailStatement.setInt(3, qty);
									orderDetailStatement.setDouble(4, price);
									orderDetailStatement.setString(5, serviceCode);

									insOD = orderDetailStatement.executeUpdate();
//									out.println("insOD: " + insOD);
								}
							} catch (SQLException e) {
								e.printStackTrace();
								errors.add("Database error while inserting into OrderDetail.");
							}
						}
					} catch (SQLException e) {
						e.printStackTrace();
						errors.add("Database error while fetching serviceCode.");
					}
				}
			}

			conn.close();

			if (insOM == 1 && insOD == 1) {
				session.setAttribute("sesOrderNo", newOrderNo);
				response.sendRedirect("./Invoice.jsp");
			} else {
				errors.add("Can't add! Please try again.");
			}

			if (!errors.isEmpty()) {
				request.setAttribute("orderErrors", errors);
				request.getRequestDispatcher("./ConfirmOrder.jsp").forward(request, response);
			}
		%>

		<%@include file="./Header.jsp" %>
		<h1 align="center">Order Placed</h1><br>
	</body>
</html>