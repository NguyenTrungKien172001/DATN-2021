create database graduation_pro_1;
use graduation_pro_1;

create table roles
(
	id varchar(255) primary key,
    name nvarchar(255)  
);


create table accounts
(
	id bigint auto_increment primary key,
    password nvarchar(255) ,
    email varchar(255) ,
    telephone varchar(13) ,
    update_at timestamp,
    role_id varchar(255) ,
    delete_at bit,
    constraint FK_accounts_roles foreign key(role_id) references roles(id)
);

create table verifycation_token
(
	id bigint auto_increment primary key,
    account_id bigint ,
    token nvarchar(255) ,
    type varchar(30) ,
    create_at timestamp ,
    expires_at timestamp ,
    cerified timestamp,
	constraint FK_verifycation_token_account foreign key(account_id) references accounts(id)
);

create table posts
(
	id bigint auto_increment primary key,
    title nvarchar(2000) ,
    content text ,
    image varchar(255) ,
    account_id bigint ,
    delete_at bit,
    constraint FK_post_account foreign key(account_id) references accounts(id)
);

create table comments
(
	id bigint auto_increment primary key,
    content nvarchar(2000) ,
    image varchar(255),
    create_at timestamp,
    post_id bigint ,
    account_id bigint ,
    delete_at bit,
    constraint FK_comments_accounts foreign key(account_id) references accounts(id),
    constraint FK_comments_posts foreign key(post_id) references posts(id)
);

 create table provinces
 (
	 id varchar(10)  primary key,
	 name varchar(255) ,
	 type varchar(30) 
 );
 
  create table districts
 (
	 id varchar(10)  primary key,
	 name nvarchar(255) ,
	 type varchar(30) ,
	 province_id varchar(10) ,
     constraint FK_districts_provinces foreign key(province_id) references provinces(id)
 );
 
 create table communes
(
	id varchar(10)  primary key,
	name nvarchar(255) ,
	type varchar(255) ,
    district_id varchar(10) ,
	constraint FK_communes_districts foreign key(district_id) references districts(id)
);


create table customer_profile
(
	id bigint auto_increment primary key,
    account_id bigint ,
    image varchar(255) ,
    fullname nvarchar(255) ,
    birthday datetime ,
    gender bit ,
    communes_id varchar(10) ,
    diachi nvarchar(500),
    telephone varchar(13) ,
    story nvarchar(1000),
    create_at timestamp,
    update_at timestamp,
    delete_at bit,
    constraint FK_customer_profile_accounts foreign key(account_id) references accounts(id),
    constraint FK_customer_profile_communes foreign key(communes_id) references communes(id)
);

create table e_wallet
(
	id bigint auto_increment primary key,
    balance double ,
    customer_id bigint ,
    constraint FK_e_wallet_customer_profile foreign key(customer_id) references customer_profile(id)
);

create table history_wallet
(
	id bigint auto_increment primary key,
    create_at timestamp ,
    wallet_id bigint ,
    description nvarchar(255) ,
    constraint FK_history_wallet_e_wallet foreign key(wallet_id) references e_wallet(id)
);

create table likes
(
	id bigint  primary key auto_increment,
	create_at timestamp ,
    post_id bigint ,
    account_id bigint ,
    constraint FK_likes_posts foreign key(post_id) references posts(id),
    constraint FK_likes_accounts foreign key(account_id) references accounts(id)
);

create table dentist_profile
(
	id bigint  primary key auto_increment,
    account_id bigint ,
	image varchar(255) ,
	cccd varchar(15) ,
	full_name nvarchar(255) ,
	birthday timestamp ,
	gender bit ,
	communes_id varchar(10) ,
    diachi nvarchar(500),
	telephone varchar(13) ,
	exp text ,
	create_at timestamp ,
	update_at timestamp,
	delete_at bit,
    constraint FK_dentist_profile_communes foreign key(communes_id) references communes(id),
    constraint FK_dentist_profile_accounts foreign key(account_id) references accounts(id)
);

 create table schedule_time
 (
	 id bigint  primary key auto_increment,
	 day_of_week  date , -- timestamp
	 start time ,
	 end time ,
     dentist_id bigint ,
	 delete_at bit,
     constraint FK_schedule_time_dentist_profile foreign key(dentist_id) references dentist_profile(id)
 );

create table booking
(
	id bigint auto_increment primary key,
    dentist_id bigint ,
    customer_id bigint ,
    booking_date timestamp ,
    description nvarchar(500) ,
    ketqua nvarchar(300),
    ghichu nvarchar(300),
    status int ,
    schedule_time_id bigint ,
    constraint FK_booking_customer_profile foreign key(customer_id) references customer_profile(id),
    constraint FK_booking_dentist_profile foreign key(dentist_id) references dentist_profile(id),
    constraint FK_booking_schedule_time foreign key(schedule_time_id) references schedule_time(id)
);


 create table voucher
 (
	 id varchar(255)  primary key,
	 content nvarchar(255) ,
	 image varchar(255) ,
	 sale double ,
	 start timestamp ,
	 end timestamp ,
	 create_at timestamp ,
	 delete_at bit
 );

create table service
(
	id bigint auto_increment primary key,
    content nvarchar(2000) ,
    image varchar(255) ,
    name nvarchar(255) ,
    price double ,
    create_at timestamp ,
    delete_at bit
);

create table booking_detail
(
	id bigint primary key auto_increment,
    booking_id bigint ,
    service_id bigint ,
    voucher_id varchar(255), -- có hoặc không
	price double ,
	constraint FK_booking_detail_service foreign key(service_id) references service(id),
	constraint FK_booking_detail_voucher foreign key(voucher_id) references voucher(id),
	constraint FK_booking_detail_booking foreign key(booking_id) references booking(id)
);




CREATE TABLE thang 
      (
		id int,
        thang Nvarchar(10)
      );
      insert into thang(id,thang)values(1,'Tháng 1');
      insert into thang(id,thang)values(2,'Tháng 2');
      insert into thang(id,thang)values(3,'Tháng 3');
      insert into thang(id,thang)values(4,'Tháng 4');
      insert into thang(id,thang)values(5,'Tháng 5');
      insert into thang(id,thang)values(6,'Tháng 6');
      insert into thang(id,thang)values(7,'Tháng 7');
      insert into thang(id,thang)values(8,'Tháng 8');
      insert into thang(id,thang)values(9,'Tháng 9');
      insert into thang(id,thang)values(10,'Tháng 10');
      insert into thang(id,thang)values(11,'Tháng 11');
      insert into thang(id,thang)values(12,'Tháng 12');
 
 
 
-- 																FUNCTION AND PROC AND VIEW



-- 	================================================================= FUNCTION ==================================================================================
-- check điều kiện đủ gửi voucher
DELIMITER $$
CREATE FUNCTION getCountBooking(id bigint) RETURNS int
    DETERMINISTIC
BEGIN
	declare tong integer;
	SELECT COUNT(bk.ID) INTO tong
    FROM BOOKING bk
	WHERE bK.CUSTOMER_ID = id and bk.status =1;
RETURN tong;
END$$
DELIMITER ;

-- get role by account id
DELIMITER $$
CREATE FUNCTION getRoelByAccount(id bigint) RETURNS nvarchar(20)
    DETERMINISTIC
BEGIN
	declare role nvarchar(20);
	select acc.role_id into role
    from accounts acc 
	WHERE acc.id = id and acc.delete_at = 0;
RETURN role;
END$$
DELIMITER ;
DELIMITER $$
CREATE  FUNCTION ROWPERROW() RETURNS int
    DETERMINISTIC
