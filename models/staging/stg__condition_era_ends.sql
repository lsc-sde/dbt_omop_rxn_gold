{{
  config(
    materialized = "table",
    tags = ['omop', 'era', 'condition']
    )
}}

SELECT
  c.PERSON_ID,
  c.CONDITION_CONCEPT_ID,
  c.CONDITION_START_DATE,
  MIN(e.END_DATE) AS ERA_END_DATE
FROM {{ ref('stg__condition_era_target') }} AS c
INNER JOIN {{ ref('stg__condition_era_end_dates') }} AS e
  ON
    c.PERSON_ID = e.PERSON_ID
    AND c.CONDITION_CONCEPT_ID = e.CONDITION_CONCEPT_ID
    AND e.END_DATE >= c.CONDITION_START_DATE
GROUP BY
  c.PERSON_ID,
  c.CONDITION_CONCEPT_ID,
  c.CONDITION_START_DATE
