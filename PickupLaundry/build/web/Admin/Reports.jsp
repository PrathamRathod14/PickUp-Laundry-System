<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
		<link rel="stylesheet" href="../assets/bootstrap/css/bootstrap.css">

        <title>Reports</title>
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
		<h1 align="center">Reports</h1>
	<center>
        <select id="selReport">
            <option>Select Report</option>
            <option value="viewOrdersByCustomer">View Orders by Customer</option>
            <option value="topServicesOrdered">List Top 5 Services Ordered</option>
            <option value="topRevenueServices">List Top 5 Revenue Services</option>
        </select><br><br>
        <div id="custInput" style="display: none;">
            <input type="text" name="txtMobileNo" id="mobileNo" placeholder="Customer's Mobile No." value="8521475235">
            <button id="btnFetchCustData" class="btn btn-primary">Fetch Data</button>
        </div>
        <div id="resultTable"></div>
	</center>
	<script src="../assets/jquery-3.2.1.min.js"></script>
	<script>
		$(document).ready(function () {
			$('#selReport').on('change', function () {
				var selOpt = $(this).val();
				if (selOpt === "viewOrdersByCustomer") {
					$('#custInput').show();
				} else {
					$('#custInput').hide();
				}
				if (selOpt === "topServicesOrdered") {
					topServicesOrdered()
				}
				if (selOpt === "topRevenueServices") {
					topRevenueServices();
				}
			});

			$('#btnFetchCustData').on('click', function () {
				var selOpt = $('#selReport').val();
				if (selOpt === "viewOrdersByCustomer") {
					var mobileNo = $('#mobileNo').val();
					viewOrdersByCustomer(mobileNo);
				}
			});
		});

		function viewOrdersByCustomer(mobileNo) {
			$.ajax({
				url: 'https://pickuplaundry.000webhostapp.com/getCustomerOrders.php',
				type: 'GET',
				data: {txtMobileNo: mobileNo},
				success: function (data) {
					var tab = '<table class="table table-bordered w-25">';
					tab += '<thead><tr><th>Order No</th><th>Order Amount</th><th>Order Date</th></tr></thead>';
					tab += '<tbody>';

					for (var i = 0; i < data.length; i++) {
						var order = data[i];
						tab += '<tr>';
						tab += '<td>' + order.orderNo + '</td>';
						tab += '<td>' + order.orderAmount + '</td>';
						tab += '<td>' + order.orderDate + '</td>';
						tab += '</tr>';
					}

					tab += '</tbody></table>';
					
					$('#resultTable').html(tab);
				},
				error: function (error) {
					console.log('An error occurred: ' + error);
				}
			});
		}

		function topServicesOrdered(){
			$.ajax({
				url: 'https://pickuplaundry.000webhostapp.com/mostlyOrdered.php',
				type: 'GET',
				data: {},
				success: function (data) {
					var tab = '<table class="table table-bordered w-25">';
					tab += '<thead><tr><th>Service Name</th><th>Total No. of Orders</th></tr></thead>';
					tab += '<tbody>';

					for (var i = 0; i < data.length; i++) {
						tab += '<tr>';
						tab += '<td>' + data[i].serviceName + '</td>';
						tab += '<td>' + data[i].totalOrdered + '</td>';
						tab += '</tr>';
					}

					tab += '</tbody></table>';
					
					$('#resultTable').html(tab);
				},
				error: function (error) {
					console.log('An error occurred: ' + error);
				}
			});
		}

		function topRevenueServices(){
			$.ajax({
				url: 'https://pickuplaundry.000webhostapp.com/highestRevenue.php',
				type: 'GET',
				data: {},
				success: function (data) {
					var tab = '<table class="table table-bordered w-25">';
					tab += '<thead><tr><th>Service Name</th><th>Total No. of Orders</th></tr></thead>';
					tab += '<tbody>';

					for (var i = 0; i < data.length; i++) {
						var order = data[i];
						tab += '<tr>';
						tab += '<td>' + data[i].serviceName + '</td>';
						tab += '<td>' + data[i].orderCount + '</td>';
						tab += '</tr>';
					}

					tab += '</tbody></table>';
					
					$('#resultTable').html(tab);
				},
				error: function (error) {
					console.log('An error occurred: ' + error);
				}
			});
		}
	</script>


</body>
</html>