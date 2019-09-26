class AddTokenToUsers < ActiveRecord::Migration
  def change
    add_column :users, :token, :string, length: 32
    add_column :users, :dt_exp_token, :datetime
  end
end
