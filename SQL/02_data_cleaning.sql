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
