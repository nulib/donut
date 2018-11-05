class CreateAreasOfInterest < ActiveRecord::Migration[5.1]
  def change
    create_table :areas_of_interest do |t|
      t.string :file_id, null: false
      t.integer :x, null: false, default: 0
      t.integer :y, null: false, default: 0
      t.integer :width, null: false
      t.integer :height, null: false
      t.integer :rotation, null: false, default: 0
      t.timestamps

      t.index :file_id
    end
  end
end
