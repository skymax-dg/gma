class CreateAnainds < ActiveRecord::Migration
  def change
    create_table :anainds do |t|
      t.references :anagen
      t.string :tpind, :limit => 1
      t.string :indir, :limit => 100
      t.string :localita, :limit => 100
      t.string :cap, :limit => 5
      t.integer :nrmag

      t.timestamps
    end
    add_index :anainds, :anagen_id
  end
end
