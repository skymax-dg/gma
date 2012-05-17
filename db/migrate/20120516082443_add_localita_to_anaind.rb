class AddLocalitaToAnaind < ActiveRecord::Migration
  def up
    add_column :anainds, :localita_id, :integer, :references => :localita
  end

  def down
    remove_column :anainds, :localita_id
  end
end
