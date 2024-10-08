{{
  config(
    materialized = 'table',
    )
}}

select
  p.provider_id,
  p.provider_name,
  p.npi,
  p.dea,
  p.specialty_concept_id,
  p.care_site_id,
  p.year_of_birth,
  p.gender_concept_id,
  p.provider_source_value,
  p.specialty_source_value,
  p.specialty_source_concept_id,
  p.gender_source_value,
  p.gender_source_concept_id
from {{ source('omop', 'provider') }} as p
