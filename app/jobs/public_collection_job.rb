class PublicCollectionJob < ApplicationJob
  def perform(*collection_ids)
    Image.find_each(member_of_collection_ids_ssim: collection_ids, visibility_ssi: ['restricted', 'authenticated']) do |image|
      PublicImageJob.perform_later(image)
    end
  end
end
