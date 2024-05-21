select
  de.drug_exposure_id,
  de.person_id,
  de.drug_concept_id,
  de.drug_exposure_start_date,
  de.drug_exposure_start_datetime,
  de.drug_exposure_end_date,
  de.drug_exposure_end_datetime,
  de.verbatim_end_date,
  de.drug_type_concept_id,
  de.stop_reason,
  de.refills,
  de.quantity,
  de.days_supply,
  de.sig,
  de.route_concept_id,
  de.lot_number,
  de.provider_id,
  de.visit_occurrence_id,
  de.visit_detail_id,
  de.drug_source_value,
  de.drug_source_concept_id,
  de.route_source_value,
  de.dose_unit_source_value
from {{ source('omop', 'drug_exposure') }} as de
inner join {{ ref('stg__person') }} as p
  on de.person_id = p.person_id
inner join {{ ref('stg__visit_occurrence') }} as vo
  on de.visit_occurrence_id = vo.visit_occurrence_id
where
  de.drug_exposure_start_date >= cast(p.birth_datetime as date)
  and de.drug_exposure_start_date is not null
  and
  de.drug_exposure_start_date
  >= '{{ var("minimum_observation_period_start_date") }}'
