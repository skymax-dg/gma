class AddFieldsToAnagens < ActiveRecord::Migration
  def change
    add_column :anagens, :codnaz, :string, limit: 2
    add_column :anagens, :codident, :string, limit: 20
    add_column :anagens, :pec, :string, limit: 50
  end
end
