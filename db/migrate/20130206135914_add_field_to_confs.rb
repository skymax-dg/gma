class AddFieldToConfs < ActiveRecord::Migration
  def change
    add_column :confs, :defcausmag, :integer
    add_column :confs, :defdatadoc, :date
    add_column :confs, :defdesdoc, :string, :limit => 150
  end
end
