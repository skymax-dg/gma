class AddAnagenToConto < ActiveRecord::Migration
  def up
    add_column :contos, :anagen_id, :integer, :references => :anagen
  end

  def down
    remove_column :contos, :anagen_id
  end
end
