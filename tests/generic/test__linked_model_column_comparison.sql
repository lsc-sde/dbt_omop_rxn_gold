{% test linked_model_column_comparison(model, column_name, other_model, other_column, fk, operator) %}

{# This tests uses operator to compare two columns in two models joined by fk #}

select
    m1.{{ fk }},
    {{ column_name }},
    {{ other_column }},
    '{{ operator }}' as expectation
from {{ model }} as m1
join {{ other_model }} as m2
on m1.{{ fk }} = m2.{{ fk }}
{% if operator=='le' %}
  where {{ column_name }} > {{ other_column }}
{% elif operator=='lt' %}
  where {{ column_name }} >= {{ other_column }}
{% elif operator=='ge' %}
  where {{ column_name }} < {{ other_column }}
{% elif operator=='gt' %}
  where {{ column_name }} <= {{ other_column }}
{% elif operator=='eq' %}
  where {{ column_name }} != {{ other_column }}
{% endif %}

{% endtest %}
