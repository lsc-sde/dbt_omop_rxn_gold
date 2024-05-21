  {{ get_observation_period ('observation', 'observation_date', 'observation_date') }}

select
  person_id,
  observation_period_start_date,
  observation_period_end_date
from cte
