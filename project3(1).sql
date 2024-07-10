create database pro;
show databases;
use pro;
show variables like'secure_file_priv';
create table users( user_id int,created_at varchar(100),company_id int,
language varchar(70),activated_at varchar(100),state varchar(60));

load data infile "C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/users.csv"
INTO TABLE users
FIELDS TERMINATED BY ',' 
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS;

select * from users;
alter table users add column temp_created_at datetime;
update users set temp_created_at = str_to_date(created_at,'%d-%m-%Y %H:%i:%s');
alter table users drop column created_at;
alter table users change column temp_created_at created_at datetime;

create table events_tbl(user_id int,occurred_at varchar(100),event_type varchar(100),
event_name varchar(100),location varchar(90),device varchar(100),user_type int);
show variables like'secure_file_priv';

load data infile "C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/events.csv"
INTO TABLE events_tbl
FIELDS TERMINATED BY ',' 
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS;
desc events_tbl;
select * from events_tbl;
alter table events_tbl add column temp_occurred_at datetime;
update events_tbl set temp_occurred_at = str_to_date(occurred_at,'%d-%m-%Y %H:%i');

alter table events_tbl drop column occurred_at;
alter table events_tbl change column temp_occurred_at occurred_at datetime;

create table email_events(user_id int,occurred_at varchar(100),action varchar(100),
user_type int);

load data infile "C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/email_events.csv"
INTO TABLE email_events
FIELDS TERMINATED BY ',' 
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS;
show variables like'secure_file_priv';
select * from email_events;
alter table email_events add column temp_occurred_at datetime;
update email_events set temp_occurred_at = str_to_date(occurred_at,'%d-%m-%Y %H:%i');
alter table email_events drop column occurred_at;
alter table email_events change column temp_occurred_at occurred_at datetime;

#Task1(calculate the weekly user engagement)
select extract(week from occurred_at) as Week_numbers, count(distinct user_id)
 as Active_user 
from events_tbl 
where event_type='engagement'
group by 1
order by 1; 

select week(occurred_at) as Week_numbers,count(user_id) as Users 
from events_tbl where event_type='engagement' group by 1 order by 1;


#Task2(calculate the user growth for the product)
with cte as (select Month(created_at) as Month,count(user_id) as Users
from users group by 1) select Month ,Users,round((Users/lag(Users,1)
 over(order by Month)-1)*100,2) as Growth_Percent from cte;

#Task3(calculate the weekly retention of users based on their sign-up cohort)
SELECT 
    occurred_at,
    WEEK(occurred_at) AS Week_number
FROM 
    events_tbl;


Select first as "Week Numbers",
sum(case when week_number=0 then 1 else 0 end) as "Week 0",
sum(case when week_number=1 then 1 else 0 end) as "Week 1",
sum(case when week_number=2 then 1 else 0 end) as "Week 2",
sum(case when week_number=3 then 1 else 0 end) as "Week 3",
sum(case when week_number=4 then 1 else 0 end) as "Week 4",
sum(case when week_number=5 then 1 else 0 end) as "Week 5",
sum(case when week_number=6 then 1 else 0 end) as "Week 6",
sum(case when week_number=7 then 1 else 0 end) as "Week 7",
sum(case when week_number=8 then 1 else 0 end) as "Week 8",
sum(case when week_number=9 then 1 else 0 end) as "Week 9",
sum(case when week_number=10 then 1 else 0 end) as "Week 10",
sum(case when week_number=11 then 1 else 0 end) as "Week 11", 
sum(case when week_number=12 then 1 else 0 end) as "Week 12",
sum(case when week_number=13 then 1 else 0 end) as "Week 13",
sum(case when week_number=14 then 1 else 0 end) as "Week 14",
sum(case when week_number=15 then 1 else 0 end) as "Week 15",
sum(case when week_number=16 then 1 else 0 end) as "Week 16",
sum(case when week_number=17 then 1 else 0 end) as "Week 17",
sum(case when week_number=18 then 1 else 0 end) as "Week 18",
sum(case when week_number=19 then 1 else 0 end) as "Week 19",
#-calculate retention rates for each week
(sum(case when week_number=1 then 1 else 0 end)/sum(case when week_number=0 then 1 else 0 end))
*100 as Retention_Rate_Week_1,
(sum(case when week_number=2 then 1 else 0 end)/sum(case when week_number=1 then 1 else 0 end))
*100 as Retention_Rate_Week_2,
(sum(case when week_number=3 then 1 else 0 end)/sum(case when week_number=2 then 1 else 0 end))
*100 as Retention_Rate_Week_3,
(sum(case when week_number=4 then 1 else 0 end)/sum(case when week_number=3 then 1 else 0 end))
*100 as Retention_Rate_Week_4,
(sum(case when week_number=5 then 1 else 0 end)/sum(case when week_number=4 then 1 else 0 end))
*100 as Retention_Rate_Week_5,
(sum(case when week_number=6 then 1 else 0 end)/sum(case when week_number=5 then 1 else 0 end))
*100 as Retention_Rate_Week_6,
(sum(case when week_number=7 then 1 else 0 end)/sum(case when week_number=6 then 1 else 0 end))
*100 as Retention_Rate_Week_7,
(sum(case when week_number=8 then 1 else 0 end)/sum(case when week_number=7 then 1 else 0 end))
*100 as Retention_Rate_Week_8,
(sum(case when week_number=9 then 1 else 0 end)/sum(case when week_number=8 then 1 else 0 end))
*100 as Retention_Rate_Week_9,
(sum(case when week_number=10 then 1 else 0 end)/sum(case when week_number=9 then 1 else 0 end))
*100 as Retention_Rate_Week_10,
(sum(case when week_number=11 then 1 else 0 end)/sum(case when week_number=10 then 1 else 0 end))
*100 as Retention_Rate_Week_11,
(sum(case when week_number=12 then 1 else 0 end)/sum(case when week_number=11 then 1 else 0 end))
*100 as Retention_Rate_Week_12,
(sum(case when week_number=13 then 1 else 0 end)/sum(case when week_number=12 then 1 else 0 end))
*100 as Retention_Rate_Week13,
(sum(case when week_number=14 then 1 else 0 end)/sum(case when week_number=13 then 1 else 0 end))
*100 as Retention_Rate_Week14,
(sum(case when week_number=15 then 1 else 0 end)/sum(case when week_number=14 then 1 else 0 end))
*100 as Retention_Rate_Week15,
(sum(case when week_number=16 then 1 else 0 end)/sum(case when week_number=15 then 1 else 0 end))
*100 as Retention_Rate_Week16,
(sum(case when week_number=17 then 1 else 0 end)/sum(case when week_number=16 then 1 else 0 end))
*100 as Retention_Rate_Week17,
(sum(case when week_number=18 then 1 else 0 end)/sum(case when week_number=17 then 1 else 0 end))
*100 as Retention_Rate_Week18,
(sum(case when week_number=19 then 1 else 0 end)/sum(case when week_number=18 then 1 else 0 end))
*100 as Retention_Rate_Week19
from  (SELECT a.user_id,a.login_week,b.first_week as
first_week,a.login_week-first_week as week_number FROM (SELECT
user_id,week(occurred_at) AS login_week FROM events GROUP BY
user_id,week(occurred_at)) a,(SELECT user_id, min(week(occurred_at)) AS first_week
FROM events GROUP BY user_id) b where a.user_id=b.user_id) as with_week_number
group by first_week order by first_week;


