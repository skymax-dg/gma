class AddDatiPagToSpediz < ActiveRecord::Migration
  def change
    add_column :spedizs, :pagam, :string, :limit => 500
    add_column :spedizs, :banca, :string, :limit => 200
  end
end
