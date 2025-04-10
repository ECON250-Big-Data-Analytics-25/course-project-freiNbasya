{{ config(
    materialized='view',
    description='Staging model for fp_orders; Derived column shows how long it takes from order being approved to being delivered to customer') }}


with source as (select * from {{ source('ikondenko', 'fp_orders') }}),
derived as (
select
    order_id,
    customer_id,
    order_status,
    order_purchase_timestamp,
    order_approved_at,
    order_delivered_carrier_date
    order_delivered_customer_date,
    order_estimated_delivery_date,
    case 
        when order_approved_at is null or order_delivered_customer_date is null then null
        else DATE_DIFF(DATE(order_delivered_customer_date), DATE(order_approved_at), DAY)
    end as delivery_time
from source
)

select * from derived
