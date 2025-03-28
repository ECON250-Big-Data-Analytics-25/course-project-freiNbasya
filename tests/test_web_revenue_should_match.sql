select date, revenue_sum as fct_revenue 
from {{ref("fct_web_daily_stats")}}
join
( select date, sum(transaction)
    {{ref("week5_transactions_deduplicated_view")}}
) using(date)