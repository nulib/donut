class AddUsernameToUsers < ActiveRecord::Migration[5.1]
  def change
    add_column :users, :username, :string
    add_index :users, :username, name: 'index_users_on_username'
    remove_columns :users, :reset_password_token, :reset_password_sent_at
  end
end
