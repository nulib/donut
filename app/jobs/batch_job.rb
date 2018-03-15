class BatchJob < ApplicationJob
  def perform(batch)
    batch.batch_items.each do |item|
      BatchItemJob.perform_later(item)
    end
  end
end
