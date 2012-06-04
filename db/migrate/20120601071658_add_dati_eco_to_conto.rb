class AddDatiEcoToConto < ActiveRecord::Migration
  def change
    add_column :contos, :tipopeo, :string, :limit => 1
  end
end
