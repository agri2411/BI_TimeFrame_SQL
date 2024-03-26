select 
  timeframe_id,display_name
, sum(case when o.fact_date between t.ty_start_date and t.ty_end_date then sales end) as ty_sales 
, sum(case when o.fact_date between t.ly_start_date and t.ly_end_date then sales end) as ly_sales
, sum(case when o.fact_date between t.lly_start_date and t.lly_end_date then sales end) as lly_sales
from 
	fact_sales inner join timeframes t 
on o.fact_date between t.ty_start_date and t.ty_end_date
or o.fact_date between t.ly_start_date and t.ly_end_date
or o.fact_date between t.lly_start_date and t.lly_end_date
where 
  timeframe='DoD'
group by 
  timeframe_id,display_name
