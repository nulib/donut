# Generated via
#  `rails generate hyrax:work Image`
module Hyrax
  class ImageForm < Hyrax::Forms::WorkForm
    self.model_class = ::Image
    self.terms += [:alternate_title, :resource_type, :abstract, :accession_number, :call_number, :caption, :catalog_key, :citation, :contributor_role, :creator_role, :genre, :provenance, :physical_description, :related_url_label, :rights_holder, :style_period, :technique] # rubocop:disable Metrics/LineLength
    self.required_fields = [:title, :date_created, :accession_number, :rights_statement]

    def primary_terms
      [:title, :date_created, :accession_number, :creator, :rights_statement, :description]
    end
  end
end
