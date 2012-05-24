class Conto < ActiveRecord::Base
  has_many :tesdocs
  belongs_to :anagen

  attr_accessible :annoese, :azienda, :codice, :descriz, :anagen_id, :tipoconto, :cntrpartita, :sconto

  validates :annoese, :azienda, :codice, :descriz, :tipoconto, :sconto, :presence => true
  
  TIPOCONTO = $ParAzienda['CONTO']['TIPOCONTO']

  def magsavailable(inivalue)
    return Hash[*Anaind::NRMAG.select{|k,v| inivalue.index(k)}.flatten] if self.anagen.nil?
    return self.anagen.magsavailable(inivalue)
  end
end
