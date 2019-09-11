class CreateCollectionVisibilityHistory < ActiveRecord::Migration[5.1]
  def change
    create_table :collection_visibility_histories do |t|
      t.string :collection_id
      t.string :submitter
      t.string :visibility

      t.timestamps
    end
  end
end
