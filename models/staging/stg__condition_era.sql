select distinct
  ce.condition_era_id,
  ce.person_id,
  ce.condition_concept_id,
  ce.condition_era_start_date,
  ce.condition_era_end_date,
  ce.condition_occurrence_count
from {{ source('omop', 'condition_era') }} as ce
inner join {{ ref('stg__person') }} as p
  on ce.person_id = p.person_id
where
  ce.condition_era_start_date >= cast(p.birth_datetime as date)
  and ce.condition_era_start_date <= {{ dbt.current_timestamp() }}
  and ce.condition_era_id is not null
  and ce.condition_concept_id is not null
  and ce.condition_era_start_date is not null
  and ce.condition_era_end_date is not null
