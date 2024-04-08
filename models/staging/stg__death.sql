select
  d.person_id,
  d.death_date,
  d.death_datetime,
  d.death_type_concept_id,
  d.cause_concept_id,
  d.cause_source_value,
  d.cause_source_concept_id
from {{ source('omop', 'death') }} as d
inner join {{ ref('stg__person') }} as p
  on d.person_id = p.person_id
where
  d.death_date >= cast(p.birth_datetime as date)