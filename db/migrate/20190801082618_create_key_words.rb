class CreateKeyWords < ActiveRecord::Migration
  def change
    create_table :key_words do |t|
      t.string :desc, limit: 32
      t.integer :parent_id, index: true
      t.integer :keyword_type, default: 0

      t.timestamps
    end
  end
end
