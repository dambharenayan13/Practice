drop procedure if exists pro1;
delimiter $
create procedure pro1()
BEGIN
	select "Hello World " R1;
end $
delimiter ;


drop procedure if exists pro1;
delimiter $
create procedure pro1()
BEGIN
	select * from dept;
end $
delimiter ;



drop procedure if exists pro1;
delimiter $
create procedure pro1()
BEGIN
	insert into i values(1,1,1);
end $
delimiter ;


drop procedure if exists pro1;
delimiter $
create procedure pro1()
BEGIN
	declare x int default 100;
	declare y int;
	set y := 200;
	select x+y;
end $
delimiter ;


drop procedure if exists pro1;
delimiter $
create procedure pro1(x int, y int)
BEGIN
	select x+y;
end $
delimiter ;


drop procedure if exists pro1;
delimiter $
create procedure pro1(in x int, in y int,  out z int)
BEGIN
	set z := x+y;
end $
delimiter ;



drop procedure if exists pro1;
delimiter $
create procedure pro1(in x int, in y int,  out z int,  out z1 int)
BEGIN
	set z := x+y;
	set z1 := x*y;
end $
delimiter ;


drop procedure if exists pro1;
delimiter $
create procedure pro1()
BEGIN
	declare exit handler for sqlexception
	BEGIN
	    ROLLBACK;
		SELECT 'Transaction failed. Rolled back.' AS message;
	end;
	Start Transaction Read Write;

	insert into a1 values(2);
	insert into a2 values(2);
	commit;
	
end $
delimiter ;



drop procedure if exists pro1;
delimiter $
create procedure pro1()
BEGIN
	
	insert into dept values(81, 'PQR', 'baroda','xyz', '24/03/1989',-1);
end $
delimiter ;




drop procedure if exists pro1;
delimiter $
create procedure pro1(p_dname varchar(20), p_loc varchar(20), p_pwd varchar(20), p_STARTEDON varchar(20) )
BEGIN
	declare v_deptno int default 0;
	select max(deptno) + 1 into v_deptno from dept;
	insert into dept values(v_deptno, upper(p_dname),  upper(p_loc) , p_pwd, p_STARTEDON);
	select  "Record inserted ....." as Message;
end $
delimiter ;


  call pro1('marketing', 'baroda','saleel', '22/12/1989')

drop procedure if exists pro1;
delimiter $
create procedure pro1(p_deptno int)
BEGIN
	delete from dept where deptno = p_deptno;
	select  "Record deleted ....." as Message;
end $
delimiter ;



drop procedure if exists pro1;
delimiter $
create procedure pro1(p_deptno int)
BEGIN
	declare flag bool default false;
	 
	 select	true into flag from dept where deptno =  p_deptno;
	 
	 if flag THEN
		delete from dept where deptno =  p_deptno;
		select "Record deleted ..." as MSG;
	 ELSE
			select "Record not found..." as MSG;
	 end if;
end $
delimiter ;




drop procedure if exists pro1;
delimiter $
create procedure pro1(x int, y int)
BEGIN
	
	select * from dept limit x, y;
end $
delimiter ;



drop procedure if exists pro1;
delimiter $
create procedure pro1(p_last_record int)
BEGIN
	declare v_cnt int default 0;
	
	select count(*) - p_last_record  into v_cnt from dept;
	
	select * from dept limit v_cnt, p_last_record;
	
end $
delimiter ;



drop procedure if exists pro1;
delimiter $
create procedure pro1()
BEGIN
	declare x int;
	set x := 1;
	
	lbl1:LOOP
		
		select x;
		set x := x + 1;
		
		if x >=10 THEN
			leave lbl1;
		end if;
		
	end loop lbl1;
end $
delimiter ;


drop procedure if exists pro1;
delimiter $
create procedure pro1()
BEGIN
	declare x int default 1; 
	
	lbl1:LOOP
		
		select x;
		set x := x + 1;
		
		if x >10 THEN
			leave lbl1;
		end if;
		
		insert into t values(curdate() + interval x day);
	end loop lbl1;
