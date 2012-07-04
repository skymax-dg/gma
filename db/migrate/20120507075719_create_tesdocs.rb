class CreateTesdocs < ActiveRecord::Migration
  def change
    create_table :tesdocs do |t|
      t.integer :azienda, :null => false
      t.integer :annoese, :null => false
      t.integer :tipo_doc, :null => false
      t.integer :num_doc, :null => false
      t.date :data_doc, :null => false
      t.string :descriz, :limit => 150
      t.references :causmag
      t.references :conto
      t.decimal :sconto, :precision => 5, :scale => 2, :default => 0, :null => false

      t.timestamps
    end
    add_index :tesdocs, :causmag_id
    add_index :tesdocs, :conto_id
    add_index :tesdocs, [:data_doc, :num_doc], {:name => "idx_tesdocs_on_data_doc_num_doc"}
  end
end
