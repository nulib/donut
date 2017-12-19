module Importer
  module Factory
    class ObjectFactory
      extend ActiveModel::Callbacks
      define_model_callbacks :save, :create
      class_attribute :klass, :system_identifier_field
      attr_reader :attributes, :s3_resource, :object

      def initialize(attributes, s3_resource = nil)
        @attributes = attributes
        @s3_resource = s3_resource
      end

      def run
        arg_hash = { id: attributes[:id], name: 'UPDATE', klass: klass }
        @object = find
        if @object
          ActiveSupport::Notifications.instrument('import.importer', arg_hash) { update }
        else
          ActiveSupport::Notifications.instrument('import.importer', arg_hash.merge(name: 'CREATE')) { create }
        end
        yield(object) if block_given?
        object
      end

      def update
        raise "Object doesn't exist" unless object
        run_callbacks(:save) do
          work_actor.update(environment(update_attributes))
        end
        log_updated(object)
      end

      def create_attributes
        transform_attributes
      end

      def update_attributes
        transform_attributes.except(:id)
      end

      def find
        return find_object_by_id if attributes[:id]
        return search_by_identifier if attributes[system_identifier_field].present?
        nil
      end

      def find_object_by_id
        klass.find(attributes[:id]) if klass.exists?(attributes[:id])
      end

      def search_by_identifier
        query = { Solrizer.solr_name(system_identifier_field, :symbol) =>
                    attributes[system_identifier_field] }
        klass.where(query).first
      end

      def create
        attrs = create_attributes
        @object = klass.new
        run_callbacks :save do
          run_callbacks :create do
            klass == Collection ? create_collection(attrs) : work_actor.create(environment(attrs))
          end
        end
        log_created(object)
      end

      def log_created(obj)
        msg = "Created #{klass.model_name.human} #{obj.id}"
        Rails.logger.info("#{msg} (#{Array(attributes[system_identifier_field]).first})")
      end

      def log_updated(obj)
        msg = "Updated #{klass.model_name.human} #{obj.id}"
        Rails.logger.info("#{msg} (#{Array(attributes[system_identifier_field]).first})")
      end

      private

        # @param [Hash] attrs the attributes to put in the environment
        # @return [Hyrax::Actors::Environment]
        def environment(attrs)
          Hyrax::Actors::Environment.new(@object, Ability.new(User.first), attrs)
        end

        def work_actor
          Hyrax::CurationConcern.actor
        end

        def create_collection(attrs)
          @object.attributes = attrs
          @object.apply_depositor_metadata(User.first)
          @object.save!
        end

        # Override if we need to map the attributes from the parser in
        # a way that is compatible with how the factory needs them.
        def transform_attributes
          StringLiteralProcessor.process(attributes.slice(*permitted_attributes))
                                .merge(file_attributes)
        end

        # NOTE: This approach is probably broken since the actor that handled `:files` attribute was removed:
        # https://github.com/samvera/hyrax/commit/3f1b58195d4381c51fde8b9149016c5b09f0c9b4
        def file_attributes
          file_specs = Array.wrap(attributes[:file]).map do |file_path|
            file_spec(file_path)
          end
          file_specs.empty? ? {} : { remote_files: file_specs }
        end

        def resolve_file(file_path)
          target = Pathname.new(file_path)
          source = Pathname.new(s3_resource.key)
          relative_key = target.relative_path_from(source).relative_path_from(Pathname.new('..'))
          s3_resource.bucket.object(relative_key.to_s)
        end

        def file_spec(file_path)
          s3_object = resolve_file(file_path)
          url = s3_object.presigned_url(:get)
          # WHAT: Fully decode the URL and then encode it one level
          # WHY:  Minio hates double-encoding; S3 hates no encoding
          url = URI.decode(url) while URI.decode(url) != url
          url = URI.encode(url)
          { url: url, file_size: s3_object.size }
        end

        def permitted_attributes
          klass.properties.keys.map(&:to_sym) + [:id, :edit_users, :edit_groups, :read_groups, :visibility]
        end
    end
  end
end
