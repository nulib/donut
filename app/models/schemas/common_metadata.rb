# frozen_string_literal: true

module Schemas
  ##
  # Schema for metadata shared among Work types
  #
  # @example applying the common metadata schema
  #
  #   class WorkType < ActiveFedora::Base
  #     include ::Hyrax::WorkBehavior
  #     include ::Schemas::CommonMetadata
  #     include ::Hyrax::BasicMetadata
  #   end
  #
  # @see ActiveFedora::Base
  # @see Hyrax::WorkBehavior
  module CommonMetadata
    extend ActiveSupport::Concern

    # rubocop:disable Metrics/BlockLength
    included do
      property :nul_use_statement, predicate: ::RDF::Vocab::DC.accessRights do |index|
        index.as :stored_searchable
      end

      property :subject_geographical, predicate: ::RDF::Vocab::DC.spatial, class_name: ControlledVocabularies::Base do |index|
        index.as :stored_searchable, :facetable
      end

      property :subject_temporal, predicate: ::RDF::Vocab::DC.temporal do |index|
        index.as :stored_searchable, :facetable
      end

      # MARC Relators

      property :architect, predicate: ::RDF::Vocab::MARCRelators.arc, class_name: ControlledVocabularies::Base do |index|
        index.as :stored_searchable, :facetable
      end

      property :artist, predicate: ::RDF::Vocab::MARCRelators.art, class_name: ControlledVocabularies::Base do |index|
        index.as :stored_searchable, :facetable
      end

      property :author, predicate: ::RDF::Vocab::MARCRelators.aut, class_name: ControlledVocabularies::Base do |index|
        index.as :stored_searchable, :facetable
      end

      property :cartographer, predicate: ::RDF::Vocab::MARCRelators.ctg, class_name: ControlledVocabularies::Base do |index|
        index.as :stored_searchable, :facetable
      end

      property :compiler, predicate: ::RDF::Vocab::MARCRelators.com, class_name: ControlledVocabularies::Base do |index|
        index.as :stored_searchable, :facetable
      end

      property :composer, predicate: ::RDF::Vocab::MARCRelators.cmp, class_name: ControlledVocabularies::Base do |index|
        index.as :stored_searchable, :facetable
      end

      property :designer, predicate: ::RDF::Vocab::MARCRelators.dsr, class_name: ControlledVocabularies::Base do |index|
        index.as :stored_searchable, :facetable
      end

      property :director, predicate: ::RDF::Vocab::MARCRelators.drt, class_name: ControlledVocabularies::Base do |index|
        index.as :stored_searchable, :facetable
      end

      property :draftsman, predicate: ::RDF::Vocab::MARCRelators.drm, class_name: ControlledVocabularies::Base do |index|
        index.as :stored_searchable, :facetable
      end

      property :editor, predicate: ::RDF::Vocab::MARCRelators.edt, class_name: ControlledVocabularies::Base do |index|
        index.as :stored_searchable, :facetable
      end

      property :engraver, predicate: ::RDF::Vocab::MARCRelators.egr, class_name: ControlledVocabularies::Base do |index|
        index.as :stored_searchable, :facetable
      end

      property :illustrator, predicate: ::RDF::Vocab::MARCRelators.ill, class_name: ControlledVocabularies::Base do |index|
        index.as :stored_searchable, :facetable
      end

      property :librettist, predicate: ::RDF::Vocab::MARCRelators.lbt, class_name: ControlledVocabularies::Base do |index|
        index.as :stored_searchable, :facetable
      end

      property :performer, predicate: ::RDF::Vocab::MARCRelators.prf, class_name: ControlledVocabularies::Base do |index|
        index.as :stored_searchable, :facetable
      end

      property :photographer, predicate: ::RDF::Vocab::MARCRelators.pht, class_name: ControlledVocabularies::Base do |index|
        index.as :stored_searchable, :facetable
      end

      property :presenter, predicate: ::RDF::Vocab::MARCRelators.pre, class_name: ControlledVocabularies::Base do |index|
        index.as :stored_searchable, :facetable
      end

      property :printer, predicate: ::RDF::Vocab::MARCRelators.prt, class_name: ControlledVocabularies::Base do |index|
        index.as :stored_searchable, :facetable
      end

      property :printmaker, predicate: ::RDF::Vocab::MARCRelators.prm, class_name: ControlledVocabularies::Base do |index|
        index.as :stored_searchable, :facetable
      end

      property :producer, predicate: ::RDF::Vocab::MARCRelators.pro, class_name: ControlledVocabularies::Base do |index|
        index.as :stored_searchable, :facetable
      end

      property :production_manager, predicate: ::RDF::Vocab::MARCRelators.pmn, class_name: ControlledVocabularies::Base do |index|
        index.as :stored_searchable, :facetable
      end

      property :screenwriter, predicate: ::RDF::Vocab::MARCRelators.aus, class_name: ControlledVocabularies::Base do |index|
        index.as :stored_searchable, :facetable
      end

      property :sculptor, predicate: ::RDF::Vocab::MARCRelators.scl, class_name: ControlledVocabularies::Base do |index|
        index.as :stored_searchable, :facetable
      end

      property :sponsor, predicate: ::RDF::Vocab::MARCRelators.spn, class_name: ControlledVocabularies::Base do |index|
        index.as :stored_searchable, :facetable
      end
    end
    # rubocop:enable Metrics/BlockLength
  end
end