#Tas4 (calculate the weekly engagement per device)
select extract(week from occurred_at) as "Week Numbers",
count(distinct case when device in('dell inspiron notebook') then user_id else null end ) 
as "Dell Inspiron Notebook",
count(distinct case when device in('iphone 5') then user_id else null end ) 
as "Iphone 5",
count(distinct case when device in('iphone 4s') then user_id else null end ) 
as "Iphone 4s",
count(distinct case when device in('windows surface') then user_id else null end ) 
as "Windows Surface",
count(distinct case when device in('macbook air') then user_id else null end ) 
as "Macbook Air",
count(distinct case when device in('iphone 5s') then user_id else null end ) 
as "Iphone 5s",
count(distinct case when device in('macbook pro') then user_id else null end ) 
as "Macbook Pro",
count(distinct case when device in('kindle fire') then user_id else null end ) 
as "Kindle Fire",
count(distinct case when device in('ipad mini') then user_id else null end ) 
as "Ipad Mini",
count(distinct case when device in('nexus 7') then user_id else null end ) 
as "Nexus 7",
count(distinct case when device in('nexus 5') then user_id else null end ) 
as "Nexus 5",
count(distinct case when device in('samsung galaxy s4') then user_id else null end ) 
as "Samsung Galaxy S4",
count(distinct case when device in('lenovo thinkpad') then user_id else null end ) 
as "Lenovo Thinkpad",
count(distinct case when device in('samsumg galaxy tablet') then user_id else null end ) 
as "Samsumg Galaxy Tablet",
count(distinct case when device in('acer aspire notebook') then user_id else null end ) 
as "Acer Aspire Notebook",
count(distinct case when device in('asus chromebook') then user_id else null end ) 
as "Asus Chromebook",
count(distinct case when device in('mac mini') then user_id else null end ) 
as "Mac Mini",
count(distinct case when device in('hp pavilion desktop') then user_id else null end ) 
as "Hp Pavilion Desktop",
count(distinct case when device in('samsung galaxy note') then user_id else null end ) 
as "Samsung galaxy note",
count(distinct case when device in('ipad air') then user_id else null end ) 
as "Ipad Air",
count(distinct case when device in('htc one') then user_id else null end ) 
as "Htc One",
count(distinct case when device in('dell inspiron desktop') then user_id else null end ) 
as "Dell Inspiron Desktop",
count(distinct case when device in('amazon fire phone') then user_id else null end ) 
as "Amazon Fire Phone",
count(distinct case when device in('acer aspire desktop') then user_id else null end ) 
as "Acer Aspire Desktop",
count(distinct case when device in('nokia lumia 635') then user_id else null end ) 
as "Nokia Lumia 635",
count(distinct case when device in('nexus 10') then user_id else null end ) 
as "nexus 10"
from events_tbl
where event_type='engagement'
group by 1 order by 1;

#Task5(calculate the email engagement metrics)
select week,
round((weekly_digest/total*100),2) as 'Weekly Digest Rate',
round((email_opens/total*100),2) as "Email Open Rate",
round((email_clickthroughs/total*100),2) as "Email Clickthorugh Rate",
round((reengagement_emails/total*100),2) as "Reengagement Email Rate"
from (
select extract(week from occurred_at) as Week,
count(case when action='sent_weekly_digest' then user_id else null end) as
weekly_digest,
count(case when action='email_open' then user_id else null end) as
email_open,
count(case when action='email_clickthrough' then user_id else null end) as
email_clickthroughs,
count(case when action='sent_reengagement_email' then user_id else null end) as
reengagement_email,
count(user_id) as Total
from email_events
group by 1) sub
group by 1 order by 1;
