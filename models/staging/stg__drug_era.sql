select
  de.drug_era_id,
  de.person_id,
  de.drug_concept_id,
  de.drug_era_start_date,
  de.drug_era_end_date,
  de.drug_exposure_count,
  de.gap_days
from {{ source('omop', 'drug_era') }} as de
inner join {{ ref('stg__person') }} as p
  on de.person_id = p.person_id
where
  de.drug_era_start_date >= cast(p.birth_datetime as date)
  and
  de.drug_era_start_date >= '{{ var("minimum_observation_period_start_date") }}'
