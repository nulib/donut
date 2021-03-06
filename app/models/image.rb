# Generated via
#  `rails generate hyrax:work Image`
class Image < ActiveFedora::Base
  include ::Hyrax::WorkBehavior
  include ::Schemas::Administrative
  include ::Schemas::Workflow
  include ::Schemas::CommonMetadata
  include MicroserviceMinter
  include ::CommonIndexer::Base

  self.indexer = ImageIndexer
  DEFAULT_STATUS = 'Not started'.freeze
  DEFAULT_PRESERVATION_LEVEL = '1'.freeze

  validates :title, presence: { message: 'Your work must have a title.' }
  validates :accession_number, presence: { message: 'Accession number is required.' }, accession_number: true, on: :create
  validates :resource_type, resource_type: true
  validates :date_created, presence: { message: 'Date created is required' }, edtf_date: true
  validates :preservation_level, preservation_level: true
  validates :status, status: true
  validates :license, license: true
  validates :rights_statement, presence: { message: 'Rights statement is required' }, rights_statement: true

  after_initialize :default_values

  before_save :fetch_missing_labels

  after_save do
    ArkMintingService.mint_identifier_for(self) if ark.nil?
  end

  property :alternate_title, predicate: ::RDF::Vocab::DC.alternative, multiple: true do |index|
    index.as :stored_searchable
  end

  property :accession_number, predicate: ::RDF::URI('http://id.loc.gov/vocabulary/subjectSchemes/local'), multiple: false do |index|
    index.as :symbol
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

  property :genre, predicate: ::RDF::URI('http://www.europeana.eu/schemas/edm/hasType'), class_name: ControlledVocabularies::Base, multiple: true do |index|
    index.as :stored_searchable, :facetable
  end

  property :notes, predicate: ::RDF::Vocab::SKOS.note, multiple: true do |index|
    index.as :stored_searchable
  end

  property :physical_description_material, predicate: ::RDF::Vocab::DC.medium, multiple: true do |index|
    index.as :stored_searchable
  end

  property :physical_description_size, predicate: ::RDF::Vocab::Bibframe.extent, multiple: true do |index|
    index.as :stored_searchable
  end

  property :provenance, predicate: ::RDF::Vocab::DC.provenance, multiple: true do |index|
    index.as :stored_searchable
  end

  property :related_material, predicate: ::RDF::Vocab::DC.relation, multiple: true do |index|
    index.as :stored_searchable
  end

  property :rights_holder, predicate: ::RDF::Vocab::DC.rightsHolder, multiple: true do |index|
    index.as :stored_searchable
  end

  property :scope_and_contents, predicate: ::RDF::Vocab::SKOS.scopeNote, multiple: true do |index|
    index.as :stored_searchable
  end

  property :series, predicate: ::RDF::Vocab::Bibframe.series, multiple: true do |index|
    index.as :stored_searchable
  end

  property :style_period, predicate: ::RDF::URI('http://purl.org/vra/StylePeriod'), class_name: ControlledVocabularies::Base, multiple: true do |index|
    index.as :stored_searchable, :facetable
  end

  property :table_of_contents, predicate: ::RDF::Vocab::DC.tableOfContents, multiple: true do |index|
    index.as :stored_searchable
  end

  property :technique, predicate: ::RDF::URI('http://purl.org/vra/Technique'), class_name: ControlledVocabularies::Base, multiple: true do |index|
    index.as :stored_searchable, :facetable
  end

  property :nul_creator, predicate: ::Vocab::Donut.creator, multiple: true do |index|
    index.as :stored_searchable, :facetable
  end

  property :subject_topical, predicate: ::RDF::Vocab::DC.subject, class_name: ControlledVocabularies::Base, multiple: true do |index|
    index.as :stored_searchable, :facetable
  end

  property :nul_contributor, predicate: ::Vocab::Donut.contributor, multiple: true do |index|
    index.as :stored_searchable, :facetable
  end

  # This must come after the WorkBehavior because it finalizes the metadata
  # schema (by adding accepts_nested_attributes)
  include ::Hyrax::BasicMetadata

  id_blank = proc { |attributes| attributes[:id].blank? }

  self.controlled_properties += [:architect, :artist, :author, :based_near, :cartographer, :collector, :compiler,
                                 :composer, :contributor, :creator, :designer, :director, :distributor, :donor,
                                 :draftsman, :editor, :engraver, :genre, :illustrator, :language, :librettist,
                                 :musician, :performer, :photographer, :presenter, :printer, :printmaker, :producer,
                                 :production_manager, :screenwriter, :sculptor, :sponsor, :style_period,
                                 :subject_geographical, :subject_topical, :technique, :transcriber]

  self.controlled_properties.each do |property|
    accepts_nested_attributes_for property, reject_if: id_blank, allow_destroy: true
  end

  def default_values
    self.status ||= DEFAULT_STATUS
    self.preservation_level ||= DEFAULT_PRESERVATION_LEVEL
  end

  def to_common_index
    CommonIndexService.index(self)
  end

  def fetch_missing_labels
    tap do |i|
      i.attributes.each_pair do |_name, values|
        Array(values).each do |val|
          val.fetch if val.is_a?(ControlledVocabularies::Base) && !val.label_present
        end
      end
    end
  end

  def top_level_in_collection?(collection)
    return false unless member_of_collections.include?(collection)
    in_works.none? { |parent| parent.member_of_collections.include?(collection) }
  end

  apply_schema Schemas::CoreMetadata, Schemas::GeneratedResourceSchemaStrategy.new
end
