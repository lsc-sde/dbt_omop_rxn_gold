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
inner join {{ source('omop', 'person') }}  as p
  on co.person_id = p.person_id
where
  co.condition_occurrence_id is not null
  and co.condition_concept_id is not null
  and co.condition_start_date >= cast(p.birth_datetime as date)
  and co.condition_start_date <= {{ dbt.current_timestamp() }}
-- ToDo: Add a clause to exclude events after death
