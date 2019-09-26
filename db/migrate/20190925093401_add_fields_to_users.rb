class AddFieldsToUsers < ActiveRecord::Migration
  def change
    add_column :users, :anagen_id, :integer, index: true
    add_column :users, :user_tp, :integer, default: 1
    add_column :users, :privilege, :integer, default: 1
  end
end
