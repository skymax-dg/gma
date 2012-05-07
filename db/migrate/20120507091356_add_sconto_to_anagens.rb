class AddScontoToAnagens < ActiveRecord::Migration
  def change
    add_column :anagens, :sconto, :decimal, :precision => 5, :scale => 2, :default => 0
  end
end
