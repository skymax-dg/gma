class AddTogliSpeseSpedizioneToCoupons < ActiveRecord::Migration
  def change
    add_column :coupons, :togli_spese_spedizione, :integer, default: 1
  end
end
