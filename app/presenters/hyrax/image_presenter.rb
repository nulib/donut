# Generated via
#  `rails generate hyrax:work Image`
module Hyrax
  class ImagePresenter < Hyrax::WorkShowPresenter
    TERMS = [
      :abstract,
      :accession_number,
      :alternate_title,
      :architect_label,
      :ark,
      :artist_label,
      :author_label,
      :bibliographic_citation,
      :box_name,
      :box_number,
      :call_number,
      :caption,
      :cartographer_label,
      :catalog_key,
      :compiler_label,
      :composer_label,
      :contributor_label,
      :creator_label,
      :date_created_display,
      :designer_label,
      :director_label,
      :draftsman_label,
      :editor_label,
      :engraver_label,
      :folder_name,
      :folder_number,
      :genre_label,
      :illustrator_label,
      :language_label,
      :librettist_label,
      :notes,
      :nul_contributor,
      :nul_creator,
      :nul_use_statement,
      :performer_label,
      :photographer_label,
      :physical_description_material,
      :physical_description_size,
      :presenter_label,
      :printer_label,
      :printmaker_label,
      :producer_label,
      :production_manager_label,
      :provenance,
      :related_material,
      :rights_holder,
      :scope_and_contents,
      :screenwriter_label,
      :sculptor_label,
      :series,
      :sponsor_label,
      :style_period_label,
      :subject_geographical_label,
      :subject_temporal,
      :subject_topical_label,
      :table_of_contents,
      :technique_label
    ].freeze

    ADMIN_TERMS = [
      :project_name,
      :project_description,
      :proposer,
      :project_manager,
      :task_number,
      :preservation_level,
      :project_cycle,
      :status
    ].freeze

    (TERMS + ADMIN_TERMS).uniq.each { |term| delegate term, to: :solr_document }
  end
end
