select
  vd.visit_detail_id,
  vd.person_id,
  vd.visit_detail_concept_id,
  vd.visit_detail_start_date,
  vd.visit_detail_start_datetime,
  vd.visit_detail_end_date,
  vd.visit_detail_end_datetime,
  vd.visit_detail_type_concept_id,
  vd.provider_id,
  vd.care_site_id,
  vd.visit_detail_source_value,
  vd.visit_detail_source_concept_id,
  vd.admitted_from_concept_id,
  vd.admitted_from_source_value,
  vd.discharged_to_source_value,
  vd.discharged_to_concept_id,
  vd.preceding_visit_detail_id,
  vd.parent_visit_detail_id,
  vd.visit_occurrence_id
from {{ source('omop', 'visit_detail') }} as vd
-- the inner join is on clean visit_occurrences
inner join {{ ref('visit_occurrence') }} as vo
where vd.visit_occurrence_id = vo.visit_occurrence_id
