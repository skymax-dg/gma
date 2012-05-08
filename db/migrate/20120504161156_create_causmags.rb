class CreateCausmags < ActiveRecord::Migration
  def change
    create_table :causmags do |t|
      t.integer :azienda, :null => false
      t.string :descriz, :limit => 100, :null => false
      t.string :tipo, :limit => 1, :null => false
      t.string :movimpmag, :limit => 1, :null => false
      t.references :magsrc
      t.references :magdst
      t.string :contabile, :limit => 1, :null => false

      t.timestamps
    end
    add_index :causmags, :magsrc_id
    add_index :causmags, :magdst_id
    add_index :causmags, [:azienda, :descriz], {:name => "idx_causmags_on_descriz", :unique => true}
  end
end
