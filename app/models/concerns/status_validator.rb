class StatusValidator < ActiveModel::EachValidator
  def validate_each(record, attribute, value)
    return if valid?(value)
    record.errors.add(attribute, "#{value} is not a valid status")
  end

  def valid?(value)
    ids = Hyrax::StatusAuthorities.new.select_active_options.map(&:last)
    ids.include?(value)
  end
end
