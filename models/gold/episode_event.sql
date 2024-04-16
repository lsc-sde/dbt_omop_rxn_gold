{{
  config(
    materialized = 'table',
    )
}}

select
  ee.episode_id,
  ee.event_id,
  ee.episode_event_field_concept_id
from {{ source('omop', 'episode_event') }} as ee
