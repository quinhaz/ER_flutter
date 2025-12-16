<?php
// ALLOW FLUTTER WEB TO CONNECT
header("Access-Control-Allow-Origin: *");
header("Access-Control-Allow-Headers: Content-Type, Access-Control-Allow-Headers, Authorization, X-Requested-With");
header("Access-Control-Allow-Methods: GET, POST, OPTIONS");

// Handle "Preflight" requests (Browser checking permission)
if ($_SERVER['REQUEST_METHOD'] == 'OPTIONS') {
    http_response_code(200);
    exit();
}

header('Content-Type: application/json');
$conn = new mysqli("localhost", "root", "", "gri");

$input = json_decode(file_get_contents('php://input'), true);
$cel_id = $input['celebrationId'];
$owner_id = $input['ownerUserId'];
$type = $input['type'];
$fee = $input['feeAmount'];
$status = 'Pendente'; // Default status

// Columns from screenshot: celebration_id, owner_user_id, type, fee_amount, fee_status
$stmt = $conn->prepare("INSERT INTO documents (celebration_id, owner_user_id, type, fee_amount, fee_status) VALUES (?, ?, ?, ?, ?)");
$stmt->bind_param("iisds", $cel_id, $owner_id, $type, $fee, $status);

if ($stmt->execute()) {
    echo json_encode(["success" => true, "id" => $conn->insert_id]);
} else {
    echo json_encode(["success" => false, "message" => $stmt->error]);
}
$conn->close();
?>