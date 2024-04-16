{{
  config(
    materialized = 'table',
    )
}}

select
  cs.concept_id,
  cs.concept_synonym_name,
  cs.language_concept_id
from {{ source('vocab', 'concept_synonym') }} as cs
