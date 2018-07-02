# This module points the FileSet to the location of the technical metdata.
# By default, the file holding the metadata is :original_file and the terms
# are listed under ::characterization_terms.
# Implementations may define their own terms or use a different source file, but
# any terms must be set on the ::characterization_proxy by the Hydra::Works::CharacterizationService
#
# class MyFileSet
#   include Hyrax::FileSetBehavior
# end
#
# MyFileSet.characterization_proxy = :master_file
# MyFileSet.characterization_terms = [:term1, :term2, :term3]
module Hyrax
  module FileSet
    module Characterization
      extend ActiveSupport::Concern

      included do
        class_attribute :characterization_terms, :characterization_proxy
        self.characterization_terms = [
          :format_label, :file_size, :height, :width, :filename, :well_formed,
          :page_count, :file_title, :last_modified, :original_checksum,
          :duration, :sample_rate, :compression, :photometric_interpretation,
          :samples_per_pixel, :x_resolution, :y_resolution, :resolution_unit,
          :date_time, :bits_per_sample, :make, :model, :strip_offsets,
          :rows_per_strip, :strip_byte_counts, :icc_profile_description,
          :donut_exif_version, :exif_all_data
        ]
        self.characterization_proxy = :original_file

        delegate(*characterization_terms, to: :characterization_proxy)

        def characterization_proxy
          send(self.class.characterization_proxy) || NullCharacterizationProxy.new
        end

        def characterization_proxy?
          !characterization_proxy.is_a?(NullCharacterizationProxy)
        end

        def mime_type
          @mime_type ||= characterization_proxy.mime_type
        end
      end

      class NullCharacterizationProxy
        def method_missing(*_args) # rubocop:disable Style/MethodMissing
          []
        end

        def respond_to_missing?(_method_name, _include_private = false)
          super
        end

        def mime_type; end
      end
    end
  end
end
