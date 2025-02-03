<%@page import="java.text.SimpleDateFormat"%>
<%@page import="java.util.Date"%>
<%@page import="Database.DBConnection"%>
<%@page import="java.sql.*"%>
<%@ page import = "java.io.*,java.util.*,javax.mail.*"%>
<%@ page import = "javax.mail.internet.*,javax.activation.*"%>
<%@ page import = "javax.servlet.http.*,javax.servlet.*" %>

<%@page contentType="text/html" pageEncoding="UTF-8"%>

<!DOCTYPE html>
<html lang="en">
	<head>
		<meta charset="UTF-8">
		<meta name="viewport" content="width=device-width, initial-scale=1.0">
		<title>Invoice</title>
		<link rel="stylesheet" href="../assets/bootstrap/css/bootstrap.css">
		<style>
			body {
				font-family: Arial, sans-serif;
				margin: 0;
				padding: 20px;
				padding-top: 0px;
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
		<script src="https://checkout.razorpay.com/v1/checkout.js"></script>

	</head>
	<body>
		<%@include file="./Header.jsp" %>

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

		<%			String result;

//			String email = session.getAttribute("sesEmail").toString();
//			String to = email;
//
//			String from = "abc@gmail.com";
//
//			String host = "localhost";
//
//			Properties properties = System.getProperties();
//
//			// Setup mail server
//			properties.setProperty("mail.smtp.host", host);
//
//			// Get the default Session object.
//			Session mailSession = Session.getDefaultInstance(properties);
//
//			try {
//				// Create a default MimeMessage object.
//				MimeMessage message = new MimeMessage(mailSession);
//
//				// Set From: header field of the header.
//				message.setFrom(new InternetAddress(from));
//
//				// Set To: header field of the header.
//				message.addRecipient(Message.RecipientType.TO,
//						new InternetAddress(to));
//				// Set Subject: header field
//				message.setSubject("Invoice | Pickup Laundry");
//
//				// Now set the actual message
//				message.setText("This is actual message");
//
//				// Send message
//				Transport.send(message);
//				result = "Sent message successfully....";
//			} catch (MessagingException mex) {
//				mex.printStackTrace();
//				result = "Error: unable to send message....";
//			}
		%>
		<br><br>
	<center><button onclick="downloadPDF()" class="btn btn-primary">Download PDF</button></center><br>
	<center><button onclick="onButtonClick()" class="btn btn-primary">Pay</button></center>

	<script>
		function downloadPDF() {
			window.location.href = "./DownloadPDF.jsp";
//			window.print();
		}
	</script>

	<script>
		function onButtonClick() {
			var options = {
				"key": "rzp_test_paIUk4G9hyJfnK", // Enter the Key ID generated from the Dashboard
				"amount": "<%= totalAmount * 100%>", // Amount is in currency subunits. Default currency is INR. Hence, 50000 refers to 50000 paise
				"currency": "INR",
				"name": "Pickup Laundry",
				"description": "Payment",
				"image": "../Traveler/assets/images/logo.png",
				//                "order_id": "order_9A33XWu170gUtm", //This is a sample Order ID. Pass the `id` obtained in the response of Step 1
				"handler": function (response) {
					// console.log(response);

					if (response.razorpay_payment_id) {
						var pid = response.razorpay_payment_id;

						// Create a hidden form element
						var form = document.createElement("form");
						form.method = "POST";
						// form.action = "ajaxbooking.php";

						// Create an input element to hold the payment ID
						var pidInput = document.createElement("input");
						pidInput.type = "hidden";
						pidInput.name = "pid";
						pidInput.value = pid;

						// Append the input to the form
						form.appendChild(pidInput);

						// Append the form to the document and submit it
						document.body.appendChild(form);
						form.submit();
					}
				}
			};
			var rzp1 = new Razorpay(options);
			rzp1.on('payment.failed', function (response) {
				alert(response.error.code);
				alert(response.error.description);
				alert(response.error.source);
				alert(response.error.step);
				alert(response.error.reason);
			});
			rzp1.open();
		}
	</script>
	
</body>
</html>