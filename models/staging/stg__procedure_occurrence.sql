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
from {{ source('omop', 'procedure_occurrence') }} as po
inner join {{ ref('stg__person') }} as p
  on po.person_id = p.person_id
inner join {{ ref('stg__visit_occurrence') }} as vo
  on po.visit_occurrence_id = vo.visit_occurrence_id
where
  po.procedure_date >= cast(p.birth_datetime as date)
  and po.procedure_date is not null
  and
  po.procedure_date >= '{{ var("minimum_observation_period_start_date") }}'
