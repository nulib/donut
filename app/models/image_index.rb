module ImageIndex
  extend ActiveSupport::Concern

  def to_common_index
    common_index_model.merge(
      common_index_fields
    ).merge(
      common_index_values(:abstract, :caption, :description, :keyword, :provenance,
                          :publisher, :rights_holder, :source, :visibility)
    ).merge(
      common_index_labels(:language)
    ).merge(
      common_index_extra_fields
    )
  end

  private
    def common_index_autocomplete(*fields)
    end

    def common_index_date(edtf_date)
      Array(edtf_date).collect do |date|
        Array(Date.edtf(date)).map(&:iso8601)
      end.flatten.sort.uniq
    end

    def common_index_model
      {
        model: {
          application: Rails.application.class.parent.name,
          name: self.class.name
        }
      }
    end

    def common_index_extra_fields
      {
        extra_fields: common_index_labels(:genre, :style_period, :technique).merge({
          physical_description: { material: physical_description_material, size: physical_description_size }
        })
      }
    end

    def common_index_fields # rubocop:disable Metrics/MethodLength
      {
        admin_set: { id: admin_set&.id, title: admin_set&.title },
        collection: member_of_collections.map { |c| { id: c.id, title: c.title.to_a } }.flatten,
        contributor: common_index_typed_values(
          :architect, :artist, :author, :cartographer, :compiler, :composer,
          :contributor, :creator, :designer, :director, :draftsman, :editor, :engraver,
          :illustrator, :librettist, :nul_creator, :performer, :photographer, :presenter,
          :printer, :printmaker, :producer, :production_manager, :screenwriter, :sculptor,
          :sponsor
        ),
        date: common_index_date(date_created),
        permalink: ark,
        subject: common_index_typed_values(:subject, [:subject_geographical, 'geographical'], [:subject_topical, 'topical']),
        title: { primary: title, alternate: alternate_title }
      }
    end

    def common_index_values(*fields)
      {}.tap do |result|
        fields.each do |field|
          value = send(field)
          result[field] = value unless value.empty?
        end
      end
    end

    def common_index_labels(*fields)
      {}.tap do |result|
        fields.each do |field|
          value = send(field)
          result[field] = value.map { |v| { uri: v.id, label: v.fetch.preferred_label } } unless value.empty?
        end
      end
    end

    def common_index_typed_values(*fields)
      [].tap do |result|
        fields.each do |field|
          (name, type) = field.is_a?(Array) ? field.map(&:to_s) : [field.to_s, field.to_s]

          next if self[name].empty?
          Array(self[name]).each do |value|
            uri = value.is_a?(ControlledVocabularies::Base) ? value.id : nil
            label = value.is_a?(ControlledVocabularies::Base) ? value.fetch.preferred_label : value
            result << { type: type, uri: uri, label: label }
          end
        end
      end
    end
end
