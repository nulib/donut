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
<<<<<<< HEAD
    term :creator
    term :contributor
=======
    term :hasCreator
    term :hasContributor
    term :exif_tool_version
    term :exif_all_data
>>>>>>> add in all but artist and note where we have the wrong predicate via todos
  end
end
