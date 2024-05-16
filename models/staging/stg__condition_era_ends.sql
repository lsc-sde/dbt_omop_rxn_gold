{{
  config(
    materialized = "table",
    tags = ['omop', 'era', 'condition']
    )
}}

select
  c.PERSON_ID,
  c.CONDITION_CONCEPT_ID,
  c.CONDITION_START_DATE,
  MIN(e.END_DATE) as ERA_END_DATE
from {{ ref('stg__condition_era_target') }} as c
inner join {{ ref('stg__condition_era_end_dates') }} as e
  on
    c.PERSON_ID = e.PERSON_ID
    and c.CONDITION_CONCEPT_ID = e.CONDITION_CONCEPT_ID
    and c.CONDITION_START_DATE <= e.END_DATE
group by
  c.PERSON_ID,
  c.CONDITION_CONCEPT_ID,
  c.CONDITION_START_DATE
