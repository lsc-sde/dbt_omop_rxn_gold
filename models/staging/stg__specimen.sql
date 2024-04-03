select
  sp.specimen_id,
  sp.person_id,
  sp.specimen_concept_id,
  sp.specimen_type_concept_id,
  sp.specimen_date,
  sp.specimen_datetime,
  sp.quantity,
  sp.unit_concept_id,
  sp.anatomic_site_concept_id,
  sp.disease_status_concept_id,
  sp.specimen_source_id,
  sp.specimen_source_value,
  sp.unit_source_value,
  sp.anatomic_site_source_value,
  sp.disease_status_source_value
from {{ source('omop', 'specimen') }} as sp
inner join {{ source('omop', 'person') }} as p
  on sp.person_id = p.person_id
where
  exists (
    select 1
    from {{ ref('stg__persons_with_facts') }} as p
    where p.person_id = sp.person_id
  )
  and sp.specimen_date >= cast(p.birth_datetime as date)
