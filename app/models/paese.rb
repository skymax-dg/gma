class Paese < ActiveRecord::Base
  has_many :localitas

  attr_accessible :descriz, :tpeu
  
  validates :descriz, :tpeu, :presence => true
  validates :descriz, :length => { :maximum => 50, :too_long  => "Lunghezza massima permessa: 50 caratteri" }
  validates :tpeu, :length => { :maximum => 1, :too_long  => "Valore obbligatorio: E=Europeo - X=eXtraeuropeo" }
end
