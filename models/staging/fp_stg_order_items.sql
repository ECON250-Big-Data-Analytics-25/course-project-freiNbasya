{{config(
    materialized='view',
    description='Staging model for fp_order_items; Derived column: sum of price and shipping price (freight_value)')}}

with source as (select * from {{ source('ikondenko', 'fp_order_items') }}),

derived as (
select
    order_id,
    order_item_id,
    product_id,
    seller_id,
    shipping_limit_date,
    cast(price as float64) as price,
    cast(freight_value as float64) as freight_value,
    cast(price as float64) + cast(freight_value as float64) as total_price
from source
)

select * from derived