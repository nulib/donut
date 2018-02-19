if Settings.s3.dropbox
  settings = Settings.s3.dropbox.to_h.merge(response_type: :signed_url)
  BrowseEverything.configure('s3' => settings)
end
