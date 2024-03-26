# BI_TimeFrame_SQL
This is to pre calculate the timeframe for data analysis, we can calculate all previous years start and end date for last 3 years for all period starting from   

1) FY
2) YTD 
3) QTD 
4) MTD 
5) QoQ 
6) MoM 
7) WoW 
8) DoD 

These period we can derive from date dimension table as most of the datawarehouse layer has this dimension table and we can store the start and end date which will help us saving computational time on reports/dashboard queries.

#How to use the sql query?
Just replace the dim_date table with your data warehouse table name and then you are good to go.
