class AddJtiToUsers < ActiveRecord::Migration[7.0]
  def change
    add_column :users, :jti, :string, null: false # rubocop:disable Rails/NotNullColumn
    add_index :users, :jti, unique: true
  end
end
