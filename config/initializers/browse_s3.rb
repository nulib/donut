if Settings.aws.buckets.dropbox
  region = Aws.config[:region] || ENV['AWS_REGION'] || ENV['AWS_DEFAULT_REGION']
  if ENV['AWS_EXECUTION_ENV'] == 'AWS_ECS_EC2'
    response = Typhoeus.get('http://169.254.169.254/latest/dynamic/instance-identity/document')
    if response.code == 200
      doc = JSON.parse(response.body)
      region = doc['region']
    end
  end

  settings = { bucket: Settings.aws.buckets.dropbox, region: region, response_type: :signed_url }
  BrowseEverything.configure('s3' => settings)
end
