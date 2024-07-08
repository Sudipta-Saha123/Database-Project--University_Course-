<div class="modal fade text-black" id="registrationModal" tabindex="-1" aria-labelledby="registrationModalLabel" aria-hidden="true" data-bs-backdrop="static" data-bs-keyboard="false">
    <div class="modal-dialog modal-dialog-centered modal-dialog-scrollable">
        <div class="modal-content">
            <div class="modal-header">
                <h1 class="modal-title fs-5" id="registrationModalLabel">Register A new User</h1>
                <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
            </div>
            <form action="../model/add-user.php" method="post">
                <div class="modal-body ">
                    <div class="form-floating mb-3">
                        <input type="text" name="name" class="form-control" id="floatingInput" placeholder="John Doe" 
                        value="<?php echo isset($_SESSION['name']) ? $_SESSION['name'] : ''   ?>">
                        <label for="floatingInput">Name</label>
                    </div>
                    <div class="form-floating mb-3">
                        <input type="email" class="form-control" id="floatingInput" placeholder="name@example.com"
                        name="email"
                        value="<?php echo isset($_SESSION['email']) ? $_SESSION['email'] : ''   ?>"
                        >
                        <label for="floatingInput" 
                        >Email address</label>
                    </div>
                    <div class="form-floating mb-3">
                        <input type="text" class="form-control" id="floatingInput" placeholder="01878042329"
                        name="phone"
                        value="<?php echo isset($_SESSION['phone']) ? $_SESSION['phone'] : ''  ?>"
                        >
                        <label for="floatingInput">Phone</label>
                    </div>
                    <div class="form-floating">
                        <input type="password" class="form-control" id="floatingPassword" placeholder="Password"
                        name="password"
                        value="<?php echo isset($_SESSION['password']) ? $_SESSION['password'] : ''   ?>"
                        >
                        <label for="floatingPassword">Password</label>
                    </div>

                    <select name="manager" class="form-select form-select-lg mt-3" aria-label="Default select example">
                        <option selected>Select Manager</option>
                        <option value="1">Manager 1</option>
                        <option value="2">Manager 2</option>
                        <option value="3">Manager 3</option>
                    </select>

                    <div class="d-grid gap-2">
                        <button class="btn btn-primary mt-4" type="submit">Confirm</button>
                    </div>
                </div>
            </form>
            <div class="modal-footer">
                <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Close</button>
            </div>
        </div>
    </div>
</div>