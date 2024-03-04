{# Placeholder logic to allow ATLAS to work
https://stackoverflow.com/questions/48425120/merge-overlapping-dates-in-sql-server
#}

{{
  config(
    materialized = 'view',
    )
}}

--noqa
select
  *
  from {{ source('omop', 'observation_period') }}
--noqa
