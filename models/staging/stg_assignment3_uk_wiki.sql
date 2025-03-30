{{ config(materialized='view') }}
select
  datehour,
  title,
  views,
  "desktop" as src,
  FORMAT_TIMESTAMP('%Y-%m-%d', datehour) as date,
from {{ source('test_dataset', 'assignment3_input_uk') }}
union all
select
  datehour,
  title,
  views,
  "mobile" as src,
  FORMAT_TIMESTAMP('%Y-%m-%d', datehour) as date,
from {{ source('test_dataset', 'assignment3_input_uk_m') }}