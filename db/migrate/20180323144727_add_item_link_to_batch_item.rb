class AddItemLinkToBatchItem < ActiveRecord::Migration[5.1]
  def change
    add_column :batch_items, :created_item, :string
  end
end
