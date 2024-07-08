<!DOCTYPE html>
<html lang="en">

<head>
    <meta charset="UTF-8">
    <meta http-equiv="X-UA-Compatible" content="IE=edge">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Login</title>
    <link rel="stylesheet" href="../assets/css/bootstrap.css">
    <script src="../assets/js/bootstrap.js"></script>

    <style>
        .login-form{
            width: 400px;
            margin: 0 auto;
            margin-top: 200px;
            padding: 30px 20px;
            background-color: #2C3333;
            border-radius: 10px;
        }

        .custom{
            margin-left: 20px;
        }
    </style>
</head>

<body class="bg-dark text-white">
    <div class="login-form">
        <form method="post" action="../model/login.php">
            <label for="exampleInputEmail1" class="form-label">Email address</label>
            <input type="text" class="form-control" name="email">

            <label for="exampleInputEmail1" class="form-label">Password</label>
            <input type="password" class="form-control" name="password">
            <div class="d-flex mt-5">
                <button type="submit" class="btn btn-primary">Login</button>
                <a href="#" class="custom link-info link-offset-2 link-underline-opacity-25 link-underline-opacity-100-hover" data-bs-toggle="modal" data-bs-target="#registrationModal">Register a new account</a>
            </div>
        </form>
    </div>
        
    
    <?php 
        require_once('registration.php');
        
        if(isset($_REQUEST['cannotAdd'])) echo "<script>alert('Restricted On. Cannot Add Passenger!');</script>";
        if(isset($_REQUEST['failed'])) echo "<script>alert('Something went wrong. Login Failed');</script>";

        if(isset($_REQUEST['success'])) echo "<script>alert('Registration Successful. Please login Now!');</script>";
    ?>
</body>

</html>