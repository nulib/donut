if Settings.aws.buckets.dropbox

  settings = { bucket: Settings.aws.buckets.dropbox, region: Settings.aws_region, response_type: :signed_url }
  BrowseEverything.configure('s3' => settings)
end
