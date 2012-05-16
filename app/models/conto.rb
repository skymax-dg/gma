class Conto < ActiveRecord::Base
  has_many :tesdocs
  belongs_to :anagen

  attr_accessible :annoese, :azienda, :cntrpartita, :codice, :descriz, :tipoconto, :sconto

  validates :annoese, :azienda, :codice, :descriz, :tipoconto, :anagen_id, :presence => true
end
