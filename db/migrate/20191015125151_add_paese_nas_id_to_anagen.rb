class AddPaeseNasIdToAnagen < ActiveRecord::Migration
  def change
    add_column :anagens, :paese_nas_id, :integer, index: true
  end
end
