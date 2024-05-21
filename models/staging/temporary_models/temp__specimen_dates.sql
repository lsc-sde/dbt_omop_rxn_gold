  {{ get_observation_period ('specimen', 'specimen_date', 'specimen_date') }}

select
  person_id,
  observation_period_start_date,
  observation_period_end_date
from cte
