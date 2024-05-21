{#
Identify all patients with at least one row in any of the fact tables.
#}

{{
  config(
    materialized = 'table',
    )
}}

--noqa

select distinct person_id
from
  (
    select person_id
    from {{ source('omop', 'measurement') }}
    where
      measurement_date >= '{{ var("minimum_observation_period_start_date") }}'
    union
    select person_id
    from {{ source('omop', 'observation') }}
    where
      observation_date >= '{{ var("minimum_observation_period_start_date") }}'
    union
    select person_id
    from {{ source('omop', 'condition_occurrence') }}
    where
      condition_start_date
      >= '{{ var("minimum_observation_period_start_date") }}'
    union
    select person_id
    from {{ source('omop', 'procedure_occurrence') }}
    where procedure_date >= '{{ var("minimum_observation_period_start_date") }}'
    union
    select person_id
    from {{ source('omop', 'drug_exposure') }}
    where
      drug_exposure_start_date
      >= '{{ var("minimum_observation_period_start_date") }}'
    union
    select person_id
    from {{ source('omop', 'device_exposure') }}
    where
      device_exposure_start_date
      >= '{{ var("minimum_observation_period_start_date") }}'
    union
    select person_id
    from {{ source('omop', 'visit_occurrence') }}
    where
      visit_start_date >= '{{ var("minimum_observation_period_start_date") }}'

  ) as t

--noqa
