# Generated via
#  `rails generate hyrax:work Image`
module Hyrax
  class ImagePresenter < Hyrax::WorkShowPresenter
    TERMS = [:abstract, :accession_number, :alternate_title, :ark,
             :call_number, :caption, :catalog_key, :citation, :contributor_role_label,
             :creator_role, :genre_label, :language_label, :provenance, :physical_description,
             :rights_holder, :style_period_label, :technique_label,
             :nul_creator, :nul_subject, :nul_contributor,
             :box_name, :box_number, :folder_name, :folder_number].freeze

    ADMIN_TERMS = [:project_name, :project_description, :proposer, :project_manager,
                   :task_number, :preservation_level, :project_cycle, :status].freeze

    (TERMS + ADMIN_TERMS).uniq.each { |term| delegate term, to: :solr_document }
  end
end
