<?php
// This is a simplified example. In a real application, you would:
// 1. Sanitize and validate all input to prevent security vulnerabilities.
// 2. Use a secure database connection (e.g., PDO with prepared statements).
// 3. Implement robust error handling and logging.
// 4. Encrypt sensitive data before storage.

$servername = "localhost";
$username = "username";
$password = "password";
$dbname = "clinical_db";

// Create connection
$conn = new mysqli($servername, $username, $password, $dbname);

// Check connection
if ($conn->connect_error) {
    die("Connection failed: " . $conn->connect_error);
}

// Get form data
$patientId = $_POST['patientId'];
$trialId = $_POST['trialId'];
$age = $_POST['age'];
$gender = $_POST['gender'];

// SQL to insert data (using prepared statements for security)
$sql = "INSERT INTO patient_demographics (patient_id, trial_id, age, gender) VALUES (?, ?, ?, ?)";
$stmt = $conn->prepare($sql);
$stmt->bind_param("ssis", $patientId, $trialId, $age, $gender); // s = string, i = integer

if ($stmt->execute()) {
    echo "New record created successfully for Patient ID: " . htmlspecialchars($patientId);
} else {
    echo "Error: " . $stmt->error;
}

$stmt->close();
$conn->close();
?>
