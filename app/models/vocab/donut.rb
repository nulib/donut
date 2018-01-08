# frozen_string_literal: true

require 'rdf'

module Vocab
  class Donut < RDF::Vocabulary('http://www.library.northwestern.edu/terms#')
    term :project_name
    term :project_description
    term :proposer
    term :manager
    term :task_number
    term :preservation_level
    term :cycle
    term :qr_status
  end
end
