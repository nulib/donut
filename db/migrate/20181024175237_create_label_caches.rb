class CreateLabelCaches < ActiveRecord::Migration[5.1]
  def change
    create_table :label_caches do |t|
      t.string :uri, null: false
      t.string :label, null: false
      t.timestamps
    end
  end
end
