{% test linked_model_date_comparison(model, column_name, other_model, other_column, fk, operator) %}

{# This tests uses operator to compare two columns in two models joined by fk #}

select
  {{ model.identifier }}_id,
  m1.{{ fk }},
  {{ column_name }},
  {{ other_column }},
  '{{ operator }}' as expectation
from {{ model }} as m1
join {{ other_model }} as m2
on m1.{{ fk }} = m2.{{ fk }}
{% if operator=='le' %}
  where to_date({{ column_name }}) > to_date({{ other_column }})
{% elif operator=='lt' %}
  where to_date({{ column_name }}) >= to_date({{ other_column }})
{% elif operator=='ge' %}
  where to_date({{ column_name }}) < to_date({{ other_column }})
{% elif operator=='gt' %}
  where to_date({{ column_name }}) <= to_date({{ other_column }})
{% elif operator=='eq' %}
  where to_date({{ column_name }}) != to_date({{ other_column }})
{% endif %}

{% endtest %}
