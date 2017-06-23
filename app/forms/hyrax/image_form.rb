# Generated via
#  `rails generate hyrax:work Image`
module Hyrax
  class ImageForm < Hyrax::Forms::WorkForm
    self.model_class = ::Image
    self.terms += [:resource_type, :abstract, :accession_number, :call_number, :catalog_key, :citation, :contributor_role, :creator_attribution, :creator_role, :genre, :physical_description, :related_url_label, :rights_holder, :style_period, :technique ]
    self.required_fields = [:title, :date_created, :accession_number]

    def primary_terms
      [:title, :description, :date_created, :accession_number, :creator]
    end
  end
end
