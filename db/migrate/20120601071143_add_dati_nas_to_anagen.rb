class AddDatiNasToAnagen < ActiveRecord::Migration
  def change
    add_column :anagens, :dtnas, :date
    add_column :anagens, :luogonas_id, :integer, :references => :localita
    add_column :anagens, :sesso, :string, :limit => 1
  end
end
