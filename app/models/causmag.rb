class Causmag < ActiveRecord::Base
  has_many :tesdocs

  attr_accessible :azienda, :tipo_doc, :descriz, :des_caus, :tipo, :movimpmag, :nrmagsrc, :nrmagdst, :contabile, :modulo

  validates :azienda, :descriz, :contabile, :tipo, :movimpmag, :nrmagsrc, :nrmagdst, :presence => true
  # Fare un validate con i valori ammessi
  validates :descriz, :des_caus, :length => { :maximum => 100}

  TIPO_DOC = $ParAzienda['CAUSMAG']['TIPO_DOC']
  TIPO = $ParAzienda['CAUSMAG']['TIPO']
  MOVIMPMAG = $ParAzienda['CAUSMAG']['MOVIMPMAG']
  CONTABILE = $ParAzienda['CAUSMAG']['CONTABILE']
  NRMAG = $ParAzienda['ANAIND']['NRMAG']

end
