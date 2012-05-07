class AddAziendaToArticle < ActiveRecord::Migration
  def change
    add_column :articles, :azienda, :integer, :null => false
  end
end
