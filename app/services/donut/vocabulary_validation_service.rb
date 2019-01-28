# Validates uris
# based on: https://github.com/nulib/next-generation-repository/wiki/URI-Construction-for-Controlled-Vocabularies
module Donut
  class VocabularyValidationService
    VOCABULARIES = [
      %r{^http://vocab.getty.edu/ulan/[0-9]+/?$},
      %r{^http://vocab.getty.edu/aat/[0-9]+/?$},
      %r{^http://id.worldcat.org/fast/[1-9]{1}[0-9]+/?$},
      %r{^http://sws.geonames.org/[0-9]+/?$},
      %r{^http://id.loc.gov/authorities/names/n(o|r)?[0-9]+/?$},
      %r{^http://id.loc.gov/authorities/subjects/sh[0-9]+/?$},
      %r{^http://id.loc.gov/vocabulary/languages/[a-z]{3}/?$}
    ].freeze

    def self.valid?(uri)
      regex = Regexp.union(VOCABULARIES)
      !regex.match(uri).nil?
    end
  end
end
