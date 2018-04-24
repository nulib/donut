require 'active_elastic_job'

module ActiveJob
  module QueueAdapters
    class BetterActiveElasticJobAdapter < ActiveElasticJobAdapter
      class << self
        private

          def build_message(queue_name, serialized_job, timestamp)
            super.tap do |result|
              if queue_name.ends_with?('.fifo')
                job = JSON.parse(serialized_job)
                id_argument = job['arguments'].find { |arg| arg.is_a?(Hash) && arg.keys.first == '_aj_globalid' }
                group_id = id_argument.nil? ? job['arguments'].first.to_s : id_argument['_aj_globalid']
                result[:message_group_id] = group_id
              end
            end
          end
      end
    end
  end
end
