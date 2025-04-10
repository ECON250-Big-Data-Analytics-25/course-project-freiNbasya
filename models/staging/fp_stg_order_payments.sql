{{config(
    materialized='view',
    description='Staging model for fp_order_payments; Derived column checks whether payment was made by credit card, which is the most popular payment method')}}

with source as (select * from {{ source('ikondenko', 'fp_order_payments') }}),

derived as (
select
    order_id,
    payment_sequential,
    payment_type,
    payment_installments,
    payment_value,
    case when payment_type = 'credit_card' then true else false end as is_credit_card
from source
)

select * from derived