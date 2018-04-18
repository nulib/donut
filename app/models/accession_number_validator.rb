class AccessionNumberValidator < ActiveModel::EachValidator
  def validate_each(record, attribute, value)
    return unless duplicate?(value)
    record.errors.add(:base, 'An error occured. Please see details below')
    record.errors.add(attribute, 'Accession number must be unique')
  end

  def duplicate?(value)
    Donut::DuplicateAccessionVerificationService.duplicate?(value)
  end
end
