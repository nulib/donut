class CreateCrappyStateMachines < ActiveRecord::Migration[5.1]
  def change
    create_table :crappy_state_machine do |t|
      t.string   :job_class, null: false
      t.string   :job_id, null: false
      t.string   :target_id, null: false
      t.string   :work_id
      t.string   :state
      t.timestamps
    end
  end
end
