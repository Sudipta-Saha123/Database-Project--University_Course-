
CREATE USER shamim IDENTIFIED BY "shamim";
GRANT CREATE VIEW, CONNECT, RESOURCE, UNLIMITED TABLESPACE TO shamim;

--- Creating a table named 'manager'
CREATE TABLE manager
(
    mgr_id    number(10) PRIMARY KEY,
    mgr_name  varchar2(20),
    mgr_pass  varchar2(20),
    mgr_email varchar2(50),
    mgr_phone varchar2(20)
);


-- creating two sequences to manage automatic id generation
CREATE SEQUENCE mgr_seq START WITH 1;
CREATE SEQUENCE my_seq START WITH 1;


INSERT INTO manager VALUES (mgr_seq.nextval, 'manager', '123' , 'mgr'||my_seq.nextval||'@gmail.com' , '0123404239');

INSERT INTO manager VALUES (3, 'name', 'password' , 'mgr@gmail.com' , '0123404239');


-- Creating a Table named 'passenger'
CREATE TABLE passenger
(
    pass_id       number(10) PRIMARY KEY,
    pass_name     varchar2(20),
    pass_password varchar2(20),
    pass_email    varchar2(50),
    pass_phone    varchar2(20),
    mgr_id        number(10),
    FOREIGN KEY (mgr_id) REFERENCES manager (mgr_id)
);

-- creating a sequence which will start from 1 named 'pass_seq'
CREATE SEQUENCE pass_seq START WITH 1;

INSERT INTO passenger VALUES (pass_seq.nextval, 'user'||my_seq.nextval, my_seq.nextval, 'passenger'||my_seq.nextval||'@gmail.com', '123123123', my_seq.nextval-11);


-- creating a table named ticket
CREATE TABLE ticket
(
    ticket_id     number(10) PRIMARY KEY,
    total_ticket  number(1),
    ticket_status varchar2(10),
    pass_id       number(10),
    FOREIGN KEY (pass_id) REFERENCES passenger (pass_id)
);

CREATE SEQUENCE ticket_seq START WITH 1;
INSERT INTO ticket VALUES (ticket_seq.nextval, 2, 'Booked', 1);


-- creating a table named schedule
CREATE TABLE schedule
(
    sch_id         number(10) PRIMARY KEY,
    departure      varchar2(20),
    destination    varchar2(20),
    departure_time date,
    arrival_time   date,
    cost      number(10, 2),
    mgr_id         number(10),
    FOREIGN KEY (mgr_id) REFERENCES manager (mgr_id)
);


CREATE SEQUENCE sche_seq START WITH 1;

INSERT INTO schedule VALUES (sche_seq.nextval, 'Dhaka', 'Khulna', TO_DATE('27-05-23 12:00 p.m.','dd-mm-yy hh:mi a.m.'), TO_DATE('27-05-23 7:30 p.m.','dd-mm-yy hh:mi a.m.'), 960, 2);


-- booking table
CREATE TABLE book
(
    book_id number(10) PRIMARY KEY,
    pass_id number(10),
    sch_id  number(10),
    FOREIGN KEY (pass_id) REFERENCES passenger (pass_id),
    FOREIGN KEY (sch_id) REFERENCES schedule (sch_id)
);

CREATE SEQUENCE book_seq START WITH 1;

INSERT INTO book VALUES (book_seq.nextval, 12, 1);



-- order table
CREATE TABLE orders
(
    order_id    number(10) PRIMARY KEY,
    ticket_id   number(10),
    sche_id number(10),
    FOREIGN KEY (ticket_id) REFERENCES ticket (ticket_id),
    FOREIGN KEY (sche_id) REFERENCES schedule (sch_id)
);


CREATE SEQUENCE order_seq START WITH 1;

INSERT INTO orders VALUES (order_seq.nextval, 2, 1);

-- train_class table
CREATE TABLE train_class
(
    class_id number(10) PRIMARY KEY,
    class    varchar2(20),
    min_cost number(10),
    max_cost number(10)
);

CREATE SEQUENCE train_class_seq START WITH 1;

INSERT INTO train_class VALUES (train_class_seq.nextval, 'First Class', 6001, 9999);

-- #Searching & Advanced Searching Queries

-- 1. Search the passenger who's name contains with "%user%"
CREATE OR REPLACE VIEW search_passenger AS
SELECT *
FROM PASSENGER
WHERE PASS_NAME LIKE '%user%';
select * from search_passenger;

