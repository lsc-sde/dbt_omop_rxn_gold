  {{ get_observation_period ('device_exposure', 'device_exposure_start_date', 'device_exposure_start_date') }}

select
  person_id,
  observation_period_start_date,
  observation_period_end_date
from cte
