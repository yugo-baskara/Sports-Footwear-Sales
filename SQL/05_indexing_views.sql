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
