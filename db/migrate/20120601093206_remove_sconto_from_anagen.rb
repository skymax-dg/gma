class RemoveScontoFromAnagen < ActiveRecord::Migration
  def change
    remove_column :anagens, :sconto
  end
end
