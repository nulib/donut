# frozen_string_literal: true

class SolrDocument
  include Blacklight::Solr::Document
  include Blacklight::Gallery::OpenseadragonSolrDocument

  # Adds Hyrax behaviors to the SolrDocument.
  include Hyrax::SolrDocumentBehavior

  # self.unique_key = 'id'

  # Email uses the semantic field mappings below to generate the body of an email.
  SolrDocument.use_extension(Blacklight::Document::Email)

  # SMS uses the semantic field mappings below to generate the body of an SMS email.
  SolrDocument.use_extension(Blacklight::Document::Sms)

  # DublinCore uses the semantic field mappings below to assemble an OAI-compliant Dublin Core document
  # Semantic mappings of solr stored fields. Fields may be multi or
  # single valued. See Blacklight::Document::SemanticFields#field_semantics
  # and Blacklight::Document::SemanticFields#to_semantic_values
  # Recommendation: Use field names from Dublin Core
  use_extension(Blacklight::Document::DublinCore)

  # Do content negotiation for AF models.

  use_extension(Hydra::ContentNegotiation)

  attribute :contributor_label, Solr::Array, solr_name('contributor_label')
  attribute :creator_label, Solr::Array, solr_name('creator_label')
  attribute :language_label, Solr::Array, solr_name('language_label')
  attribute :style_period_label, Solr::Array, solr_name('style_period_label')
  attribute :genre_label, Solr::Array, solr_name('genre_label')
  attribute :technique_label, Solr::Array, solr_name('technique_label')
  attribute :subject_topical_label, Solr::Array, solr_name('subject_topical_label')

  # CommonMetadata attributes
  attribute :subject_geographical_label, Solr::Array, solr_name('subject_geographical_label')
  attribute :architect_label, Solr::Array, solr_name('architect_label')
  attribute :artist_label, Solr::Array, solr_name('artist_label')
  attribute :author_label, Solr::Array, solr_name('author_label')
  attribute :cartographer_label, Solr::Array, solr_name('cartographer_label')
  attribute :compiler_label, Solr::Array, solr_name('compiler_label')
  attribute :composer_label, Solr::Array, solr_name('composer_label')
  attribute :designer_label, Solr::Array, solr_name('designer_label')
  attribute :director_label, Solr::Array, solr_name('director_label')
  attribute :draftsman_label, Solr::Array, solr_name('draftsman_label')
  attribute :editor_label, Solr::Array, solr_name('editor_label')
  attribute :engraver_label, Solr::Array, solr_name('engraver_label')
  attribute :illustrator_label, Solr::Array, solr_name('illustrator_label')
  attribute :librettist_label, Solr::Array, solr_name('librettist_label')
  attribute :performer_label, Solr::Array, solr_name('performer_label')
  attribute :photographer_label, Solr::Array, solr_name('photographer_label')
  attribute :presenter_label, Solr::Array, solr_name('presenter_label')
  attribute :printer_label, Solr::Array, solr_name('printer_label')
  attribute :printmaker_label, Solr::Array, solr_name('printmaker_label')
  attribute :producer_label, Solr::Array, solr_name('producer_label')
  attribute :production_manager_label, Solr::Array, solr_name('production_manager_label')
  attribute :screenwriter_label, Solr::Array, solr_name('screenwriter_label')
  attribute :sculptor_label, Solr::Array, solr_name('sculptor_label')
  attribute :sponsor_label, Solr::Array, solr_name('sponsor_label')

  def date_created_display
    fetch(Solrizer.solr_name('date_created_display', :stored_searchable), [])
  end

  def abstract
    fetch(Solrizer.solr_name('abstract', :stored_searchable), [])
  end

  def accession_number
    fetch(Solrizer.solr_name('accession_number', :symbol), [])
  end

  def alternate_title
    fetch(Solrizer.solr_name('alternate_title', :stored_searchable), [])
  end

  def ark
    fetch(Solrizer.solr_name('ark', :stored_searchable), [])
  end

  def bibliographic_citation
    fetch(Solrizer.solr_name('bibliographic_citation', :stored_searchable), [])
  end

  def box_name
    fetch(Solrizer.solr_name('box_name', :stored_searchable), [])
  end

  def box_number
    fetch(Solrizer.solr_name('box_number', :stored_searchable), [])
  end

  def call_number
    fetch(Solrizer.solr_name('call_number', :stored_searchable), [])
  end

  def caption
    fetch(Solrizer.solr_name('caption', :stored_searchable), [])
  end

  def catalog_key
    fetch(Solrizer.solr_name('catalog_key', :stored_searchable), [])
  end

  def contributor_label
    fetch(Solrizer.solr_name('contributor_label', :stored_searchable), [])
  end

  def creator_label
    fetch(Solrizer.solr_name('creator_label', :stored_searchable), [])
  end

  def folder_name
    fetch(Solrizer.solr_name('folder_name', :stored_searchable), [])
  end

  def folder_number
    fetch(Solrizer.solr_name('folder_number', :stored_searchable), [])
  end

  def genre
    fetch(Solrizer.solr_name('genre', :stored_searchable), [])
  end

  def nul_contributor
    fetch(Solrizer.solr_name('nul_contributor', :stored_searchable), [])
  end

  def nul_creator
    fetch(Solrizer.solr_name('nul_creator', :stored_searchable), [])
  end

  def nul_use_statement
    fetch(Solrizer.solr_name('nul_use_statement', :stored_searchable), [])
  end

  def physical_description_material
    fetch(Solrizer.solr_name('physical_description_material', :stored_searchable), [])
  end

  def physical_description_size
    fetch(Solrizer.solr_name('physical_description_size', :stored_searchable), [])
  end

  def preservation_level
    fetch(Solrizer.solr_name('preservation_level', :stored_searchable), [])
  end

  def project_cycle
    fetch(Solrizer.solr_name('project_cycle', :stored_searchable), [])
  end

  def project_name
    fetch(Solrizer.solr_name('project_name', :stored_searchable), [])
  end

  def project_description
    fetch(Solrizer.solr_name('project_description', :stored_searchable), [])
  end

  def project_manager
    fetch(Solrizer.solr_name('project_manager', :stored_searchable), [])
  end

  def proposer
    fetch(Solrizer.solr_name('proposer', :stored_searchable), [])
  end

  def provenance
    fetch(Solrizer.solr_name('provenance', :stored_searchable), [])
  end

  def rights_holder
    fetch(Solrizer.solr_name('rights_holder', :stored_searchable), [])
  end

  def status
    fetch(Solrizer.solr_name('status', :stored_searchable), [])
  end

  def style_period
    fetch(Solrizer.solr_name('style_period', :stored_searchable), [])
  end

  def subject_geographical_label
    fetch(Solrizer.solr_name('subject_geographical_label', :stored_searchable), [])
  end

  def subject_temporal
    fetch(Solrizer.solr_name('subject_temporal', :stored_searchable), [])
  end

  def subject_topical_label
    fetch(Solrizer.solr_name('subject_topical_label', :stored_searchable), [])
  end

  def task_number
    fetch(Solrizer.solr_name('task_number', :stored_searchable), [])
  end

  def technique
    fetch(Solrizer.solr_name('technique', :stored_searchable), [])
  end

  # CommonMetadata methods
  def architect_label
    fetch(Solrizer.solr_name('architect_label', :stored_searchable), [])
  end

  def artist_label
    fetch(Solrizer.solr_name('artist_label', :stored_searchable), [])
  end

  def author_label
    fetch(Solrizer.solr_name('author_label', :stored_searchable), [])
  end

  def cartographer_label
    fetch(Solrizer.solr_name('cartographer_label', :stored_searchable), [])
  end

  def compiler_label
    fetch(Solrizer.solr_name('compiler_label', :stored_searchable), [])
  end

  def composer_label
    fetch(Solrizer.solr_name('composer_label', :stored_searchable), [])
  end

  def designer_label
    fetch(Solrizer.solr_name('designer_label', :stored_searchable), [])
  end

  def director_label
    fetch(Solrizer.solr_name('director_label', :stored_searchable), [])
  end

  def draftsman_label
    fetch(Solrizer.solr_name('draftsman_label', :stored_searchable), [])
  end

  def editor_label
    fetch(Solrizer.solr_name('editor_label', :stored_searchable), [])
  end

  def engraver_label
    fetch(Solrizer.solr_name('engraver_label', :stored_searchable), [])
  end

  def illustrator_label
    fetch(Solrizer.solr_name('illustrator_label', :stored_searchable), [])
  end

  def librettist_label
    fetch(Solrizer.solr_name('librettist_label', :stored_searchable), [])
  end

  def notes
    fetch(Solrizer.solr_name('notes', :stored_searchable), [])
  end

  def performer_label
    fetch(Solrizer.solr_name('performer_label', :stored_searchable), [])
  end

  def photographer_label
    fetch(Solrizer.solr_name('photographer_label', :stored_searchable), [])
  end

  def presenter_label
    fetch(Solrizer.solr_name('presenter_label', :stored_searchable), [])
  end

  def printer_label
    fetch(Solrizer.solr_name('printer_label', :stored_searchable), [])
  end

  def printmaker_label
    fetch(Solrizer.solr_name('printmaker_label', :stored_searchable), [])
  end

  def producer_label
    fetch(Solrizer.solr_name('producer_label', :stored_searchable), [])
  end

  def production_manager_label
    fetch(Solrizer.solr_name('production_manager_label', :stored_searchable), [])
  end

  def related_material
    fetch(Solrizer.solr_name('related_material', :stored_searchable), [])
  end

  def scope_and_contents
    fetch(Solrizer.solr_name('scope_and_contents', :stored_searchable), [])
  end

  def screenwriter_label
    fetch(Solrizer.solr_name('screenwriter_label', :stored_searchable), [])
  end

  def sculptor_label
    fetch(Solrizer.solr_name('sculptor_label', :stored_searchable), [])
  end

  def sponsor_label
    fetch(Solrizer.solr_name('sponsor_label', :stored_searchable), [])
  end

  def series
    fetch(Solrizer.solr_name('series', :stored_searchable), [])
  end

  def table_of_contents
    fetch(Solrizer.solr_name('table_of_contents', :stored_searchable), [])
  end

  def photometric_interpretation
    fetch(Solrizer.solr_name('photometric_interpretation', :stored_searchable), [])
  end

  def samples_per_pixel
    fetch(Solrizer.solr_name('samples_per_pixel', :stored_searchable), [])
  end

  def x_resolution
    fetch(Solrizer.solr_name('x_resolution', :stored_searchable), [])
  end

  def y_resolution
    fetch(Solrizer.solr_name('y_resolution', :stored_searchable), [])
  end

  def resolution_unit
    fetch(Solrizer.solr_name('resolution_unit', :stored_searchable), [])
  end

  def date_time
    fetch(Solrizer.solr_name('date_time', :stored_searchable), [])
  end

  def bits_per_sample
    fetch(Solrizer.solr_name('bits_per_sample', :stored_searchable), [])
  end

  def make
    fetch(Solrizer.solr_name('make', :stored_searchable), [])
  end

  def model
    fetch(Solrizer.solr_name('model', :stored_searchable), [])
  end

  def strip_offsets
    fetch(Solrizer.solr_name('strip_offsets', :stored_searchable), [])
  end

  def rows_per_strip
    fetch(Solrizer.solr_name('rows_per_strip', :stored_searchable), [])
  end

  def strip_byte_counts
    fetch(Solrizer.solr_name('strip_byte_counts', :stored_searchable), [])
  end

  def icc_profile_description
    fetch(Solrizer.solr_name('icc_profile_description', :stored_searchable), [])
  end

  def donut_exif_version
    fetch(Solrizer.solr_name('donut_exif_version', :stored_searchable), [])
  end

  def exif_all_data
    fetch(Solrizer.solr_name('exif_all_data', :stored_searchable), [])
  end
end
