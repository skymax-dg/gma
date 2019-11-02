class CreateKeyWordRels < ActiveRecord::Migration
  def change
    create_table :key_word_rels do |t|
      t.integer :key_word_id, index: true
      t.string :desc, limit: 32
      t.references :key_wordable, polymorphic: true, index: true

      t.timestamps
    end
  end
end
