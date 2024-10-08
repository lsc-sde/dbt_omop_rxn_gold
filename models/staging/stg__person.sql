{{
  config(
    materialized = 'table',
    )
}}

select
  p.person_id,
  p.gender_concept_id,
  p.year_of_birth,
  p.month_of_birth,
  p.day_of_birth,
  cast(p.birth_datetime as date) as birth_datetime,
  p.race_concept_id,
  p.ethnicity_concept_id,
  p.location_id,
  p.provider_id,
  p.care_site_id,
  p.person_source_value,
  p.gender_source_value,
  p.gender_source_concept_id,
  p.race_source_value,
  p.race_source_concept_id,
  p.ethnicity_source_value,
  p.ethnicity_source_concept_id
from {{ source('omop', 'person') }} as p
where
-- patients should have atleast one fact
  exists (
    select 1
    from {{ ref('stg__persons_with_facts') }} as op
    where op.person_id = p.person_id
  )
  and
  not exists (
    select 1
    from {{ source('ndo', 'ext__data_opt_out') }} as op
    where op.person_id = p.person_id
  )
  -- patients cannot be born in the future
  and p.birth_datetime <= {{ dbt.current_timestamp() }}
  -- gender concept must be female or male
  and p.gender_concept_id in (8532, 8507)
