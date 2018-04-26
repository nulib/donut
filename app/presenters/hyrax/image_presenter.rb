# Generated via
#  `rails generate hyrax:work Image`
module Hyrax
  class ImagePresenter < Hyrax::WorkShowPresenter
    TERMS = [:abstract, :accession_number, :alternate_title, :ark,
             :bibliographic_citation, :call_number, :caption, :catalog_key, :contributor_label, :creator_label, :date_created_display,
             :genre_label, :subject_geographical_label, :subject_topical_label, :subject_temporal, :language_label,
             :provenance, :physical_description_material, :physical_description_size, :rights_holder,
             :style_period_label, :technique_label, :nul_creator, :nul_contributor, :nul_use_statement,
             :box_name, :box_number, :folder_name, :folder_number, :architect,
             :artist_label, :author_label, :cartographer_label, :compiler_label, :composer_label, :designer_label,
             :director_label, :draftsman_label, :editor_label, :engraver_label, :illustrator_label, :librettist_label,
             :performer_label, :photographer_label, :presenter_label, :printer_label, :printmaker_label, :producer_label,
             :production_manager_label, :screenwriter_label, :sculptor_label, :sponsor_label].freeze

    ADMIN_TERMS = [:project_name, :project_description, :proposer, :project_manager,
                   :task_number, :preservation_level, :project_cycle, :status].freeze

    (TERMS + ADMIN_TERMS).uniq.each { |term| delegate term, to: :solr_document }
  end
end
