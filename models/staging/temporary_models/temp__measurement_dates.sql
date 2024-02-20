{{ get_observation_period ('measurement', 'measurement_date', 'measurement_date') }}

select
  person_id,
  observation_period_start_date,
  observation_period_end_date
from cte
