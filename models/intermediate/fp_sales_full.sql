{{ config(
    materialized='table',
    partition_by={"field": "order_purchase_timestamp", "data_type": "timestamp"},
    cluster_by=["customer_id"])}}

with customers as (select * from {{ ref('fp_stg_customers')}}),

order_items as (select * from {{ ref('fp_stg_order_items')}}),

order_payments as (select * from {{ ref('fp_stg_order_payments')}}),

orders as (select * from {{ ref('fp_stg_orders')}}),

categories as (select * from {{ ref('fp_stg_product_category_name_translation')}}),

products as (select * from {{ ref('fp_stg_products') }}),

sellers as (select * from {{ ref('fp_stg_sellers')}}),

seller_info as (
select distinct
    oit.order_id,
    s.seller_id,
    s.seller_city,
    s.seller_state
from order_items oit
    join sellers s on oit.seller_id = s.seller_id
),

seller_aggregated as (
select
    order_id,
    array_agg(struct(seller_id, seller_city, seller_state)) as sellers
from seller_info
group by order_id
),

item_aggregated as (
select
    oit.order_id,
    sum(oit.price) as order_total_price,
    sum(oit.freight_value) as order_total_freight,
    array_agg(distinct cat.product_category_name_english) as product_categories_english,
    array_agg(distinct p.product_category_name) as product_categories_original
from order_items oit
join products p on oit.product_id = p.product_id
    join categories cat on p.product_category_name = cat.product_category_name
group by oit.order_id
),

payments_aggregate as (
select
    order_id,
    array_agg(struct(
        payment_type,
        payment_installments,
        payment_value,
        is_credit_card
    )) as order_payments
from order_payments
group by order_id
)

select
o.order_id,
o.customer_id,

c.customer_state,
c.customer_city,

o.order_status,
o.order_purchase_timestamp,
o.order_approved_at,
o.order_delivered_customer_date,
o.order_estimated_delivery_date,
o.delivery_time,

iagg.order_total_price,
iagg.order_total_freight,
iagg.product_categories_english,
iagg.product_categories_original,

sagg.sellers,

pagg.order_payments

from orders o
join customers c on o.customer_id = c.customer_id
join item_aggregated iagg on o.order_id = iagg.order_id
join seller_aggregated sagg on o.order_id = sagg.order_id
join payments_aggregate pagg on o.order_id = pagg.order_id