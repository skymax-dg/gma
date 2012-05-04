class Mag < ActiveRecord::Base
  attr_accessible :codice, :descriz

  validates :codice, :descriz, :presence => true
  validates :codice, :descriz, :uniqueness => true

  validates :descriz,  :length => { :maximum => 50, :too_long  => "Lunghezza massima permessa: 50 caratteri" }
end
