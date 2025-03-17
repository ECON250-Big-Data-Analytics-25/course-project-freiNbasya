{{config(materialized='table')}}
select 
published_month,
round(avg(days_until_updated)) avg_update_period_total,
round(avg(if(is_updated = 1, days_until_updated, null))) avg_update_period
from
{{ref("int_arxiv_duration_lim")}}
-- where is_updated = 1
group by 1