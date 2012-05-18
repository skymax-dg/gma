class AddColumnToCausmag < ActiveRecord::Migration
  def up
    add_column :causmags, :tipo_doc, :integer, :null => false, :default => 0
    add_column :causmags, :des_caus, :string, :limit => 100
    add_column :causmags, :modulo, :string, :limit => 50
    add_column :causmags, :nrmagsrc, :integer
    add_column :causmags, :nrmagdst, :integer
  end

  def down
    remove_column :causmags, :tipo_doc
    remove_column :causmags, :des_caus
    remove_column :causmags, :modulo
    remove_column :causmags, :nrmagsrc
    remove_column :causmags, :nrmagdst
  end
end
