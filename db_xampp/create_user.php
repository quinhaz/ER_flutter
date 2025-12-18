<?php
// --- IMPORTANT: CORS HEADERS ---
header("Access-Control-Allow-Origin: *");
header("Access-Control-Allow-Headers: Content-Type, Access-Control-Allow-Headers, Authorization, X-Requested-With");
header("Access-Control-Allow-Methods: GET, POST, OPTIONS");

// Handle "Preflight" requests
if ($_SERVER['REQUEST_METHOD'] == 'OPTIONS') {
    http_response_code(200);
    exit();
}
// -------------------------------

header('Content-Type: application/json');

// Connect to Database
$conn = new mysqli("localhost", "root", "", "gri");

// Check connection
if ($conn->connect_error) {
    die(json_encode(["success" => false, "message" => "Connection failed: " . $conn->connect_error]));
}

// Get the data sent from Flutter
$input = json_decode(file_get_contents('php://input'), true);

// VALIDATION: Check if data arrived
if (!isset($input['email']) || !isset($input['password'])) {
    echo json_encode(["success" => false, "message" => "Missing email or password"]);
    exit();
}

$name = $input['name'];
$email = $input['email'];
$pass = $input['password']; 
$role = $input['role'];

// Check if email already exists
$check = $conn->query("SELECT id FROM users WHERE email = '$email'");
if ($check->num_rows > 0) {
    echo json_encode(["success" => false, "message" => "Email already registered"]);
    exit();
}

// Insert User
$stmt = $conn->prepare("INSERT INTO users (name, email, password, role) VALUES (?, ?, ?, ?)");
$stmt->bind_param("ssss", $name, $email, $pass, $role);

if ($stmt->execute()) {
    echo json_encode(["success" => true, "id" => $conn->insert_id]);
} else {
    echo json_encode(["success" => false, "message" => "SQL Error: " . $stmt->error]);
}

$conn->close();
?>