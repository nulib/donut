# Generated via
#  `rails generate hyrax:work Image`
class Image < ActiveFedora::Base
  include ::Hyrax::WorkBehavior
  include MicroserviceMinter

  self.indexer = ImageIndexer
  # Change this to restrict which works can be added as a child.
  # self.valid_child_concerns = []
  validates :title, presence: { message: 'Your work must have a title.' }
  validates :accession_number, presence: { message: 'Your work must have an accession_number.' }

  self.human_readable_type = 'Image'

  after_save do
    ArkMintingService.mint_identifier_for(self) if ark.nil?
  end

  property :abstract, predicate: ::RDF::Vocab::DC.abstract, multiple: true do |index|
    index.as :stored_searchable
  end

  property :alternate_title, predicate: ::RDF::Vocab::DC.alternative, multiple: true do |index|
    index.as :stored_searchable
  end

  property :accession_number, predicate: ::RDF::URI('http://id.loc.gov/vocabulary/subjectSchemes/local'), multiple: false do |index|
    index.as :stored_searchable
  end

  property :ark, predicate: ::RDF::Vocab::DataCite.ark, multiple: false do |index|
    index.as :stored_searchable
  end

  property :call_number, predicate: ::RDF::Vocab::Bibframe.shelfMark, multiple: false do |index|
    index.as :stored_searchable
  end

  property :caption, predicate: ::RDF::Vocab::SCHEMA.caption, multiple: true do |index|
    index.as :stored_searchable
  end

  property :catalog_key, predicate: ::RDF::URI('http://www.w3.org/2002/07/owl#sameAs'), multiple: true do |index|
    index.as :stored_searchable
  end

  property :citation, predicate: ::RDF::Vocab::DC.bibliographicCitation, multiple: true do |index|
    index.as :stored_searchable
  end

  property :contributor_role, predicate: ::RDF::URI('http://example.com/donut/contributor/role'), multiple: true do |index|
    index.as :stored_searchable, :facetable
  end

  property :creator_role, predicate: ::RDF::Vocab::BF2.role, multiple: true do |index|
    index.as :stored_searchable, :facetable
  end

  property :genre, predicate: ::RDF::URI('http://www.europeana.eu/schemas/edm/hasType'), multiple: true do |index|
    index.as :stored_searchable, :facetable
  end

  property :physical_description, predicate: ::RDF::Vocab::Bibframe.extent, multiple: true do |index|
    index.as :stored_searchable
  end

  property :provenance, predicate: ::RDF::Vocab::DC.provenance, multiple: true do |index|
    index.as :stored_searchable
  end

  property :related_url_label, predicate: ::RDF::RDFS.label, multiple: true do |index|
    index.as :stored_searchable
  end

  property :rights_holder, predicate: ::RDF::Vocab::DC.rightsHolder, multiple: true do |index|
    index.as :stored_searchable
  end

  property :style_period, predicate: ::RDF::URI('http://purl.org/vra/StylePeriod'), multiple: true do |index|
    index.as :stored_searchable, :facetable
  end

  property :technique, predicate: ::RDF::URI('http://purl.org/vra/Technique'), multiple: true do |index|
    index.as :stored_searchable, :facetable
  end

  # This must come after the WorkBehavior because it finalizes the metadata
  # schema (by adding accepts_nested_attributes)
  include ::Hyrax::BasicMetadata
end
