<?php
$servername = "localhost";
$username = "root";
$password = "";
$dbname = "gri";

// Create connection
$conn = new mysqli($servername, $username, $password, $dbname);

// Check connection
if ($conn->connect_error) {
  die("Connection failed: " . $conn->connect_error);
}

// 1. Fetch Celebrations
$sql_celeb = "SELECT * FROM celebrations";
$result_celeb = $conn->query($sql_celeb); // FIXED: used correct variable

$data_celeb = array();
if ($result_celeb->num_rows > 0) {
  while($row = $result_celeb->fetch_assoc()) {
    $data_celeb[] = $row;
  }
}

// 2. Fetch Documents
$sql_docu = "SELECT * FROM documents";
$result_docu = $conn->query($sql_docu); // FIXED

$data_docu = array();
if ($result_docu->num_rows > 0) {
  while($row = $result_docu->fetch_assoc()) {
    $data_docu[] = $row;
  }
}

// 3. Fetch Payments
$sql_pay = "SELECT * FROM payments";
$result_pay = $conn->query($sql_pay); // FIXED

$data_pay = array();
if ($result_pay->num_rows > 0) {
  while($row = $result_pay->fetch_assoc()) {
    $data_pay[] = $row;
  }
}

// 4. Fetch Users
$sql_user = "SELECT * FROM users";
$result_user = $conn->query($sql_user); // FIXED

$data_user = array();
if ($result_user->num_rows > 0) {
  while($row = $result_user->fetch_assoc()) {
    $data_user[] = $row;
  }
}

// 5. Combine everything into one Master Array
$master_data = array(
    "celebrations" => $data_celeb,
    "documents"    => $data_docu,
    "payments"     => $data_pay,
    "users"        => $data_user
);

// Return the Master JSON
header('Content-Type: application/json');
echo json_encode($master_data);

$conn->close();
?>