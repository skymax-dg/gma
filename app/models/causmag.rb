class Causmag < ActiveRecord::Base
  has_many :tesdocs

  attr_accessible :azienda, :descriz, :contabile, :tipo, :movimpmag
  validates :azienda, :descriz, :contabile, :tipo, :movimpmag, :presence => true
  # Fare un validate con i valori ammessi
  validates :contabile, :length => { :maximum => 1, :too_long  => "1 carattere obbligatorio (Valori ammessi: S = Mov.Contabile - N = Mov.non Contabile" }
  validates :tipo,  :length => { :maximum => 1, :too_long  => "1 carattere obbligatorio (Valori ammessi: E = Entrata - U = Uscita - T = Trasferimento" }
end
