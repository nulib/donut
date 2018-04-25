class ResourceTypeValidator < ActiveModel::EachValidator
  def validate_each(record, attribute, value)
    invalid_resources = get_invalid_resources(value)
    record.errors.add(attribute, error_message(invalid_resources)) if invalid_resources.any?
  end

  private

    def get_invalid_resources(value)
      authority = Qa::Authorities::Local::FileBasedAuthority.new('resource_types')
      # the .present? check is to accomodate empty string/nil values since this
      # isn't a required field, so ""/nil are valid entries
      invalid_entries = value.map { |x| x if authority.find(x).blank? && x.present? }
      invalid_entries.compact
    end

    def error_message(types)
      "#{types.join(', ')} #{sentence_helper(types.count)} invalid resource #{'type'.pluralize(types.count)}"
    end

    def sentence_helper(count)
      count == 1 ? 'is an' : 'are'
    end
end
