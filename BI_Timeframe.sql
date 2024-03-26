with todays_cte as(
    select * from dim_date where date_id=current_date()
),
cal as (
select 
    d.*,
    t.year as today_year,
    t.date_id as today_date,
    t.quarter as today_quarter,
    t.month as today_month,
    t.day as today_cal_year_day
from 
    dim_date d cross join todays_cte t
where 
    d.year between t.year-2 and t.year
)
, cte as (
select 'FY' as timeframe,
 'FY' as timeframe_id,
 'FY' as display_name,
 min(case when year=today_year then date_id end) as ty_start_date,
 max(case when year=today_year then date_id end) as ty_end_date,
 min(case when year=today_year-1 then date_id end) as ly_start_date,
 max(case when year=today_year-1 then date_id end) as ly_end_date,
 min(case when year=today_year-2 then date_id end) as lly_start_date,
 max(case when year=today_year-2 then date_id end) as lly_end_date
 from cal

union all
select 'QoQ' as timeframe,
cast(quarter as string) as timeframe_id,
concat('Q', cast(quarter as string)) as display_name,
 min(case when year=today_year then date_id end) as ty_start_date,
 max(case when year=today_year then date_id end) as ty_end_date,
 min(case when year=today_year-1 then date_id end) as ly_start_date,
 max(case when year=today_year-1 then date_id end) as ly_end_date,
 min(case when year=today_year-2 then date_id end) as lly_start_date,
 max(case when year=today_year-2 then date_id end) as lly_end_date
 from cal
 group by quarter
union all
select 
'YTD' as timeframe,
'YTD' as timeframe_id,
'YTD' as display_name,
 min(case when year=today_year then date_id end) as ty_start_date,
 max(case when year=today_year then date_id end) as ty_end_date,
 min(case when year=today_year-1 then date_id end) as ly_start_date,
 max(case when year=today_year-1 then date_id end) as ly_end_date,
 min(case when year=today_year-2 then date_id end) as lly_start_date,
 max(case when year=today_year-2 then date_id end) as lly_end_date
 from cal
where day<=today_cal_year_day
 union all
select 
'QTD' as timeframe,
'QTD' as timeframe_id,
'QTD' as display_name,
 min(case when year=today_year then date_id end) as ty_start_date,
 max(case when year=today_year then date_id end) as ty_end_date,
 min(case when year=today_year-1 then date_id end) as ly_start_date,
 max(case when year=today_year-1 then date_id end) as ly_end_date,
 min(case when year=today_year-2 then date_id end) as lly_start_date,
 max(case when year=today_year-2 then date_id end) as lly_end_date
 from cal
where quarter=today_quarter and day<=today_cal_year_day
 union all
select 
'MTD' as timeframe,
'MTD' as timeframe_id,
'MTD' as display_name,
 min(case when year=today_year then date_id end) as ty_start_date,
 max(case when year=today_year then date_id end) as ty_end_date,
 min(case when year=today_year-1 then date_id end) as ly_start_date,
 max(case when year=today_year-1 then date_id end) as ly_end_date,
 min(case when year=today_year-2 then date_id end) as lly_start_date,
 max(case when year=today_year-2 then date_id end) as lly_end_date
 from cal
where month=today_month and day<=today_cal_year_day
 union all
select 
'MoM' as timeframe,
 cast(month as string) as timeframe_id,
 month_short_label_en as display_name,
 min(case when year=today_year then date_id end) as ty_start_date,
 max(case when year=today_year then date_id end) as ty_end_date,
 min(case when year=today_year-1 then date_id end) as ly_start_date,
 max(case when year=today_year-1 then date_id end) as ly_end_date,
 min(case when year=today_year-2 then date_id end) as lly_start_date,
 max(case when year=today_year-2 then date_id end) as lly_end_date
 from cal
 group by month,month_short_label_en
  union all
select 
'WoW' as timeframe,
 cast(week_of_year as string) as timeframe_id,
 concat('Week ', cast(week_of_year as string)) as display_name,
 min(case when year=today_year then date_id end) as ty_start_date,
 max(case when year=today_year then date_id end) as ty_end_date,
 min(case when year=today_year-1 then date_id end) as ly_start_date,
 max(case when year=today_year-1 then date_id end) as ly_end_date,
 min(case when year=today_year-2 then date_id end) as lly_start_date,
 max(case when year=today_year-2 then date_id end) as lly_end_date
 from cal
 group by week_of_year
 union all
select 
'DoD' as timeframe,
 cast(week_of_year as string) as timeframe_id,
 concat('W', cast(week_of_year as string), ' ', day_of_week_short_label_en) as display_name,
 min(case when year=today_year then date_id end) as ty_start_date,
 max(case when year=today_year then date_id end) as ty_end_date,
 min(case when year=today_year-1 then date_id end) as ly_start_date,
 max(case when year=today_year-1 then date_id end) as ly_end_date,
 min(case when year=today_year-2 then date_id end) as lly_start_date,
 max(case when year=today_year-2 then date_id end) as lly_end_date
 from cal
 group by week_of_year,day_of_week,day_of_week_short_label_en)
select *  from cte 
order by case when timeframe='DoD' then 1 else 0 end, timeframe,length(timeframe_id),timeframe_id