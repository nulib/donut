class PreservationLevelValidator < ActiveModel::EachValidator
  def validate_each(record, attribute, value)
    return if valid?(value)
    record.errors.add(attribute, "Only #{valid_values} are valid preservation level values")
  end

  private

    def valid?(value)
      ids = Hyrax::PreservationLevelAuthorities.new.select_active_options.map(&:last)
      ids.include?(value)
    end

    def valid_values
      Hyrax::PreservationLevelAuthorities.new.select_active_options.map(&:last).join(', ')
    end
end
