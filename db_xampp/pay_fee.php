<?php
ini_set('display_errors', 0);
error_reporting(E_ALL);
// --- 1. CORS HEADERS (REQUIRED) ---
header("Access-Control-Allow-Origin: *");
header("Access-Control-Allow-Headers: Content-Type, Access-Control-Allow-Headers, Authorization, X-Requested-With");
header("Access-Control-Allow-Methods: GET, POST, OPTIONS");
header('Content-Type: application/json');

if ($_SERVER['REQUEST_METHOD'] == 'OPTIONS') {
    http_response_code(200);
    exit();
}
// ----------------------------------

header('Content-Type: application/json');

// 2. Connect to Database
$conn = new mysqli("localhost", "root", "", "gri");
if ($conn->connect_error) {
    die(json_encode(["success" => false, "message" => "Connection failed: " . $conn->connect_error]));
}

// 3. Receive Data
$input = json_decode(file_get_contents('php://input'), true);

if (!$input) {
    echo json_encode(["success" => false, "message" => "No data received"]);
    exit();
}

$doc_id = (int)$input['documentId'];
$user_id = (int)$input['userId'];
$method = $input['method'];
$amount = (float)$input['amount'];

// 4. Insert into Payments Table
// Columns from your screenshot: document_id, user_id, amount, method, provider_status, confirmed_at
$status = 'confirmed'; // We assume payment is instant for this demo
$now = date('Y-m-d H:i:s');

$stmt = $conn->prepare("INSERT INTO payments (document_id, user_id, amount, method, provider_status, confirmed_at) VALUES (?, ?, ?, ?, ?, ?)");

if (!$stmt) {
    echo json_encode(["success" => false, "message" => "SQL Prepare Error: " . $conn->error]);
    exit();
}

// iidsss = integer, integer, double, string, string, string
$stmt->bind_param("iidsss", $doc_id, $user_id, $amount, $method, $status, $now);

if ($stmt->execute()) {
    // 5. Update Documents Table (Mark as 'Pago')
    // We update fee_status to 'Pago' so the app knows it is done.
    $update = $conn->prepare("UPDATE documents SET fee_status = 'Pago' WHERE id = ?");
    $update->bind_param("i", $doc_id);
    $update->execute();

    echo json_encode(["success" => true]);
} else {
    echo json_encode(["success" => false, "message" => "SQL Error: " . $stmt->error]);
}

$stmt->close();
$conn->close();
?>