BrowseEverything::Retriever.class_eval do
  class << self
    alias_method :_can_retrieve?, :can_retrieve?
    def can_retrieve?(uri, _headers)
      _can_retrieve?(uri)
    end
  end
end

FileSet.class_eval do
  before_save :ensure_label_present

  def ensure_label_present
    return if label.present? || import_url.nil?
    self.label = File.basename(URI(import_url).path)
  end
end
