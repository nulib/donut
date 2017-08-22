NulibMicroservices.configure do |config|
  Settings.microservices.each_pair do |k, v|
    if k.to_s == 'api_key'
      config.api_key['x-api-key'] = Settings.microservices.api_key
    else
      config.send("#{k}=".to_sym, v)
    end
  end
end