-- 2. Find the total number of tickets sold for each schedule, along with the departure and destination for the schedule
SELECT departure, destination, SUM(total_ticket)
FROM schedule s, ticket t, book b
WHERE s.sch_id = b.sch_id
GROUP BY departure, destination;


-- 3. Find the number of manager based on their salary
select mgr_salary, count(*) from manager group by mgr_salary;

-- 4. Retrieve the passenger ID, name, email, manager name, and manager email for any specific passenger by his/her name from the passenger and manager tables.

SELECT p.PASS_ID, p.PASS_NAME, p.PASS_EMAIL, m.MGR_NAME, m.MGR_EMAIL
FROM passenger p
JOIN manager m ON p.MGR_ID = m.MGR_ID
WHERE p.PASS_NAME = 'Shamim'

-- 5. Find of all managers who have managed a schedule with a cost greater than $1000
SELECT mgr_name, SUM(s.cost)
FROM manager m, schedule s
WHERE m.mgr_id = s.mgr_id AND s.cost > 1000
GROUP BY mgr_name, mgr_email, mgr_phone;

-- 6. Find the total number of tickets sold for each schedule, along with the departure and destination, where the tickets are either "Active" or "Booked" status and schedules are managed by a manager with an ID of 10, and the departure time is after 6 PM
SELECT departure, destination, SUM(total_ticket)
FROM schedule s, ticket t, book b
WHERE s.sch_id = b.sch_id
  AND t.ticket_status IN ('Active', 'Booked') AND s.mgr_id = 10
  AND s.departure_time > '18:00:00' AND (t.total_ticket * s.cost)>500
GROUP BY departure, destination;


-- #Procedures

-- 1. A user registration package that includes a procedure, function, and proper exception handling.
CREATE OR REPLACE PACKAGE pkg_user_registration
IS
    PROCEDURE register(
        		p_name IN passenger.pass_name%TYPE,
        		p_password IN passenger.pass_password%TYPE,
        		p_email IN passenger.pass_email%TYPE,
		        p_phone IN passenger.pass_phone%TYPE,
        		p_mgr_id IN passenger.mgr_id%TYPE);
END pkg_user_registration;

CREATE OR REPLACE PACKAGE BODY pkg_user_registration
IS
    FUNCTION is_passenger_unique(
        	    p_email passenger.pass_email%TYPE)
	RETURN BOOLEAN IS
	v_count NUMBER := 0;
    BEGIN
        SELECT COUNT(*) INTO v_count FROM passenger
        WHERE pass_email = p_email;

        IF v_count = 0 THEN RETURN TRUE;
        ELSE RETURN FALSE;
        END IF;
    END;

    PROCEDURE register(
	        	p_name IN passenger.pass_name%TYPE,
		p_password IN passenger.pass_password%TYPE,
	        	p_email IN passenger.pass_email%TYPE,
		p_phone IN passenger.pass_phone%TYPE,
	        	p_mgr_id IN passenger.mgr_id%TYPE)
        IS
        is_pass_unique BOOLEAN;
        exc_duplicate_user EXCEPTION;
    BEGIN
        is_pass_unique := is_passenger_unique(p_email);

        IF is_pass_unique = FALSE THEN
            RAISE exc_duplicate_user;
        END IF;

        INSERT INTO passenger
        VALUES (pass_seq.NEXTVAL, p_name, p_password, p_email, p_phone, p_mgr_id);
        DBMS_OUTPUT.PUT_LINE('The user has been registered successfully.');

        EXCEPTION WHEN exc_duplicate_user THEN
            DBMS_OUTPUT.PUT_LINE('The username or email address is not unique. Please try it once again.');            
    END;
END pkg_user_registration;

BEGIN
    pkg_user_registration.register('Dopa mine', '123123', 'dopa@gmail.com', '01212312334', 1);
END;


-- 2. A package including procedure, function, and proper exception handling to remove a user based on his email address.
CREATE OR REPLACE PACKAGE pkg_remove_user
IS
    PROCEDURE remove(p_email IN passenger.pass_email%TYPE);
END pkg_remove_user;


