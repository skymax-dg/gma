class Paese < ActiveRecord::Base
  before_destroy :require_no_localitas
  has_many :localitas

  attr_accessible :descriz, :tpeu, :codfis, :prepiva
  
  validates :descriz, :tpeu, :presence => true
  validates :descriz, :length => { :maximum => 50}

  TPEU = $ParAzienda['PAESE']['TPEU']

  private

  def require_no_localitas
    self.errors.add :base, "Almeno una citta' fa riferimento al Paese che si desidera eliminare."
    raise ActiveRecord::RecordInvalid.new self unless localitas.count == 0
  end
  
end