BEGIN
DECLARE n INT DEFAULT 0;
DECLARE i INT DEFAULT 0;
DECLARE id INT DEFAULT 0;
DECLARE olddate datetime ;
SELECT COUNT(p.id) FROM dentist_profile p INTO n;
select s.day_of_week from schedule_time s order by s.day_of_week desc limit 0,1 into olddate;
SET i=0;
WHILE i<n DO 
   select dp.id from dentist_profile dp LIMIT i,1 into  id;
  INSERT INTO schedule_time(day_of_week, start, end, dentist_id, delete_at)  VALUES(DATE_ADD((if(olddate < now(),now(),olddate)),INTERVAL 1 DAY),TIME('7:00:00'),TIME('9:00:00'),id,0);
  INSERT INTO schedule_time(day_of_week, start, end, dentist_id, delete_at)  VALUES(DATE_ADD((if(olddate < now(),now(),olddate)), INTERVAL 1 DAY),TIME('9:00:00'),TIME('11:00:00'),id,0);
  INSERT INTO schedule_time(day_of_week, start, end, dentist_id, delete_at)  VALUES(DATE_ADD((if(olddate < now(),now(),olddate)), INTERVAL 1 DAY),TIME('13:30:00'),TIME('15:30:00'),id,0);
  INSERT INTO schedule_time(day_of_week, start, end, dentist_id, delete_at)  VALUES(DATE_ADD((if(olddate < now(),now(),olddate)), INTERVAL 1 DAY),TIME('15:30:00'),TIME('17:30:00'),id,0);
  SET i = i + 1;
END WHILE;
return (select count(s.id) from schedule_time s order by s.day_of_week desc limit 0,1);
END$$
DELIMITER ;  

SET SQL_SAFE_UPDATES = 0;
DELIMITER $$
CREATE  FUNCTION CLEAERRECYCLE() RETURNS int
    DETERMINISTIC
BEGIN
DELETE FROM SCHEDULE_TIME s WHERE S.ID NOT IN (SELECT bk.SCHEDULE_TIME_ID FROM BOOKING bk);
return (select count(s.id) from schedule_time s );
END$$
DELIMITER ;  



-- ================================================================= ROCEDURE ==================================================================================

-- call customer theo id account
DELIMITER //
CREATE PROCEDURE callCustomerByAccount(idAccount int)
BEGIN
	SELECT *  FROM customer_profile cs
    where cs.account_id = idAccount;
END //
DELIMITER ;

-- get list account limit
DELIMITER $$
CREATE PROCEDURE getAccountLimit(a int, b int)
BEGIN
   SELECT *  FROM accounts
   limit a,b;
END $$
DELIMITER ;
drop PROCEDURE getAccountLimit;

DELIMITER //
CREATE PROCEDURE reportThang(nam int)
BEGIN
	select 
	thang,
	ifnull(tongtien,0) as tongtien
	from
	(
		select 
		th.thang,
		(select 
		sum(dt.price) as tong
		from booking_detail dt, booking bk
		where dt.booking_id = bk.id and month(bk.booking_date) = th.id and year(bk.booking_date) = nam) as tongtien
		from thang th
	) a;
END // 
DELIMITER ;


DELIMITER //
CREATE PROCEDURE exportHoaDon(bookingid int)
BEGIN
	select 
	hoten,
	sdt,
	concat(if(duong is null,'',concat(duong,',')),' ',xaa,', ',huyen,',  ',tinh) as diachi,
	ifnull(tongtien,0) tongtien,
	ifnull(bacsi,"") bacsi,
    mavoucher,
    sale
	from(
	select
	(select pr.fullname from customer_profile pr where pr.id = bk.customer_id) as hoten,
	(select pr.telephone from customer_profile pr where pr.id = bk.customer_id) as sdt,
	(select pr.diachi from customer_profile pr where pr.id = bk.customer_id) duong,
	(select cm.name from communes cm where cm.id = (select pr.communes_id from customer_profile pr where pr.id = bk.customer_id) ) as xaa,
	(select dt.name from districts dt where dt.id = (select cm.district_id from communes cm where cm.id = (select pr.communes_id from customer_profile pr where pr.id = bk.customer_id))) as huyen,
	(select pr.name from provinces pr where pr.id = (select dt.province_id from districts dt where dt.id = (select cm.district_id from communes cm where cm.id = (select pr.communes_id from customer_profile pr where pr.id = bk.customer_id)))) as tinh,
	(select sum(bkd3.price)  - (if(ifnull((select v.sale from voucher v where v.id = bkd3.voucher_id),0) <=100,(sum(bkd3.price) * ifnull((select v.sale from voucher v where v.id = bkd3.voucher_id),0) / 100) ,(select v2.sale from voucher v2 where v2.id = bkd3.voucher_id )))
    from booking bk3, booking_detail bkd3 
    where bk3.id = bkd3.booking_id and bk3.id = bk.id) as tongtien,
	(select df.full_name from dentist_profile df where df.id = bk.dentist_id) as bacsi,
    (select v.id from voucher v where v.id = (select bkd4.voucher_id from booking_detail bkd4 where bkd4.booking_id = bk.id limit 0,1)) as mavoucher,
    (select v.sale from voucher v where v.id = (select bkd4.voucher_id from booking_detail bkd4 where bkd4.booking_id = bk.id limit 0,1)) as sale
	from booking bk where bk.id = bookingid
	)  a;
END 
// 
DELIMITER ;


DELIMITER //
CREATE PROCEDURE exportHoaDon2(bookingid int)
BEGIN
	select
	content,
	ifnull(price,0) as price
	from
	(
		select
		(select sv.name from service sv where sv.id = bkd.service_id) as content,
		bkd.price as price
		from booking bk, booking_detail bkd
		where bk.id = bkd.booking_id
		and bk.id = bookingid
	) a;
END 
// 
DELIMITER ;

-- drop FUNCTION DAMBAO7NGAYTRONG;
DELIMITER $$
CREATE  FUNCTION DAMBAO7NGAYTRONG() RETURNS int
    DETERMINISTIC
