class CreateRigdocs < ActiveRecord::Migration
  def change
    create_table :rigdocs do |t|
      t.references :tesdoc, :null => false
      t.integer :prgrig, :null => false
      t.references :article
      t.string :descriz, :limit => 150
      t.integer :qta
      t.decimal :prezzo, :precision => 12, :scale => 6, :default => 0, :null => false
      t.decimal :sconto, :precision => 5, :scale => 2, :default => 0, :null => false

      t.timestamps
    end
    add_index :rigdocs, :article_id
    add_index :rigdocs, :tesdoc_id
    add_index :rigdocs, [:tesdoc_id, :prgrig], :unique => true
    add_index :rigdocs, :descriz
  end
end
