module Importer
  module Factory
    module WithAssociatedCollection
      extend ActiveSupport::Concern

      # Strip out the :collection key, and add the member_of_collection_ids,
      # which is used by Hyrax::Actors::AddAsMemberOfCollectionsActor
      def create_attributes
        return super if attributes[:collections].nil?
        super.except(:collections).merge(member_of_collections: collections)
      end

      # Strip out the :collection key, and add the member_of_collection_ids,
      # which is used by Hyrax::Actors::AddAsMemberOfCollectionsActor
      def update_attributes
        super.except(:collections).merge(member_of_collections: collections)
      end

      private

        def collections
          [].tap do |result|
            attributes.fetch(:collections).each do |c|
              result << CollectionFactory.new(c).find_or_create
            end
          end
        end
    end
  end
end
