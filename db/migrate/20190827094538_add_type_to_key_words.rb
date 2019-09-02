class AddTypeToKeyWords < ActiveRecord::Migration
  def change
    add_column :key_words, :type, :string, limit: 24
  end
end
