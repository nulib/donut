module Donut
  class DuplicateAccessionVerificationService
    attr_reader :accession_number

    # @param accession_number [String] the accession_number of the work
    def self.unique?(accession_number)
      new(accession_number).duplicate_ids.empty?
    end

    # @param accession_number [String] the accession_number of the work
    def self.duplicate?(accession_number)
      new(accession_number).duplicate_ids.present?
    end

    # @param accession_number [String] the accession_number of the work
    def initialize(accession_number)
      @accession_number = accession_number
    end

    # return [Array<String>] array of pids
    def duplicate_ids
      return [] if accession_number.nil?
      Image.where(accession_number_ssim: @accession_number)
    end
  end
end
