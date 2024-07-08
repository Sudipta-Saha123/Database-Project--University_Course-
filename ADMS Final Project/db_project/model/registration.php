<?php

if(session_status() === PHP_SESSION_NONE) session_start();

require_once 'database-config.php';
require_once 'string-validate.php';


    $username = removeWhitespaces($_POST['name']);
    $password = removeWhitespaces($_POST['password']);
    $email = removeWhitespaces($_POST['email']);
    $phone = removeWhitespaces($_POST['phone']);
    $managerId = $_POST['manager'];
    if (
        
        checkLength($username, 3)
        && validateEmail($email)
        && checkLength($password, 2)
        && checkLength($phone,10,12)
        && $managerId > 0        
       
    ) {
        $query = "BEGIN pkg_user_registration.register(:username, :password, :email, :phone, :managerId); END;";
        try {
            $conn = oci_connect(USERNAME, PASSWORD, CONNECTION_STRING);

            $stid = oci_parse($conn, $query);

            oci_bind_by_name($stid, ":username", $username);
            oci_bind_by_name($stid, ":password", $password);
            oci_bind_by_name($stid, ":email", $email);
            oci_bind_by_name($stid, ":phone", $phone);
            oci_bind_by_name($stid, ":managerId", $managerId);

            oci_execute($stid);
            
            if($_SESSION['op'] == "Restrict DML : ON")
            {
                header("Location: ../view/login.php?cannotAdd");
            }else
            header("Location: ../view/login.php?success");
            die();

        } catch (Exception $ex) {
            header("Location: ../view/database-error.php");
            die();
        }
    }else
    {
        header("Location: ../view/login.php?failed");

    }
