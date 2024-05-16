{{
  config(
    materialized = "table",
    tags = ['omop', 'era', 'condition']
    )
}}

select
  co.person_id,
  co.condition_concept_id,
  co.condition_start_date,
  coalesce(co.condition_end_date, dateadd(day, 1, co.condition_start_date))
    as condition_end_date
from {{ ref('stg__condition_occurrence') }} as co
