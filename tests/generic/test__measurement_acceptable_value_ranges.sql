{% test measurement_acceptable_value_ranges(model, column_name, model_acceptable_ranges) %}

select
  m.measurement_id,
  m.measurement_concept_id,
  m.value_as_number,
  mar.lower_limit,
  mar.upper_limit
from {{ model }} as m
join {{ model_acceptable_ranges }} as mar
on mar.measurement_concept_id = m.measurement_concept_id
where {{ column_name }} < mar.lower_limit
or {{ column_name }} > mar.upper_limit

{% endtest %}
