{{ get_observation_period ('stg__visit_occurrence', 'visit_start_date', 'visit_end_date') }}

select
  person_id,
  observation_period_start_date,
  observation_period_end_date
from cte
