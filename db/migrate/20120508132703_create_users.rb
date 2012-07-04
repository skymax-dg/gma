class CreateUsers < ActiveRecord::Migration
  def change
    create_table :users do |t|
      t.integer :azienda, :null => false
      t.string :login, :limit => 20, :null => false
      #t.string :pwd, :limit => 20, :null => false

      t.timestamps
    end
    add_index "users", ["azienda", "login"], {:name => "idx_users_on_login", :unique => true}
  end
end
