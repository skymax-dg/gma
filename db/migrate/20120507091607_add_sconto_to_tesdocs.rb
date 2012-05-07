class AddScontoToTesdocs < ActiveRecord::Migration
  def change
    add_column :tesdocs, :sconto, :decimal, :precision => 5, :scale => 2, :default => 0
  end
end
