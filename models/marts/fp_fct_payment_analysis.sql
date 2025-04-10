{{ config(
    materialized='table',
    description='Payment method trends, installment patterns and regional preferences analysis')}}

with orders as (
  select
    order_id,
    order_purchase_timestamp,
    order_total_price,
    order_payments
  from {{ ref('fp_sales_full') }}
),

payments_unnested as (
  select
    order_id,
    order_total_price,
    payment.payment_type,
    payment.payment_installments,
    payment.payment_value,
    payment.is_credit_card
  from orders,
  UNNEST(order_payments) as payment
)

select
payment_type,
count(*) as payment_count,
avg(payment_installments) as avg_installments,
sum(payment_value) as total_payment_value
from payments_unnested
group by payment_type
order by payment_type
