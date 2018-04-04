module Schemas
  class CoreMetadata < ActiveTriples::Schema
    property :contributor, predicate: ::RDF::Vocab::DC11.contributor, class_name: ControlledVocabularies::Base do |index|
      index.as :stored_searchable, :facetable
    end
    property :creator, predicate: ::RDF::Vocab::DC11.creator, class_name: ControlledVocabularies::Base do |index|
      index.as :stored_searchable, :facetable
    end
    property :keyword, predicate: ::RDF::Vocab::SCHEMA.keywords
    property :language, predicate: ::RDF::Vocab::DC11.language, class_name: ControlledVocabularies::Base
  end
end
