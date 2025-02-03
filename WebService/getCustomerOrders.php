<?php 
header("Access-Control-Allow-Origin: http://localhost:8080");
header("Access-Control-Allow-Methods: GET, POST, PUT, DELETE, OPTIONS");
header("Access-Control-Allow-Headers: Content-Type");

require_once './SQLConnection.php';

$mobileNo = $_GET['txtMobileNo'];

$sql = "SELECT * FROM ordermaster WHERE mobileNo = ?";
$stmt = $con->prepare($sql);
$stmt->bind_param('s', $mobileNo);
$stmt->execute();
$result = $stmt->get_result(); 

// Fetch the result as an associative array
$data = $result->fetch_all(MYSQLI_ASSOC);

// Output the result as JSON
header('Content-Type: application/json');
echo json_encode($data);

$con->close();
?>