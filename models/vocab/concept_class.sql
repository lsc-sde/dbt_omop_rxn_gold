select
  cc.concept_class_id,
  cc.concept_class_name,
  cc.concept_class_concept_id
from {{ source('vocab', 'concept_class') }} as cc
