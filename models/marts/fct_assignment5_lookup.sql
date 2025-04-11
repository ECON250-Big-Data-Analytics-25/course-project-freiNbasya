{{
config(
materialized ='incremental',
unique_key ='title'
)
}}
with input as (
select
title,
date(datehour) as date,
views
from {{source('test_dataset', 'assignment5_input')}}
{% if is_incremental() %}
where date(datehour) >= (select max(last_appearance) from {{ this }}) - 1
{% endif %}
)

select
title,
min(date) as first_appearance,
max(date) as last_appearance,
sum(views) as total_views,
CURRENT_TIMESTAMP() as insert_time
from input
group by title