CREATE OR REPLACE PACKAGE BODY pkg_remove_user
IS
    FUNCTION is_passenger_exist(p_email passenger.pass_email%TYPE)
    RETURN BOOLEAN IS
        v_count NUMBER := 0;
    BEGIN
        SELECT COUNT(*) INTO v_count FROM passenger
        WHERE pass_email = p_email;

        IF v_count = 0 THEN RETURN FALSE;
        ELSE RETURN TRUE;
        END IF;
    END;

    PROCEDURE remove(p_email IN passenger.pass_email%TYPE)
    IS
        is_user_exist BOOLEAN;
        exc_user_not_exist EXCEPTION;
    BEGIN
        is_user_exist := is_passenger_exist(p_email);

        IF is_user_exist = FALSE THEN
            RAISE exc_user_not_exist;
        END IF;

        DELETE FROM passenger WHERE pass_email = p_email;

        DBMS_OUTPUT.PUT_LINE('The user has been deleted successfully');

        EXCEPTION WHEN exc_user_not_exist THEN
            DBMS_OUTPUT.PUT_LINE('The email address is not exist. Please try it once again.');
        WHEN others THEN 
            DBMS_OUTPUT.PUT_LINE('Foreign key problem. User cannot be deleted!');
    END;
END pkg_remove_user;

BEGIN
    pkg_remove_user.remove('dopa@gmail.com');
END;

-- 3. A package that includes a procedure, function, and proper exception handling to delay all schedules of any specific destination by one day.
CREATE OR REPLACE PACKAGE pkg_delay_schedule
IS
    PROCEDURE delay(p_destination IN schedule.destination%TYPE);
END pkg_delay_schedule;


CREATE OR REPLACE PACKAGE BODY pkg_delay_schedule
IS
    FUNCTION is_schedule_exist(p_destination schedule.destination%TYPE)
    RETURN BOOLEAN IS
        v_count NUMBER := 0;
    BEGIN
        SELECT COUNT(*) INTO v_count FROM schedule
        WHERE destination = p_destination;

        IF v_count = 0 THEN RETURN FALSE;
        ELSE RETURN TRUE;
        END IF;
    END;

    PROCEDURE delay(p_destination IN schedule.destination%TYPE)
    IS
        is_sch_exist BOOLEAN;
        exc_sch_not_exist EXCEPTION;
    BEGIN
        is_sch_exist := is_schedule_exist(p_destination);

        IF is_sch_exist = FALSE THEN
            RAISE exc_sch_not_exist;
        END IF;

        UPDATE schedule
        SET departure_time = departure_time + INTERVAL '1' DAY,
            arrival_time = arrival_time + INTERVAL '1' DAY
        WHERE destination = p_destination;

        DBMS_OUTPUT.PUT_LINE('The schedule(s) has been delayed by 1 day.');

        EXCEPTION WHEN exc_sch_not_exist THEN
            DBMS_OUTPUT.PUT_LINE('There is no schedule available for that destination.');
    END;
END pkg_delay_schedule;


BEGIN
    pkg_delay_schedule.delay('Chittagong');
END;

-- 4. A stored procedure to update email address of a passenger

CREATE PROCEDURE update_passenger_email(
    		p_pass_id IN passenger.pass_id%TYPE,
   		p_new_email IN passenger.pass_email%TYPE
) AS
BEGIN
    UPDATE passenger SET pass_email = p_new_email
    WHERE pass_id = p_pass_id;
END;

BEGIN
    update_passenger_email (5, 'updated@gmail.com');
END;


-- 5. A stored procedure to update salary of manager using a threshold

CREATE OR REPLACE 
    PROCEDURE updateSalary(p_threshold IN manager.mgr_salary%TYPE, p_amount IN manager.mgr_salary%TYPE)
as
cursor c_manager is
select mgr_id from manager where mgr_salary > p_threshold; 
BEGIN
    FOR r_manager IN c_manager
        LOOP
            UPDATE manager SET mgr_salary = mgr_salary + p_amount 
            WHERE mgr_id = r_manager.mgr_id;
        END LOOP;
END;

BEGIN
    updateSalary(4000, 1000);
END;


-- 6. A stored procedure to delete all cancelled tickets
CREATE PROCEDURE delete_cancelled_tickets AS
    CURSOR c_ticket IS
        SELECT ticket_id FROM ticket WHERE ticket_status = 'Cancelled';
BEGIN
    FOR r_ticket IN c_ticket
        LOOP
            DELETE FROM ticket WHERE ticket_id = r_ticket.ticket_id;
        END LOOP;
END;

