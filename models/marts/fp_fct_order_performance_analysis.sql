{{ config(
    materialized='table',
    description='Monthly order performance analysis')}}

with orders as (
select 
    order_id,
    customer_id,
    customer_state,
    order_status,
    order_purchase_timestamp,
    order_total_price
from {{ ref('fp_sales_full') }}
),

orders_extracted as (
select
    order_id,
    customer_id,
    customer_state,
    order_status,
    order_total_price,
    extract(year from order_purchase_timestamp) as order_year,
    extract(month from order_purchase_timestamp) as order_month
from orders
)

select
order_year,
order_month,
customer_state,
order_status,
count(distinct order_id) as total_orders,
sum(order_total_price) as total_revenue,
avg(order_total_price) as avg_order_value
from orders_extracted
group by 1,2,3,4
order by order_year, order_month, customer_state, order_status