BEGIN
DECLARE n INT DEFAULT 0;
DECLARE i INT DEFAULT 0;
DECLARE id INT DEFAULT 0;
DECLARE olddate datetime ;
SELECT COUNT(p.id) FROM dentist_profile p INTO n;
select s.day_of_week from schedule_time s order by s.day_of_week desc limit 0,1 into olddate;
SET i=0;
WHILE i<n DO 
   select dp.id from dentist_profile dp LIMIT i,1 into  id;
    if(select count(*) <= 0 from schedule_time s where year(s.day_of_week )=year( DATE_ADD(now(),INTERVAL 1 DAY)) and month(s.day_of_week ) = month( DATE_ADD(now(),INTERVAL 1 DAY)) and date(s.day_of_week ) = date( DATE_ADD(now(),INTERVAL 1 DAY)) and s.dentist_id = id) then
	  INSERT INTO schedule_time(day_of_week, start, end, dentist_id, delete_at)  VALUES(DATE_ADD(now(),INTERVAL 1 DAY),TIME('7:00:00'),TIME('9:00:00'),id,0);
	  INSERT INTO schedule_time(day_of_week, start, end, dentist_id, delete_at)  VALUES(DATE_ADD(now(),INTERVAL 1 DAY),TIME('9:00:00'),TIME('11:00:00'),id,0);
	  INSERT INTO schedule_time(day_of_week, start, end, dentist_id, delete_at)  VALUES(DATE_ADD(now(),INTERVAL 1 DAY),TIME('13:30:00'),TIME('15:30:00'),id,0);
	  INSERT INTO schedule_time(day_of_week, start, end, dentist_id, delete_at)  VALUES(DATE_ADD(now(),INTERVAL 1 DAY),TIME('15:30:00'),TIME('17:30:00'),id,0);
	end if;
	 if(select count(*) <= 0 from schedule_time s where year(s.day_of_week )=year( DATE_ADD(now(),INTERVAL 2 DAY)) and month(s.day_of_week ) = month( DATE_ADD(now(),INTERVAL 2 DAY)) and date(s.day_of_week ) = date( DATE_ADD(now(),INTERVAL 2 DAY)) and s.dentist_id = id) then
      INSERT INTO schedule_time(day_of_week, start, end, dentist_id, delete_at)  VALUES(DATE_ADD(now(),INTERVAL 2 DAY),TIME('7:00:00'),TIME('9:00:00'),id,0);
	  INSERT INTO schedule_time(day_of_week, start, end, dentist_id, delete_at)  VALUES(DATE_ADD(now(),INTERVAL 2 DAY),TIME('9:00:00'),TIME('11:00:00'),id,0);
	  INSERT INTO schedule_time(day_of_week, start, end, dentist_id, delete_at)  VALUES(DATE_ADD(now(),INTERVAL 2 DAY),TIME('13:30:00'),TIME('15:30:00'),id,0);
	  INSERT INTO schedule_time(day_of_week, start, end, dentist_id, delete_at)  VALUES(DATE_ADD(now(),INTERVAL 2 DAY),TIME('15:30:00'),TIME('17:30:00'),id,0);
    end if;
     if(select count(*) <= 0 from schedule_time s where year(s.day_of_week )=year( DATE_ADD(now(),INTERVAL 3 DAY)) and month(s.day_of_week ) = month( DATE_ADD(now(),INTERVAL 3 DAY)) and date(s.day_of_week ) = date( DATE_ADD(now(),INTERVAL 3 DAY)) and s.dentist_id = id) then
      INSERT INTO schedule_time(day_of_week, start, end, dentist_id, delete_at)  VALUES(DATE_ADD(now(),INTERVAL 3 DAY),TIME('7:00:00'),TIME('9:00:00'),id,0);
	  INSERT INTO schedule_time(day_of_week, start, end, dentist_id, delete_at)  VALUES(DATE_ADD(now(),INTERVAL 3 DAY),TIME('9:00:00'),TIME('11:00:00'),id,0);
	  INSERT INTO schedule_time(day_of_week, start, end, dentist_id, delete_at)  VALUES(DATE_ADD(now(),INTERVAL 3 DAY),TIME('13:30:00'),TIME('15:30:00'),id,0);
	  INSERT INTO schedule_time(day_of_week, start, end, dentist_id, delete_at)  VALUES(DATE_ADD(now(),INTERVAL 3 DAY),TIME('15:30:00'),TIME('17:30:00'),id,0);
    end if;
	if(select count(*) <= 0 from schedule_time s where year(s.day_of_week )=year( DATE_ADD(now(),INTERVAL 4 DAY)) and month(s.day_of_week ) = month( DATE_ADD(now(),INTERVAL 4 DAY)) and date(s.day_of_week ) = date( DATE_ADD(now(),INTERVAL 4 DAY)) and s.dentist_id = id) then
      INSERT INTO schedule_time(day_of_week, start, end, dentist_id, delete_at)  VALUES(DATE_ADD(now(),INTERVAL 4 DAY),TIME('7:00:00'),TIME('9:00:00'),id,0);
	  INSERT INTO schedule_time(day_of_week, start, end, dentist_id, delete_at)  VALUES(DATE_ADD(now(),INTERVAL 4 DAY),TIME('9:00:00'),TIME('11:00:00'),id,0);
	  INSERT INTO schedule_time(day_of_week, start, end, dentist_id, delete_at)  VALUES(DATE_ADD(now(),INTERVAL 4 DAY),TIME('13:30:00'),TIME('15:30:00'),id,0);
	  INSERT INTO schedule_time(day_of_week, start, end, dentist_id, delete_at)  VALUES(DATE_ADD(now(),INTERVAL 4 DAY),TIME('15:30:00'),TIME('17:30:00'),id,0);
    end if;  
     if(select count(*) <= 0 from schedule_time s where year(s.day_of_week )=year( DATE_ADD(now(),INTERVAL 5 DAY)) and month(s.day_of_week ) = month( DATE_ADD(now(),INTERVAL 5 DAY)) and date(s.day_of_week ) = date( DATE_ADD(now(),INTERVAL 5 DAY)) and s.dentist_id = id) then
      INSERT INTO schedule_time(day_of_week, start, end, dentist_id, delete_at)  VALUES(DATE_ADD(now(),INTERVAL 5 DAY),TIME('7:00:00'),TIME('9:00:00'),id,0);
	  INSERT INTO schedule_time(day_of_week, start, end, dentist_id, delete_at)  VALUES(DATE_ADD(now(),INTERVAL 5 DAY),TIME('9:00:00'),TIME('11:00:00'),id,0);
	  INSERT INTO schedule_time(day_of_week, start, end, dentist_id, delete_at)  VALUES(DATE_ADD(now(),INTERVAL 5 DAY),TIME('13:30:00'),TIME('15:30:00'),id,0);
	  INSERT INTO schedule_time(day_of_week, start, end, dentist_id, delete_at)  VALUES(DATE_ADD(now(),INTERVAL 5 DAY),TIME('15:30:00'),TIME('17:30:00'),id,0);
	end if;
     if(select count(*) <= 0 from schedule_time s where year(s.day_of_week )=year( DATE_ADD(now(),INTERVAL 6 DAY)) and month(s.day_of_week ) = month( DATE_ADD(now(),INTERVAL 6 DAY)) and date(s.day_of_week ) = date( DATE_ADD(now(),INTERVAL 6 DAY)) and s.dentist_id = id) then
      INSERT INTO schedule_time(day_of_week, start, end, dentist_id, delete_at)  VALUES(DATE_ADD(now(),INTERVAL 6 DAY),TIME('7:00:00'),TIME('9:00:00'),id,0);
	  INSERT INTO schedule_time(day_of_week, start, end, dentist_id, delete_at)  VALUES(DATE_ADD(now(),INTERVAL 6 DAY),TIME('9:00:00'),TIME('11:00:00'),id,0);
	  INSERT INTO schedule_time(day_of_week, start, end, dentist_id, delete_at)  VALUES(DATE_ADD(now(),INTERVAL 6 DAY),TIME('13:30:00'),TIME('15:30:00'),id,0);
	  INSERT INTO schedule_time(day_of_week, start, end, dentist_id, delete_at)  VALUES(DATE_ADD(now(),INTERVAL 6 DAY),TIME('15:30:00'),TIME('17:30:00'),id,0);
	end if;
     if(select count(*) <= 0 from schedule_time s where year(s.day_of_week )=year( DATE_ADD(now(),INTERVAL 7 DAY)) and month(s.day_of_week ) = month( DATE_ADD(now(),INTERVAL 7 DAY)) and date(s.day_of_week ) = date( DATE_ADD(now(),INTERVAL 7 DAY)) and s.dentist_id = id) then
      INSERT INTO schedule_time(day_of_week, start, end, dentist_id, delete_at)  VALUES(DATE_ADD(now(),INTERVAL 7 DAY),TIME('7:00:00'),TIME('9:00:00'),id,0);
	  INSERT INTO schedule_time(day_of_week, start, end, dentist_id, delete_at)  VALUES(DATE_ADD(now(),INTERVAL 7 DAY),TIME('9:00:00'),TIME('11:00:00'),id,0);
	  INSERT INTO schedule_time(day_of_week, start, end, dentist_id, delete_at)  VALUES(DATE_ADD(now(),INTERVAL 7 DAY),TIME('13:30:00'),TIME('15:30:00'),id,0);
	  INSERT INTO schedule_time(day_of_week, start, end, dentist_id, delete_at)  VALUES(DATE_ADD(now(),INTERVAL 7 DAY),TIME('15:30:00'),TIME('17:30:00'),id,0);
end if;
  SET i = i + 1;
END WHILE;
return (select count(s.id) from schedule_time s order by s.day_of_week desc limit 0,1);
END$$
DELIMITER ;  


DELIMITER ;;
CREATE  PROCEDURE reportStatus(trangthai int)
BEGIN
select fullname,concat(if(diachi is null,'',concat(diachi,',')),' ',xaa,', ',huyen,',  ',tinh) as diachi, dontrongngay from(
select cp.fullname, cp.diachi,
(select cm.name from communes cm where cm.id = (select pr.communes_id from customer_profile pr where pr.id = cp.id) ) as xaa,
(select dt.name from districts dt where dt.id = (select cm.district_id from communes cm where cm.id = (select pr.communes_id from customer_profile pr where pr.id = cp.id))) as huyen,
(select pr.name from provinces pr where pr.id = (select dt.province_id from districts dt where dt.id = (select cm.district_id from communes cm where cm.id = (select pr.communes_id from customer_profile pr where pr.id = cp.id)))) as tinh,
(select count(*) from booking bk where bk.customer_id = cp.id) as dontrongngay
from customer_profile cp where cp.id in (select bk2.customer_id from booking bk2 where bk2.status = trangthai)) as a;
End;
;;DELIMITER ; 


