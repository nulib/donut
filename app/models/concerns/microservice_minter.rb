module MicroserviceMinter
  extend ActiveSupport::Concern

  ## This overrides the default behavior, which is to ask Fedora for an id
  # @see ActiveFedora::Persistence.assign_id
  def assign_id
    service.mint_id_get.id if configured?
  end

  private

    def service
      @service ||= NulibMicroservices::DefaultApi.new
    end

    def configured?
      NulibMicroservices.configure.api_key['x-api-key'].present?
    end
end
