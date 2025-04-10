{{ config(
    materialized='table',
    description='Analysis of top performing product categories by region, price, or time period')}}

with orders as (
    select
        order_id,
        customer_state,
        order_purchase_timestamp,
        order_total_price,
        product_categories_english,
        product_categories_original
    from {{ ref('fp_sales_full') }}
),

orders_extracted as (
select
    order_id,
    customer_state,
    order_total_price,
    product_categories_english,
    product_categories_original,
    extract(year from order_purchase_timestamp) as order_year,
    extract(month from order_purchase_timestamp) as order_month
from orders
)

select
order_year,
order_month,
customer_state,
product_categories_english as product_category,
count(distinct order_id) as orders,
sum(order_total_price) as total_revenue
from orders_extracted
group by 1,2,3,4
order by total_revenue desc, orders desc
