class CatalogController < ApplicationController
  include Hydra::Catalog
  include Hydra::Controller::ControllerBehavior

  # This filter applies the hydra access controls
  before_action :enforce_show_permissions, only: :show

  def self.uploaded_field
    solr_name('system_create', :stored_sortable, type: :date)
  end

  def self.modified_field
    solr_name('system_modified', :stored_sortable, type: :date)
  end

  configure_blacklight do |config|
    config.index.thumbnail_method = :render_thumbnail
    config.show.thumbnail_method = :render_thumbnail
    config.index.thumbnail_field = 'file_set_iiif_urls_ssim'
    config.http_method = :post
    config.view.gallery.partials = %i[index_header index]
    config.view.masonry.partials = [:index]
    config.view.slideshow.partials = [:index]

    config.show.tile_source_field = :content_metadata_image_iiif_info_ssm
    config.show.partials.insert(1, :openseadragon)
    config.search_builder_class = Hyrax::CatalogSearchBuilder

    # Show gallery view
    config.view.gallery.partials = %i[index_header index]
    config.view.slideshow.partials = [:index]

    ## Default parameters to send to solr for all search-like requests. See also SolrHelper#solr_search_params
    config.default_solr_params = {
      qt: 'search',
      rows: 10,
      qf: 'title_tesim description_tesim keyword_tesim'
    }

    # solr field configuration for document/show views
    config.index.title_field = solr_name('title', :stored_searchable)
    config.index.display_type_field = solr_name('has_model', :symbol)

    # solr fields that will be treated as facets by the blacklight application
    #   The ordering of the field names is the order of the display
    config.add_facet_field solr_name('human_readable_type', :facetable), label: 'Type', limit: 5
    config.add_facet_field solr_name('resource_type', :facetable), label: 'Resource Type', limit: 5
    config.add_facet_field solr_name('creator_label', :facetable), label: 'Creator', limit: 5
    config.add_facet_field solr_name('contributor_label', :facetable), label: 'Contributor', limit: 5
    config.add_facet_field solr_name('keyword', :facetable), limit: 5
    config.add_facet_field solr_name('subject', :facetable), label: 'Uncontrolled Subject', limit: 5
    config.add_facet_field solr_name('language_label', :facetable), label: 'Language', limit: 5
    config.add_facet_field solr_name('based_near_label', :facetable), label: 'Location (Place of Publication)', limit: 5
    config.add_facet_field solr_name('publisher', :facetable), limit: 5
    config.add_facet_field solr_name('file_format', :facetable), limit: 5
    config.add_facet_field solr_name('technique_label', :facetable), label: 'Technique', limit: 5
    config.add_facet_field solr_name('member_of_collections', :symbol), label: 'Collections', limit: 5
    config.add_facet_field solr_name('proposer', :facetable), label: 'Proposer', limit: 5
    config.add_facet_field solr_name('project_manager', :facetable), label: 'Project Manager', limit: 5
    config.add_facet_field solr_name('preservation_level', :facetable), label: 'Preservation Level', limit: 5
    config.add_facet_field solr_name('project_cycle', :facetable), label: 'Project Cycle', limit: 5
    config.add_facet_field solr_name('status', :facetable), label: 'Status', limit: 5
    config.add_facet_field solr_name('style_period_label', :facetable), label: 'Style Period', limit: 5
    config.add_facet_field solr_name('genre_label', :facetable), label: 'Genre', limit: 5
    config.add_facet_field solr_name('nul_creator', :facetable), label: 'Uncontrolled Creator', limit: 5
    config.add_facet_field solr_name('subject_topical_label', :facetable), label: 'Subject Topical', limit: 5
    config.add_facet_field solr_name('nul_contributor', :facetable), label: 'Uncontrolled Contributor', limit: 5

    # CommonMetadata facet fields
    config.add_facet_field solr_name('subject_geographical_label', :facetable), label: 'Subject Geographical', limit: 5
    config.add_facet_field solr_name('subject_temporal', :facetable), label: 'Subject Temporal', limit: 5

    config.add_facet_field solr_name('architect_label', :facetable), label: 'Architect', limit: 5
    config.add_facet_field solr_name('artist_label', :facetable), label: 'Artist', limit: 5
    config.add_facet_field solr_name('author_label', :facetable), label: 'Author', limit: 5
    config.add_facet_field solr_name('cartographer_label', :facetable), label: 'Cartographer', limit: 5
    config.add_facet_field solr_name('collector_label', :facetable), label: 'Collector', limit: 5
    config.add_facet_field solr_name('compiler_label', :facetable), label: 'Compiler', limit: 5
    config.add_facet_field solr_name('composer_label', :facetable), label: 'Composer', limit: 5
    config.add_facet_field solr_name('designer_label', :facetable), label: 'Designer', limit: 5
    config.add_facet_field solr_name('director_label', :facetable), label: 'Director', limit: 5
    config.add_facet_field solr_name('distributor_label', :facetable), label: 'Distributor', limit: 5
    config.add_facet_field solr_name('donor_label', :facetable), label: 'Donor', limit: 5
    config.add_facet_field solr_name('draftsman_label', :facetable), label: 'Draftsman', limit: 5
    config.add_facet_field solr_name('editor_label', :facetable), label: 'Editor', limit: 5
    config.add_facet_field solr_name('engraver_label', :facetable), label: 'Engraver', limit: 5
    config.add_facet_field solr_name('illustrator_label', :facetable), label: 'Illustrator', limit: 5
    config.add_facet_field solr_name('librettist_label', :facetable), label: 'Librettist', limit: 5
    config.add_facet_field solr_name('musician_label', :facetable), label: 'Musician', limit: 5
    config.add_facet_field solr_name('performer_label', :facetable), label: 'Performer', limit: 5
    config.add_facet_field solr_name('photographer_label', :facetable), label: 'Photographer', limit: 5
    config.add_facet_field solr_name('presenter_label', :facetable), label: 'Presenter', limit: 5
    config.add_facet_field solr_name('printer_label', :facetable), label: 'Printer', limit: 5
    config.add_facet_field solr_name('printmaker_label', :facetable), label: 'Printmaker', limit: 5
    config.add_facet_field solr_name('producer_label', :facetable), label: 'Producer', limit: 5
    config.add_facet_field solr_name('production_manager_label', :facetable), label: 'Production Manager', limit: 5
    config.add_facet_field solr_name('screenwriter_label', :facetable), label: 'Screenwriter', limit: 5
    config.add_facet_field solr_name('sculptor_label', :facetable), label: 'Sculptor', limit: 5
    config.add_facet_field solr_name('sponsor_label', :facetable), label: 'Sponsor', limit: 5
    config.add_facet_field solr_name('transcriber_label', :facetable), label: 'Transcriber', limit: 5

    # exif metadata
    config.add_facet_field solr_name('height', :facetable), label: 'Height', limit: 5
    config.add_facet_field solr_name('width', :facetable), label: 'Width', limit: 5
    config.add_facet_field solr_name('bits_per_sample', :facetable), label: 'Bits Per Sample', limit: 5
    config.add_facet_field solr_name('compression', :facetable), label: 'Compression', limit: 5
    config.add_facet_field solr_name('photometric_interpretation', :facetable), label: 'Photometric Interpretation', limit: 5
    config.add_facet_field solr_name('make', :facetable), label: 'Make', limit: 5
    config.add_facet_field solr_name('model', :facetable), label: 'Model', limit: 5
    config.add_facet_field solr_name('x_resolution', :facetable), label: 'X Resolution', limit: 5
    config.add_facet_field solr_name('y_resolution', :facetable), label: 'Y Resolution', limit: 5
    config.add_facet_field solr_name('icc_profile_description', :facetable), label: 'Profile Description', limit: 5

    # The generic_type isn't displayed on the facet list
    # It's used to give a label to the filter that comes from the user profile
    config.add_facet_field solr_name('generic_type', :facetable), if: false

    # Have BL send all facet field names to Solr, which has been the default
    # previously. Simply remove these lines if you'd rather use Solr request
    # handler defaults, or have no facets.
    config.add_facet_fields_to_solr_request!

    # solr fields to be displayed in the index (search results) view
    #   The ordering of the field names is the order of the display
    # rubocop:disable Metrics/LineLength
    config.add_index_field solr_name('title', :stored_searchable), label: 'Title', itemprop: 'name', if: false
    config.add_index_field solr_name('description', :stored_searchable), itemprop: 'description', helper_method: :iconify_auto_link
    config.add_index_field solr_name('keyword', :stored_searchable), itemprop: 'keywords', link_to_search: solr_name('keyword', :facetable)
    config.add_index_field solr_name('subject_topical_label', :stored_searchable), link_to_search: solr_name('subject_topical_label', :facetable)
    config.add_index_field solr_name('subject', :stored_searchable), label: 'Uncontrolled Subject', itemprop: 'about', link_to_search: solr_name('subject', :facetable)
    config.add_index_field solr_name('creator_label', :stored_searchable), label: 'Creator', link_to_search: solr_name('creator_label', :facetable)
    config.add_index_field solr_name('contributor_label', :stored_searchable), label: 'Contributor', link_to_search: solr_name('contributor_label', :facetable)
    config.add_index_field solr_name('proxy_depositor', :symbol), label: 'Depositor', helper_method: :link_to_profile
    config.add_index_field solr_name('depositor'), label: 'Owner', helper_method: :link_to_profile
    config.add_index_field solr_name('publisher', :stored_searchable), itemprop: 'publisher', link_to_search: solr_name('publisher', :facetable)
    config.add_index_field solr_name('based_near_label', :stored_searchable), label: 'Location (Place of Publication)', itemprop: 'contentLocation', link_to_search: solr_name('based_near_label', :facetable)
    config.add_index_field solr_name('language_label', :stored_searchable), label: 'Language', link_to_search: solr_name('language_label', :facetable)
    config.add_index_field solr_name('date_uploaded', :stored_sortable, type: :date), itemprop: 'datePublished', helper_method: :human_readable_date
    config.add_index_field solr_name('date_modified', :stored_sortable, type: :date), itemprop: 'dateModified', helper_method: :human_readable_date
    config.add_index_field solr_name('date_created_display', :stored_searchable), itemprop: 'dateCreated', label: 'Date Created'
    config.add_index_field solr_name('rights', :stored_searchable), helper_method: :license_links
    config.add_index_field solr_name('resource_type', :stored_searchable), label: 'Resource Type', link_to_search: solr_name('resource_type', :facetable)
    config.add_index_field solr_name('bibliographic_citation', :stored_searchable), label: 'Citation'
    config.add_index_field solr_name('file_format', :stored_searchable), link_to_search: solr_name('file_format', :facetable)
    config.add_index_field solr_name('identifier', :stored_searchable), helper_method: :index_field_link, field_name: 'identifier'
    config.add_index_field solr_name('embargo_release_date', :stored_sortable, type: :date), label: 'Embargo release date', helper_method: :human_readable_date
    config.add_index_field solr_name('lease_expiration_date', :stored_sortable, type: :date), label: 'Lease expiration date', helper_method: :human_readable_date
    config.add_index_field solr_name('preservation_level', :stored_searchable), label: 'Preservation level', link_to_search: solr_name('preservation_level', :facetable)
    config.add_index_field solr_name('proposer', :stored_searchable), label: 'Proposer', link_to_search: solr_name('proposer', :facetable)
    config.add_index_field solr_name('project_manager', :stored_searchable), label: 'Project manager', link_to_search: solr_name('project_manager', :facetable)
    config.add_index_field solr_name('project_cycle', :stored_searchable), label: 'Project cycle', link_to_search: solr_name('project_cycle', :facetable)
    config.add_index_field solr_name('status', :stored_searchable), label: 'Status', link_to_search: solr_name('status', :facetable)
    config.add_index_field solr_name('style_period_label', :stored_searchable), label: 'Style Period', link_to_search: solr_name('style_period_label', :facetable)
    config.add_index_field solr_name('genre_label', :stored_searchable), label: 'Genre', link_to_search: solr_name('genre_label', :facetable)
    config.add_index_field solr_name('technique_label', :stored_searchable), label: 'Technique', link_to_search: solr_name('technique_label', :facetable)
    config.add_index_field solr_name('physical_description_material', :stored_searchable), label: 'Physical Description Material', link_to_search: solr_name('physical_description_material', :facetable)
    config.add_index_field solr_name('physical_description_size', :stored_searchable), label: 'Physical Description Size', link_to_search: solr_name('physical_description_size', :facetable)
    config.add_index_field solr_name('abstract', :stored_searchable), label: 'Abstract'
    config.add_index_field solr_name('box_name', :stored_searchable), label: 'Box Name'
    config.add_index_field solr_name('box_number', :stored_searchable), label: 'Box Number'
    config.add_index_field solr_name('folder_name', :stored_searchable), label: 'Folder Name'
    config.add_index_field solr_name('folder_number', :stored_searchable), label: 'Folder Number'
    config.add_index_field solr_name('notes', :stored_searchable), label: 'Notes'
    config.add_index_field solr_name('related_material', :stored_searchable), label: 'Related Material'
    config.add_index_field solr_name('scope_and_contents', :stored_searchable), label: 'Scope and Contents'
    config.add_index_field solr_name('series', :stored_searchable), label: 'Series'
    config.add_index_field solr_name('table_of_contents', :stored_searchable), label: 'Table of Contents'
    config.add_index_field solr_name('legacy_identifier', :stored_searchable), label: 'Legacy Identifier'

    # CommonMetadata fields to display in search results
    config.add_index_field solr_name('nul_use_statement', :stored_searchable), label: 'NUL Use Statement'
    config.add_index_field solr_name('architect_label', :stored_searchable), link_to_search: solr_name('architect', :facetable), label: 'Architect'
    config.add_index_field solr_name('artist_label', :stored_searchable), link_to_search: solr_name('artist', :facetable), label: 'Artist'
    config.add_index_field solr_name('author_label', :stored_searchable), link_to_search: solr_name('author', :facetable), label: 'Author'
    config.add_index_field solr_name('cartographer_label', :stored_searchable), link_to_search: solr_name('cartographer', :facetable), label: 'Cartographer'
    config.add_index_field solr_name('collector_label', :stored_searchable), link_to_search: solr_name('collector', :facetable), label: 'Collector'
    config.add_index_field solr_name('compiler_label', :stored_searchable), link_to_search: solr_name('compiler', :facetable), label: 'Compiler'
    config.add_index_field solr_name('composer_label', :stored_searchable), link_to_search: solr_name('composer', :facetable), label: 'Composer'
    config.add_index_field solr_name('designer_label', :stored_searchable), link_to_search: solr_name('designer', :facetable), label: 'Designer'
    config.add_index_field solr_name('director_label', :stored_searchable), link_to_search: solr_name('director', :facetable), label: 'Director'
    config.add_index_field solr_name('distributor_label', :stored_searchable), link_to_search: solr_name('distributor', :facetable), label: 'Distributor'
    config.add_index_field solr_name('donor_label', :stored_searchable), link_to_search: solr_name('donor', :facetable), label: 'Donor'
    config.add_index_field solr_name('draftsman_label', :stored_searchable), link_to_search: solr_name('draftsman', :facetable), label: 'Draftsman'
    config.add_index_field solr_name('editor_label', :stored_searchable), link_to_search: solr_name('editor', :facetable), label: 'Editor'
    config.add_index_field solr_name('engraver_label', :stored_searchable), link_to_search: solr_name('engraver', :facetable), label: 'Engraver'
    config.add_index_field solr_name('illustrator_label', :stored_searchable), link_to_search: solr_name('illustrator', :facetable), label: 'Illustrator'
    config.add_index_field solr_name('librettist_label', :stored_searchable), link_to_search: solr_name('librettist', :facetable), label: 'Librettist'
    config.add_index_field solr_name('musician_label', :stored_searchable), link_to_search: solr_name('musician', :facetable), label: 'Musician'
    config.add_index_field solr_name('performer_label', :stored_searchable), link_to_search: solr_name('performer', :facetable), label: 'Performer'
    config.add_index_field solr_name('photographer_label', :stored_searchable), link_to_search: solr_name('photographer', :facetable), label: 'Photographer'
    config.add_index_field solr_name('presenter_label', :stored_searchable), link_to_search: solr_name('presenter', :facetable), label: 'Presenter'
    config.add_index_field solr_name('printer_label', :stored_searchable), link_to_search: solr_name('printer', :facetable), label: 'Printer'
    config.add_index_field solr_name('printmaker_label', :stored_searchable), link_to_search: solr_name('printmaker', :facetable), label: 'Printmaker'
    config.add_index_field solr_name('producer_label', :stored_searchable), link_to_search: solr_name('producer', :facetable), label: 'Producer'
    config.add_index_field solr_name('production_manager_label', :stored_searchable), link_to_search: solr_name('production_manager', :facetable), label: 'Production Manager'
    config.add_index_field solr_name('screenwriter_label', :stored_searchable), link_to_search: solr_name('screenwriter', :facetable), label: 'Screenwriter'
    config.add_index_field solr_name('sculptor_label', :stored_searchable), link_to_search: solr_name('sculptor', :facetable), label: 'Sculptor'
    config.add_index_field solr_name('sponsor_label', :stored_searchable), link_to_search: solr_name('sponsor', :facetable), label: 'Sponsor'
    config.add_index_field solr_name('transcriber_label', :stored_searchable), link_to_search: solr_name('transcriber', :facetable), label: 'Transcriber'
    # rubocop:enable Metrics/LineLength

    # solr fields to be displayed in the show (single result) view
    #   The ordering of the field names is the order of the display
    config.add_show_field solr_name('title', :stored_searchable)
    config.add_show_field solr_name('description', :stored_searchable)
    config.add_show_field solr_name('keyword', :stored_searchable)
    config.add_show_field solr_name('subject_topical_label', :stored_searchable), label: 'Subject Topical'
    config.add_show_field solr_name('subject', :stored_searchable), label: 'Uncontrolled Subject'
    config.add_show_field solr_name('bibliographic_citation', :stored_searchable), label: 'Citation'
    config.add_show_field solr_name('based_near_label', :stored_searchable), label: 'Location (Place of Publication)'
    config.add_show_field solr_name('creator_label', :stored_searchable), label: 'Creator'
    config.add_show_field solr_name('contributor_label', :stored_searchable), label: 'Contributor'
    config.add_show_field solr_name('publisher', :stored_searchable)
    config.add_show_field solr_name('language_label', :stored_searchable), label: 'Language'
    config.add_show_field solr_name('date_uploaded', :stored_searchable)
    config.add_show_field solr_name('date_modified', :stored_searchable)
    config.add_show_field solr_name('date_created_display', :stored_searchable), label: 'Date Created Display'
    config.add_show_field solr_name('rights', :stored_searchable)
    config.add_show_field solr_name('resource_type', :stored_searchable), label: 'Resource Type'
    config.add_show_field solr_name('format', :stored_searchable)
    config.add_show_field solr_name('identifier', :stored_searchable)
    config.add_show_field solr_name('project_name', :stored_searchable)
    config.add_show_field solr_name('project_description', :stored_searchable)
    config.add_show_field solr_name('proposer', :stored_searchable)
    config.add_show_field solr_name('project_manager', :stored_searchable)
    config.add_show_field solr_name('task_number', :stored_searchable)
    config.add_show_field solr_name('preservation_level', :stored_searchable)
    config.add_show_field solr_name('project_cycle', :stored_searchable)
    config.add_show_field solr_name('status', :stored_searchable)
    config.add_show_field solr_name('style_period_label', :stored_searchable), label: 'Style Period'
    config.add_show_field solr_name('genre_label', :stored_searchable), label: 'Genre'
    config.add_show_field solr_name('technique_label', :stored_searchable), label: 'Technique'
    config.add_show_field solr_name('physical_description_material', :stored_searchable), label: 'Physical Description Material'
    config.add_show_field solr_name('physical_description_size', :stored_searchable), label: 'Physical Description Size'
    config.add_show_field solr_name('abstract', :stored_searchable)
    config.add_show_field solr_name('box_name', :stored_searchable), label: 'Box Name'
    config.add_show_field solr_name('box_number', :stored_searchable), label: 'Box Number'
    config.add_show_field solr_name('folder_name', :stored_searchable), label: 'Folder Name'
    config.add_show_field solr_name('folder_number', :stored_searchable), label: 'Folder Number'
    config.add_show_field solr_name('legacy_identifier', :stored_searchable), label: 'Legacy Identifiers'

    # CommonMetadata fields for the single result view
    config.add_show_field solr_name('nul_use_statement', :stored_searchable)
    config.add_show_field solr_name('subject_geographical_label', :stored_searchable)
    config.add_show_field solr_name('subject_temporal', :stored_searchable)
    config.add_show_field solr_name('architect_label', :stored_searchable)
    config.add_show_field solr_name('artist_label', :stored_searchable)
    config.add_show_field solr_name('author_label', :stored_searchable)
    config.add_show_field solr_name('cartographer_label', :stored_searchable)
    config.add_show_field solr_name('collector_label', :stored_searchable)
    config.add_show_field solr_name('compiler_label', :stored_searchable)
    config.add_show_field solr_name('composer_label', :stored_searchable)
    config.add_show_field solr_name('designer_label', :stored_searchable)
    config.add_show_field solr_name('director_label', :stored_searchable)
    config.add_show_field solr_name('distributor_label', :stored_searchable)
    config.add_show_field solr_name('donor_label', :stored_searchable)
    config.add_show_field solr_name('draftsman_label', :stored_searchable)
    config.add_show_field solr_name('editor_label', :stored_searchable)
    config.add_show_field solr_name('engraver_label', :stored_searchable)
    config.add_show_field solr_name('illustrator_label', :stored_searchable)
    config.add_show_field solr_name('librettist_label', :stored_searchable)
    config.add_show_field solr_name('musician_label', :stored_searchable)
    config.add_show_field solr_name('performer_label', :stored_searchable)
    config.add_show_field solr_name('photographer_label', :stored_searchable)
    config.add_show_field solr_name('presenter_label', :stored_searchable)
    config.add_show_field solr_name('printer_label', :stored_searchable)
    config.add_show_field solr_name('printmaker_label', :stored_searchable)
    config.add_show_field solr_name('producer_label', :stored_searchable)
    config.add_show_field solr_name('production_manager_label', :stored_searchable)
    config.add_show_field solr_name('screenwriter_label', :stored_searchable)
    config.add_show_field solr_name('sculptor_label', :stored_searchable)
    config.add_show_field solr_name('sponsor_label', :stored_searchable)
    config.add_show_field solr_name('transcriber_label', :stored_searchable)

    # "fielded" search configuration. Used by pulldown among other places.
    # For supported keys in hash, see rdoc for Blacklight::SearchFields
    #
    # Search fields will inherit the :qt solr request handler from
    # config[:default_solr_parameters], OR can specify a different one
    # with a :qt key/value. Below examples inherit, except for subject
    # that specifies the same :qt as default for our own internal
    # testing purposes.
    #
    # The :key is what will be used to identify this BL search field internally,
    # as well as in URLs -- so changing it after deployment may break bookmarked
    # urls.  A display label will be automatically calculated from the :key,
    # or can be specified manually to be different.
    #
    # This one uses all the defaults set by the solr request handler. Which
    # solr request handler? The one set in config[:default_solr_parameters][:qt],
    # since we aren't specifying it otherwise.
    config.add_search_field('all_fields', label: 'All Fields') do |field|
      all_names = config.show_fields.values.map(&:field).join(' ')
      title_name = solr_name('title', :stored_searchable)
      field.solr_parameters = {
        qf: "#{all_names} file_format_tesim all_text_timv accession_number_ssim id",
        pf: title_name.to_s
      }
    end

    # Now we see how to over-ride Solr request handler defaults, in this
    # case for a BL "search field", which is really a dismax aggregate
    # of Solr search fields.
    # creator, title, description, publisher, date_created,
    # subject, language, resource_type, format, identifier, based_near,
    config.add_search_field('contributor') do |field|
      field.label = 'Contributor'
      solr_name = solr_name('contributor_label', :stored_searchable)
      field.solr_local_parameters = {
        qf: solr_name,
        pf: solr_name
      }
    end

    config.add_search_field('creator') do |field|
      field.label = 'Creator'
      solr_name = solr_name('creator_label', :stored_searchable)
      field.solr_local_parameters = {
        qf: solr_name,
        pf: solr_name
      }
    end

    config.add_search_field('title') do |field|
      solr_name = solr_name('title', :stored_searchable)
      field.solr_local_parameters = {
        qf: solr_name,
        pf: solr_name
      }
    end

    config.add_search_field('description') do |field|
      field.label = 'Abstract or Summary'
      solr_name = solr_name('description', :stored_searchable)
      field.solr_local_parameters = {
        qf: solr_name,
        pf: solr_name
      }
    end

    config.add_search_field('publisher') do |field|
      solr_name = solr_name('publisher', :stored_searchable)
      field.solr_local_parameters = {
        qf: solr_name,
        pf: solr_name
      }
    end

    config.add_search_field('date_created') do |field|
      solr_name = solr_name('created', :stored_searchable)
      field.solr_local_parameters = {
        qf: solr_name,
        pf: solr_name
      }
    end

    config.add_search_field('date_created_display') do |field|
      field.label = 'Date Created Display'
      solr_name = solr_name('date_created_display', :stored_searchable)
      field.solr_local_parameters = {
        qf: solr_name,
        pf: solr_name
      }
    end

    config.add_search_field('subject') do |field|
      solr_name = solr_name('subject_label', :stored_searchable)
      field.solr_local_parameters = {
        qf: solr_name,
        pf: solr_name
      }
    end

    config.add_search_field('language') do |field|
      solr_name = solr_name('language_label', :stored_searchable)
      field.solr_local_parameters = {
        qf: solr_name,
        pf: solr_name
      }
    end

    config.add_search_field('resource_type') do |field|
      solr_name = solr_name('resource_type', :stored_searchable)
      field.solr_local_parameters = {
        qf: solr_name,
        pf: solr_name
      }
    end

    config.add_search_field('format') do |field|
      solr_name = solr_name('format', :stored_searchable)
      field.solr_local_parameters = {
        qf: solr_name,
        pf: solr_name
      }
    end

    config.add_search_field('identifier') do |field|
      solr_name = solr_name('id', :stored_searchable)
      field.solr_local_parameters = {
        qf: solr_name,
        pf: solr_name
      }
    end

    config.add_search_field('based_near') do |field|
      field.label = 'Location'
      solr_name = solr_name('based_near_label', :stored_searchable)
      field.solr_local_parameters = {
        qf: solr_name,
        pf: solr_name
      }
    end

    config.add_search_field('style_period') do |field|
      field.label = 'Style Period'
      solr_name = solr_name('style_period_label', :stored_searchable)
      field.solr_local_parameters = {
        qf: solr_name,
        pf: solr_name
      }
    end

    config.add_search_field('technique') do |field|
      field.label = 'Technique'
      solr_name = solr_name('technique_label', :stored_searchable)
      field.solr_local_parameters = {
        qf: solr_name,
        pf: solr_name
      }
    end

    config.add_search_field('genre') do |field|
      field.label = 'Genre'
      solr_name = solr_name('genre_label', :stored_searchable)
      field.solr_local_parameters = {
        qf: solr_name,
        pf: solr_name
      }
    end

    config.add_search_field('keyword') do |field|
      solr_name = solr_name('keyword', :stored_searchable)
      field.solr_local_parameters = {
        qf: solr_name,
        pf: solr_name
      }
    end

    config.add_search_field('depositor') do |field|
      solr_name = solr_name('depositor', :symbol)
      field.solr_local_parameters = {
        qf: solr_name,
        pf: solr_name
      }
    end

    config.add_search_field('rights') do |field|
      solr_name = solr_name('rights', :stored_searchable)
      field.solr_local_parameters = {
        qf: solr_name,
        pf: solr_name
      }
    end

    # CommonMetadata fields

    config.add_search_field('nul_use_statement') do |field|
      field.label = 'NUL Use Statement'
      solr_name = solr_name('nul_use_statement', :stored_searchable)
      field.solr_local_parameters = {
        qf: solr_name,
        pf: solr_name
      }
    end

    config.add_search_field('subject_geographical') do |field|
      field.label = 'Subject Geographical'
      solr_name = solr_name('subject_geographical_label', :stored_searchable)
      field.solr_local_parameters = {
        qf: solr_name,
        pf: solr_name
      }
    end

    config.add_search_field('subject_temporal') do |field|
      field.label = 'Subject Temporal'
      solr_name = solr_name('subject_temporal', :stored_searchable)
      field.solr_local_parameters = {
        qf: solr_name,
        pf: solr_name
      }
    end

    config.add_search_field('architect') do |field|
      field.label = 'Architect'
      solr_name = solr_name('architect_label', :stored_searchable)
      field.solr_local_parameters = {
        qf: solr_name,
        pf: solr_name
      }
    end

    config.add_search_field('artist') do |field|
      field.label = 'Artist'
      solr_name = solr_name('artist_label', :stored_searchable)
      field.solr_local_parameters = {
        qf: solr_name,
        pf: solr_name
      }
    end

    config.add_search_field('author') do |field|
      field.label = 'Author'
      solr_name = solr_name('author_label', :stored_searchable)
      field.solr_local_parameters = {
        qf: solr_name,
        pf: solr_name
      }
    end

    config.add_search_field('cartographer') do |field|
      field.label = 'Cartographer'
      solr_name = solr_name('cartographer_label', :stored_searchable)
      field.solr_local_parameters = {
        qf: solr_name,
        pf: solr_name
      }
    end

    config.add_search_field('collector') do |field|
      field.label = 'Collector'
      solr_name = solr_name('collector_label', :stored_searchable)
      field.solr_local_parameters = {
        qf: solr_name,
        pf: solr_name
      }
    end

    config.add_search_field('compiler') do |field|
      field.label = 'Compiler'
      solr_name = solr_name('compiler_label', :stored_searchable)
      field.solr_local_parameters = {
        qf: solr_name,
        pf: solr_name
      }
    end

    config.add_search_field('composer') do |field|
      field.label = 'Composer'
      solr_name = solr_name('composer_label', :stored_searchable)
      field.solr_local_parameters = {
        qf: solr_name,
        pf: solr_name
      }
    end

    config.add_search_field('designer') do |field|
      field.label = 'Designer'
      solr_name = solr_name('designer_label', :stored_searchable)
      field.solr_local_parameters = {
        qf: solr_name,
        pf: solr_name
      }
    end

    config.add_search_field('director') do |field|
      field.label = 'Director'
      solr_name = solr_name('director_label', :stored_searchable)
      field.solr_local_parameters = {
        qf: solr_name,
        pf: solr_name
      }
    end

    config.add_search_field('distributor') do |field|
      field.label = 'Distributor'
      solr_name = solr_name('distributor_label', :stored_searchable)
      field.solr_local_parameters = {
        qf: solr_name,
        pf: solr_name
      }
    end

    config.add_search_field('donor') do |field|
      field.label = 'Donor'
      solr_name = solr_name('donor_label', :stored_searchable)
      field.solr_local_parameters = {
        qf: solr_name,
        pf: solr_name
      }
    end

    config.add_search_field('draftsman') do |field|
      field.label = 'Draftsman'
      solr_name = solr_name('draftsman_label', :stored_searchable)
      field.solr_local_parameters = {
        qf: solr_name,
        pf: solr_name
      }
    end

    config.add_search_field('editor') do |field|
      field.label = 'Editor'
      solr_name = solr_name('editor_label', :stored_searchable)
      field.solr_local_parameters = {
        qf: solr_name,
        pf: solr_name
      }
    end

    config.add_search_field('engraver') do |field|
      field.label = 'Engraver'
      solr_name = solr_name('engraver_label', :stored_searchable)
      field.solr_local_parameters = {
        qf: solr_name,
        pf: solr_name
      }
    end

    config.add_search_field('illustrator') do |field|
      field.label = 'Illustrator'
      solr_name = solr_name('illustrator_label', :stored_searchable)
      field.solr_local_parameters = {
        qf: solr_name,
        pf: solr_name
      }
    end

    config.add_search_field('librettist') do |field|
      field.label = 'Librettist'
      solr_name = solr_name('librettist_label', :stored_searchable)
      field.solr_local_parameters = {
        qf: solr_name,
        pf: solr_name
      }
    end

    config.add_search_field('musician') do |field|
      field.label = 'Musician'
      solr_name = solr_name('musician_label', :stored_searchable)
      field.solr_local_parameters = {
        qf: solr_name,
        pf: solr_name
      }
    end

    config.add_search_field('performer') do |field|
      field.label = 'Performer'
      solr_name = solr_name('performer_label', :stored_searchable)
      field.solr_local_parameters = {
        qf: solr_name,
        pf: solr_name
      }
    end

    config.add_search_field('photographer') do |field|
      field.label = 'Photographer'
      solr_name = solr_name('photographer_label', :stored_searchable)
      field.solr_local_parameters = {
        qf: solr_name,
        pf: solr_name
      }
    end

    config.add_search_field('presenter') do |field|
      field.label = 'Presenter'
      solr_name = solr_name('presenter_label', :stored_searchable)
      field.solr_local_parameters = {
        qf: solr_name,
        pf: solr_name
      }
    end

    config.add_search_field('printer') do |field|
      field.label = 'Printer'
      solr_name = solr_name('printer_label', :stored_searchable)
      field.solr_local_parameters = {
        qf: solr_name,
        pf: solr_name
      }
    end

    config.add_search_field('printmaker') do |field|
      field.label = 'Printmaker'
      solr_name = solr_name('printmaker_label', :stored_searchable)
      field.solr_local_parameters = {
        qf: solr_name,
        pf: solr_name
      }
    end

    config.add_search_field('producer') do |field|
      field.label = 'Producer'
      solr_name = solr_name('producer_label', :stored_searchable)
      field.solr_local_parameters = {
        qf: solr_name,
        pf: solr_name
      }
    end

    config.add_search_field('production_manager') do |field|
      field.label = 'Production Manager'
      solr_name = solr_name('production_manager_label', :stored_searchable)
      field.solr_local_parameters = {
        qf: solr_name,
        pf: solr_name
      }
    end

    config.add_search_field('screenwriter') do |field|
      field.label = 'Screenwriter'
      solr_name = solr_name('screenwriter_label', :stored_searchable)
      field.solr_local_parameters = {
        qf: solr_name,
        pf: solr_name
      }
    end

    config.add_search_field('sculptor') do |field|
      field.label = 'Sculptor'
      solr_name = solr_name('sculptor_label', :stored_searchable)
      field.solr_local_parameters = {
        qf: solr_name,
        pf: solr_name
      }
    end

    config.add_search_field('sponsor') do |field|
      field.label = 'Sponsor'
      solr_name = solr_name('sponsor_label', :stored_searchable)
      field.solr_local_parameters = {
        qf: solr_name,
        pf: solr_name
      }
    end

    config.add_search_field('transcriber') do |field|
      field.label = 'Transcriber'
      solr_name = solr_name('transcriber_label', :stored_searchable)
      field.solr_local_parameters = {
        qf: solr_name,
        pf: solr_name
      }
    end

    # "sort results by" select (pulldown)
    # label in pulldown is followed by the name of the SOLR field to sort by and
    # whether the sort is ascending or descending (it must be asc or desc
    # except in the relevancy case).
    # label is key, solr field is value
    config.add_sort_field "score desc, #{uploaded_field} desc", label: 'relevance'
    config.add_sort_field "#{uploaded_field} desc", label: "date uploaded \u25BC"
    config.add_sort_field "#{uploaded_field} asc", label: "date uploaded \u25B2"
    config.add_sort_field "#{modified_field} desc", label: "date modified \u25BC"
    config.add_sort_field "#{modified_field} asc", label: "date modified \u25B2"

    # If there are more than this many search results, no spelling ("did you
    # mean") suggestion is offered.
    config.spell_max = 5
  end

  # disable the bookmark control from displaying in gallery view
  # Hyrax doesn't show any of the default controls on the list view, so
  # this method is not called in that context.
  def render_bookmarks_control?
    false
  end
end
