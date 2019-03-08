class EnvironmentConfigurator < ActiveFedora::FileConfigurator
  def initialize
    reset!
  end

  def load_fedora_config
    return @fedora_config unless @fedora_config.empty?

    fedora_setting = Settings.fedora&.url || ENV['FEDORA_URL']
    if fedora_setting.present?
      ActiveFedora::Base.logger&.info('ActiveFedora: loading fedora config from FEDORA_URL')
      fedora_url = Addressable::URI.parse(fedora_setting)
      request_params = convert_numbers_to_numbers(fedora_url.query_values&.symbolize_keys)
      @fedora_config = { user: fedora_url.user, password: fedora_url.password, base_path: ENV['FEDORA_BASE_PATH'] || '', request: request_params }
      fedora_url.userinfo = fedora_url.query = nil
      @fedora_config[:url] = fedora_url.to_s
      ENV['FEDORA_URL'] ||= fedora_setting
    else
      super
    end
    @fedora_config
  end

  def load_solr_config
    return @solr_config unless @solr_config.empty?

    solr_setting = Settings.solr&.url || ENV['SOLR_URL']
    if solr_setting.present?
      ActiveFedora::Base.logger&.info('ActiveFedora: loading solr config from SOLR_URL')
      @solr_config = { url: solr_setting }
      ENV['SOLR_URL'] ||= solr_setting
    else
      super
    end
    Blacklight.connection_config.merge!(@solr_config)
    @solr_config
  end

  private

    def convert_numbers_to_numbers(hash)
      return nil if hash.nil?
      {}.tap do |result|
        hash.each_pair do |k, v|
          result[k] = case v
                      when /^[0-9]+$/         then v.to_i
                      when /^[0-9]+\.[0-9]+$/ then v.to_f
                      else v
                      end
        end
      end
    end
end
ActiveFedora.configurator = EnvironmentConfigurator.new
ActiveFedora.init
