{{ config(materialized='table') }}
with filtered_data as (
    select 
    *
    from {{ ref('int_assignment3_uk_wiki') }}
    where is_meta_page = false  
), 

aggregated_data as (
    select 
        title,
        sum(views) as total_views,
        sum(case when src = 'mobile' then views else 0 end) as total_mobile_views
    from filtered_data
    group by title
),

final_data as (
    select 
        *,
        safe_divide(total_mobile_views, total_views) * 100 as mobile_percentage
    from aggregated_data
    order by total_views desc
    limit 200
)

select * from final_data order by mobile_percentage
