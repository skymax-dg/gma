class Causmag < ActiveRecord::Base
  # Definisce la relazione 1a1 con la classe "Mag"
  # tramite :magsrc (magsrc_id)
  # e la chiave primaria della classe "Mag" (id)  
  belongs_to :magsrc, :class_name => "Mag"
  # Definisce la relazione 1a1 con la classe "Mag"
  # tramite :magdst (magdst_id)
  # e la chiave primaria della classe "Mag" (id)  
  belongs_to :magdst, :class_name => "Mag"

  attr_accessible :descriz, :fattura, :tipo, :magsrc_id, :magdst_id
  validates :descriz, :fattura, :tipo, :presence => true
  # Fare un validate con i valori ammessi
  validates :fattura, :length => { :maximum => 1, :too_long  => "1 carattere obbligatorio (Valori ammessi: S = Con Fattura - N = Senza Fattura" }
  validates :tipo,  :length => { :maximum => 1, :too_long  => "1 carattere obbligatorio (Valori ammessi: V = Vendita - A = Acquisto - G = Generico" }
end
