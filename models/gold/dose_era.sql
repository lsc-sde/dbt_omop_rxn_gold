{{
  config(
    materialized = 'table',
    )
}}

select
  de.dose_era_id,
  de.person_id,
  de.drug_concept_id,
  de.unit_concept_id,
  de.dose_value,
  de.dose_era_start_date,
  de.dose_era_end_date
from {{ source('omop', 'dose_era') }} as de
