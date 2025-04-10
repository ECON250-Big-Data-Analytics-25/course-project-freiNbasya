{{ config(
    materialized='view',
    description='Staging model for fp_product_category_name_translation; Derived column shows whether original and localized names are the same')}}


with source as (select * from {{ source('ikondenko', 'fp_product_category_name_translation') }}),

derived as (
select
    lower(product_category_name) as product_category_name,
    lower(product_category_name_english) as product_category_name_english,
    case
        when product_category_name is null or product_category_name_english is null then null
        when lower(product_category_name) = lower(product_category_name_english)  then true
        else false
    end as is_same
from source
)

select * from derived