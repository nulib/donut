Rails.application.config.after_initialize do
  if Rails.application.config.active_job.queue_adapter.to_sym == :shoryuken
    ActiveJob::Base.class_eval do
      after_enqueue  :delete_idempotent_cache_key
      around_perform :ensure_idempotence

      private

      def idempotent_cache_key
        "active_job_#{job_id}_state"
      end

      def delete_idempotent_cache_key
        Rails.cache.delete(idempotent_cache_key)
      end

      def ensure_idempotence
        job_state = Rails.cache.read(idempotent_cache_key)
        if job_state.present?
          Rails.logger.warn("Ignoring job #{job_id} because it's already #{job_state}")
        else
          Rails.cache.write(idempotent_cache_key, 'processing', expires_in: 15.minutes)
          yield if block_given?
          Rails.cache.write(idempotent_cache_key, 'completed', expires_in: 15.minutes)
        end
      end
    end
  end
end
