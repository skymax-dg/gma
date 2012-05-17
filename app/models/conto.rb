class Conto < ActiveRecord::Base
  has_many :tesdocs
  belongs_to :anagen

  attr_accessible :annoese, :azienda, :codice, :descriz, :anagen_id, :tipoconto, :cntrpartita, :sconto

  validates :annoese, :azienda, :codice, :descriz, :tipoconto, :sconto, :presence => true
  
  TIPOCONTO = $ParAzienda['CONTO']['TIPOCONTO']

end
