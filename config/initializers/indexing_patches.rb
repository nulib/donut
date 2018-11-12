# Use n-triples for indexing to prevent Fedora from blocking while assembling the RDF response
ActiveFedora::Fedora.class_eval do
  def ntriples_connection
    authorized_connection.tap { |conn| conn.headers['Accept'] = 'application/n-triples' }
  end

  def build_ntriples_connection
    ActiveFedora::InitializingConnection.new(ActiveFedora::CachingConnection.new(ntriples_connection, omit_ldpr_interaction_model: true), root_resource_path)
  end
end

ActiveFedora::Indexing::DescendantFetcher.class_eval do
  private

    def rdf_resource
      @rdf_resource ||= Ldp::Resource::RdfSource.new(ActiveFedora.fedora.build_ntriples_connection, uri)
    end
end

# Strip all non-printing, non-whitespace characters from string and text fields
ActiveFedora::Indexing.module_eval do
  def to_solr(_solr_doc = {}, _opts = {})
    indexing_service.generate_solr_document.tap do |doc|
      doc.each_pair do |k, v|
        doc[k] = printable_chars(v) if k.match?(/_(te|s)[sim]+$/)
      end
    end
  end

  private

    def printable_chars(val)
      return val.collect { |e| printable_chars(e) } if val.respond_to?(:each)
      val.to_s.gsub(/[^[:print:]\s]/, '')
    end
end
