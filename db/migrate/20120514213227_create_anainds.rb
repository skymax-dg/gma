class CreateAnainds < ActiveRecord::Migration
  def change
    create_table :anainds do |t|
      t.references :anagen
      t.string :tpind, :limit => 2
      t.string :indir, :limit => 255
      t.string :desloc, :limit => 255
      t.string :cap, :limit => 5
      t.integer :nrmag, :null => false

      t.timestamps
    end
    add_index :anainds, :anagen_id
  end
end
