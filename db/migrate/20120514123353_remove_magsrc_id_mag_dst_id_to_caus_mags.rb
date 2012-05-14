class RemoveMagsrcIdMagDstIdToCausMags < ActiveRecord::Migration
  def up
    remove_column :causmags, :magsrc_id
    remove_column :causmags, :magdst_id
  end

  def down
    add_column :causmags, :magsrc_id, :integer
    add_column :causmags, :magdst_id, :integer
  end
end
