class Mag < ActiveRecord::Base
  # definisce una relazione 1aN col la classe causmag(:causmags)
  # tramite l'attributo "magsrc_id"
  has_many :causmags, :foreign_key => "magsrc_id",
                     :dependent => :destroy  
  # definisce una relazione 1aN col la classe causmag(:causmags)
  # tramite l'attributo "magdst_id"
  has_many :causmags, :foreign_key => "magdst_id",
                     :dependent => :destroy  
  attr_accessible :azienda, :codice, :descriz

  validates :azienda, :codice, :descriz, :presence => true
  validates :codice, :descriz, :uniqueness => true

  validates :descriz,  :length => { :maximum => 50, :too_long  => "Lunghezza massima permessa: 50 caratteri" }
end
