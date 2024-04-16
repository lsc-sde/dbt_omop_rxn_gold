{{
  config(
    materialized = 'table',
    )
}}

select
  r.relationship_id,
  r.relationship_name,
  r.is_hierarchical,
  r.defines_ancestry,
  r.reverse_relationship_id,
  r.relationship_concept_id
from {{ source('vocab', 'relationship') }} as r
