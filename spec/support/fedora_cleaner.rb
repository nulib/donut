require 'active_fedora/cleaner'

RSpec.configure do |config|
  config.after do
    ActiveFedora::Cleaner.clean! if ActiveFedora::Base.count > 0
  end
end
