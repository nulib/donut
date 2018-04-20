require 'ldp'
require 'rsolr'
require 'donut/retry'

RSolr::Client.include(Donut::Retry::Solr)
Ldp::Client.include(Donut::Retry::Ldp)
