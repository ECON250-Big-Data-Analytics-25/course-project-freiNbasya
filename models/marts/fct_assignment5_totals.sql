{{
config(
materialized =
'incremental',
incremental_strategy ="insert_overwrite",
partition_by = {
"field": "date",
"data_type": "date",
}
)
}}

select 
date(datehour) as date,
title,
sum(views) as views,
current_timestamp() as insert_time
from {{source('test_dataset', 'assignment5_input')}}
{% if is_incremental() %}
where date(datehour) >= _dbt_max_partition - 1
{% endif %}
group by date, title
