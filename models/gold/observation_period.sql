{{
  config(
    materialized = 'table',
    )
}}

{# Placeholder logic to allow ATLAS to work
https://stackoverflow.com/questions/48425120/merge-overlapping-dates-in-sql-server
#}

{{
  config(
    materialized = 'table',
    )
}}

--noqa
select
  person_id,
  observation_period_start_date,
  observation_period_end_date,
  32817 as period_type_concept_id,
  row_number() over (order by person_id) as observation_period_id
from {{ ref("temp__observation_dates") }}
--noqa
