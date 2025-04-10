{{config(
    materialized='view',
    description='Staging model for fp_customers; no derived columns')}}

with source as (select * from {{ source('ikondenko', 'fp_customers')}})

select * from source