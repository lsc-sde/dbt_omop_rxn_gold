{{
  config(
    materialized = 'table',
    )
}}

select
  po.procedure_occurrence_id,
  po.person_id,
  po.procedure_concept_id,
  po.procedure_date,
  po.procedure_datetime,
  po.procedure_end_date,
  po.procedure_end_datetime,
  po.procedure_type_concept_id,
  po.modifier_concept_id,
  po.quantity,
  po.provider_id,
  po.visit_occurrence_id,
  po.visit_detail_id,
  po.procedure_source_value,
  po.procedure_source_concept_id,
  po.modifier_source_value
from {{ ref('stg__procedure_occurrence') }} as po
