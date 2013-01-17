class Scadenza < ActiveRecord::Base
  belongs_to :tesdoc

  attr_accessible :data, :stato, :tesdoc_id, :tipo, :descriz, :importo

  TIPO  = $ParAzienda['SCADENZA']['TIPO']
  STATO = $ParAzienda['SCADENZA']['STATO']

  validates :data, :stato, :tesdoc_id, :tipo, :importo, :presence => true

end
