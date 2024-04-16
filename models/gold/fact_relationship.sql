{{
  config(
    materialized = 'table',
    )
}}

select
  fr.domain_concept_id_1,
  fr.fact_id_1,
  fr.domain_concept_id_2,
  fr.fact_id_2,
  fr.relationship_concept_id
from {{ source('omop', 'fact_relationship') }} as fr
