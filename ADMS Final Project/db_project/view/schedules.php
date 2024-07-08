<div class="modal fade text-black" id="exampleModal" tabindex="-1" aria-labelledby="exampleModalLabel" aria-hidden="true">
  <div class="modal-dialog modal-lg modal-dialog-centered modal-dialog-scrollable">
    <div class="modal-content">
      <div class="modal-header">
        <h1 class="modal-title fs-5" id="exampleModalLabel">Schedules of All Train</h1>
        <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
      </div>
      <div class="modal-body ">
      <h2 class="admin-form-title">Train Schedules</h2>
        <div class="table-wrapper">
            <table class="table table-striped table-hover" id="users-table">
                <tr>
                    <th scope="row">ID</th>
                    <th scope="row">Departure</th>
                    <th scope="row">Destination</th>
                    <th scope="row">Departure Time</th>
                    <th scope="row">Arrival Time</th>
                    <th scope="row">Cost</th>
                    <th scope="row">Manager</th>
                </tr>
                <?PHP 
                require_once('../model/schedules.php');
                fetchSchedule();
                ?>
            </table>
        </div>
      </div>
      <div class="modal-footer">
        <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Close</button>
      </div>
    </div>
  </div>
</div>