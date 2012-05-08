class Article < ActiveRecord::Base
  has_many :prezzoarticclis, :foreign_key => "artic_id",
                             :dependent => :destroy  
  has_many :rigdocs
  attr_accessible :codice, :descriz, :prezzo, :azienda

  validates :codice, :descriz, :azienda, :presence => true
  validates :codice, :descriz, :uniqueness => true

  validates :codice,  :length => { :maximum => 10, :too_long  => "Lunghezza massima permessa: 10 caratteri" }
  validates :descriz, :length => { :maximum => 50, :too_long  => "Lunghezza massima permessa: 50 caratteri" }
end
