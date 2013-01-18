class AddSfxToCausmags < ActiveRecord::Migration
  def change
    add_column :causmags, :sfx, :string, :limit => 5
  end
end
