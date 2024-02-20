select
  nn.note_nlp_id,
  nn.note_id,
  nn.section_concept_id,
  nn.snippet,
  nn.offset,
  nn.lexical_variant,
  nn.note_nlp_concept_id,
  nn.note_nlp_source_concept_id,
  nn.nlp_system,
  nn.nlp_date,
  nn.nlp_datetime,
  nn.term_exists,
  nn.term_temporal,
  nn.term_modifiers
from {{ source('omop', 'note_nlp') }} as nn
