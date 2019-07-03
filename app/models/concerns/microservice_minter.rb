module MicroserviceMinter
  extend ActiveSupport::Concern

  ## This overrides the default behavior, which is to ask Fedora for an id
  # @see ActiveFedora::Persistence.assign_id
  def assign_id
    lambda = Settings.aws&.lambdas&.noid
    return nil if lambda.nil?
    client = Aws::Lambda::Client.new
    response = client.invoke(function_name: lambda)
    JSON.parse(response.payload.read)['result']
  end
end
