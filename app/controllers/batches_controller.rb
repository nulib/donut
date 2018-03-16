class BatchesController < Hyrax::MyController
  include Hyrax::Breadcrumbs

  def index
    add_breadcrumbs
    @batches = Batch.all
  end

  def show
    @batch = Batch.find(params[:id])
    add_breadcrumbs(label: t(:'hyrax.admin.sidebar.batch'), location: @batch)
  end

  def detail
    @batch_items = BatchItem.where(accession_number: params[:accession_number]).order(:updated_at)
    add_breadcrumbs(label: t(:'hyrax.admin.sidebar.batch_item'), location: batch_item_path(accession_number: params[:accession_number]))
  end

  private

    def add_breadcrumbs(final_item = nil)
      add_breadcrumb t(:'hyrax.controls.home'), root_path
      add_breadcrumb t(:'hyrax.dashboard.breadcrumbs.admin'), hyrax.dashboard_path
      add_breadcrumb t(:'hyrax.admin.sidebar.batches'), main_app.batches_path
      return if final_item.nil?
      add_breadcrumb final_item[:label], final_item[:location]
    end
end
