class AddAnagenToConto < ActiveRecord::Migration
  def up
    add_column :contos, :anagen_id, :integer, :references => :anagen
    add_index "contos", ["azienda", "annoese", "anagen_id", "tipoconto"], {:name => "idx_contos_on_tipoconto_anagen_id", :unique => true}
  end

  def down
    remove_column :contos, :anagen_id
  end
end
