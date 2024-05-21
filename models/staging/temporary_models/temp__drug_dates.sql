  {{ get_observation_period ('drug_exposure', 'drug_exposure_start_date', 'drug_exposure_start_date') }}

select
  person_id,
  observation_period_start_date,
  observation_period_end_date
from cte
