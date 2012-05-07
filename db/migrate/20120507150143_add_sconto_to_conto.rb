class AddScontoToConto < ActiveRecord::Migration
  def change
    add_column :contos, :sconto, :decimal, :precision=>5, :scale => 2
  end
end
