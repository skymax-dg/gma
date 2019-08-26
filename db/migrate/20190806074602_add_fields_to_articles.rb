class AddFieldsToArticles < ActiveRecord::Migration
  def change
    add_column :articles, :subtitle, :text
    add_column :articles, :sinossi,  :text
    add_column :articles, :abstract, :text
    add_column :articles, :quote,    :text
    add_column :articles, :weigth,   :integer
    add_column :articles, :ppc,      :integer, default: 1
    add_column :articles, :ppb,      :integer
    add_column :articles, :state,    :integer
    add_column :articles, :width,    :integer
    add_column :articles, :height,   :integer
    add_column :articles, :dtpub,    :date
  end
end
