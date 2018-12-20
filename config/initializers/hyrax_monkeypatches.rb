BrowseEverything::Retriever.class_eval do
  class << self
    alias_method :_can_retrieve?, :can_retrieve?
    def can_retrieve?(uri, _headers={})
      _can_retrieve?(uri)
    end
  end
end

FileSet.class_eval do
  before_save :decode_import_url
  before_save :ensure_label_present

  def decode_import_url
    return if import_url.nil?
    decoded_url = URI.decode(import_url)
    while !BrowseEverything::Retriever.can_retrieve?(import_url) && (import_url != decoded_url)
      Rails.logger.info("Decoding #{import_url}")
      self.import_url = decoded_url
      decoded_url = URI.decode(import_url)
    end
  end

  def ensure_label_present
    return if label.present? || import_url.nil?
    self.label = File.basename(URI(import_url).path)
  end
end
