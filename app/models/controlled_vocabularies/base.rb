module ControlledVocabularies
  class Base < ActiveTriples::Resource
    include CachingFetcher
  end
end
