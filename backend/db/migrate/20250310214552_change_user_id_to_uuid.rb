class ChangeUserIdToUuid < ActiveRecord::Migration[6.0]
  def change
    remove_column :users, :id
    add_column :users, :id, :string, primary_key: true, default: -> { "lower(hex(randomblob(16)))" }
  end
end
