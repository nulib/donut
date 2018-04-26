class EdtfDateValidator < ActiveModel::EachValidator
  def validate_each(record, attribute, value)
    errors = value.reject(&:empty?).select { |date| invalid?(date) }
    return if errors.to_a.empty?
    record.errors.add(attribute, "Invalid EDTF #{'date'.pluralize(errors.size)}: #{errors.join(',')}")
  end

  def invalid?(value)
    Date.edtf(value).nil?
  end
end
