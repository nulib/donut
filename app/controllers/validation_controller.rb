class ValidationController < ApplicationController
  protect_from_forgery with: :null_session
  before_action :transform_rights_statement

  def validate_new
    validate(transform_new_params)
  end

  def validate_edit
    validate(transform_edit_params)
  end

  private

    def validate(attributes)
      payload = if Donut::ValidationService.valid?(klass: Image, attributes: attributes)
                  { message: 'Validation Success' }
                else
                  { error: Donut::ValidationService.errors(klass: Image, attributes: attributes) }
                end
      render json: payload, status: 200
    end

    def transform_new_params
      validation_params.except(:member_of_collections_attributes)
    end

    def transform_edit_params
      # give it a dummy accession_number
      # because 'edit' will find it's own asseccsion as duplicate
      # but needs a unique one to validate
      validation_params.except(:accession_number, :permissions_attributes, :version, :member_of_collections_attributes).merge(accession_number: 'INVALID_ACCESSION')
    end

    def transform_rights_statement
      return if params[:image][:rights_statement].is_a? Array
      params[:image][:rights_statement] = [params[:image][:rights_statement]]
    end

    def validation_params
      params.require(:image).permit(Hyrax::ImageForm.permitted_params, rights_statement: [])
    end
end
