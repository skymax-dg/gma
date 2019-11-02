class AddCellulareToAnagens < ActiveRecord::Migration
  def change
    add_column :anagens, :cellulare, :string, limit: 15
  end
end
