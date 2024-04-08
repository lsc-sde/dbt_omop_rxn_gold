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
    select person_id from {{ source('omop', 'measurement') }}
    union
    select person_id from {{ source('omop', 'observation') }}
    union
    select person_id from {{ source('omop', 'condition_occurrence') }}
    union
    select person_id from {{ source('omop', 'procedure_occurrence') }}
    union
    select person_id from {{ source('omop', 'drug_exposure') }}
    union
    select person_id from {{ source('omop', 'device_exposure') }}
    union
    select person_id from {{ source('omop', 'visit_occurrence') }}

  ) as t

--noqa
