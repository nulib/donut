require 'carrierwave'

if Settings.aws.buckets.upload
  CarrierWave.configure do |config|
    config.storage = :aws
    config.aws_bucket = Settings.aws.buckets.upload
    config.aws_acl = 'bucket-owner-full-control'
  end
end
