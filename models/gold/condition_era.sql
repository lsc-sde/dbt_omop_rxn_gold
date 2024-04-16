{{
  config(
    materialized = 'table',
    )
}}

select
  ce.condition_era_id,
  ce.person_id,
  ce.condition_concept_id,
  ce.condition_era_start_date,
  ce.condition_era_end_date,
  ce.condition_occurrence_count
from {{ ref('stg__condition_era') }} as ce
