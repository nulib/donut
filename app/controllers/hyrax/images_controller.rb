# Generated via
#  `rails generate hyrax:work Image`

module Hyrax
  class ImagesController < ApplicationController
    # Adds Hyrax behaviors to the controller.
    include Hyrax::WorksControllerBehavior
    include Hyrax::BreadcrumbsForWorks
    self.curation_concern_type = ::Image

    # Use this line if you want to use a custom presenter
    self.show_presenter = Hyrax::ImagePresenter

    def status
      render json: CrappyStateMachine.work_status(params[:id])
    end
  end
end
