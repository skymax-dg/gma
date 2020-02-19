class AddStateToKeyWords < ActiveRecord::Migration
  def change
    add_column :key_words, :state, :integer, index: true, default: 1
  end
end
