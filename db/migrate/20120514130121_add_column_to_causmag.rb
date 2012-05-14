class AddColumnToCausmag < ActiveRecord::Migration
  def up
    add_column :causmags, :tipo_doc, :integer, :null => false, :default => 0
    add_column :causmags, :des_caus, :string, :limit => 100
    add_column :causmags, :modulo, :string, :limit => 50
    add_column :causmags, :nrmag_src, :integer
    add_column :causmags, :nrmag_dst, :integer
  end

  def down
    remove_column :causmags, :tipo_doc
    remove_column :causmags, :des_caus
    remove_column :causmags, :modulo
    remove_column :causmags, :nrmag_src
    remove_column :causmags, :nrmag_dst
  end
end
