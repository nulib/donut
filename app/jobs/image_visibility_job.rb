class ImageVisibilityJob < ApplicationJob
  def perform(image, visibility)
    return if image.visibility == visibility

    image.visibility = visibility
    image.save
    image.file_sets.each do |fs|
      next if fs.visibility == visibility
      fs.visibility = visibility
      fs.save
    end
  end
end
