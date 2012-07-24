class CreateLocalitas < ActiveRecord::Migration
  def change
    create_table :localitas do |t|
      t.string :descriz, :limit => 50, :null => false
      t.string :prov, :limit => 2
      t.string :cap, :limit => 5
      t.references :paese
      t.string :codfis, :limit => 4

      t.timestamps
    end
    add_index :localitas, :paese_id
    add_index :localitas, [:descriz], {:name => "idx_localitas_on_descriz"}
  end
end
