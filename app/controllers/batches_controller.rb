class BatchesController < Hyrax::MyController
  include Hyrax::Breadcrumbs

  def index
    add_breadcrumb t(:'hyrax.controls.home'), root_path
    add_breadcrumb t(:'hyrax.dashboard.breadcrumbs.admin'), hyrax.dashboard_path
    add_breadcrumb t(:'hyrax.admin.sidebar.batches'), main_app.batches_path

    @batches = Batch.all
  end

  def show
    @batch = Batch.find(params[:id])

    add_breadcrumb t(:'hyrax.controls.home'), root_path
    add_breadcrumb t(:'hyrax.dashboard.breadcrumbs.admin'), hyrax.dashboard_path
    add_breadcrumb t(:'hyrax.admin.sidebar.batches'), main_app.batches_path
    add_breadcrumb t(:'hyrax.admin.sidebar.batch'), @batch
  end
end
