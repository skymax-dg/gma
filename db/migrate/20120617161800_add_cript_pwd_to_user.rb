class AddCriptPwdToUser < ActiveRecord::Migration
  def change
    add_column :users, :salt, :string, :limit => 100, :null => false
    add_column :users, :pwdcript, :string, :limit => 100, :null => false
  end
end
