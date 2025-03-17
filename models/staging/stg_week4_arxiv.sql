
  select 
  date_trunc(published_date, month) as published_month,
  regexp_replace(id, r'^\w+-', 'https://arxiv.org/abs/') as url,

  JSON_QUERY_ARRAY(authors) as json_authors,
  split(regexp_replace(authors, r"\'|\[|\]", ""), ',') as split_authors,
  * 
  from {{source('ikondenko', 'assignment1_full')}}
