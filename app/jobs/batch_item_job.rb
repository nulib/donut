class BatchItemJob < ApplicationJob
  def perform(batch_item)
    batch_item.run
  end
end
