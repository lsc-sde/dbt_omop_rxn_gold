{{
  config(
    materialized = 'table',
    )
}}

select
  ca.ancestor_concept_id,
  ca.descendant_concept_id,
  ca.min_levels_of_separation,
  ca.max_levels_of_separation
from {{ source('vocab', 'concept_ancestor') }} as ca