end $
delimiter ;




drop procedure if exists pro1;
delimiter $
create procedure pro1()
b1:BEGIN
	declare exit handler for  1062 select 'present ..';
	insert into a1 values(1,1); 	
end b1$
delimiter ;


drop procedure if exists pro1;
delimiter $
create procedure pro1()
b1:BEGIN
	declare exit handler for sqlexception
	b2:begin
		rollback;
		select 'Transaction undon...';
	end b2;

	start transaction read write;
	
	insert into a1 values(4,'shanchali'); 
	insert into a2 values(2,'bharuch'); 

	commit;
	select	'Trainaction done';
	
end b1$
delimiter ;



drop procedure if exists pro1;
delimiter $
create procedure pro1()
b1:BEGIN
	declare v_deptno int;
	declare v_dname, v_loc, v_pwd, v_startedon varchar(20);
	
	declare c1 cursor for select * from dept;
	
	declare exit handler for 1329 select 'done';
	open c1;
	lbl:loop
		fetch c1 into v_deptno, v_dname, v_loc, v_pwd, v_startedon;
		select v_deptno, v_dname, v_loc, v_pwd, v_startedon;
	end loop lbl;
	close c1;
end b1$
delimiter ;



drop procedure if exists pro1;
delimiter $
create procedure pro1()
b1:BEGIN
	declare v_deptno int;
	declare v_name, v_job varchar(20);
	
	declare c1 cursor for  select ename, job, deptno from emp;
	
	declare exit handler for 1329 select 'done';
	open c1;
	lbl:loop
		fetch c1 into v_name, v_job , v_deptno;
		if v_deptno = 10 THEN
			insert into e1 values(v_name, v_job , v_deptno);
		elseif v_deptno = 20 THEN
			insert into e2 values(v_name, v_job , v_deptno);
		ELSE
			insert into e3 values(v_name, v_job , v_deptno);
		end if;
		
	end loop lbl;
	close c1;
end b1$
delimiter ;
********************************************Assignment************************************************

DELIMITER $$

CREATE PROCEDURE transfer_money(
    IN from_acc INT,
    IN to_acc INT,
    IN amt DECIMAL(10,2)
)
BEGIN
    DECLARE bal DECIMAL(10,2);

    START TRANSACTION;

    SELECT balance INTO bal
    FROM accounts
    WHERE acc_no = from_acc;

    IF bal < amt THEN
        ROLLBACK;
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Not enough balance';
    END IF;

    UPDATE accounts
    SET balance = balance - amt
    WHERE acc_no = from_acc;

    UPDATE accounts
    SET balance = balance + amt
    WHERE acc_no = to_acc;

    INSERT INTO transaction_history(from_acc, to_acc, amount)
    VALUES(from_acc, to_acc, amt);

    COMMIT;
END $$

DELIMITER ;



DELIMITER $$

CREATE PROCEDURE make_order(
    IN cust_id INT,
    IN product INT,
    IN qty INT
)
BEGIN
    DECLARE stock INT;
    DECLARE price DECIMAL(10,2);
    DECLARE total DECIMAL(10,2);

    SELECT stock, price INTO stock, price
    FROM products
    WHERE product_id = product;

    IF stock < qty THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Stock not available';
    END IF;

    SET total = price * qty * 1.18;   -- GST 18%

    UPDATE products
    SET stock = stock - qty
    WHERE product_id = product;

    INSERT INTO orders(customer_id, product_id, qty, total_price)
    VALUES(cust_id, product, qty, total);

END $$

DELIMITER ;



DELIMITER $$

CREATE TRIGGER auto_discount_product
BEFORE INSERT ON products
FOR EACH ROW
BEGIN
    SET NEW.price = NEW.price - (NEW.price * (FLOOR(RAND()*26)+5)/100);
END $$

DELIMITER ;

UPDATE orders
SET total_price = total_price - FLOOR(RAND()*101)
WHERE order_id = LAST_INSERT_ID();



DELIMITER $$

