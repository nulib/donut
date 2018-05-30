# Ruby doesn't have the constants in this scope that the
# CollectionForm needs (Hyrax::SearchState), due to using
# a class_eval, so we have to require it here

# rubocop:disable Rails/DynamicFindBy
gem_dir = Gem::Specification.find_by_name('hyrax').gem_dir
# rubocop:enable Rails/DynamicFindBy
require "#{gem_dir}/lib/hyrax/search_state"

Hyrax::Dashboard::CollectionsController.class_eval do
  def show
    if @collection.collection_type.brandable?
      banner_info = CollectionBrandingInfo.where(collection_id: @collection.id.to_s).where(role: 'banner')
      @banner_file = File.split(banner_info.first.local_path).last unless banner_info.empty?
    end

    presenter
    query_collection_members
  end

  def remove_redundant_files(public_files)
    # remove any public ones that were not included in the selection.
    logos_info = CollectionBrandingInfo.where(collection_id: @collection.id.to_s).where(role: 'logo')
    logos_info.each do |logo_info|
      # logo_info.delete(logo_info.local_path) unless public_files.include? logo_info.local_path
      logo_info.destroy unless public_files.include? logo_info.local_path
    end
  end
end
