class PublishJob < ApplicationJob
  def perform(work)
    work.fetch_labels
    work.update_index
    work.update_common_index
    IiifManifestService.write_manifest(work.id)
  end
end
