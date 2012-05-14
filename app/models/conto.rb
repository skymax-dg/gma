class Conto < ActiveRecord::Base
  attr_accessible :annoese, :azienda, :cntrpartita, :codice, :descriz, :tipoconto, :sconto

  has_many :tesdocs
  belongs_to :anagen

  validates :annoese, :azienda, :codice, :descriz, :tipoconto, :presence => true

end