-- ================================================================= VIEW ==================================================================================


-- View report dentist trả về danh sách các bác sĩ - số lần đặt
CREATE OR REPLACE VIEW reportAllDentist AS 
select 
dtpf.full_name as fullname,(select count(bk.dentist_id) from booking bk where bk.dentist_id = dtpf.id) as solandat
from dentist_profile dtpf;

-- View services trả về tên dịch vụ - số lần đặt top lớn đến nhỏ
CREATE OR REPLACE VIEW CountServices AS    
select
(select sv.name from service sv where sv.id = bkd.service_id) tenDV,
 (select count(dt.service_id) from booking_detail dt where dt.service_id = bkd.service_id) as sl
from service sv, booking_detail bkd
where sv.id = bkd.service_id
group by tenDV
order by count(bkd.service_id) desc;

-- View report booking trả về số đơn hàng đã hủy, đã xác nhận, chưa xác nhận, đã xong

CREATE OR REPLACE VIEW CountBooking AS
select 
(IFNULL((select count(b.id) from booking b where b.status =1 and b.schedule_time_id = (select s.id from schedule_time s where year(s.day_of_week )=year(now()) 
																				and month(s.day_of_week ) = month(now()) 
																				and date(s.day_of_week ) = date(now())limit 0,10)),0)) as xacnhan,
(IFNULL((select count(b.id) from booking b where b.status =2 and b.schedule_time_id = (select s.id from schedule_time s where year(s.day_of_week )=year(now()) 
																				and month(s.day_of_week ) = month(now()) 
																				and date(s.day_of_week ) = date(now())limit 0,1)),0)) as daxong,
(IFNULL((select count(b.id) from booking b where b.status =3 and b.schedule_time_id = (select s.id from schedule_time s where year(s.day_of_week )=year(now()) 
																				and month(s.day_of_week ) = month(now()) 
																				and date(s.day_of_week ) = date(now())limit 0,1)),0)) as dahuy,
(IFNULL((select count(b.id) from booking b where b.status =0 and b.schedule_time_id = (select s.id from schedule_time s where year(s.day_of_week )=year(now()) 
																				and month(s.day_of_week ) = month(now()) 
																				and date(s.day_of_week ) = date(now())limit 0,1)),0)) as choxacnhan
from dual;


-- CREATE OR REPLACE VIEW CountBooking AS
-- select 
-- (select count(b.id) from booking b where b.status =1) as xacnhan,
-- (select count(b.id) from booking b where b.status =2) as daxong,
-- (select count(b.id) from booking b where b.status =3) as dahuy,
-- (select count(b.id) from booking b where b.status =0) as choxacnhan
-- from dual;
-- select * from CountBooking;

-- View report Custoemr Profile trả về danh sách khách hàng vs số lần đặt
CREATE OR REPLACE VIEW CountCustomer AS
select 
ctm.fullname,
(select count(b.customer_id) from booking b where b.customer_id = ctm.id) as solandat
from customer_profile ctm;
-- select * from CountCustomer;

-- View thống kê doanh thu theo năm
CREATE OR REPLACE VIEW reportDoanhThu AS
select DISTINCT year(bk2.booking_date) as nam,
(select 
	sum(IFNULL(tongtien,0)) as tongt
	from
		(select
		(select sum(dt.price) from booking_detail dt where dt.booking_id = bk.id) tongtien
		from booking bk
		where year(bk.booking_date)  = year(bk2.booking_date)
	) a
) as tongtien
from booking bk2
order by nam ASC;
create or replace view reportThangHoadon as
select 
t.thang,
ifnull(t.tong,0) as tong
from
(
select 
th.thang,
(select count(bk.id) as tong from booking bk where month(bk.booking_date) = th.id and year(bk.booking_date) = year(now()))  as tong
from thang th
) t;


-- ===================================================== INSERT =====================================================================

ALTER TABLE accounts AUTO_INCREMENT = 0;
ALTER TABLE booking AUTO_INCREMENT = 0;
ALTER TABLE booking_detail AUTO_INCREMENT = 0;
ALTER TABLE comments AUTO_INCREMENT = 0;
ALTER TABLE communes AUTO_INCREMENT = 0;
ALTER TABLE customer_profile AUTO_INCREMENT = 0;
ALTER TABLE dentist_profile AUTO_INCREMENT = 0;
ALTER TABLE districts AUTO_INCREMENT = 0;
ALTER TABLE likes AUTO_INCREMENT = 0;
ALTER TABLE posts AUTO_INCREMENT = 0;
ALTER TABLE provinces AUTO_INCREMENT = 0;
ALTER TABLE roles AUTO_INCREMENT = 0;
ALTER TABLE schedule_time AUTO_INCREMENT = 0;
ALTER TABLE service AUTO_INCREMENT = 0;
ALTER TABLE verifycation_token AUTO_INCREMENT = 0;
ALTER TABLE voucher AUTO_INCREMENT = 0;


insert into roles (id,name) values('ADMIN','ROLE_ADMIN');
insert into roles (id,name) values('CUSTOMER','ROLE_CUSTOMER');
insert into roles (id,name) values('DENTIST','ROLE_DENTIST');
insert into roles (id,name) values('RECEPTIONIST','ROLE_RECEPTIONIST');

-- acc
insert into accounts values (1,"$2a$10$qHS5CmD0mvdS.RQIhUka9ux13LY1n0VNHdiA.xVeTvNKDTMm2JgAy","user@gmail.com","012334555","2021-12-01","CUSTOMER",0),
(2,"$2a$10$i1chBi.Fyrz7oSL1uj2VFucbXPlfVWiIObvV.6Tb2qHBwUd0D59.O","user2@gmail.com","012334555","2021-12-01","CUSTOMER",0),
(3,"$2a$10$qHS5CmD0mvdS.RQIhUka9ux13LY1n0VNHdiA.xVeTvNKDTMm2JgAy","admin@gmail.com","012334555","2021-12-01","ADMIN",0),
(4,"$2a$10$qHS5CmD0mvdS.RQIhUka9ux13LY1n0VNHdiA.xVeTvNKDTMm2JgAy","admin1@gmail.com","012334555","2021-12-01","ADMIN",0),
(5,"$2a$10$smmze6thQ.5v5s5Waq9sNuWlsEOrB2e85tkNDyHG9kjrYxmmyXxAW","dentist@gmail.com","012334555","2021-12-01","DENTIST",0),
(6,"$2a$10$qHS5CmD0mvdS.RQIhUka9ux13LY1n0VNHdiA.xVeTvNKDTMm2JgAy","dentist1@gmail.com","012334555","2021-12-01","DENTIST",0);

insert into accounts values (7,"$2a$10$qHS5CmD0mvdS.RQIhUka9ux13LY1n0VNHdiA.xVeTvNKDTMm2JgAy","dentist3@gmail.com","012334555","2021-12-01","DENTIST",0);
insert into accounts values (8,"$2a$10$qHS5CmD0mvdS.RQIhUka9ux13LY1n0VNHdiA.xVeTvNKDTMm2JgAy","dentist4@gmail.com","012334555","2021-12-01","DENTIST",0);
insert into accounts values (9,"$2a$10$qHS5CmD0mvdS.RQIhUka9ux13LY1n0VNHdiA.xVeTvNKDTMm2JgAy","dentist5@gmail.com","012334555","2021-12-01","DENTIST",0);

