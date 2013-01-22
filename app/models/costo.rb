class Costo < ActiveRecord::Base

  belongs_to :tesdoc

  attr_accessible :tesdoc_id, :data, :importo, :stato, :tipo_spe, :descriz

  validates :tesdoc_id, :importo, :stato, :presence => true

  STATO  = $ParAzienda['COSTO']['STATO']
  TIPO_SPE = $ParAzienda['COSTO']['TIPO_SPE']

end
