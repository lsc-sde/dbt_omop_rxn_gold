select
  m.metadata_id,
  m.metadata_concept_id,
  m.metadata_type_concept_id
  m.value_as_string,
  m.value_as_concept_id,
  m.value_as_number,
  m.metadata_date,
  m.metadata_datetime
from {{ source('omop', 'metadata') }} as m