BEGIN
    delete_cancelled_tickets;
END;


-- # Triggers

-- 1. A trigger to enforce the constraint that each schedule can have at most 50 rows with the same destination and an arrival time that is less than the current date and time.
CREATE OR REPLACE TRIGGER trg_limit_destination
    BEFORE INSERT OR UPDATE
    ON schedule FOR EACH ROW
DECLARE
    v_count NUMBER;
BEGIN
    SELECT COUNT(*) INTO v_count FROM schedule
    WHERE destination = :NEW.destination AND arrival_time < SYSDATE;

    IF v_count >= 50 THEN
        RAISE_APPLICATION_ERROR(-20001, 'There can be at most 50 rows with the same destination and an arrival time less than the current date and time');
    END IF;
END;

-- 2. Create a backup table of passenger with trigger
CREATE or Replace TABLE passenger_backup
AS SELECT * FROM passenger where 1 = 2;

CREATE OR REPLACE TRIGGER backup_passenger_trigger
    AFTER INSERT OR UPDATE OR DELETE ON passenger
    FOR EACH ROW
BEGIN
    INSERT INTO passenger_backup
    VALUES (:NEW.pass_id, :NEW.pass_name, :NEW.pass_password,
            :NEW.pass_email, :NEW.pass_phone, :NEW.mgr_id);
END;

-- 3. A trigger to keep log of insert, update, and delete operation on each row of passenger table

CREATE TABLE passenger_log
(
    log_id        NUMBER PRIMARY KEY,
    pass_id       NUMBER,
    pass_name     VARCHAR2(20),
    pass_password VARCHAR2(20),
    pass_email    VARCHAR2(50),
    pass_phone    VARCHAR2(20),
    mgr_id        NUMBER,
    log_operation VARCHAR2(10),
    log_timestamp TIMESTAMP
);

CREATE SEQUENCE pass_log_seq START WITH 1;

CREATE OR REPLACE TRIGGER passenger_trg
    AFTER INSERT OR DELETE OR UPDATE ON passenger FOR EACH ROW
BEGIN
    IF INSERTING THEN
        INSERT INTO passenger_log
        VALUES (pass_log_seq.NEXTVAL, :NEW.pass_id,:NEW.pass_name,
		 :NEW.pass_password, :NEW.pass_email, :NEW.pass_phone,
		 :NEW.mgr_id, 'INSERT', SYSTIMESTAMP);
    ELSIF DELETING THEN
        INSERT INTO passenger_log
        VALUES (pass_log_seq.NEXTVAL, :old.pass_id, :old.pass_name,
		 :old.pass_password, :old.pass_email, :old.pass_phone,
		 :old.mgr_id, 'DELETE', SYSTIMESTAMP);
    ELSIF UPDATING THEN
        INSERT INTO passenger_log
        VALUES (pass_log_seq.NEXTVAL, :NEW.pass_id, :NEW.pass_name,
		 :NEW.pass_password, :NEW.pass_email, :NEW.pass_phone,
		 :NEW.mgr_id, 'UPDATE', SYSTIMESTAMP);
    END IF;
END;

-- 4. Prevent updating an order to a non-existent ticket or schedule
CREATE OR REPLACE TRIGGER prevent_invalid_order_update
    BEFORE UPDATE
    ON orders FOR EACH ROW
DECLARE
    v_ticket_count NUMBER;
    v_schedule_count NUMBER;
BEGIN
    SELECT COUNT(*) INTO v_ticket_count FROM ticket
    WHERE ticket_id = :NEW.ticket_id;

    SELECT COUNT(*) INTO v_schedule_count FROM schedule
    WHERE sch_id = :NEW.sche_id;

    IF v_ticket_count = 0 THEN
        RAISE_APPLICATION_ERROR(-20006, 'Invalid Ticket ID');
    ELSIF v_schedule_count = 0 THEN
        RAISE_APPLICATION_ERROR(-20009, 'Invalid Schedule ID');
    END IF;
END;






-- 0. restrict user to insert update or delete

create or replace trigger restricted_dml 
before insert or update or delete on passenger
begin 
if (TO_CHAR(SYSDATE, 'HH24:MI') NOT BETWEEN '09:00' AND '18:00') THEN
RAISE_APPLICATION_ERROR(-20124, 'You can manipulate employee only between 9:00 am and 6:00 pm.');
end if;
end;

drop trigger restricted_dml;