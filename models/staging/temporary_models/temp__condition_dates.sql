  {{ get_observation_period ('condition_era', 'condition_era_start_date', 'condition_era_end_date') }}

select
  person_id,
  observation_period_start_date,
  observation_period_end_date
from cte
