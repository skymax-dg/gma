class Causale < ActiveRecord::Base
  before_destroy :require_no_causmags
  has_many :causmags

  attr_accessible :azienda, :descriz, :tipoiva, :tiporeg, :contoiva

  validates :azienda, :descriz, :tipoiva, :tiporeg, :presence => true
  validates :descriz, :length => { :maximum => 100}

  TIPOIVA = $ParAzienda['CAUSALE']['TIPOIVA']
  TIPOREG = $ParAzienda['CAUSALE']['TIPOREG']

  private

  def require_no_causmags
    self.errors.add :base, "Almeno una causale di magazzino fa riferimento alla causale che si desidera eliminare."
    raise ActiveRecord::RecordInvalid.new self unless causmags.count == 0
  end

end