CREATE FUNCTION get_total_cost(pid INT)
RETURNS DECIMAL(10,2)
DETERMINISTIC
BEGIN
    DECLARE doc DECIMAL(10,2);
    DECLARE med DECIMAL(10,2);

    SELECT doctor_fee, medicine_fee
    INTO doc, med
    FROM treatment
    WHERE patient_id = pid;

    RETURN doc + med;
END $$

DELIMITER ;


DELIMITER $$

CREATE FUNCTION get_insurance_amount(pid INT)
RETURNS DECIMAL(10,2)
DETERMINISTIC
BEGIN
    DECLARE ins VARCHAR(3);
    DECLARE cost DECIMAL(10,2);

    SELECT insurance INTO ins FROM patients WHERE patient_id = pid;
    SET cost = get_total_cost(pid);

    IF ins = 'YES' THEN
        RETURN cost * 0.20;
    ELSE
        RETURN 0;
    END IF;
END $$

DELIMITER ;



DELIMITER $$

CREATE FUNCTION check_patient_insurance(pid INT)
RETURNS VARCHAR(20)
DETERMINISTIC
BEGIN
    DECLARE ins VARCHAR(3);
    SELECT insurance INTO ins FROM patients WHERE patient_id = pid;

    IF ins = 'YES' THEN
        RETURN 'Insured';
    ELSE
        RETURN 'Not Insured';
    END IF;
END $$

DELIMITER ;

DELIMITER $$

CREATE FUNCTION get_highest_bill_patient()
RETURNS INT
DETERMINISTIC
BEGIN
    DECLARE pid INT;

    SELECT patient_id
    INTO pid
    FROM treatment
    ORDER BY (doctor_fee + medicine_fee) DESC
    LIMIT 1;

    RETURN pid;
END $$

DELIMITER ;



DELIMITER $$

CREATE FUNCTION get_medicine_cost(pid INT)
RETURNS DECIMAL(10,2)
DETERMINISTIC
BEGIN
    DECLARE med DECIMAL(10,2);
    SELECT medicine_fee INTO med FROM treatment WHERE patient_id = pid;
    RETURN med;
END $$

DELIMITER ;



DELIMITER $$

CREATE FUNCTION get_doctor_cost(pid INT)
RETURNS DECIMAL(10,2)
DETERMINISTIC
BEGIN
    DECLARE doc DECIMAL(10,2);
    SELECT doctor_fee INTO doc FROM treatment WHERE patient_id = pid;
    RETURN doc;
END $$

DELIMITER ;


DELIMITER $$

CREATE FUNCTION get_final_bill(pid INT, tax DECIMAL(5,2))
RETURNS DECIMAL(12,2)
DETERMINISTIC
BEGIN
    DECLARE total DECIMAL(10,2);
    DECLARE ins DECIMAL(10,2);

    SET total = get_total_cost(pid);
    SET ins = get_insurance_amount(pid);

    SET total = total - ins;
    SET total = total + (total * (tax/100));

    RETURN total;
END $$

DELIMITER ;




DELIMITER $$

CREATE PROCEDURE calculate_salary(emp INT)
BEGIN
    DECLARE basic INT;
    DECLARE allow INT;
    DECLARE deduct INT;
    DECLARE net INT;

    SELECT basic, allowance, deduction
    INTO basic, allow, deduct
    FROM employees
    WHERE emp_id = emp;

    SET net = basic + allow - deduct;

    INSERT INTO payroll_history(emp_id, net_salary)
    VALUES(emp, net);
END $$

DELIMITER ;



DELIMITER $$

CREATE PROCEDURE book_ticket(
    IN pname VARCHAR(50),
    IN train INT
)
BEGIN
    DECLARE seats INT;
    DECLARE booked INT;

    SELECT total_seats, booked_seats INTO seats, booked
    FROM trains WHERE train_id = train;

    IF booked < seats THEN
        UPDATE trains SET booked_seats = booked_seats + 1 WHERE train_id = train;

        INSERT INTO tickets(passenger_name, train_id, seat_no)
        VALUES(pname, train, booked + 1);
    ELSE
        INSERT INTO waiting_list(passenger_name, train_id)
        VALUES(pname, train);
    END IF;
