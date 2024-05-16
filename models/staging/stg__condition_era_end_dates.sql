{{
  config(
    materialized = "table",
    tags = ['omop', 'era', 'condition']
    )
}}

select
  E.PERSON_ID,
  E.CONDITION_CONCEPT_ID,
  DATEADD(day, -30, E.EVENT_DATE) as END_DATE -- unpad the end date
from (
  select
    E1.PERSON_ID,
    E1.CONDITION_CONCEPT_ID,
    E1.EVENT_DATE,
    coalesce(E1.START_ORDINAL, MAX(E2.START_ORDINAL)) as START_ORDINAL,
    E1.OVERALL_ORD
  from (
    select
      PERSON_ID,
      CONDITION_CONCEPT_ID,
      EVENT_DATE,
      EVENT_TYPE,
      START_ORDINAL,
      row_number() over (
        partition by PERSON_ID,
        CONDITION_CONCEPT_ID order by
          EVENT_DATE,
          EVENT_TYPE
      ) as OVERALL_ORD -- this re-numbers the inner UNION so all rows are numbered ordered by the event date
    from (
      -- select the start dates, assigning a row number to each
      select
        PERSON_ID,
        CONDITION_CONCEPT_ID,
        CONDITION_START_DATE as EVENT_DATE,
        -1 as EVENT_TYPE,
        row_number() over (
          partition by PERSON_ID,
          CONDITION_CONCEPT_ID order by CONDITION_START_DATE
        ) as START_ORDINAL
      from {{ ref('stg__condition_era_target') }}

      union all

      -- pad the end dates by 30 to allow a grace period for overlapping ranges.
      select
        PERSON_ID,
        CONDITION_CONCEPT_ID,
        DATEADD(day, 30, CONDITION_END_DATE),
        1 as EVENT_TYPE,
        NULL
      from {{ ref('stg__condition_era_target') }}
    ) as RAWDATA
  ) as E1
  inner join (
    select
      PERSON_ID,
      CONDITION_CONCEPT_ID,
      CONDITION_START_DATE as EVENT_DATE,
      row_number() over (
        partition by PERSON_ID,
        CONDITION_CONCEPT_ID order by CONDITION_START_DATE
      ) as START_ORDINAL
    from {{ ref('stg__condition_era_target') }}
  ) as E2
    on
      E1.PERSON_ID = E2.PERSON_ID
      and E1.CONDITION_CONCEPT_ID = E2.CONDITION_CONCEPT_ID
      and E1.EVENT_DATE >= E2.EVENT_DATE
  group by
    E1.PERSON_ID,
    E1.CONDITION_CONCEPT_ID,
    E1.EVENT_DATE,
    E1.START_ORDINAL,
    E1.OVERALL_ORD
) as E
where (2 * E.START_ORDINAL) - E.OVERALL_ORD = 0
