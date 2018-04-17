module Donut
  class SeedDataService
    class << self
      def dump
        admin_sets = AdminSet.all.collect do |as|
          dump_admin_set(as)
        end

        users = User.all.collect do |user|
          user_hash = user.attributes.reject { |k, _v| k =~ /(id|_at)$/ }
          user_hash['groups'] = user.groups
          user_hash
        end

        {
          users: users,
          admin_sets: admin_sets
        }
      end

      def load(data)
        data[:admin_sets].each do |admin_set|
          yield :admin_set, admin_set['title'] if block_given?
          load_admin_set(admin_set) if AdminSet.where(title: admin_set['title']).empty?
        end

        data[:users].each do |user_properties|
          yield :user, user_properties['email'] if block_given?
          load_user(user_properties)
        end
      end

      private

      def dump_admin_set(admin_set)
        {}.tap do |hsh|
          admin_set.attributes.each_pair do |k, v|
            next if k.match?(/(id|_at)$/)
            hsh[k] = v.to_a
          end

          hsh['permission_template'] = dump_permission_template(admin_set.permission_template)
        end
      end

      def dump_permission_template(template)
        template.attributes.tap do |hsh|
          hsh.reject! { |k, _v| k =~ /(id|_at)$/ }
          hsh['grants'] = []
          template.access_grants.each do |grant|
            hsh['grants'] << grant.attributes.reject { |k, _v| k =~ /(id|_at)$/ unless k == 'agent_id' }
          end
        end
      end

      def load_admin_set(data)
        template = data.delete('permission_template')
        AdminSet.create(data).tap do |as|
          load_permission_template(as, template)
        end
      end

      def load_permission_template(as, data)
        Hyrax::PermissionTemplate.create(data.merge(source_id: as.id, access_grants_attributes: data.delete('grants'))).tap do |pt|
          Hyrax::Workflow::WorkflowImporter.load_workflow_for(permission_template: pt)
          Sipity::Workflow.activate!(permission_template: pt, workflow_name: Hyrax.config.default_active_workflow_name)
        end
      end

      def load_user(user_properties)
        groups = user_properties.delete('groups')
        User.find_or_create_by(email: user_properties['email']).tap do |user|
          user.update_attributes(user_properties)
          groups.each do |g|
            next if g == 'registered'
            role = Role.find_or_create_by(name: g)
            role.users << user unless role.users.include?(user)
          end
        end
      end
    end
  end
end