-- post
insert into posts values(1,"TÌM HIỂU BỆNH SÂU RĂNG Ở TRẺ VÀ CÁCH PHÒNG TRÁNH",
"Theo nghiên cứu thì có đến 90% trẻ em gặp phải tình trạng sâu răng. Tình trạng này trở thành vấn đề đau đầu của nhiều bậc phụ huynh.
 Hãy cùng tìm hiểu về bệnh sâu răng ở trẻ để biết cách phòng tránh và bảo vệ hàm răng cho bé yêu.
 Bệnh sâu răng ở trẻ là tình trạng bề mặt răng bị tổn thương do sự tác động của thức ăn và vi khuẩn trên răng.
 Do thói quen ăn uống và vệ sinh nên nhiều trẻ gặp phải tình trạng này. 
 Những vùng có điều kiện sống thấp như miền núi, nông thôn... 
 thì tỉ lệ này cao hơn do các bậc cha mẹ không thực sự quan tâm đến sức khỏe răng miệng cho trẻ.
 Mặc dù tình trạng sâu răng khá phổ biến nhưng vẫn còn nhiều người chưa phân biệt được các triệu chứng của căn bệnh này. Một số bệnh nhân còn lầm tưởng một vài dấu hiệu của bệnh thành các biểu hiện báo hiệu mọc răng khôn. Tùy vào vị trí răng bị sâu và tình trạng mà các triệu chứng cũng có sự khác biệt. Ngoài ra, một số bệnh nhân bị sâu răng nhưng nhận thấy bất kỳ triệu chứng nào nên thường chủ quan. Chính vì thế, việc tìm hiểu về các căn bệnh răng miệng là rất cần thiết,
 nhằm phát hiện và điều trị bệnh kịp thời.
 Sử dụng kem đánh răng có chứa Fluoride để vệ sinh răng miệng sau mỗi lần ăn uống. 
 Đặc biệt, phải đánh răng ít nhất hai lần trong ngày (vào buổi tối trước khi đi ngủ và buổi sáng sau khi thức dậy). 
 Sử dụng chỉ nha khoa hoặc bàn chải đánh răng có đầu nhỏ để vệ sinh các kẽ răng. Hạn chế sử dụng tăm vì
 thông thường đầu tăm to nên rất dễ gây chảy máu chân răng."
 ,"sau-rang-856.jpg",3,0),
(2,"BỌC RĂNG SỨ CÓ TỐT KHÔNG?","Bọc răng sứ thẩm mỹ là một trong những giải pháp phục hình răng gãy rụng, 
sứt mẻ, thưa  một cách tốt nhất hiện nay. Chất liệu răng sứ có độ tương thích cao với men răng cao, 
nhanh chóng tích hợp được với răng thật, cho bạn một hàm răng mới ổn định và đảm bảo được tính thẩm mỹ. 
Nhờ vậy bạn sẽ có được nụ cười tự tin hơn trong giao tiếp hàng ngày.
Răng sứ thẩm mỹ có tốt không, có nên bọc răng sứ không... đó là băn khoăn của nhiều người khi lựa chọn dịch vụ cho mình. Trên thực tế bọc răng sứ tốt hay không còn phụ thuộc vào nhiều yếu tố. 
Theo các chuyên gia nha khoa thì bọc răng sứ là phương pháp thẩm mỹ nha khoa có nhiều ưu điểm.
Một vài tuần sau khi bọc răng, bạn nên tái khám để kiểm tra hoạt động của 
răng mới hoặc những vấn đề phát sinh nếu có. Răng sứ có tuổi thọ trung bình từ 5-15 và sau đó bạn cần thay răng sứ mới. Thời gian cụ thể là bao lâu phụ thuộc rất nhiều vào cách chăm sóc răng miệng và thói quen sinh hoạt của bạn. Bạn nên tránh những tật xấu như nghiến, mím chặt răng, nhai đá, cắn móng tay hoặc dùng răng cắn xé bao bì. Một lợi thế của bọc răng sứ là bạn không cần tuân thủ chế độ chăm sóc đặc biệt như khi niềng răng. Tuy nhiên, bọc răng sứ không có nghĩa là bạn không bị sâu răng. 
Sâu răng có thể tấn công cả răng sứ và trong trường hợp này, bạn phải bọc lại răng"
,"boc-rang-su-858.jpg",3,0),
(3,"HƯỚNG PHÁP ĐÁNH RĂNG ĐÚNG CÁCH NHƯ THẾ NÀO","Đánh răng là một bước không thể thiếu trong quy trình vệ sinh răng miệng. Đánh răng giúp loại bỏ vi khuẩn trong khoang miệng, trên các mặt của răng, hạn chế hình thành mảng bám. 
Đánh răng sẽ hạn chế sự hình thành các vấn đề răng miệng.
Đánh răng tuy đơn giản và cần thực hiện hàng ngày nhưng hầu hết mọi người vẫn đang thực hiện theo thói quen. 
Thậm chí nhiều bạn đang đánh răng sai cách gây tổn thương đến vùng nướu,
 gây hại men răng và không làm sạch răng hoàn toàn.
 Số lần đánh răng: Nhiều bạn cho rằng đánh răng càng nhiều thì càng tốt. Tuy nhiên nhận định này không đúng bởi đánh răng quá mức có thể ảnh hưởng đến men răng. Đánh răng ngày 2 lần là lí tưởng và nên thực hiện trước khi đi ngủ và sau khi thức dậy. Tuy nhiên, bạn có thể đánh răng 
 nhiều hơn nếu vào ngày đó bạn ăn quá nhiều đồ ngọt hoặc những thực phẩm gây hôi miệng.Thời điểm đánh răng: 
 Để bảo vệ răng, bạn nên đánh răng sau khi ăn uống ít nhất 30 phút. Nếu đánh răng ngay sau khi ăn, các axit trong răng vẫn còn khả năng tác động đến men răng gây hỏng men răng.
Thời gian đánh răng: Đánh răng quá nhanh hoặc quá chậm cũng không tốt. Thời gian lí tưởng cho một lần đánh răng là 3 phút đối với bàn chải thông 
thường và ngăn hơn với bàn chải điện."
 ,"danh-rang-dung-cach-859.jpg",2,0);
