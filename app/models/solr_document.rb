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

  def abstract
    fetch(Solrizer.solr_name('abstract', :stored_searchable), [])
  end

  def accession_number
    fetch(Solrizer.solr_name('accession_number', :stored_searchable), [])
  end

  def call_number
    fetch(Solrizer.solr_name('call_number', :stored_searchable), [])
  end

  def catalog_key
    fetch(Solrizer.solr_name('catalog_key', :stored_searchable), [])
  end

  def citation
    fetch(Solrizer.solr_name('citation', :stored_searchable), [])
  end

  def contributor_role
    fetch(Solrizer.solr_name('contributor_role', :stored_searchable), [])
  end

  def creator_attribution
    fetch(Solrizer.solr_name('creator_attribution', :stored_searchable), [])
  end

  def creator_role
    fetch(Solrizer.solr_name('creator_role', :stored_searchable), [])
  end

  def genre
    fetch(Solrizer.solr_name('contributor_role', :stored_searchable), [])
  end

  def physical_description
    fetch(Solrizer.solr_name('physical_description', :stored_searchable), [])
  end

  def related_url_label
    fetch(Solrizer.solr_name('related_url_label', :stored_searchable), [])
  end

  def rights_holder
    fetch(Solrizer.solr_name('rights_holder', :stored_searchable), [])
  end

  def style_period
    fetch(Solrizer.solr_name('style_period', :stored_searchable), [])
  end

  def technique
    fetch(Solrizer.solr_name('technique', :stored_searchable), [])
  end
end
