{{
  config(
    materialized = 'table',
    )
}}

select
  cr.concept_id_1,
  cr.concept_id_2,
  cr.relationship_id,
  cr.valid_start_date,
  cr.valid_end_date,
  cr.invalid_reason
from {{ source('vocab', 'concept_relationship') }} as cr
