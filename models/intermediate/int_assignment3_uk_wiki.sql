{{ config(materialized='view') }}
select
  *,
 case 
    when split(title, ':')[offset(0)] in ('Вікіпедія','Категорія','Файл')
    then split(title, ':')[offset(0)]
    else "Not meta page"
  end as meta_page_type,
  case 
    when split(title, ':')[offset(0)] in ('Вікіпедія','Категорія','Файл')
    then true else false
  end as is_meta_page
from {{ ref('stg_assignment3_uk_wiki') }}
