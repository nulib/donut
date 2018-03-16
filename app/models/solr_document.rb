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

  attribute :language_label, Solr::Array, solr_name('language_label')
  attribute :style_period_label, Solr::Array, solr_name('style_period_label')
  attribute :genre_label, Solr::Array, solr_name('genre_label')
  attribute :technique_label, Solr::Array, solr_name('technique_label')
  attribute :subject_topical_label, Solr::Array, solr_name('subject_topical_label')

  # CommonMetadata attributes
  attribute :architect, Solr::Array, solr_name('architect_label')
  attribute :artist, Solr::Array, solr_name('artist_label')
  attribute :author, Solr::Array, solr_name('author_label')
  attribute :cartographer, Solr::Array, solr_name('cartographer_label')
  attribute :compiler, Solr::Array, solr_name('compiler_label')
  attribute :composer, Solr::Array, solr_name('composer_label')
  attribute :designer, Solr::Array, solr_name('designer_label')
  attribute :director, Solr::Array, solr_name('director_label')
  attribute :draftsman, Solr::Array, solr_name('draftsman_label')
  attribute :editor, Solr::Array, solr_name('editor_label')
  attribute :engraver, Solr::Array, solr_name('engraver_label')
  attribute :illustrator, Solr::Array, solr_name('illustrator_label')
  attribute :librettist, Solr::Array, solr_name('librettist_label')
  attribute :performer, Solr::Array, solr_name('performer_label')
  attribute :photographer, Solr::Array, solr_name('photographer_label')
  attribute :presenter, Solr::Array, solr_name('presenter_label')
  attribute :printer, Solr::Array, solr_name('printer_label')
  attribute :printmaker, Solr::Array, solr_name('printmaker_label')
  attribute :producer, Solr::Array, solr_name('producer_label')
  attribute :production_manager, Solr::Array, solr_name('production_manager_label')
  attribute :screenwriter, Solr::Array, solr_name('screenwriter_label')
  attribute :sculptor, Solr::Array, solr_name('sculptor_label')
  attribute :sponsor, Solr::Array, solr_name('sponsor_label')

  def abstract
    fetch(Solrizer.solr_name('abstract', :stored_searchable), [])
  end

  def accession_number
    fetch(Solrizer.solr_name('accession_number', :stored_searchable), [])
  end

  def alternate_title
    fetch(Solrizer.solr_name('alternate_title', :stored_searchable), [])
  end

  def ark
    fetch(Solrizer.solr_name('ark', :stored_searchable), [])
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

  def citation
    fetch(Solrizer.solr_name('citation', :stored_searchable), [])
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

  def physical_description
    fetch(Solrizer.solr_name('physical_description', :stored_searchable), [])
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
  def architect
    fetch(Solrizer.solr_name('architect', :stored_searchable), [])
  end

  def artist
    fetch(Solrizer.solr_name('artist', :stored_searchable), [])
  end

  def author
    fetch(Solrizer.solr_name('author', :stored_searchable), [])
  end

  def cartographer
    fetch(Solrizer.solr_name('cartographer', :stored_searchable), [])
  end

  def compiler
    fetch(Solrizer.solr_name('compiler', :stored_searchable), [])
  end

  def composer
    fetch(Solrizer.solr_name('composer', :stored_searchable), [])
  end

  def designer
    fetch(Solrizer.solr_name('designer', :stored_searchable), [])
  end

  def director
    fetch(Solrizer.solr_name('director', :stored_searchable), [])
  end

  def draftsman
    fetch(Solrizer.solr_name('draftsman', :stored_searchable), [])
  end

  def editor
    fetch(Solrizer.solr_name('editor', :stored_searchable), [])
  end

  def engraver
    fetch(Solrizer.solr_name('engraver', :stored_searchable), [])
  end

  def illustrator
    fetch(Solrizer.solr_name('illustrator', :stored_searchable), [])
  end

  def librettist
    fetch(Solrizer.solr_name('librettist', :stored_searchable), [])
  end

  def performer
    fetch(Solrizer.solr_name('performer', :stored_searchable), [])
  end

  def photographer
    fetch(Solrizer.solr_name('photographer', :stored_searchable), [])
  end

  def presenter
    fetch(Solrizer.solr_name('presenter', :stored_searchable), [])
  end

  def printer
    fetch(Solrizer.solr_name('printer', :stored_searchable), [])
  end

  def printmaker
    fetch(Solrizer.solr_name('printmaker', :stored_searchable), [])
  end

  def producer
    fetch(Solrizer.solr_name('producer', :stored_searchable), [])
  end

  def production_manager
    fetch(Solrizer.solr_name('production_manager', :stored_searchable), [])
  end

  def screenwriter
    fetch(Solrizer.solr_name('screenwriter', :stored_searchable), [])
  end

  def sculptor
    fetch(Solrizer.solr_name('sculptor', :stored_searchable), [])
  end

  def sponsor
    fetch(Solrizer.solr_name('sponsor', :stored_searchable), [])
  end
end
