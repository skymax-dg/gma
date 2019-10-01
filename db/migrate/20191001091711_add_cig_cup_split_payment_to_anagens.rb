class AddCigCupSplitPaymentToAnagens < ActiveRecord::Migration
  def change
    add_column :anagens, :cod_cig, :string, limit: 20
    add_column :anagens, :cod_cup, :string, limit: 20
    add_column :anagens, :split_payement, :integer, default: 0
    add_column :anagens, :cod_carta_studente, :string, limit: 7
    add_column :anagens, :cod_carta_docente, :string, limit: 8
    add_column :anagens, :attivo, :integer, default: 1
  end
end
