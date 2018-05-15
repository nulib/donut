class SolrCollectionCreator
  attr_accessor :name

  def initialize(name)
    @name = name
  end

  def perform
    return unless Settings.solrcloud
    client.get '/solr/admin/collections', params: collection_options.merge(action: 'CREATE', name: name) unless collection_exists? name
  end

  class CollectionOptions
    attr_reader :settings

    def initialize(settings = {})
      @settings = settings
    end

    ##
    # @example Camel-casing
    #   { replication_factor: 5 } # => { "replicationFactor" => 5 }
    # @example Blank-rejecting
    #   { emptyValue: '' } #=> { }
    # @example Nested value-flattening
    #   { collection: { config_name: 'x' } } # => { 'collection.configName' => 'x' }
    def to_h
      Hash[*settings.map { |k, v| transform_entry(k, v) }.flatten].reject { |_k, v| v.blank? }.symbolize_keys
    end

    private

      def transform_entry(k, v)
        case v
        when Hash
          v.map do |k1, v1|
            ["#{transform_key(k)}.#{transform_key(k1)}", v1]
          end
        else
          [transform_key(k), v]
        end
      end

      def transform_key(k)
        k.to_s.camelize(:lower)
      end
  end

  private

    def client
      Blacklight.default_index.connection
    end

    def collection_options
      CollectionOptions.new(Settings.solr.collection_options.to_hash).to_h
    end

    def collection_exists?(name)
      response = client.get '/solr/admin/collections', params: { action: 'LIST' }
      collections = response['collections']

      collections.include? name
    end

    def collection_url(name)
      normalized_uri = if Settings.solr.url.ends_with?('/')
                         Settings.solr.url
                       else
                         "#{Settings.solr.url}/"
                       end

      uri = URI(normalized_uri) + name

      uri.to_s
    end
end
