require 'aws-sdk-lambda'

class CreatePyramidTiffJob < ApplicationJob
  # @param [FileSet] file_set

  def perform(file_set) # rubocop:disable Metrics/AbcSize
    payload = JSON.generate(source: fedora_binary_s3_uri_for(file_set),
                            target: IiifDerivativeService.derivative_path_for(file_set.id))

    resp = lambda_client.invoke(function_name: Settings.aws.lambdas.pyramid,
                                payload: payload)

    resp_payload = JSON.parse(resp.payload.string)
    case resp_payload['statusCode']
    when 200
      Rails.logger.info("#{file_set.id} received by #{Settings.aws.lambdas.pyramid}")
    when 304
      Rails.logger.info("#{file_set.id} skipped by #{Settings.aws.lambdas.pyramid}")
    else
      Rails.logger.error("An error occurred with #{Settings.aws.lambdas.pyramid} processing #{file_set.id}")
    end
  end

  private

    def lambda_client
      @lambda_client ||= Aws::Lambda::Client.new(region: Settings.aws_region)
    end

    def fedora_binary_s3_uri_for(file_set)
      "s3://#{Settings.aws.buckets.fedora}/#{premis_digest(file_set.original_file.uri.to_s).sub('urn:sha1:', '')}"
    end

    def premis_digest(uri)
      ActiveFedora::FixityService.new(uri).expected_message_digest
    rescue Ldp::NotFound
      raise "CreatePyramidTiffJob error: No original file for was found for #{file_set.id}"
    end
end
