module Schemas
  class CoreMetadata < ActiveTriples::Schema
    property :language, predicate: ::RDF::Vocab::DC11.language, class_name: ControlledVocabularies::Language
  end
end
