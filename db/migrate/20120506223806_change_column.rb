class ChangeColumn < ActiveRecord::Migration
  def up
    remove_column :prezzoarticclis, :prezzo
    change_table :prezzoarticclis do |t|
      t.decimal :prezzo, :scale => 2, :precision => 8
    end
  end

  def down
    remove_column :prezzoarticclis, :prezzo
    change_table :prezzoarticclis do |t|
      t.float :prezzo
    end
  end
end
