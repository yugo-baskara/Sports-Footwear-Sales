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


-- ================== --
-- Create Clean Table --
-- ================== --

create table portofolio.footwear_sales_clean as
select
	order_id,
	dt.order_date,
-- separate year and month
	year(dt.order_date) as order_year,
	month(dt.order_date) as order_month,
dt.brand,
dt.model_name,
dt.category,
dt.gender,
dt.size,
dt.color,
dt.base_price_usd,
dt.discount_percent,
dt.final_price_usd,
dt.units_sold,
-- fix revenue
(dt.final_price_usd * dt.units_sold) as revenue_usd,
dt.payment_method,
dt.sales_channel,
dt.country,
dt.customer_income_level,
dt.customer_rating
from (
select
    order_id,
	str_to_date(order_date, '%Y-%m-%d') as order_date,
	trim(brand) as brand,
	trim(model_name) as model_name,
	trim(category) as category,
	trim(gender) as gender,
	size,
	trim(color) as color,
	base_price_usd,
	discount_percent,
	final_price_usd,
	units_sold,
	trim(payment_method) as payment_method,
	trim(sales_channel) as sales_channel,
	trim(country) as country,
	trim(customer_income_level) as customer_income_level,
	customer_rating
from portofolio.footwear_sales_raw) dt
;


select
	order_id,
    count(*)
from
	portofolio.footwear_sales_clean
group by
	order_id
having count(*) > 1
;

-- Ensure no duplicate before applying primary key

alter table portofolio.footwear_sales_clean
add primary key (order_id)
;


-- ========== --
-- Audit Data --
-- ========== --

select
	*
from
	portofolio.footwear_sales_clean
where revenue_usd != final_price_usd * units_sold
;

select
	*
from
	portofolio.footwear_sales_clean
where
	final_price_usd > base_price_usd
;

select
	*
from
	portofolio.footwear_sales_clean
where
	order_id is null
	or order_date is null
	or revenue_usd is null
;


select
	*
from
	portofolio.footwear_sales_clean
where
	customer_rating < 0 or customer_rating > 5
;


select
	*
from
	portofolio.footwear_sales_clean
where
	units_sold <= 0
;


-- ============= --
-- Total Revenue --
-- ============= --

select
	sum(revenue_usd) as total_revenue
from
	portofolio.footwear_sales_clean
;

-- Total revenue represents the overall scale of the global footwear business. 
-- This metric serves as a baseline for evaluating overall performance and supports deeper analysis across time, geography, and customer segments.


-- ======================== --
-- Total Revenue Per Year --
-- ======================== --

select
	order_year,
    sum(revenue_usd) as total_revenue
from
	portofolio.footwear_sales_clean
group by
	order_year
order by
	order_year desc
;

-- Yearly revenue trends provide visibility into business growth over time.
-- Consistent increases suggest strong market demand and expansion, while declines may indicate shifting consumer behavior or increased competitive pressure.


-- ======================== --
-- Total Revenue by Country --
-- ======================== --

select
	country,
    sum(revenue_usd) as total_revenue
from
	portofolio.footwear_sales_clean
group by
	country
order by
	total_revenue desc
;

-- Revenue distribution by country highlights the most profitable markets.
-- High-performing countries can be prioritized for expansion, while underperforming regions may require targeted strategies to improve market penetration.


-- ==================== --
-- Top Country per Year --
-- ==================== --

select
	*
from (
	select
		order_year,
		country,
		sum(revenue_usd) as revenue,
    rank() over (partition by order_year order by sum(revenue_usd) desc) as rnk
    from
		portofolio.footwear_sales_clean
	group by
		order_year,
		country
) as t
where
	rnk = 1
;

-- This analysis identifies which countries dominate revenue generation each year.
-- Changes in top-performing countries may reflect evolving market trends, economic conditions, or shifts in regional demand.


-- ========= --
-- Top Brand --
-- ========= --

select
	*
from (
	select
    order_year,
    brand,
    sum(revenue_usd) as revenue,
    rank() over (partition by order_year order by sum(revenue_usd) desc) as rnk 
from portofolio.footwear_sales_clean
group by
order_year,
brand
) t
where rnk = 1
;

-- Brands that consistently rank as top performers demonstrate strong market positioning and customer loyalty.
-- Variations in rankings across years indicate competitive dynamics and innovation within the footwear industry.

select
	brand,
    sum(revenue_usd) as total_revenue
from
	portofolio.footwear_sales_clean
group by
	brand
order by
	total_revenue desc
;

-- The top-performing brand by total revenue represents the market leader.
-- This serves as a benchmark for evaluating other brands and understanding competitive positioning.


-- =================== --
-- Average Order Value --
-- =================== --

select
	sum(revenue_usd) / count(distinct order_id) as avg_order_value
from
	portofolio.footwear_sales_clean
;

-- AOV measures the average revenue per transaction.
-- A higher AOV indicates that customers are purchasing higher-value products or buying in larger quantities, which can inform upselling and bundling strategies.


-- ========================= --
-- Sales Channel Performance --
-- ========================= --

select
	sales_channel,
    sum(revenue_usd) as total_revenue
from
	portofolio.footwear_sales_clean
group by
	sales_channel
order by
	total_revenue desc
;

-- Sales channel performance reveals customer purchasing preferences across different platforms (e.g., online vs offline).
-- High-performing channels should be further optimized, while weaker channels may require strategic adjustments.



-- =============== --
-- Discount Impact --
-- =============== --

select
	discount_percent,
    sum(units_sold) as total_unit,
    sum(revenue_usd) as total_revenue
from
	portofolio.footwear_sales_clean
group by
	discount_percent
order by
	discount_percent desc
;

-- Discounts directly influence sales volume and revenue.
-- If higher discounts significantly increase units sold but not overall revenue, pricing strategies may need optimization to maintain profitability. 


-- ===================== --
-- Customer Segmentation --
-- ===================== --

select
	customer_income_level,
    sum(revenue_usd) as total_spending
from
	portofolio.footwear_sales_clean
group by
	customer_income_level
order by
	total_spending desc
;

-- Segmenting customers by income level helps identify the most valuable customer groups. 
-- This enables more effective pricing strategies, product positioning, and targeted marketing campaigns.



-- ================ --
-- Product Category --
-- ================ --

select
	category,
    sum(revenue_usd) as total_sales
from
	portofolio.footwear_sales_clean
group by
	category
order by
	total_sales desc
;

-- Product categories with the highest revenue contribution reflect current market demand.
-- These insights can guide inventory planning, product development, and promotional strategies.


-- ========== --
-- YOY Growth --
-- ========== --

select
	order_year,
    sum(revenue_usd) as revenue,
    lag(sum(revenue_usd)) over (order by order_year) as prev_year,
    round((sum(revenue_usd) - lag(sum(revenue_usd)) over (order by order_year)) 
    / nullif (lag(sum(revenue_usd)) over (order by order_year), 0) * 100,2) as growth_pct
from
	portofolio.footwear_sales_clean
group by
	order_year
;

-- YoY growth measures business performance over time.
-- Positive growth indicates healthy expansion, while declines highlight the need for deeper investigation into internal or external factors affecting performance.


-- ======================================= --
-- Indexing Performance of Order and Brand --
-- ======================================= --

create index idx_order_year on portofolio.footwear_sales_clean(order_year);
create index idx_order_brand on portofolio.footwear_sales_clean(brand);


-- =========================== --
-- Automation of Sales Summary --
-- =========================== --

create view sales_summary as
select
	order_year,
    sum(revenue_usd) as total_revenue
from
	portofolio.footwear_sales_clean
group by
	order_year
;
