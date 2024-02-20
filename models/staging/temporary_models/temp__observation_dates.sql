{{
  config(
    materialized = 'table'

    )
}}

with spans as (
  select * from {{ ref('temp__condition_dates') }}
  union
  select * from {{ ref('temp__visit_dates') }}
  union
  select * from {{ ref('temp__measurement_dates') }}
)

select
  person_id,
  cast(min(observation_period_start_date) as date)
    as observation_period_start_date,
  cast(max(observation_period_end_date) as date) as observation_period_end_date
from spans
group by person_id
