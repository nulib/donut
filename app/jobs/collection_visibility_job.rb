class CollectionVisibilityJob < ApplicationJob
  def perform(*collection_ids, visibility)
    visibility_options = %w[restricted authenticated open]

    Image.find_each(member_of_collection_ids_ssim: collection_ids, visibility_ssi: visibility_options - [visibility]) do |image|
      ImageVisibilityJob.perform_later(image, visibility)
    end
  end
end
