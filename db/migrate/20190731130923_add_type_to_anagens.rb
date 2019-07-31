class AddTypeToAnagens < ActiveRecord::Migration
  def change
    add_column :anagens, :type, :string, index: true, length: 24
  end
end
