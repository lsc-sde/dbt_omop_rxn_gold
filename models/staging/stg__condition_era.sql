{{
  config(
    materialized = "table",
    tags = ['omop', 'condition', 'era']
    )
}}

select
  cast(row_number() over (
    order by person_id
  ) as bigint) as condition_era_id,
  cast(person_id as bigint) as person_id,
  cast(condition_concept_id as bigint) as condition_concept_id,
  min(condition_start_date) as condition_era_start_date,
  era_end_date as condition_era_end_date,
  count(*) as condition_occurrence_count
from {{ ref('stg__condition_era_ends') }}
group by
  person_id,
  condition_concept_id,
  era_end_date
