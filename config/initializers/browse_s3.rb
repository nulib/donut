if Settings.aws.buckets.dropbox
  settings = { bucket: Settings.aws.buckets.dropbox, response_type: :signed_url }
  BrowseEverything.configure('s3' => settings)
end