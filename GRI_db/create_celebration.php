<?php
header('Content-Type: application/json');

// Database credentials
$servername = "localhost";
$username = "root";
$password = "";
$dbname = "gri";

// 1. Connect
$conn = new mysqli($servername, $username, $password, $dbname);

if ($conn->connect_error) {
    die(json_encode(["success" => false, "message" => "Connection failed: " . $conn->connect_error]));
}

// 2. Receive JSON from Flutter
$inputJSON = file_get_contents('php://input');
$input = json_decode($inputJSON, true);

if (!$input) {
    echo json_encode(["success" => false, "message" => "No data received"]);
    exit();
}

// 3. Prepare variables (Handle NULLs automatically)
// We use the "ternary operator" (?:) to set empty fields to NULL
$type = $input['type'] ?? 'Batismo';
$date = $input['date'] ?? date('Y-m-d');
$details = $input['details'] ?? '';
$owner_id = $input['ownerUserId'] ?? 0;

// Batismo fields
$nome_bat = $input['nomeBatizado'] ?? null;
$pai = $input['pai'] ?? null;
$mae = $input['mae'] ?? null;
$pad1 = $input['padrinho1'] ?? null;
$pad2 = $input['padrinho2'] ?? null;
$data_nasc = $input['dataNascimento'] ?? null;

// Casamento fields
$conjuge_id = $input['conjugeUserId'] ?? null;
$test1 = $input['testemunha1'] ?? null;
$test2 = $input['testemunha2'] ?? null;

// Obito fields
$nome_fal = $input['nomeFalecido'] ?? null;
$data_nasc_fal = $input['dataNascimentoFalecido'] ?? null;
$data_obit = $input['dataObito'] ?? null;
$local_sep = $input['localSepultura'] ?? null;

// 4. The SQL Query (Insert EVERYTHING)
// We use Prepared Statements (?) to prevent hacking (SQL Injection)
$sql = "INSERT INTO celebrations (
    type, date, details, owner_user_id, 
    nome_batizado, pai, mae, padrinho1, padrinho2, data_nascimento,
    conjuge_user_id, testemunha1, testemunha2,
    nome_falecido, data_nascimento_falecido, data_obito, local_sepultura
) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)";

$stmt = $conn->prepare($sql);

if (!$stmt) {
    echo json_encode(["success" => false, "message" => "SQL Error: " . $conn->error]);
    exit();
}

// "s" means string, "i" means integer. We map the types below:
// ssss ssssss isss ssss (17 variables)
$stmt->bind_param(
    "sssissssssissssss", 
    $type, $date, $details, $owner_id,
    $nome_bat, $pai, $mae, $pad1, $pad2, $data_nasc,
    $conjuge_id, $test1, $test2,
    $nome_fal, $data_nasc_fal, $data_obit, $local_sep
);

if ($stmt->execute()) {
    // Return the new ID so Flutter can update the list immediately
    echo json_encode(["success" => true, "id" => $conn->insert_id]);
} else {
    echo json_encode(["success" => false, "message" => "Error executing query: " . $stmt->error]);
}

$stmt->close();
$conn->close();
?>