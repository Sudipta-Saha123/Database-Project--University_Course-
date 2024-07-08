<?php 
        if(session_status() === PHP_SESSION_NONE) session_start();
        if(!isset($_SESSION['op']) || empty($_SESSION['op'])) $_SESSION['op'] = "Restrict DML : OFF";    
        // print_r($_SESSION);
?>

<!DOCTYPE html>
<html lang="en">

<head>
    <meta charset="UTF-8">
    <meta http-equiv="X-UA-Compatible" content="IE=edge">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Dashboard</title>
    <link rel="stylesheet" href="../assets/css/bootstrap.css">
    <script src="../assets/js/bootstrap.js"></script>

    <style>
        .card{
            width: 400px;
            margin: 0 auto;
            margin-top: 60px;
            background-color: white;
        }
    </style>
</head>

<body class="bg-dark text-white">
    <div class="card">
        <div class="d-grid gap-2 p-4 col-12 mx-auto">
        <button class="btn btn-primary" type="button" data-bs-toggle="modal" data-bs-target="#registrationModal">Add User</button>
        <button class="btn btn-primary" type="button" data-bs-toggle="modal" data-bs-target="#manageUserModel">Manage User</button>
        <button class="btn btn-primary" type="button" data-bs-toggle="modal" data-bs-target="#exampleModal">View Schedule</button>
        <button class="btn btn-primary" type="button" id="myBtn" onclick="f()"><?php echo $_SESSION['op']; ?></button>
        <button onclick="location.href = 'login.php';" class="btn btn-primary" type="button">Logout</button>
        </div>
    </div>


    <?php    require_once('schedules.php'); ?>
    <?php    require_once('add-user.php'); ?>
    <?php    require_once('users.php'); ?>

    <?php 

        if(isset($_REQUEST['failed'])) echo "<script>alert('Duplicate entry. Cannot Add user!');</script>";
        if(isset($_REQUEST['cannotAdd'])) echo "<script>alert('Restricted On. Cannot Add Passenger!');</script>";
        if(isset($_REQUEST['success'])) echo "<script>alert('New Passenger added!');</script>";
        if(isset($_REQUEST['deleted'])) echo "<script>alert('Passenger Successfully deleted!');</script>";
        if(isset($_REQUEST['cannot-remove-passenger'])) echo "<script>alert('Passenger Cannot Be removed! Might be constraint problem!');</script>";



    ?>

    <script>
        function f()
        {
            var button = document.getElementById("myBtn");
            var buttonText = button.innerHTML;           
            window.location.href = "../model/restrict.php?op="+buttonText;
        }

    </script>
</body>

</html>

