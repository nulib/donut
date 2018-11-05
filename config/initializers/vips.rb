begin
  require 'ruby-vips'
rescue LoadError => e
  raise unless e.message.include?(%(Could not open library 'libvips.))
  Rails.logger.warn('Could not load VIPS library. Proceeding but derivative creation will fail hard.')
end
