class Causmag < ActiveRecord::Base
  before_destroy :require_no_tesdocs
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

  private

  def require_no_tesdocs
    self.errors.add :base, "Almeno un documento fa riferimento alla causale che si desidera eliminare."
    raise ActiveRecord::RecordInvalid.new self unless tesdocs.count == 0
  end

end
