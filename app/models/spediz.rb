class Spediz < ActiveRecord::Base
  belongs_to :tesdoc
  belongs_to :anaind
  attr_accessible :porto,   :aspetto,  :caustra, :corriere, :anaind_id, :presso, :dest1,     :dest2,
                  :nrcolli, :dtrit,    :orarit,  :um,       :valore,    :note,   :tesdoc_id, :pagam, :banca

  validates :note,  :length => { :maximum => 1000}
  validates :pagam, :length => { :maximum => 500}
  validates :banca, :length => { :maximum => 200}
  validates :presso, :dest1, :dest2,  :length => { :maximum => 150}

  CAUSTRA  = $ParAzienda['SPEDIZ']['CAUSTRA']
  CORRIERE = $ParAzienda['SPEDIZ']['CORRIERE']
  ASPETTO  = $ParAzienda['SPEDIZ']['ASPETTO']
  PORTO    = $ParAzienda['SPEDIZ']['PORTO']
  UM       = $ParAzienda['SPEDIZ']['UM']

  def ind_sped # Indirizzi disponibili
    return self.tesdoc.conto.anagen.anainds.where(:flsp => "S") if self.tesdoc.conto&&self.tesdoc.conto.anagen&&self.tesdoc.conto.anagen.anainds
    return []
  end
end