# Generated by hyrax:models:install
class FileSet < ActiveFedora::Base
  include ::Hyrax::FileSetBehavior
  include MicroserviceMinter

  def to_solr(solr_doc = {})
    super(solr_doc).tap do |doc|
      # This file set gets created pretty early on in the actor stack
      # before the CreateDerivativesJob is run and to_solr gets run
      # both times. We want to skip solrizing this stuff on the first
      # to_solr call
      unless technical_metadata.blank?
        doc[Solrizer.solr_name('exifImageWidth', :stored_searchable)] = technical_metadata.image_width
        doc[Solrizer.solr_name('exifImageHeight', :stored_searchable)] = technical_metadata.image_height
        doc[Solrizer.solr_name('exifCompression', :stored_searchable)] = technical_metadata.compression
        doc[Solrizer.solr_name('photometricInterpretation', :stored_searchable)] = technical_metadata.photometric_interpretation
        doc[Solrizer.solr_name('samplesPerPixel', :stored_searchable)] = technical_metadata.samples_per_pixel
        doc[Solrizer.solr_name('xResolution', :stored_searchable)] = technical_metadata.x_resolution
        doc[Solrizer.solr_name('yResolution', :stored_searchable)] = technical_metadata.y_resolution
        doc[Solrizer.solr_name('resolutionUnit', :stored_searchable)] = technical_metadata.resolution_unit
        doc[Solrizer.solr_name('dateTime', :stored_searchable)] = technical_metadata.date_time
        doc[Solrizer.solr_name('bitsPerSample', :stored_searchable)] = technical_metadata.bits_per_sample
        doc[Solrizer.solr_name('make', :stored_searchable)] = technical_metadata.make
        doc[Solrizer.solr_name('model', :stored_searchable)] = technical_metadata.model
        doc[Solrizer.solr_name('stripOffsets', :stored_searchable)] = technical_metadata.strip_offsets
        doc[Solrizer.solr_name('rowsPerStrip', :stored_searchable)] = technical_metadata.rows_per_strip
        doc[Solrizer.solr_name('stripByteCounts', :stored_searchable)] = technical_metadata.strip_byte_counts
        doc[Solrizer.solr_name('software', :stored_searchable)] = technical_metadata.software
        doc[Solrizer.solr_name('extraSamples', :stored_searchable)] = technical_metadata.extra_samples
        doc[Solrizer.solr_name('exifToolVersion', :stored_searchable)] = technical_metadata.exif_tool_version
        doc[Solrizer.solr_name('exifAllData', :stored_searchable)] = technical_metadata.exif_all_data
      end
    end
  end

  def technical_metadata
    # we have to do a .first on the set resulting from this query since
    # it returns a relation and not an instance of the TechMD class
    @techmd || @techmd = TechnicalMetadata.where(file_set_id: self.id).first
  end
end
