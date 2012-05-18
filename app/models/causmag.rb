class Causmag < ActiveRecord::Base
  has_many :tesdocs

  attr_accessible :azienda, :tipo_doc, :descriz, :des_caus, :tipo, :movimpmag, :nrmagsrc, :nrmagdst, :contabile, :modulo

  validates :azienda, :descriz, :contabile, :tipo, :movimpmag, :nrmagsrc, :nrmagdst, :presence => true
  # Fare un validate con i valori ammessi
  validates :descriz, :des_caus, :length => { :maximum => 100, :too_long  => "Lunghezza massima consentita: 100 caratteri" }
  validates :tipo,  :length => { :maximum => 1, :too_long  => "1 carattere obbligatorio (Valori ammessi: E = Entrata - U = Uscita - T = Trasferimento" }
  validates :contabile, :length => { :maximum => 1, :too_long  => "1 carattere obbligatorio (Valori ammessi: S = Mov.Contabile - N = Mov.non Contabile" }

  TIPO_DOC = $ParAzienda['CAUSMAG']['TIPO_DOC']
  TIPO = $ParAzienda['CAUSMAG']['TIPO']
  MOVIMPMAG = $ParAzienda['CAUSMAG']['MOVIMPMAG']
  CONTABILE = $ParAzienda['CAUSMAG']['CONTABILE']
  NRMAG = $ParAzienda['ANAIND']['NRMAG']

end
