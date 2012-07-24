class AddCategIvaToArticle < ActiveRecord::Migration
  def change
    add_column :articles, :categ, :string, :limit => 2, :null => false, :default => "GE"
    add_column :articles, :iva_id, :integer, :null => false, :default => 1, :references => :iva
  end
end
