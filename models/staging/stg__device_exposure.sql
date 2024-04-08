select
  de.device_exposure_id,
  de.person_id,
  de.device_concept_id,
  de.device_exposure_start_date,
  de.device_exposure_start_datetime,
  de.device_exposure_end_date,
  de.device_exposure_end_datetime,
  de.device_type_concept_id,
  de.unique_device_id,
  de.production_id,
  de.quantity,
  de.provider_id,
  de.visit_occurrence_id,
  de.visit_detail_id,
  de.device_source_value,
  de.device_source_concept_id,
  de.unit_concept_id,
  de.unit_source_value,
  de.unit_source_concept_id
from {{ source('omop', 'device_exposure') }} as de
inner join {{ ref('stg__person') }} as p
  on de.person_id = p.person_id
inner join {{ ref('stg__visit_occurrence') }} as vo
  on de.visit_occurrence_id = vo.visit_occurrence_id
where
  de.device_exposure_start_date >= cast(p.birth_datetime as date)
  and de.device_exposure_start_date is not null
