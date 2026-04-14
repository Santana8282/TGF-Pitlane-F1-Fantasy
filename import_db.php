<?php
require_once __DIR__ . '/private/database.php';

$pdo = getDB();

$sql = file_get_contents(__DIR__ . '/db/pitlane_f1.sql');

$statements = array_filter(array_map('trim', explode(';', $sql)));

foreach ($statements as $statement) {
    if (!empty($statement)) {
        try {
            $pdo->exec($statement);
        } catch (PDOException $e) {
            echo "Error executing: $statement\n" . $e->getMessage() . "\n";
        }
    }
}

echo "Import completed.";
?>