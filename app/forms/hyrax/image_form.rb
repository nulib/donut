# Generated via
#  `rails generate hyrax:work Image`
module Hyrax
  class ImageForm < Hyrax::Forms::WorkForm
    self.model_class = ::Image
    self.terms += [:alternate_title, :resource_type, :abstract, :accession_number,
                   :bibliographic_citation, :call_number, :caption, :catalog_key, :genre, :provenance,
                   :physical_description_size, :physical_description_material, :rights_holder, :style_period, :technique,
                   :preservation_level, :status, :subject_geographical, :subject_temporal, :subject_topical, :project_name,
                   :project_description, :proposer, :project_manager, :task_number,
                   :project_cycle, :nul_creator, :nul_contributor, :nul_use_statement, :box_number,
                   :folder_number, :box_name, :folder_name, :architect, :artist,
                   :author, :cartographer, :compiler, :composer, :designer, :director,
                   :draftsman, :editor, :engraver, :illustrator, :librettist, :performer,
                   :photographer, :presenter, :printer, :printmaker, :producer,
                   :production_manager, :screenwriter, :sculptor, :sponsor]
    self.required_fields = [:accession_number, :title, :date_created, :rights_statement, :preservation_level, :status]

    def primary_terms
      [:title, :accession_number, :date_created, :rights_statement, :preservation_level, :status, :creator, :description]
    end

    # rubocop:disable Metrics/MethodLength
    def self.build_permitted_params
      super + [
        {
          style_period_attributes: [:id, :_destroy],
          genre_attributes: [:id, :_destroy],
          language_attributes: [:id, :_destroy],
          subject_geographical_attributes: [:id, :_destroy],
          subject_topical_attributes: [:id, :_destroy],
          technique_attributes: [:id, :_destroy],
          architect_attributes: [:id, :_destroy],
          artist_attributes: [:id, :_destroy],
          author_attributes: [:id, :_destroy],
          cartographer_attributes: [:id, :_destroy],
          compiler_attributes: [:id, :_destroy],
          composer_attributes: [:id, :_destroy],
          designer_attributes: [:id, :_destroy],
          director_attributes: [:id, :_destroy],
          draftsman_attributes: [:id, :_destroy],
          editor_attributes: [:id, :_destroy],
          engraver_attributes: [:id, :_destroy],
          illustrator_attributes: [:id, :_destroy],
          librettist_attributes: [:id, :_destroy],
          performer_attributes: [:id, :_destroy],
          photographer_attributes: [:id, :_destroy],
          presenter_attributes: [:id, :_destroy],
          printer_attributes: [:id, :_destroy],
          printmaker_attributes: [:id, :_destroy],
          producer_attributes: [:id, :_destroy],
          production_manager_attributes: [:id, :_destroy],
          screenwriter_attributes: [:id, :_destroy],
          sculptor_attributes: [:id, :_destroy],
          sponsor_attributes: [:id, :_destroy]
        }
      ]
    end
    # rubocop:enable Metrics/MethodLength
  end
end
