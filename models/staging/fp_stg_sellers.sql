{{ config(
    materialized='view',
    description='Staging model for fp_sellers')}}

with source as (select * from {{ source('ikondenko', 'fp_sellers') }})

select * from source