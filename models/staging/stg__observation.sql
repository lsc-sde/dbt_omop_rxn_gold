select
  o.observation_id,
  o.person_id,
  o.observation_concept_id,
  o.observation_date,
  o.observation_datetime,
  o.observation_type_concept_id,
  o.value_as_number,
  o.value_as_string,
  o.value_as_concept_id,
  o.qualifier_concept_id,
  o.unit_concept_id,
  o.provider_id,
  o.visit_occurrence_id,
  o.visit_detail_id,
  o.observation_source_value,
  o.observation_source_concept_id,
  o.unit_source_value,
  o.qualifier_source_value,
  o.value_source_value,
  o.observation_event_id,
  o.obs_event_field_concept_id,
  o.unique_key,
  o.datasource,
  o.updated_at
from {{ source('omop', 'observation') }} as o
inner join {{ ref('stg__person') }} as p
  on o.person_id = p.person_id
inner join {{ ref('stg__visit_occurrence') }} as vo
  on o.visit_occurrence_id = vo.visit_occurrence_id
inner join {{ source('vocab', 'concept') }} c
  on o.observation_concept_id = c.concept_id
  and c.invalid_reason is null
where
  o.observation_date >= cast(p.birth_datetime as date)
  and o.observation_date is not null
