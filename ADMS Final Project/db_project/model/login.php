<?php
require_once 'database-config.php';
require_once 'string-validate.php';

    $email = $_POST['email'];
    $password = $_POST['password'];

    if ($email == 'admin' && $password == 'admin') {
        header("Location: ../view/dashboard.php");
        die();
    } else if (removeWhitespaces($email) && removeWhitespaces($password)) {

        $query = "SELECT * FROM PASSENGER 
                  WHERE PASS_EMAIL = :email 
                  AND PASS_PASSWORD = :password";

        try {
            $conn = oci_connect(USERNAME, PASSWORD, CONNECTION_STRING);

            $stid = oci_parse($conn, $query);

            oci_bind_by_name($stid, ":email", $email);
            oci_bind_by_name($stid, ":password", $password);

            oci_execute($stid);

            $ociResult = oci_fetch($stid);

            if ($ociResult) {
                header("Location: ../view/home.php?login=success");
                exit;
            } else {
                header("Location: ../view/login.php?failed");
            }
            die();

        } catch (Exception $ex) {
            echo "Database not conneted or something went wrong!";
            die();
        }
    }

