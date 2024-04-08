{{
  config(
    materialized = 'table',
    )
}}

with gold_visits as (
  select
    vo.visit_occurrence_id,
    vo.person_id,
    vo.visit_concept_id,
    vo.visit_start_date,
    vo.visit_start_datetime,
    case
      when vo.visit_end_date is not null then vo.visit_end_date
      when
        vo.visit_source_value = 'PUI' and d.death_datetime is not null
        then cast(d.death_datetime as date)
      when vo.visit_source_value = 'PUI' then cast(getdate() as date)
    end as visit_end_date,
    case
      when vo.visit_end_date is not null then vo.visit_end_datetime
      when
        vo.visit_source_value = 'PUI' and d.death_datetime is not null
        then d.death_datetime
      when
        vo.visit_source_value = 'PUI'
        then cast(cast(getdate() as date) as datetime)
    end as visit_end_datetime,
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
  left join {{ source('omop', 'death') }} as d
    on vo.person_id = d.person_id
)

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
  lag(vo.visit_occurrence_id)
    over (partition by vo.person_id order by vo.visit_start_datetime)
    as preceding_visit_occurrence_id
from gold_visits as vo
inner join {{ ref('stg__person') }} as p
  on vo.person_id = p.person_id
left join {{ ref('stg__death') }} as d
  on vo.person_id = d.person_id
where
  vo.visit_start_date >= cast(p.birth_datetime as date)
  and (vo.visit_start_datetime >= p.birth_datetime or vo.visit_start_datetime is null)
  and (vo.visit_start_date <= d.death_date or d.death_date is null)
  and vo.visit_end_date is not null
  and vo.visit_end_datetime is not null
  and vo.visit_end_date >= cast(p.birth_datetime as date)
  and (vo.visit_end_date <= d.death_date or d.death_date is null)
  and vo.visit_end_date <= {{ dbt.current_timestamp() }}
  and vo.visit_end_datetime <= {{ dbt.current_timestamp() }}
  and vo.visit_concept_id is not null
