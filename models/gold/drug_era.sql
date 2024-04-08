select
  de.drug_era_id,
  de.person_id,
  de.drug_concept_id,
  de.drug_era_start_date,
  de.drug_era_end_date,
  de.drug_exposure_count,
  de.gap_days
from {{ ref('stg__drug_era') }} as de
