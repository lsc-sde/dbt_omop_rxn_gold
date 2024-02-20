{%- macro get_observation_period(model, start_date, end_date) -%}
with cte_1 as (
    select
        t.person_id ,
        case
            when
              {{ start_date }} >= '{{ var("minimum_observation_period_start_date") }}'
              and {{ start_date }} <= getdate()
              then {{ start_date }}
            else null
        end as observation_period_start_date ,
        case
            when {{ end_date }} >= '{{ var("minimum_observation_period_start_date") }}'
            and {{ end_date }} <= getdate()
            then {{ end_date }}
            else null
        end as observation_period_end_date
    from {{ ref(model) }} t
  ),
cte_2 as (
  select
    distinct person_id ,
    coalesce(observation_period_start_date, observation_period_end_date) as observation_period_start_date,
    coalesce(observation_period_end_date, observation_period_start_date) as observation_period_end_date
  from
    cte_1
  where
    observation_period_start_date is not null
    or observation_period_end_date is not null
),
cte as (
  select
    distinct person_id,
    date_trunc('MONTH', observation_period_start_date)  as observation_period_start_date,
    last_day(observation_period_end_date)  as observation_period_end_date
  from
    cte_2
)
{%- endmacro %}
