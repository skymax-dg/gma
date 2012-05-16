class Localita < ActiveRecord::Base
  belongs_to :paese
  has_many :anainds

  attr_accessible :cap, :codfis, :descriz, :prov, :paese_id
  
  validates :descriz, :presence => true
  validates :descriz, :length => { :maximum => 50, :too_long  => "Lunghezza massima permessa: 50 caratteri" }
  validates :cap, :length => { :maximum => 5, :too_long  => "Lunghezza massima permessa: 5 caratteri" }
  validates :codfis, :length => { :maximum => 4, :too_long  => "Lunghezza massima permessa: 4 caratteri" }
  validates :prov, :length => { :maximum => 2, :too_long  => "Lunghezza massima permessa: 2 caratteri" }
end
