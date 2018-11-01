module Schemas
  class CoreMetadata < ActiveTriples::Schema
    property :based_near, predicate: ::RDF::Vocab::FOAF.based_near, class_name: ControlledVocabularies::Base
    property :contributor, predicate: ::RDF::Vocab::DC11.contributor, class_name: ControlledVocabularies::Base do |index|
      index.as :stored_searchable, :facetable
    end
    property :creator, predicate: ::RDF::Vocab::DC11.creator, class_name: ControlledVocabularies::Base do |index|
      index.as :stored_searchable, :facetable
    end
    property :keyword, predicate: ::RDF::Vocab::SCHEMA.keywords
    property :language, predicate: ::RDF::Vocab::DC.language, class_name: ControlledVocabularies::Base
    property :license, predicate: ::RDF::Vocab::DC.license
  end
end
