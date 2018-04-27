class LicenseValidator < ActiveModel::EachValidator
  def validate_each(record, attribute, value)
    errors = value.reject(&:blank?).reject { |v| valid?(v) }
    return if errors.to_a.empty?
    record.errors.add(attribute, "Invalid license: #{errors.join(',')}")
  end

  def valid?(value)
    Hyrax::LicenseService.new.select_active_options.map(&:last).include?(value)
  end
end
