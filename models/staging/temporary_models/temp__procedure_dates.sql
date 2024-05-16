  {{ get_observation_period ('procedure_occurrence', 'procedure_date', 'procedure_date') }}

select
  person_id,
  observation_period_start_date,
  observation_period_end_date
from cte
