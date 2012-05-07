class CreateTesdocs < ActiveRecord::Migration
  def change
    create_table :tesdocs do |t|
      t.string :tipo_doc, :limit => 1
      t.integer :num_doc
      t.date :data_doc
      t.string :descriz, :limit => 150
      t.references :causmag
      t.references :anagen

      t.timestamps
    end
    add_index :tesdocs, :causmag_id
    add_index :tesdocs, :anagen_id
  end
end
