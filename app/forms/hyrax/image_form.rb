# Generated via
#  `rails generate hyrax:work Image`
module Hyrax
  class ImageForm < Hyrax::Forms::WorkForm
    self.model_class = ::Image
    self.terms += [
      :abstract,
      :accession_number,
      :alternate_title,
      :architect,
      :artist,
      :author,
      :bibliographic_citation,
      :box_name,
      :box_number,
      :call_number,
      :caption,
      :cartographer,
      :catalog_key,
      :compiler,
      :composer,
      :designer,
      :director,
      :draftsman,
      :editor,
      :engraver,
      :folder_name,
      :folder_number,
      :genre,
      :illustrator,
      :librettist,
      :notes,
      :nul_contributor,
      :nul_creator,
      :nul_use_statement,
      :performer,
      :photographer,
      :physical_description_material,
      :physical_description_size,
      :presenter,
      :preservation_level,
      :printer,
      :printmaker,
      :producer,
      :production_manager,
      :project_cycle,
      :project_description,
      :project_manager,
      :project_name,
      :proposer,
      :provenance,
      :related_material,
      :resource_type,
      :rights_holder,
      :scope_and_contents,
      :screenwriter,
      :sculptor,
      :series,
      :sponsor,
      :status,
      :style_period,
      :subject_geographical,
      :subject_temporal,
      :subject_topical,
      :table_of_contents,
      :task_number,
      :technique
    ]

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
          contributor_attributes: [:id, :_destroy],
          creator_attributes: [:id, :_destroy],
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
