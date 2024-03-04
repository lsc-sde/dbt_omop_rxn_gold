select
  m.measurement_id,
  m.person_id,
  m.measurement_concept_id,
  m.measurement_date,
  m.measurement_datetime,
  m.measurement_time,
  m.measurement_type_concept_id,
  m.operator_concept_id,
  m.value_as_number,
  m.value_as_concept_id,
  m.unit_concept_id,
  m.range_low,
  m.range_high,
  m.provider_id,
  m.visit_occurrence_id,
  m.visit_detail_id,
  m.measurement_source_value,
  m.measurement_source_concept_id,
  m.unit_source_value,
  m.unit_source_concept_id,
  m.value_source_value,
  m.meas_event_field_concept_id,
  m.measurement_event_id,
  m.unique_key,
  m.datasource,
  m.updated_at
from {{ source('omop', 'measurement') }} as m
inner join {{ source('omop', 'person') }}  as p
  on m.person_id = p.person_id
where
  m.measurement_id is not null
  and m.measurement_concept_id is not null
  and m.measurement_date >= cast(p.birth_datetime as date)
  and m.measurement_date <= {{ dbt.current_timestamp() }}
-- ToDo: Add a clause to exclude events after death
