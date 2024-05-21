{{
  config(
    materialized = 'view'

    )
}}

with spans as (
  select * from {{ ref('temp__condition_dates') }}
  union
  select * from {{ ref('temp__visit_dates') }}
  union
  select * from {{ ref('temp__measurement_dates') }}
  union
  select * from {{ ref('temp__procedure_dates') }}
  union
  select * from {{ ref('temp__observation_dates') }}
  union
  select * from {{ ref('temp__device_dates') }}
  union
  select * from {{ ref('temp__drug_dates') }}
  union
  select * from {{ ref('temp__specimen_dates') }}
),

observation_period as (
  select
    person_id,
    observation_period_start_date,
    observation_period_end_date,
    row_number() over (
      partition by person_id order by observation_period_start_date
    ) as row_num,
    datediff(
      day,
      lag(observation_period_end_date)
        over (partition by person_id order by observation_period_start_date),
      observation_period_start_date
    ) as time_difference
  from spans
  where observation_period_start_date >= '2005-01-01'
),

grouped_data as (
  select
    *,
    sum(
      case
        when time_difference > 548 or time_difference is null then 1 else 0
      end
    ) over (partition by person_id order by row_num) as group_id
  from observation_period
)

select distinct
  person_id,
  first_value(observation_period_start_date)
    over (
      partition by person_id, group_id order by observation_period_start_date
    )
    as observation_period_start_date,
  first_value(observation_period_end_date)
    over (
      partition by person_id,
      group_id order by observation_period_start_date desc
    )
    as observation_period_end_date
from grouped_data
