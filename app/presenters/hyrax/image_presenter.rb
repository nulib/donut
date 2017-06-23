# Generated via
#  `rails generate hyrax:work Image`
module Hyrax
  class ImagePresenter < Hyrax::WorkShowPresenter
    delegate :abstract, :accession_number, :call_number, :catalog_key, :citation, :contributor_role, :creator_attribution, :creator_role, :genre, :physical_description, :related_url_label, :rights_holder, :style_period, :technique, to: :solr_document
  end
end
