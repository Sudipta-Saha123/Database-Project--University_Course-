<?php 
            if(session_status() === PHP_SESSION_NONE) session_start();

    if(isset($_REQUEST['op']))
    {       
        if($_SESSION['op'] == "Restrict DML : OFF")
        {
            $_SESSION['op'] = "Restrict DML : ON";
        }else
        {
            $_SESSION['op'] = "Restrict DML : OFF";
        }
            

        $conn = oci_connect('shamim', 'shamim', 'localhost/xe');
        if($_REQUEST['op'] == "Restrict DML : OFF")
        {
            $query = "create or replace trigger restricted_dml 
            before insert or update or delete on passenger
            begin 
            if (TO_CHAR(SYSDATE, 'HH24:MI') NOT BETWEEN '09:00' AND '18:00') THEN
            RAISE_APPLICATION_ERROR(-20124, 'You can manipulate employee only between 9:00 am and 6:00 pm.');
            end if;
            end;";
            $stid = oci_parse($conn, $query);
            oci_execute($stid);   
        }else
        {
            $query = "drop trigger restricted_dml";
            $stid = oci_parse($conn, $query);
            oci_execute($stid);   
        }
    }

    // echo "shamim";
    header('location: ../view/dashboard.php');

?>