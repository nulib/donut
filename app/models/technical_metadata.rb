class TechnicalMetadata < ActiveFedora::Base
  include Hydra::Works::WorkBehavior
  include ::Schemas::Technical::Exif

  property :file_set_id, predicate: ::RDF::Vocab::DC11.relation, multiple: false do |index|
    index.as :stored_searchable
  end
end
