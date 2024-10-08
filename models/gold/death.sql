{{
  config(
    materialized = 'table',
    )
}}

select
  d.person_id,
  d.death_date,
  d.death_datetime,
  d.death_type_concept_id,
  d.cause_concept_id,
  d.cause_source_value,
  d.cause_source_concept_id
from {{ ref('stg__death') }} as d
