{{
  config(
    materialized = 'table',
    )
}}

select
  d.domain_id,
  d.domain_name,
  d.domain_concept_id
from {{ source('vocab', 'domain') }} as d
