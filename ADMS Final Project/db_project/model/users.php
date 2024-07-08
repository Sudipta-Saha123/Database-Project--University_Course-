<?php
require_once 'database-config.php';

if (isset($_GET['delete']))
    deleteUser($_GET['delete']);

function fetchUsers()
{
    $query = "SELECT * FROM passenger, manager
              WHERE passenger.mgr_id = manager.mgr_id";

    try {
        $conn = oci_connect(USERNAME, PASSWORD, CONNECTION_STRING);
        $stid = oci_parse($conn, $query);
        oci_execute($stid);

        $html = "";

        while (($row = oci_fetch_assoc($stid)) != false) {
            $html .= '
            <tr>
                <td>' . $row['PASS_ID'] . '</td>
                <td>' . $row['PASS_NAME'] . '</td>
                <td>' . $row['PASS_EMAIL'] . '</td>
                <td>' . $row['PASS_PASSWORD'] . '</td>
                <td>' . $row['PASS_PHONE'] . '</td>
                <td>' . $row['MGR_NAME'] . '</td>
                <td><a class="error-message" href="users.php?delete=' . $row['PASS_EMAIL'] . '">Delete</a></td>
            </tr>';
        }
        echo $html;
    } catch (Exception $ex) {
        header("Location: ../view/database-error.php");
        die();
    }
}

function deleteUser($email)
{
    
    $query = "BEGIN pkg_remove_user.remove(:email); END;";

    try {
        $conn = oci_connect(USERNAME, PASSWORD, CONNECTION_STRING);
        $stid = oci_parse($conn, $query);
        oci_bind_by_name($stid, ":email", $email);
        oci_execute($stid);
        $query = "select * from passenger where pass_email = '{$email}'";
        $stid = oci_parse($conn, $query);
        oci_execute($stid);
        $row = oci_fetch_array($stid, OCI_ASSOC+OCI_RETURN_NULLS);
        // print_r($row);
        if($row)
        {
            header("Location: ../view/dashboard.php?cannot-remove-passenger");
        }else
        {
            header("Location: ../view/dashboard.php?deleted");
        }
        die();
    } catch (Exception $ex) {
        header("Location: ../view/database-error.php");
        die();
    }
}

// deleteUser('passenger26@gmail.com');


