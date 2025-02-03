<?php
//connect database
$host = "localhost";
$con_username = "YOUR_HOST_USERNAME";
$con_password = "YOUR_HOST_PASSWORD";
$db_name = "YOUR_HOST_DATABASE_NAME";
$con = new mysqli($host,$con_username,$con_password,$db_name);

//check connection
if($con->connect_errno)
	die("Connection failed: " . $con->connect_errno);
?>