class VisibilityController < ApplicationController
  def manage
    @collection = Collection.find(params[:id])
    authorize! :edit, @collection
    @jobs = ::CollectionVisibilityHistory.where(collection_id: @collection.id).order(updated_at: :desc).first(5)
    render template: 'visibility/manage', collection: @collection, jobs: @jobs
  end

  def change
    collection = Collection.find(params[:id])
    visibility = params[:visibility] || 'open'
    authorize! :edit, collection
    ::CollectionVisibilityHistory.create(submitter: current_user.email, visibility: visibility, collection_id: collection.id)
    CollectionVisibilityJob.perform_later(collection_params, visibility)
    redirect_to Hyrax::Engine.routes.url_helpers.dashboard_collection_path(collection),
                notice: 'Job submitted. Please be patient; it may take some time to complete.'\
                        'Refresh this page to see the visibility of the collection members change.'
  end

  private

    def collection_params
      params.require(:id)
    end
end
