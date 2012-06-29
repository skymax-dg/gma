class CreateSpedizs < ActiveRecord::Migration
  def change
    create_table :spedizs do |t|
      t.integer :tesdoc_id,                     :null => false
      t.string :caustras, :limit => 100
      t.string :corriere, :limit => 150
      t.string :dest1, :limit => 150
      t.string :dest2, :limit => 150
      t.string :aspetto, :limit => 100
      t.integer :nrcolli
      t.string :um, :limit => 2
      t.decimal :peso, :precision => 8, :scale => 2
      t.string :porto, :limit => 100
      t.date :dtrit
      t.time :orarit
      t.string :note, :limit => 1000

      t.timestamps
    end
    add_index "spedizs", ["tesdoc_id"], :name => "index_spedizs_on_tesdoc_id"
    #add a foreign key
    execute <<-SQL
      ALTER TABLE spedizs
        ADD CONSTRAINT fk_spedizs_tesdoc_id_tesdocs
        FOREIGN KEY (tesdoc_id)
        REFERENCES tesdocs
    SQL
  end
end
