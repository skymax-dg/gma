class AddGrpPrgToCausMags < ActiveRecord::Migration
  def change
    add_column :causmags, :grp_prg, :integer
    add_index :causmags, [:grp_prg]
  end
end
