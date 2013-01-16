class Scadenza < ActiveRecord::Base
  belongs_to :tesdoc

  attr_accessible :data, :stato, :tesdoc_id, :tipo, :descriz

  TIPO  = $ParAzienda['SCADENZA']['TIPO']
  STATO = $ParAzienda['SCADENZA']['STATO']
end