insert into posts values(4,"NGUYÊN NHÂN, TÁC TẠI VÀ CÁCH XỬ LÝ CAO RĂNG HIỆU QUẢ",
"Trước đây, cao răng thường được “xử lý” bằng các dụng cụ cầm tay, nên thường phải sử dụng lực 
tác động mạnh mới có thể làm sạch. Bởi vậy, quá trình lấy cao răng thường gây ra chảy máu chân răng,
 gây tác động xấu đến răng, đến nướu. Tuy nhiên hiện nay tại các nha khoa lớn, chất lượng, 
 thường sử dụng công nghệ lấy cao răng bằng máy siêu âm. Đây là công nghệ dùng lực rung từ đầu máy, 
 tác động vào những mảng bám trên răng,
 nhằm bóc tách hoàn toàn chúng ra khỏi vùng răng và nướu. Để hạn chế cao răng, 
 có thể sử dụng đến một số công thức từ dầu ô liu, dầu dừa hay baking soda. 
 Tuy nhiên, để có thể loại bỏ cao răng một cách triệt để, cần tới sự trợ 
 giúp của các nha sĩ bằng các dụng cụ nha khoa chuyên dụng.Không sử dụng chỉ nha khoa để làm sạch tất cả những vụn thức ăn còn sót lại trong các kẽ răng. 
 Những vụn thức ăn này không thể loại bỏ được 100% bằng chải răng thông thường.Chế độ ăn uống nhiều đường, đồ ngọt khiến các mảng bám hình thành nhanh hơn,
 là môi trường thuận lợi để vi khuẩn hoạt động và phát triển.Để hạn chế cao răng, 
 có thể sử dụng đến một số công thức từ dầu ô liu, dầu dừa hay baking soda. 
 Tuy nhiên, để có thể loại bỏ cao răng một cách triệt để, cần tới sự trợ giúp của các nha sĩ bằng các dụng cụ nha khoa chuyên dụng.
Trước đây, cao răng thường được “xử lý” bằng các dụng cụ cầm tay, nên thường phải sử dụng lực tác động mạnh mới có thể làm sạch. Bởi vậy, quá trình lấy cao răng thường gây ra chảy máu chân răng,
 gây tác động xấu đến răng, đến nướu."
 ,"xu-ly-cao-rang-904.jpg",3,0);
 insert into posts values(5,"NIỀNG RĂNG NÊN ĂN GÌ VÀ KIÊNG GÌ ?",
"Một trong những thực phẩm bạn nên quan tâm niềng răng nên ăn gì đó là bạn nên ăn cháo, súp, 
cơm mềm bởi những thức ăn này chứa tinh bột, lỏng vừa đủ để bạn không phải dùng đến áp lực nhai quá nhiều, 
việc không phải nhai nhiều sẽ ít tác động đến mắc cài làm cho mắc cài được độ ổn định trên cung hàm.
Ăn những thực phẩm làm từ sữa, trứng khi niềng răng những thực phẩm này cung cấp đầy đủ chất protein, 
vitamin , canxi và các khoáng chất cần thiết cho cơ thể. N
goài ra hai loại thức ăn này sẽ phẩm này có nhiều ưu điểm không phải nhau quá nhiều, đặc biệt là sữa.
Các thực phẩm nên được chế biến từ sữa như: phô mai, bơ mềm các loại bánh và sữa, sữa chua…
Các món ăn làm từ trứng, các loại bánh mỳ, bánh ngọt xốp mềm không rắc hạt
Ngũ cốc, các loại mì, cơm nấu chín mềm
Thịt được chế biến cẩn thận, mềm, nhỏ: thịt băm viên, thịt hầm, thịt gia cầm và hải sản
Rau quả, các món luộc, hấp, đậu phụ, các món nghiền như khoai tây…
Trái cây: táo, chuối, nước ép trái cây, sinh tố, hoa quả
Có thể dùng thêm các loại kem, sữa, chocolate, các loại bánh như brownies, cookies mềm.
Quan tâm tới chế độ ăn uống khoa học, hợp lý sau niềng răng nha khoa có ý nghĩa vô cùng quan
 trọng trong suốt quá trình chỉnh nha để có hàm răng đều đặn hoàn hảo. 
 Mọi hoạt động ăn nhai của hàm răng sẽ chậm lại, không linh hoạt như trước, ngay từ việc nhai,
 cắn xé thức ăn. Chính vì thế, nếu không chú ý tới việc ăn uống sẽ dễ bị bung bật mắc cài, 
hoặc làm biến dạng khay niềng."
,"an-kieng-908.jpg",4,0);
 insert into posts values(6,"NIỀNG RĂNG GIÁ BAO NHIÊU?",
"Hiện nay, có 3 phương pháp chính để cải thiện tình trạng răng hô, vẩu, móm, lệch lạc...  
mỗi phương pháp sẽ có  giá niềng răng khác nhau. 
 Khi đến nha khoa các bác sĩ thăm khám chụp Xquang xem xét tình trạng cụ thể của từng người, 
 dựa vào đó sẽ đưa ra phương pháp điều trị phù hợp nhất. 
Niềng răng hết bao nhiêu tiền? Đây chắc hẳn là quan tâm của rất nhiều khách hàng trước
 khi đưa ra quyết định lựa chọn dịch vụ cho mình. Trên thực tế niềng răng bao nhiêu tiền 
 còn phụ thuộc vào nhiều yếu tố, 
đó là phương pháp chỉnh nha, địa chỉ nha khoa....
– Ốc Nông Rộng cố định – Hàm trên	5.000.000 / hàm
– Ốc Nông Rộng cố định – Hàm dưới	5.000.000 / hàm
– Ốc nông rộng tháo lắp – Hàm trên	8.000.000 / hàm
– Ốc nông rộng tháo lắp – Hàm dưới	8.000.000 / hàm
Minivis thường	2.000.000 / vis
Minivis gò má/ Vis góc hàm	4.000.000 / vis
– Mắc cài Inox thường	30.000.000 / 2 hàm
– Mắc cài Inox tự đóng 	36.000.000 / 2 hàm
– Mắc cài sứ thường 	38.000.000 / 2 hàm
– Mắc cài sứ tự đóng 	49.000.000 / 2 hàm
– Mắc cài pha lê	40.000.000 / 2 hàm
– Invisalign – Đơn giản	120.000.000đ
– Invisalign – Trung bình	150.000.000đ
– Invisalign – Phức tạp	180.000.000đ
– Mắc Cài Mặt Trong 2D	80.000.000 – 100.000.000
– Mắc Cài Mặt Trong 3D	120.000.000 – 140.000.000
– Niềng răng 3D Clear – Dưới 6 tháng	8.000.000 / 1 hàm","592ee851-86a1-4164-870d-e95d1fc095fd.jpg",4,0);
 insert into posts values(7,"5 MẸO LÀM TRẮNG RĂNG TẠI NHÀ GIÚP BẠN THOẢI MÁI LỰA CHỌN",
"Đừng nghĩ vỏ chuối vô dụng bởi nó lại là thứ làm trắng răng hiệu quả tốt. Để thực hiện, bạn chỉ cần lấy vỏ chuối mới bóc vỏ và chà nhẹ lên răng trong vòng 2 phút. Sau đó dùng nước muối súc miệng thật sạch. Duy trì cách này 2 lần/ngày trong khoảng 2 tháng bạn sẽ thấy điều bất ngờ trên hàm răng. Ngoài khả năng làm trắng, 
nhiều người sử dụng cho biết cách này còn giúp răng bóng và đều màu hơn.Nhìn chung, các mẹ làm trắng răng tại nhà dễ thực hiện, chi phí thấp nên được khá nhiều người lựa chọn. Tuy nhiên, để có kết quả như ý thì yêu cầu phải có tính kiên trì và thực hiện trong thời gian dài. 
Đôi khi với những trường hợp có men răng khó thay đổi thì các phương pháp tự nhiên như trên ít có hiệu quả.
Súc miệng bằng tinh chất dầu dừa vào buổi sáng là thói quen tốt mà bạn nên duy trì. Sau khi súc miệng hãy lấy khăn mềm chà sát lên răng để giúp răng trắng sáng và bóng đẹp hơn. Đây là một trong những cách làm trắng răng tại nhà đơn giản, tiết kiệm mà bất cứ ai cũng có thể làm được ngay tại nhà. 
Hãy thử và cảm nhận bất ngờ với hàm răng trắng sáng nhé.
Nhìn chung, các mẹ làm trắng răng tại nhà dễ thực hiện, chi phí thấp nên được khá nhiều người lựa chọn. Tuy nhiên, để có kết quả như ý thì yêu cầu phải có tính kiên trì và thực hiện trong thời gian dài. Đôi khi với những trường hợp có men răng khó
 thay đổi thì các phương pháp tự nhiên như trên ít có hiệu quả.
 Baking soda và chanh là những nguyên liệu quen thuộc trong làm đẹp. Ngoài các tác dụng làm đẹp thông thường dưỡng da, dưỡng tóc... thì nó còn có khả năng làm trắng răng tương đối tốt. Sự kết hợp giữa Baking soda và chanh có khả năng loại bỏ các vết xỉn màu trên bề mặt răng, giảm nồng độ axit và giúp răng trắng sáng hơn. Để thực hiện, các bạn chỉ cần dùng một ít banking để lên bàn chải, 
 vắt chanh lên rồi đánh răng như bình thường. Hãy thử và cảm nhận hiệu quả nhé.","27ec0474-33c7-4207-95d5-ba1245924eb5.jpg",4,0);

-- likes
insert into likes values(1,"2021-09-24",1,1),
(2,"2021-09-24",1,2),
(3,"2021-09-24",2,1),
(4,"2021-09-24",2,2);
-- comment
insert into comments values(1,'hay lắm pro',null,'2021-12-01',1,1,0),
(2,null,null,'2021-12-01',1,2,0),
(3,'viết gì vậy',null,'2021-12-01',2,2,0),
(4,'hay lắm pro vip vip',null,'2021-12-01',2,1,0),
(5,'răng của tôi',null,'2021-12-01',3,1,0);

-- provinces
insert into provinces values("HN","Ha Noi","TP"),
("HCM","Ho Chi Minh","TP");

-- districts
insert into districts values("TT","Thach That","H","HN"),
("QO","Quoc Oai","H","HN"),
("GV","Go Vap","Q","HCM"),
("Q1","Quan 1","Q","HCM");

-- communes
insert into communes values("TX","Thach Xa","X","TT"),
("CK","Can Kiem","X","TT"),
("X1","Xa 1","X","QO"),
("X2","Xa 2","X","QO"),
("G1","Go 1","X","GV"),
("G2","Go 2","X","GV");

-- customer-profile
insert into customer_profile values(1,1,"9d524ccd-055c-4648-a16c-55c1217f1eb7.jpg","user name","2001-07-01",0,"TX",'102','0123456789',"No Story","2021-09-25","2021-09-25",0),
(2,2,"278ccc4b-34e4-4fc4-9724-c38a579f7386.jpg","user2 name","2001-12-01",1,"G2",'102','0123456789',"No Story","2021-09-25","2021-09-25",0);

-- dentist_profile
insert into dentist_profile values(1,5,"9d524ccd-055c-4648-a16c-55c1217f1eb7.jpg","001201030404","Hoàng Khoa","1989-01-12",1,"CK",'102','0123456789',
"Tốt nghiệp Bác sĩ Chuyên khoa Răng Hàm Mặt, Trường Đại học Y Hà Nội.
 Bác sĩ thường xuyên tham gia các hội thảo về răng hàm mặt và chỉnh nha từ Invisalign, 3M,...cập nhật kiến thức, kỹ thuật tiên tiến nhất trong lĩnh vực chuyên môn.","2021-09-25","2021-09-25",0),
(2,6,"d0d7f0e1-5b7d-4ca8-a388-24577ed5eeab.jpg","001201030404","Văn Hiếu","1987-02-20",0,"X2",'102','0123456789'
,"Tốt nghiệp Bác sĩ Chuyên khoa Răng Hàm Mặt, Đại học Y Hà Nội
Tốt nghiệp Bác sĩ Đa khoa, Học viện Quân y
Chứng chỉ Bác sĩ Chỉnh nha máng trong suốt Invisalign của Hoa Kì
Chứng chỉ Bác sĩ chỉnh nha của Viện đào tạo Răng Hàm Mặt","2021-09-25","2021-09-25",0);

insert into dentist_profile values(3,7,"278ccc4b-34e4-4fc4-9724-c38a579f7386.jpg","001201030404","Thành Chung",
"1990-05-05",0,"X2",'102','0123456789',
"Tốt nghiệp khóa Phẫu thuật nha chu, Trung tâm Giovani, Bologna, Ý (2019)
Tốt nghiệp khóa Cấy ghép Implant tại Brazil (2018)
Tốt nghiệp Bác sĩ Nội trú Răng Hàm Mặt, Bệnh viện Đại học Y Hà Nội (2019)","2021-09-25","2021-09-25",0);
insert into dentist_profile values(4,8,"ff7f0800-754f-4071-865d-32107660cec5.jpg","001201030404","Ngọc Mai","1993-11-11",0,"X2",'102','0123456789',
"Chứng chỉ Bác sĩ chỉnh nha chuyên sâu POS của Hoa Kỳ (2018)
Chứng chỉ Veneer nâng cao, Hội Răng Hàm Mặt Việt Nam (2018)
Chứng chỉ Thẩm mỹ Nha khoa toàn hàm (2018)
Chứng chỉ SSD Module I - Smile Design khớp cắn chuyên sâu (2017)","2021-09-25","2021-09-25",0);
insert into dentist_profile values(5,9,"bdbc3099-c5c1-404e-8106-ba777cb3ee1d.png","001201030404","Phương Anh","1996-12-11",0,"X2",'102','0123456789',
"Tốt nghiệp Tiến sĩ Y khoa Răng Hàm Mặt, Đại học y Hà Nội (2015)
Tốt nghiệp Bác sĩ Chuyên khoa II, Đại học y Hà Nội (2015)
Nghiên cứu sinh tại Hoa Kỳ (2017-2018)
Tốt nghiệp hệ sau đại học Răng Hàm Mặt Cộng Hòa Tiệp Khắc, Czechoslovakia (2019-2020)
Tốt nghiệp Bác sĩ Chuyên khoa I, Đại học Y Hà Nội (2021)
Tốt nghiệp Bác sĩ Răng Hàm Mặt, Đại học Y Hà Nội (2021)","2021-09-25","2021-09-25",0);

-- schedule_time
insert into schedule_time values(1,"2021-12-29","07:00:00","9:00:00",1,0),
(2,"2021-12-29","09:30:00","11:30:00",1,0),
(3,"2021-12-28","14:00:00","16:00:00",1,0),
(4,"2021-12-28","16:30:00","18:30:00",1,0),
(5,"2021-12-27","07:00:00","9:00:00",2,0),
(6,"2021-12-27","09:30:00","11:30:00",2,0),
(7,"2021-12-26","14:00:00","16:00:00",3,0),
(8,"2021-12-25","16:30:00","18:30:00",3,0),
(9,"2021-12-25","16:30:00","18:30:00",4,0),
(10,"2021-12-25","16:30:00","18:30:00",4,0),
(11,"2021-12-25","12:30:00","14:30:00",5,0),
(12,"2021-12-25","19:30:00","21:30:00",5,0),
(13,"2022-01-01","19:30:00","21:30:00",1,0),
(14,"2022-01-02","19:30:00","21:30:00",1,0),
(15,"2022-01-03","19:30:00","21:30:00",1,0),
(16,"2022-01-04","19:30:00","21:30:00",1,0),
(17,"2022-01-05","19:30:00","21:30:00",1,0),
(18,"2022-01-06","19:30:00","21:30:00",1,0),
(19,"2022-01-07","19:30:00","21:30:00",1,0),
(20,"2022-01-08","19:30:00","21:30:00",2,0);

-- -- -- INSERT INTO schedule_time(day_of_week, start, end, dentist_id, delete_at)  VALUES(now(),TIME('7:00:00'),TIME('9:00:00'),1,0);
-- -- -- INSERT INTO schedule_time(day_of_week, start, end, dentist_id, delete_at)  VALUES(now(),TIME('7:00:01'),TIME('9:00:01'),2,0);
-- -- -- INSERT INTO schedule_time(day_of_week, start, end, dentist_id, delete_at)  VALUES(now(),TIME('7:00:02'),TIME('9:00:02'),3,0);
-- -- -- INSERT INTO schedule_time(day_of_week, start, end, dentist_id, delete_at)  VALUES(now(),TIME('7:00:03'),TIME('9:00:03'),4,0);
-- -- -- INSERT INTO schedule_time(day_of_week, start, end, dentist_id, delete_at)  VALUES(now(),TIME('7:00:04'),TIME('9:00:04'),5,0);
-- -- -- INSERT INTO schedule_time(day_of_week, start, end, dentist_id, delete_at)  VALUES(now(),TIME('7:00:05'),TIME('9:00:05'),1,0);
-- -- -- INSERT INTO schedule_time(day_of_week, start, end, dentist_id, delete_at)  VALUES(now(),TIME('7:00:06'),TIME('9:00:06'),2,0);
-- -- -- INSERT INTO schedule_time(day_of_week, start, end, dentist_id, delete_at)  VALUES(now(),TIME('7:00:07'),TIME('9:00:07'),3,0);






-- service
insert into service values(1,"Răng sứ Cercon là sứ không kim loại có lớp sườn phía bên trong là 
Zirconia và lớp sứ bên ngoài là Cercon kiss. Cercon là một khoáng sản quý được nghiên cứu và sử 
dụng rất rộng rãi trong ngành hàng không, cũng như vụ trụ, ngành công nghiệp trang sức, 
và hiện nay được sử dụng rất phổ biến trong nha khoa, để chế tạo ra những chiếc răng sứ hoàn hảo. 
Bởi răng toàn sứ Cercon có độ cứng, có thể uốn cong, độ quang học rất tốt
 cũng như màu sắc cho những chiếc răng đẹp tự nhiên như răng thật của người sử dụng.",
"rang-su-928.jpg","RĂNG SỨ CERON",3000000,"2021-09-25",0),
(2,"Tẩy trắng răng là một dịch vụ trong nha khoa sử dụng các hóa chất chuyên dụng cùng năng lượng ánh sáng tác động đến bề mặt ngoài của răng từ đó tạo ra các phản ứng oxy hóa cắt đứt các nối đôi tạo màu trong răng. 
Từ đó loại bỏ lớp xỉn màu bên ngoài răng và lấy lại vẻ trắng bóng cho hàm răng thẩm mỹ."
,"cfa6e85e-4ade-4208-8aa3-beb2112c0e35.png","TẨY TRẮNG RĂNG",500000,"2021-09-25",0),
(3,"Mắc cài sứ được gắn ở mặt trước của răng như mắc cài kim loại truyền thống.
 Nhưng so với niềng răng mắc cài kim loại thường thì chỉnh nha bằng mắc cài sứ người ở xa khó phát hiện ra 
 bạn đang niềng răng. Vì vậy khi chỉnh nha niềng răng bằng mắc cài sứ bạn sẽ không cảm thấy ngại ngùng, 
tự tin hơn trong giao tiếp cũng như công việc hàng ngày.
Có 2 loại niềng răng mắc cài sứ đó là niềng răng mắc cài sứ thường và niềng răng mắc cài sứ tự buộc.","592ee851-86a1-4164-870d-e95d1fc095fd.jpg","NIỀNG RĂNG MẮC CÀI SỨ ",2000000,"2021-09-25",0),
(4,"Cấy ghép Implant là một trong những phương pháp trồng răng giả rất được ưa chuộng hiện nay. Mặc dù chỉ là phục hình răng nhân tạo nhưng đây lại là một kỹ thuật hoàn hảo bởi nó giúp bạn sở hữu răng giả không khác gì cấu trúc răng sinh lý bình thường. Cả thân và chân răng đều được tái tạo một cách vô cùng bền chắc, 
giúp bệnh nhân có thể ăn nhai bình thường mà không gặp bất cứ trở ngại nào."
,"cay-ghep-impl-935.jpg","CẤY GHÉP IMPLANT",7000000,"2021-09-25",0),
(5,"Đính đá vào răng là phương pháp thẩm mỹ nha khoa đang “sốt xình xịch” 
trên khắp thế giới nói chung và tại Việt Nam nói riêng. Bằng những viên đá, 
kim cương hoặc những vật liệu quý hơn nữa các nha sỹ sẽ tiến hành gắn lên răng của bạn,giúp tăng sức quyến rũ,
 sự thu hút cho hàm răng, đem lại nụ cười tỏa sáng và hơn thế nữa nếu vật kiệu bằng đá quý,
 kim cương còn để những người yêu cái đẹp ngầm khoe “đẳng cấp” của mình.","dinh-da-936.jpg","ĐÍNH ĐÁ VÀO RĂNG",9000000,"2021-09-25",0),
(6,"Mặt răng sứ Veneer hiện là phương pháp thẩm mỹ răng được nhiều khách hàng lựa chọn bởi nhiều ưu điểm vượt trội. Mặt dán sứ được thiết kế đặc biệt bởi chất liệu sứ cao cấp đảm siêu cứng, siêu mỏng và siêu kháng khuẩn với bề mặt Nano tốt nhất. Với những ưu điểm vượt trội nên Veneer giúp bạn nhanh chóng có được hàm răng đều, đẹp, 
trắng sáng và hạn chế quá trình mài chỉnh đến răng thật.","rang-su-veneer-937.jpg","RĂNG SỨ VENEER",5000000,"2021-09-25",0),
(7,"Cao răng được hiểu một cách đơn giản là những mảng bám của thức ăn trên cổ răng, nướu răng… tích tụ lâu ngày mà thành. Các mảng bám này nếu để lâu ngày sẽ bám dính rất chắc vào răng, là môi trường thuận lợi để các vi khuẩn tích tụ, khiến cho tình trạng răng trở nên ố vàng, xỉn màu, lâu dần có thể gây viêm nhiễm và gây ra các bệnh lý răng miệng nguy hiểm. 
Các nha sĩ đã chỉ ra rằng, trong cao răng tồn tại và ẩn chứa tới hơn 500 loại vi khuẩn khác nhau.","27ec0474-33c7-4207-95d5-ba1245924eb5.jpg","LẤY CAO RĂNG",500000,"2021-09-25",0),
(8,"Trám răng thẩm mỹ là một trong những phương pháp nha khoa phục hình răng khá phổ biến hiện nay nhằm khôi phục lại chức năng ăn nhai và vẻ bề ngoài của những chiếc răng bị sâu, mẻ hay bị vỡ về trạng thái ban đầu như những chiếc răng tự nhiên. 
Tùy thuộc vào tình trạng răng của bạn mà bác sĩ sẽ đưa ra phương pháp trám răng thích hợp.","tram-rang-831.jpg","TRÁM RĂNG THẨM MỸ",400000,"2021-09-25",0),
(9,"Bản thân răng 8 đã tiềm ẩn rất nhiều nguy cơ bệnh lý bởi nó nằm ở vị trí trong cùng, rất khó để vệ sinh sạch sẽ như các răng bên ngoài. Thức ăn hàng ngày giắt vào răng không được loại bỏ sẽ hình thành các mảng bám, thuận lợi cho các loại vi khuẩn có hại hoạt động và gây ra hiện tượng sâu răng.
Răng 8 bị sâu nên nhổ càng sớm càng tốt để nhanh chóng loại bỏ những nguy hại tiềm","9b6c5ec1-2d30-4298-8971-43bb1d606b75.jpg","NHỔ RĂNG SỐ 8",2000000,"2021-09-25",0);

-- voucher
insert into voucher values
(1,"Giam gia 10","img.img",10,"2021-12-03","2021-12-30","2021-08-15",0),
(2,"Giam gia 20","img.img",20,"2021-12-03","2021-12-30","2021-08-15",0),
(3,"Giam gia 30","img.img",30,"2021-12-03","2021-12-30","2021-08-15",0),
(4,"Giam gia 20","img.img",20,"2021-12-03","2021-12-30","2021-08-15",0),
(5,"Giam gia 20","img.img",20,"2021-12-03","2021-12-30","2021-08-15",0),
(6,"Giam gia 20","img.img",20,"2021-12-03","2021-12-30","2021-08-15",0),
(7,"Giam gia 20","img.img",20,"2021-12-03","2021-12-30","2021-08-15",0),
(8,"Giam gia 20","img.img",20,"2021-12-03","2021-12-30","2021-08-15",0),
(9,"Giam gia 20","img.img",20,"2021-12-03","2021-12-30","2021-08-15",0),
(10,"Giam gia 20","img.img",20,"2021-12-03","2021-12-30","2021-08-15",0)
;


-- booking
 insert into booking values(1,1,1,"2021-09-25","combodichvu",null,null,0,1),
 (2,1,2,"2021-09-25","combodichvu",null,null,0,2);

insert into booking values(4,3,2,"2021-09-25","combodichvu",null,null,0,7);
insert into booking values(5,4,2,"2021-09-25","combodichvu",null,null,0,9);

-- -- booking detail
 insert into booking_detail values(1,1,1,null,2900000),
 (2,1,2,null,500000),
 (3,1,4,null,90000),
 (4,2,1,null,2100000),
 (5,2,3,null,2000000);


select 'TẠO SCHEMAS HOÀN TẤT' as SUCCESSFULLY from dual