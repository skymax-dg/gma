class Paese < ActiveRecord::Base
  has_many :localitas

  attr_accessible :descriz, :tpeu, :prepiva
  
  validates :descriz, :tpeu, :presence => true
  validates :descriz, :length => { :maximum => 50}

  TPEU = $ParAzienda['PAESE']['TPEU']

end
