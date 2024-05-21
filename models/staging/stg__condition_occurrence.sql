select
  co.condition_occurrence_id,
  co.person_id,
  co.condition_concept_id,
  co.condition_start_date,
  co.condition_start_datetime,
  co.condition_end_date,
  co.condition_end_datetime,
  co.condition_type_concept_id,
  co.condition_status_concept_id,
  co.stop_reason,
  co.provider_id,
  co.visit_occurrence_id,
  co.visit_detail_id,
  co.condition_source_value,
  co.condition_source_concept_id,
  co.condition_status_source_value
from {{ source('omop', 'condition_occurrence') }} as co
inner join {{ ref('stg__person') }} as p
  on co.person_id = p.person_id
inner join {{ ref('stg__visit_occurrence') }} as vo
  on co.visit_occurrence_id = vo.visit_occurrence_id
inner join {{ source('vocab', 'concept') }} as c
  on
    co.condition_concept_id = c.concept_id
    and c.standard_concept is not null
where
  co.condition_occurrence_id is not null
  and co.condition_concept_id is not null
  and co.condition_start_date >= cast(p.birth_datetime as date)
  and co.condition_start_date <= {{ dbt.current_timestamp() }}
  -- ToDo: Add a clause to exclude events after death
  and
  co.condition_start_date
  >= '{{ var("minimum_observation_period_start_date") }}'
