class AddIndexToAnagens < ActiveRecord::Migration
  def change
    add_index "anagens", ["cognome", "nome"], :name => "idx_anagens_on_cognome-nome"
    add_index "anagens", ["ragsoc"], :name => "idx_anagens_on_ragsoc"
  end
end
