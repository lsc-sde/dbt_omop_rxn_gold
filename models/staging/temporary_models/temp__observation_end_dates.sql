select distinct
  person_id,
  observation_period_end_date
from {{ ref("temp__observation_dates") }} as t1
where
  not exists
  (
    select * from {{ ref("temp__observation_dates") }} as t2
    where
      t2.person_id = t1.person_id
      and t2.observation_period_end_date > t1.observation_period_end_date
      and t2.observation_period_start_date <= t1.observation_period_end_date
  )
