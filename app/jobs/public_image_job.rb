class PublicImageJob < ApplicationJob
  def perform(image)
    return if image.visibility == 'open'

    image.visibility = 'open'
    image.save
    image.file_sets.each do |fs|
      next if fs.visibility == 'open'
      fs.visibility = 'open'
      fs.save
    end
  end
end
