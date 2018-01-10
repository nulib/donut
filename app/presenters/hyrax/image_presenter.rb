# Generated via
#  `rails generate hyrax:work Image`
module Hyrax
  class ImagePresenter < Hyrax::WorkShowPresenter
    TERMS = [:abstract, :accession_number, :alternate_title, :ark,
             :call_number, :caption, :catalog_key, :citation, :contributor_role,
             :creator_role, :genre, :provenance, :physical_description,
             :related_url_label, :rights_holder, :style_period, :technique].freeze

    ADMIN_TERMS = [:project_name, :project_description, :proposer, :project_manager,
                   :task_number, :preservation_level, :project_cycle, :status].freeze

    (TERMS + ADMIN_TERMS).uniq.each { |term| delegate term, to: :solr_document }

    Hyrax::MemberPresenterFactory.file_presenter_class = ::FileSetPresenter

    def manifest_url
      manifest_helper.polymorphic_url([:manifest, self])
    end

    private

      def manifest_helper
        @manifest_helper ||= ManifestHelper.new(request.base_url)
      end
  end
end
