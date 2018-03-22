class TechnicalMetadata < ActiveFedora::Base
  include Hydra::Works::WorkBehavior
  include ::Schemas::Technical::Exif
end