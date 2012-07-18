class Spediz < ActiveRecord::Base
  belongs_to :tesdoc
  belongs_to :anaind
  attr_accessible :porto,   :aspetto,  :caustra, :corriere, :anaind_id, :dest1,     :dest2,
                  :nrcolli, :dtrit,    :orarit,  :um,       :valore,    :note,      :tesdoc_id

  CAUSTRA  = $ParAzienda['SPEDIZ']['CAUSTRA']
  CORRIERE = $ParAzienda['SPEDIZ']['CORRIERE']
  ASPETTO  = $ParAzienda['SPEDIZ']['ASPETTO']
  PORTO    = $ParAzienda['SPEDIZ']['PORTO']
  UM       = $ParAzienda['SPEDIZ']['UM']

  def ind_disp # Indirizzi disponibili
    self.tesdoc.conto.anagen.anainds
  end
end