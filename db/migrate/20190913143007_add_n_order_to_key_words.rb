class AddNOrderToKeyWords < ActiveRecord::Migration
  def change
    add_column :key_words, :n_order, :integer, default: 0
  end
end
