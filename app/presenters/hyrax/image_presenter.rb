# Generated via
#  `rails generate hyrax:work Image`
module Hyrax
  class ImagePresenter < Hyrax::WorkShowPresenter
    TERMS = [:abstract, :accession_number, :alternate_title, :ark,
             :call_number, :caption, :catalog_key, :citation, :contributor_role,
             :creator_role, :genre_label, :language_label, :provenance, :physical_description,
             :related_url_label, :rights_holder, :style_period_label, :technique_label].freeze

    ADMIN_TERMS = [:project_name, :project_description, :proposer, :project_manager,
                   :task_number, :preservation_level, :project_cycle, :status].freeze

    (TERMS + ADMIN_TERMS).uniq.each { |term| delegate term, to: :solr_document }
  end
end
