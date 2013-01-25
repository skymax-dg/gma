class AddReferenteToAnagens < ActiveRecord::Migration
  def change
    add_column :anagens, :referente, :string, :limit => 150
  end
end
