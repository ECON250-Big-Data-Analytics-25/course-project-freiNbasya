{{ config(
    materialized='view',
    description='Staging model for fp_products; Derived column shows the volume of the product')}}

with source as (select * from {{ source('ikondenko', 'fp_products') }}),

derived as (
select
    product_id,
    lower(product_category_name) as product_category_name,
    product_name_lenght,
    product_description_lenght,
    product_photos_qty,
    product_weight_g,
    product_length_cm,
    product_height_cm,
    product_width_cm,
    case
        when product_length_cm is null or product_height_cm is null or product_width_cm is null then null
        else product_length_cm * product_height_cm * product_width_cm
    end as product_volume
from source
)

select * from derived