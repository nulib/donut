# Generated via
#  `rails generate hyrax:work Image`
module Hyrax
  class ImageForm < Hyrax::Forms::WorkForm
    self.model_class = ::Image
    self.terms += [:alternate_title, :resource_type, :abstract, :accession_number,
                   :call_number, :caption, :catalog_key, :citation, :contributor_role,
                   :creator_role, :genre, :provenance, :physical_description, :related_url_label,
                   :rights_holder, :style_period, :technique, :preservation_level, :status,
                   :project_name, :project_description, :proposer, :project_manager,
                   :task_number, :project_cycle, :nul_creator, :nul_subject, :nul_contributor]
    self.required_fields = [:title, :date_created, :rights_statement, :preservation_level, :status]

    def primary_terms
      [:title, :date_created, :rights_statement, :preservation_level, :status, :accession_number, :creator, :description]
    end

    # not sure about this.
    def self.build_permitted_params
      super + [
        {
          contributor_role_attributes: [:id, :_destroy],
          style_period_attributes: [:id, :_destroy],
          genre_attributes: [:id, :_destroy],
          language_attributes: [:id, :destroy],
          technique_attributes: [:id, :_destroy]
        }
      ]
    end
  end
end
