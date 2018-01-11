# frozen_string_literal: true

module Schema
  ##
  # Schema for Donut administrative metadata
  #
  # @example applying the administrative schema
  #
  #   class WorkType < ActiveFedora::Base
  #     include ::Hyrax::WorkBehavior
  #     include ::Schema::Administrative
  #     include ::Hyrax::BasicMetadata
  #   end
  #
  # @see ActiveFedora::Base
  # @see Hyrax::WorkBehavior
  module Administrative
    extend ActiveSupport::Concern

    REVIEWED_STRING = 'Reviewed'.freeze

    included do
      property :project_name, predicate: ::Vocab::Donut.project_name do |index|
        index.as :stored_searchable
      end

      property :project_description, predicate: ::Vocab::Donut.project_description do |index|
        index.as :stored_searchable
      end

      property :proposer, predicate: ::Vocab::Donut.proposer do |index|
        index.as :stored_searchable, :facetable
      end

      property :project_manager, predicate: ::Vocab::Donut.project_manager do |index|
        index.as :stored_searchable, :facetable
      end

      property :task_number, predicate: ::Vocab::Donut.task_number do |index|
        index.as :stored_searchable
      end

      property :preservation_level, predicate: ::Vocab::Donut.preservation_level do |index|
        index.as :stored_searchable, :facetable
      end

      property :project_cycle, predicate: ::Vocab::Donut.project_cycle do |index|
        index.as :stored_searchable, :facetable
      end

      property :status, predicate: ::Vocab::Donut.status do |index|
        index.as :stored_searchable, :facetable
      end
    end

    def mark_reviewed
      self.status = [REVIEWED_STRING]
    end

    def mark_reviewed!
      mark_reviewed
      save
    end

    def reviewed?
      status.include?(REVIEWED_STRING)
    end
  end
end
