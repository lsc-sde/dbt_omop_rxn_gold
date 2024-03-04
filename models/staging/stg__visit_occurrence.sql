select
  vo.visit_occurrence_id,
  vo.person_id,
  vo.visit_concept_id,
  vo.visit_start_date,
  vo.visit_start_datetime,
  vo.visit_end_date,
  vo.visit_end_datetime,
  vo.visit_type_concept_id,
  vo.provider_id,
  vo.care_site_id,
  vo.visit_source_value,
  vo.visit_source_concept_id,
  vo.admitted_from_concept_id,
  vo.admitted_from_source_value,
  vo.discharged_to_concept_id,
  vo.discharged_to_source_value,
  vo.preceding_visit_occurrence_id
from {{ source('omop', 'visit_occurrence') }} as vo
inner join {{ source('omop', 'person') }} as p
  on vo.person_id = p.person_id
where
  exists (select 1 from {{ ref('stg__persons_with_facts') }} as p where p.person_id = vo.person_id )
  and vo.visit_start_date >= cast(p.birth_datetime as date)
  -- OHDSI requires all visits are complete
  and vo.visit_end_date is not null
  and vo.visit_end_datetime is not null
  and vo.visit_end_date <= {{ dbt.current_timestamp() }}
  and vo.visit_end_datetime <= {{ dbt.current_timestamp() }}
  and vo.visit_concept_id is not null

-- ToDo: Add a clause to exclude visits after death
