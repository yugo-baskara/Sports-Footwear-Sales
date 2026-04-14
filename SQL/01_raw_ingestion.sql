-- ================ --
-- Create Raw Table --
-- ================ --

create table if not exists portofolio.footwear_sales_raw
( 
order_id varchar(20) not null,
order_date varchar(20),
brand varchar(50),
model_name varchar(100),
category varchar(50),
gender varchar(20),
size decimal(3,1),
color varchar(20),
base_price_usd decimal(10,2),
discount_percent decimal(5,2),
final_price_usd decimal(10,2),
units_sold int check (units_sold >= 0),
revenue_usd decimal(12,2),
payment_method varchar(50),
sales_channel varchar(50),
country varchar(50),
customer_income_level varchar(20),
customer_rating decimal(3,1)
)
;


-- ======================= --
-- Loading Data Into Table --
-- ======================= --

load data infile
'C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/global_sports_footwear_sales.csv'
into table
portofolio.footwear_sales_raw
fields terminated by ','
optionally enclosed by '"'
lines terminated by '\n'
ignore 1 rows
;


-- NOTE
-- Please update file path based on your local environtment
