-- ============================= --
-- Audit Data - Revenue Mismatch --
-- ============================= --

select
	*
from
	portofolio.footwear_sales_clean
where revenue_usd != final_price_usd * units_sold
;

-- ============================= --
-- Audit Data - Revenue Mismatch --
-- ============================= --

select
	*
from
	portofolio.footwear_sales_clean
where
	final_price_usd > base_price_usd
;

-- ======================= --
-- Audit Data - Null Check --
-- ======================= --

select
	*
from
	portofolio.footwear_sales_clean
where
	order_id is null
	or order_date is null
	or revenue_usd is null
;

-- ========================= --
-- Audit Data - Rating Check --
-- ========================= --

select
	*
from
	portofolio.footwear_sales_clean
where
	customer_rating < 0 or customer_rating > 5
;

-- ============================ --
-- Audit Data - Unit Sold Check --
-- ============================ --

select
	*
from
	portofolio.footwear_sales_clean
where
	units_sold <= 0
;
