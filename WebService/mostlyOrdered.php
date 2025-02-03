<?php
header("Access-Control-Allow-Origin: http://localhost:8080");
header("Access-Control-Allow-Methods: GET, POST, PUT, DELETE, OPTIONS");
header("Access-Control-Allow-Headers: Content-Type");

require_once './SQLConnection.php';

$sql = "SELECT S.serviceName, SUM(OD.quantity) AS totalOrdered 
		FROM orderdetail OD, service S
		WHERE OD.serviceCode = S.serviceCode
		GROUP BY OD.serviceCode
		ORDER BY totalOrdered DESC
		LIMIT 5;";
$stmt = $con->prepare($sql);
$stmt->execute();
$result = $stmt->get_result();

// Fetch the result as an associative array
$data = $result->fetch_all(MYSQLI_ASSOC);

// Output the result as JSON
header('Content-Type: application/json');
echo json_encode($data);

$con->close();
?>