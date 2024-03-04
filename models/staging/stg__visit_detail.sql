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
-- keep only visit detail for clean visit occurrences
where
  exists (
    select 1
    from {{ ref('stg__visit_occurrence') }} as vo
    where vo.visit_occurrence_id = vd.visit_occurrence_id
  )
  and vd.visit_detail_end_date is not null
  and vd.visit_detail_end_datetime is not null
  and vd.visit_detail_end_date < {{ dbt.current_timestamp() }}
  and vd.visit_detail_end_datetime < {{ dbt.current_timestamp() }}
