class RightsStatementValidator < ActiveModel::EachValidator
  def validate_each(record, attribute, value)
    errors = value.reject(&:blank?).reject { |v| valid?(v) }
    return if errors.to_a.empty?
    record.errors.add(attribute, "Invalid rights statement: #{errors.join(',')}")
  end

  def valid?(value)
    Hyrax::RightsStatementService.new.select_active_options.map(&:last).include?(value)
  end
end
