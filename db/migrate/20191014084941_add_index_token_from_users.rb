class AddIndexTokenFromUsers < ActiveRecord::Migration
  def change
    change_column :users, :token, :string, index: true
  end
end
