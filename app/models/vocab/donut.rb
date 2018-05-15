# frozen_string_literal: true

require 'rdf'

module Vocab
  class Donut < RDF::Vocabulary('http://www.library.northwestern.edu/terms#')
    term :project_name
    term :project_description
    term :proposer
    term :project_manager
    term :task_number
    term :preservation_level
    term :project_cycle
    term :status
    term :creator
    term :contributor
    term :donut_exif_version
    term :icc_profile_description
    term :exif_all_data
  end
end
