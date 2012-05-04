class Article < ActiveRecord::Base
  attr_accessible :codice, :descriz

  validates :codice, :descriz, :presence => true
  validates :codice, :descriz, :uniqueness => true

  validates :codice,  :length => { :maximum => 10, :too_long  => "Lunghezza massima permessa: 10 caratteri" }
  validates :descriz, :length => { :maximum => 50, :too_long  => "Lunghezza massima permessa: 50 caratteri" }
end
