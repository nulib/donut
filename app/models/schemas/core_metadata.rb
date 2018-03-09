module Schemas
  class CoreMetadata < ActiveTriples::Schema
    property :keyword,  predicate: ::RDF::Vocab::SCHEMA.keywords
    property :language, predicate: ::RDF::Vocab::DC11.language, class_name: ControlledVocabularies::Language
    property :subject, predicate: ::RDF::Vocab::DC11.subject, class_name: ControlledVocabularies::Subject
  end
end
