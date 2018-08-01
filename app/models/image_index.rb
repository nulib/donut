module ImageIndex
  extend ActiveSupport::Concern

  def to_common_index
    common_index_model.merge(
      common_index_fields
    ).merge(
      common_index_values(:abstract, :caption, :description, :keyword, :provenance,
                          :publisher, :rights_holder, :source, :visibility)
    ).merge(
      common_index_labels(:genre, :language, :style_period, :technique)
    )
  end

  private

    def common_index_model
      {
        model: {
          application: Rails.application.class.parent.name,
          name: self.class.name
        }
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
        date: date_created,
        permalink: ark,
        physical_description: { material: physical_description_material, size: physical_description_size },
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
          result[field] = value.map { |v| v.fetch.preferred_label } unless value.empty?
        end
      end
    end

    def common_index_typed_values(*fields)
      [].tap do |result|
        fields.each do |field|
          (name, type) = field.is_a?(Array) ? field.map(&:to_s) : [field.to_s, field.to_s]

          next if self[name].empty?
          Array(self[name]).each do |value|
            label = value.is_a?(ControlledVocabularies::Base) ? value.fetch.preferred_label : value
            result << { type: type, label: label }
          end
        end
      end
    end
end
