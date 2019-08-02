class VisibilityController < ApplicationController
  def make_public
    @collection = Collection.find(params[:id])
    authorize! :edit, @collection
    PublicCollectionJob.perform_later(@collection.id)
    redirect_to Hyrax::Engine.routes.url_helpers.dashboard_collection_path(@collection),
                notice: 'Job submitted. Please be patient; it may take some time to complete.'\
                        'Refresh this page to see the visibility of the collection members change.'
  end
end
