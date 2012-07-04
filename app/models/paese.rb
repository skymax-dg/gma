class Paese < ActiveRecord::Base
  before_destroy :require_no_localitas
  has_many :localitas

  attr_accessible :descriz, :tpeu, :codfis, :prepiva
  
  validates :descriz, :tpeu, :presence => true
  validates :descriz, :length => { :maximum => 50}

  TPEU = $ParAzienda['PAESE']['TPEU']
  
  def self.findlike_des(descriz)
    paeses = where("descriz like ?", "%" + descriz + "%")
    return 0, paeses if paeses.nil?
    return paeses.count, paeses
  end

  private

  def require_no_localitas
    self.errors.add :base, "Almeno una citta' fa riferimento al Paese che si desidera eliminare."
    raise ActiveRecord::RecordInvalid.new self unless localitas.count == 0
  end
end
