class AddDiscountToArticles < ActiveRecord::Migration
  def change
    add_column :articles, :discount, :decimal, precision: 5, scale: 2, default: 0.0, null: false
  end
end
