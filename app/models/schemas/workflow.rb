# frozen_string_literal: true

module Schemas
  ##
  # Schema for Donut workflow metadata
  #
  # @example applying the workflow schema
  #
  #   class WorkType < ActiveFedora::Base
  #     include ::Hyrax::WorkBehavior
  #     include ::Schemas::Workflow
  #     include ::Hyrax::BasicMetadata
  #   end
  #
  # @see ActiveFedora::Base
  # @see Hyrax::WorkBehavior
  module Workflow
    extend ActiveSupport::Concern

    included do
      property :abstract, predicate: ::RDF::Vocab::DC.abstract, multiple: true do |index|
        index.as :stored_searchable
      end

      property :box_name, predicate: ::RDF::URI.new('http://opaquenamespace.org/ns/boxName'), multiple: true do |index|
        index.as :stored_searchable
      end

      property :box_number, predicate: ::RDF::URI.new('http://opaquenamespace.org/ns/boxNumber'), multiple: true do |index|
        index.as :stored_searchable
      end

      property :folder_name, predicate: ::RDF::URI.new('http://opaquenamespace.org/ns/folderName'), multiple: true do |index|
        index.as :stored_searchable
      end

      property :folder_number, predicate: ::RDF::URI.new('http://opaquenamespace.org/ns/folderNumber'), multiple: true do |index|
        index.as :stored_searchable
      end
    end
  end
end