END $$

DELIMITER ;



DELIMITER $$

CREATE PROCEDURE apply_discount(
    IN cat VARCHAR(30),
    IN percent INT
)
BEGIN
    UPDATE product_catalog
    SET price = price - (price * (percent/100))
    WHERE category = cat;

    INSERT INTO discount_history(category, percent)
    VALUES(cat, percent);
END $$

DELIMITER ;





DELIMITER $$

CREATE PROCEDURE calculate_fd(fd INT)
BEGIN
    DECLARE p DECIMAL(10,2);
    DECLARE r DECIMAL(10,2);
    DECLARE y INT;
    DECLARE mat DECIMAL(12,2);

    SELECT principal, rate, years
    INTO p, r, y
    FROM fixed_deposit
    WHERE fd_id = fd;

    SET mat = p + (p * r * y)/100;

    INSERT INTO fd_history(fd_id, maturity_amount)
    VALUES(fd, mat);
END $$

DELIMITER ;





DELIMITER $$

CREATE FUNCTION check_status(oid INT)
RETURNS VARCHAR(30)
DETERMINISTIC
BEGIN
    DECLARE s VARCHAR(20);
    SELECT status INTO s FROM shop_orders WHERE order_id = oid;

    IF s = 'CANCELLED' THEN
        RETURN 'Order already cancelled';
    ELSE
        RETURN 'Order can be cancelled';
    END IF;
END $$

DELIMITER ;




DELIMITER $$

CREATE FUNCTION cancel_count(pid INT)
RETURNS INT
DETERMINISTIC
BEGIN
    DECLARE c INT;
    SELECT COUNT(*) INTO c
    FROM shop_orders
    WHERE product_id = pid AND status = 'CANCELLED';

    RETURN c;
END $$

DELIMITER ;




DELIMITER $$

CREATE FUNCTION get_stock_left(pid INT)
RETURNS INT
DETERMINISTIC
BEGIN
    DECLARE s INT;
    SELECT stock INTO s FROM shop_products WHERE product_id = pid;
    RETURN s;
END $$

DELIMITER ;



DELIMITER $$

CREATE FUNCTION cancelled_qty(pid INT)
RETURNS INT
DETERMINISTIC
BEGIN
    DECLARE q INT;
    SELECT SUM(qty) INTO q
    FROM shop_orders
    WHERE product_id = pid AND status = 'CANCELLED';
    RETURN COALESCE(q,0);
END $$

DELIMITER ;



DELIMITER $$

CREATE FUNCTION first_action(oid INT)
RETURNS VARCHAR(20)
DETERMINISTIC
BEGIN
    DECLARE act VARCHAR(20);

    SELECT action INTO act
    FROM order_log
    WHERE order_id = oid
    ORDER BY log_id ASC
    LIMIT 1;

    RETURN act;
END $$

DELIMITER ;



DELIMITER $$

CREATE PROCEDURE promote_students(cid INT)
BEGIN
    UPDATE student_academic
    SET semester = semester + 1
    WHERE course_id = cid AND marks >= 50;
END $$

DELIMITER ;



DELIMITER $$

CREATE PROCEDURE assign_batch()
BEGIN
    UPDATE student_academic
    SET batch = CHAR(FLOOR(RAND()*3) + 65);   -- A, B, or C
END $$

DELIMITER ;





DELIMITER $$

CREATE PROCEDURE check_in_guest(
    IN gid INT,
    IN room INT
)
BEGIN
    UPDATE rooms
    SET status = 'Occupied'
    WHERE room_no = room;

    INSERT INTO checkin_log(guest_id, room_no)
    VALUES(gid, room);
END $$

DELIMITER ;


DELIMITER $$

CREATE PROCEDURE check_reorder()
BEGIN
    INSERT INTO ReorderRequests(inventory_id, quantity_requested)
    SELECT inventory_id, (reorder_level * 2)
    FROM Inventory
    WHERE quantity < reorder_level;
END $$

DELIMITER ;









